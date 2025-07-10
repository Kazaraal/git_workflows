resource "aws_security_group" "kkWebserverSecurityGroup" {
  name                  = "allow_tls"
  description           = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id                = var.vpc_id

  tags                  = {
    Name                = "kkWebserverSecurityGroup"
    Project             = "kk_tf_demo"
  }
}

resource "aws_security_group_rule" "ssh_ingress" {
  security_group_id     = aws_security_group.kkWebserverSecurityGroup.id
  type                  = "ingress"
  from_port             = 22
  to_port               = 22
  protocol              = "tcp"
  cidr_blocks           = var.public_subnet_cidrs
}

resource "aws_security_group_rule" "http_ingress" {
  security_group_id     = aws_security_group.kkWebserverSecurityGroup.id
  type                  = "ingress"
  from_port             = 80
  to_port               = 80
  protocol              = "tcp"
  cidr_blocks           = var.public_subnet_cidrs
}

resource "aws_security_group_rule" "tls_egress" {
  security_group_id     = aws_security_group.kkWebserverSecurityGroup.id
  type                  = "egress"
  from_port             = 0
  to_port               = 0
  protocol              = "-1"
  cidr_blocks           = ["0.0.0.0/0"]
}

resource "aws_lb_target_group" "kkLbTargetGroup" {
  name                  = "kk-target-group"
  port                  = 80
  protocol              = "HTTP"
  vpc_id                = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = 200
    interval            = 15
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags                  = {
    name                = "kkLbTargetGroup"
    Project             = "kk_tf_demo"
  }
}

resource "aws_lb" "kkLoadBalancer" {
  name                  = "web-app-lb"
  load_balancer_type    = "application"
  subnets               = [var.public_subnets[0].id, var.public_subnets[1].id]
  security_groups       = [aws_security_group.kkWebserverSecurityGroup.id]

  tags                  = {
    Name                = "kkLoadBalancer"
    Project             = "kk_tf_demo"
  }
}

resource "aws_lb_listener" "kkLbListener" {
  load_balancer_arn     = aws_lb.kkLoadBalancer.arn
  port                  = 80
  protocol              = "HTTP"

  default_action {
    type                = "forward"
    target_group_arn    = aws_lb_target_group.kkLbTargetGroup.arn
  }
}

resource "aws_lb_target_group_attachment" "webserver1" {
  target_group_arn      = aws_lb_target_group.kkLbTargetGroup.arn
  target_id             = aws_instance.webserver1.id
  port                  = 80
}

resource "aws_lb_target_group_attachment" "webserver2" {
  target_group_arn      = aws_lb_target_group.kkLbTargetGroup.arn
  target_id             = aws_instance.webserver2.id
  port                  = 80
}

resource "aws_instance" "webserver1" {
  ami                           = local.ami_id
  instance_type                 = local.instance_type
  key_name                      = local.key_name
  subnet_id                     = var.public_subnets[0].id
  security_groups               = [aws_security_group.kkWebserverSecurityGroup.id]
  associate_public_ip_address   = true

  user_data                     = <<-EOF
                #!/bin/bash -xe
                sudo su
                yum update -y
                yum install -y httpd
                echo "<h1>Hello, World!</h1>server: kkWebserver1" > /var/www/html/index.html
                echo "healthy" > /var/www/html/hc.html
                service httpd start
                EOF
}

resource "aws_instance" "webserver2" {
  ami                           = local.ami_id
  instance_type                 = local.instance_type
  key_name                      = local.key_name
  subnet_id                     = var.public_subnets[1].id
  security_groups               = [aws_security_group.kkWebserverSecurityGroup.id]
  associate_public_ip_address   = true

  user_data                     = <<-EOF
                #!/bin/bash -xe
                sudo su
                yum update -y
                yum install -y httpd
                echo "<h1>Hello, World!</h1>server: kkWebserver2" > /var/www/html/index.html
                echo "healthy" > /var/www/html/hc.html
                service httpd start
                EOF
}