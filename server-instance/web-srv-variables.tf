

variable "ENVIRONMENT" {
    type = string 
    default = "Development"
}

variable "AWS_REGION" {
    type = string
    default = "us-east-1"
}

variable "rds_subnet1" {
    type = string 
    default = ""
}

variable "rds_subnet2" {
    type = string 
    default = ""
}

variable "vpc_id" {
    type = string 
    default = ""
}

variable "ALB_SG_NAME" {
    default = "alb-sg"
}

variable "alb_ports" {
    type = list(number)
    default = [80, 443]
}

variable "WEB_SRV_SG_NAME" {
    type = string 
    default = "web-srv-sg"
}

variable "web_srv_sg_ports" {
    type = list(number)
    default = [22, 80, 443]
}

variable "KEY_NAME" {
    type = string 
    default = "my_key"
}

# Specify path to your SSH Key-Pair
variable "path_to_public_key" {
    description = "Public Key Path"
    default = "/path/to/my_key.pub"
}

variable "LAUNCH_CONFIG_NAME" {
    type = string 
    default = "web-server-launch-config"
}

variable "INSTANCE_TYPE" {
    type = string 
    default = "t2.micro"
}

variable "VOLUME_TYPE" {
    default = "gp2"
}

variable "VOLUME_SIZE" {
    default = 60
}

variable "ASG_NAME" {
    default = "auto-scaling-group"
}

variable "ASG_MAX_SIZE" {
    default = 2
}

variable "ASG_MIN_SIZE" {
    default = 1
}

variable "ASG_HEALTH_CHECK_GRACE_PERIOD" {
    default = 30
}

variable "HEALTH_CHECK_TYPE" {
    default = "EC2"
}

variable "DESIRED_CAPACITY" {
    default = 1
}

variable "web_srv_subnet1" {
    type = string 
    default = ""
}

variable "web_srv_subnet2" {
    type = string 
    default = ""
}

variable "ALB_NAME" {
    default = "web-srv-lb"
}

variable "HTTP_TARGET_GROUP_NAME" {
    default = "http-target-group"
}

variable "HTTPS_TARGET_GROUP_NAME" {
    default = "https-target-group"
}

variable "AMIS" {
    type = map
    default = {
        us-east-1 = "ami-053b0d53c279acc90"
        us-east-2 = "ami-024e6efaf93d85776"
        us-west-1 = "ami-0f8e81a3da6e2510a"
        eu-west-1 = "ami-01dd271720c1ba44f"
    }
}





