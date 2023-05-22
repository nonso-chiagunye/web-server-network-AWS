

variable "AWS_REGION" {
    type = string  
    default = "us-east-1" 
}

variable "WEB_SRV_VPC_CIDR" {
    type = string
    default = "192.168.0.0/16"
}

variable "WEB_SRV_PUB_SUBNET1_CIDR" {
    type = string 
    default = "192.168.10.0/24"
}

variable "WEB_SRV_PUB_SUBNET2_CIDR" {
    type = string 
    default = "192.168.11.0/24"
}

variable "WEB_SRV_PRIV_SUBNET1_CIDR" {
    type = string 
    default = "192.168.12.0/24"
}

variable "WEB_SRV_PRIV_SUBNET2_CIDR" {
    type = string 
    default = "192.168.13.0/24"
}

variable "ENVIRONMENT" {
    type = string 
    default = "Development"
}