resource "aws_internet_gateway" "internet_gw" {
    vpc_id = aws_vpc.main_vpc.id

    tags = {
        Name = "Internet gateway"
    }
}