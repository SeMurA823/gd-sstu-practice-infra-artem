module "app_infra" {
  source = "./main_instance"
  name = "petclinic"
  instance_port = 8080
  balancer_port = 8080
  ami = "ami-07d1e810746a28d1d"
  vpc_id = aws_vpc.main_vpc.id
  subnet_id = aws_subnet.private.id
  ssh_port = 1274
  key_name = aws_key_pair.my_key.key_name
  iam_instance_profile = "IAM"
  subnets_balancer = [aws_subnet.public.id]
  user_data_instance = filebase64("./scripts/ec2-instances/start-ec2-instance.sh")
}

