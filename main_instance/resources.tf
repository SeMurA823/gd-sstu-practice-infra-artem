resource "aws_instance" "app_instance" {
    ami = "${var.ami}"
    iam_instance_profile = "${var.iam_instance_profile}"
    instance_type               = "${var.instance_type}"
    vpc_security_group_ids      = [aws_security_group.app_sg.id]
    subnet_id                   = "${var.subnet_id}"
    key_name                    = "${var.key_name}"
    tags = {
        Name = "Application instance"
    }   
}

resource "aws_security_group" "app_sg" {
    vpc_id = "${var.vpc_id}"
    name = "${var.name}"
    tags = {
        Name = "Application security group"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = "${var.instance_port}"
        to_port = "${var.instance_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "lb_sg" {
    vpc_id = "${var.vpc_id}"
    name = "${var.name}-sg"
    tags = {
        Name = "Load balancer security group"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = "${var.instance_port}"
        to_port = "${var.balancer_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_elb" "app_elb" {
    subnets = var.subnets_balancer
    name = "${var.name}-elb"
    listener {
        instance_port = var.instance_port
        instance_protocol = "http"
        lb_port = var.balancer_port
        lb_protocol = "http"
    }
    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:${var.instance_port}/"
        interval            = 5
    }
    security_groups = [aws_security_group.lb_sg.id]
    tags = {
        Name = "ELB"
    }
}

resource "aws_autoscaling_group" "asg" {
    name = var.name
    availability_zones = ["us-east-1a"]
    desired_capacity = 1
    max_size = 2
    min_size = 1
    load_balancers = [aws_elb.app_elb.id]
    health_check_type = "ELB"
    health_check_grace_period = 1200
    launch_template {
        id = aws_launch_template.alt.id
        version = "$Latest"
    }
}

resource "aws_launch_template" "alt" {
    name_prefix = "${var.name}-"
    image_id = "${var.ami}"
    instance_type = "t2.micro"
    user_data = var.user_data_instance
    key_name = "${var.key_name}"
    network_interfaces {
        associate_public_ip_address = false
        subnet_id = "${var.subnet_id}"
        security_groups = [aws_security_group.app_sg.id]
    }
    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "${var.name}"
        }
    }
    iam_instance_profile {
        name = "${var.iam_instance_profile}"
    }
    
}

resource "aws_autoscaling_policy" "policy_up" {
  name = "policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name = "cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_actions = [ aws_autoscaling_policy.policy_up.arn ]
}

resource "aws_autoscaling_policy" "policy_down" {
  name = "policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name = "cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "20"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_actions = [ aws_autoscaling_policy.policy_down.arn ]
}