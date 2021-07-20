resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.main_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gw.id
    }
}

resource "aws_main_route_table_association" "main_association" {
  vpc_id = aws_vpc.main_vpc.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_association" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    instance_id = aws_instance.bastion_instance.id
  }
}

resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_route_association_1f" {
    subnet_id      = aws_subnet.private_1f.id
    route_table_id = aws_route_table.private_route_table.id
}