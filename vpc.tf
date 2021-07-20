resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "Main VPC"
    }
    enable_dns_hostnames = true

}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    tags = {
        Name = "Public subnet"
    }
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "false"
    tags = {
        Name = "Private subnet"
    }
    availability_zone = "us-east-1a"
}
resource "aws_subnet" "private_1f" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "false"
    tags = {
        Name = "Private subnet"
    }
    availability_zone = "us-east-1f"
}

resource "aws_security_group" "public_sg" {
    vpc_id = aws_vpc.main_vpc.id
    name = "public_sg"
    tags = {
        Name = "Public security group"
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "private_sg" {
    vpc_id = aws_vpc.main_vpc.id
    name = "private_sg"
    tags = {
        Name = "Private security group"
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
