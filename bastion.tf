resource "aws_instance" "bastion_instance" {
    ami = "ami-00a9d4a05375b2763"
    source_dest_check = false
    iam_instance_profile = "Bastion"
    instance_type               = "t2.micro"
    vpc_security_group_ids      = [aws_security_group.public_sg.id, aws_security_group.nat_sg.id]
    subnet_id                   = aws_subnet.public.id
    key_name                    = aws_key_pair.my_key.key_name
    tags = {
        Name = "Bastion/NAT instance"
    }
    user_data = filebase64("./scripts/bastion/start-bastion-instance.sh")
}

resource "aws_security_group" "nat_sg" {
    vpc_id = aws_vpc.main_vpc.id
    name = "nat_sg"
    tags = {
        Name = "NAT security group"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [aws_subnet.private.cidr_block, aws_subnet.private_1f.cidr_block]
    }
}

resource "aws_security_group_rule" "public_sg_ssh_role" {
    type              = "ingress"
    from_port         = 1274
    to_port           = 1274
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.public_sg.id
}


