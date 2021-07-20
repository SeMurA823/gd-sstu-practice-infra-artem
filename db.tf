resource "aws_db_instance" "db_instance" {
    allocated_storage = 5
    engine = "mysql"
    engine_version = "8.0.25"
    instance_class = "db.t2.micro"
    name = "petclinic"
    username = "petclinic"
    password = "petclinic"
    skip_final_snapshot = true
    port = 3306
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_db_subnet_group" "db_subnet_group" {
    name = "main-db-subnet"
    subnet_ids = [aws_subnet.private.id, aws_subnet.private_1f.id]
}


resource "aws_security_group" "rds_sg" {
    vpc_id = aws_vpc.main_vpc.id
    name = "rds_sg"
    tags = {
        Name = "RDS security group"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}