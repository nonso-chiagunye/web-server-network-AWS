

# The web server will use Database in the RDS Module
module "web-srv-rds" {
    source      = "../modules/rds"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
    rds_subnet1 = var.rds_subnet1
    rds_subnet2 = var.rds_subnet2
    vpc_id = var.vpc_id
}

# Security Group for Load Balancer allows Ports 80 and 443
resource "aws_security_group" "alb_sg" {
  tags = {
    Name = "${var.ENVIRONMENT}-${var.ALB_SG_NAME}"
  }
  name = "${var.ENVIRONMENT}-${var.ALB_SG_NAME}"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id 

  dynamic "ingress" {
    for_each = var.alb_ports
    content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for Web Server allows ports 80, 443 and 22 (Management Port)
resource "aws_security_group" "web_srv_instance_sg" {
  tags = {
    Name = "${var.ENVIRONMENT}-${var.WEB_SRV_SG_NAME}"
  }
  name = "${var.ENVIRONMENT}-${var.WEB_SRV_SG_NAME}"
  description = "Web Server Instance Security Group"
  vpc_id      = var.vpc_id 

  dynamic "ingress" {
    for_each = var.web_srv_sg_ports
    content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a key-pair with ssh-keygen -t <FILENAME> in a directory, and specify path here
resource "aws_key_pair" "web_srv_key" {
  key_name      = "${var.KEY_NAME}"
  public_key    = file(var.path_to_public_key)
}

# Specify instance launch configuration based on expected workload
resource "aws_launch_configuration" "web_srv_launch_config" {
  name   = "${var.LAUNCH_CONFIG_NAME}"
  image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = var.INSTANCE_TYPE
  user_data = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'This is a Web Server\nThe Public IP is: '$MYIP > /var/www/html/index.html"
  security_groups = [aws_security_group.web_srv_instance_sg.id]
  key_name = aws_key_pair.web_srv_key.key_name
  
  root_block_device {
    volume_type = var.VOLUME_TYPE 
    volume_size = var.VOLUME_SIZE 
  }
}

# Instance Auto-scaling Configuration
resource "aws_autoscaling_group" "web_srv_asg" {
  name                      = "${var.ASG_NAME}"
  max_size                  = var.ASG_MAX_SIZE
  min_size                  = var.ASG_MIN_SIZE
  health_check_grace_period = var.ASG_HEALTH_CHECK_GRACE_PERIOD
  health_check_type         = var.HEALTH_CHECK_TYPE 
  desired_capacity          = var.DESIRED_CAPACITY 
  force_delete              = true
  launch_configuration      = aws_launch_configuration.web_srv_launch_config.name
  vpc_zone_identifier       = ["${var.web_srv_subnet1}", "${var.web_srv_subnet2}"]
  target_group_arns         = [aws_lb_target_group.http-target-group.arn]
}

# Application Load Balancer
resource "aws_lb" "web_srv_alb" {
  name               = "${var.ENVIRONMENT}-${var.ALB_NAME}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["${var.web_srv_subnet1}", "${var.web_srv_subnet2}"]

}

# Load Balancer Target Group (http)
resource "aws_lb_target_group" "http-target-group" {
  name     = "${var.HTTP_TARGET_GROUP_NAME}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# If you have an https listener, you can create https target group
# resource "aws_lb_target_group" "https-target-group" {
#   name     = "${var.HTTPS_TARGET_GROUP_NAME}"
#   port     = 443
#   protocol = "HTTPS"
#   vpc_id   = var.vpc_id
# }

# HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_srv_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.http-target-group.arn
    type             = "forward"
  }
}


# resource "aws_lb_listener" "https_listener" {
#   load_balancer_arn = aws_lb.web_srv_alb.arn
#   port              = "443"
#   protocol          = "HTTPS"

#   default_action {
#     target_group_arn = aws_lb_target_group.https-target-group.arn
#     type             = "forward"
#   }
# }


output "load_balancer_dns" {
  value = aws_lb.web_srv_alb.dns_name
}

