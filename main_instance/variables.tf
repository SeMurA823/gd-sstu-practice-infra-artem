variable "name" {
  type = string
}

variable "instance_port" {
  type = number
  default = 8080
}

variable "balancer_port" {
  type = number
  default = 80
}

variable "ami" {
  type = string
  //Ubuntu latest
  default = "ami-09e67e426f25ce0d7"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
  description = "Subnet app instance"
}

variable "ssh_port" {
  type = number
  default = 22
}

variable "key_name" {
  type = string
}

variable "iam_instance_profile" {
  type = string
}

variable "subnets_balancer" {
  type = list(string)
}

variable "user_data_instance" {
  type = string
}