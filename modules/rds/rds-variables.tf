

variable "AWS_REGION" {
    type = string 
    default = "us-east-1"
}


variable "ENVIRONMENT" {
    type = string 
    default = "Development"
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


variable "RDS_CIDR" {
    type = string 
    default = "192.168.0.0/16"
}


variable "RDS_NAME" {
    type = string 
    default = "web-srv-db"
}


variable "RDS_ALLOCATED_STORAGE" {
    type = string 
    default = "40" 
}

variable "RDS_STORAGE_TYPE" {
    type = string 
    default = "gp2" 
}


variable "RDS_ENGINE" {
    type = string 
    default = "mysql" 
}

variable "RDS_ENGINE_VERSION" {
    type = string 
    default = "8.0.28" 
}

variable "RDS_INSTANCE_CLASS" {
    type = string 
    default = "db.t3.micro" 
}

variable "RDS_BACKUP_RETENTION_PERIOD" {
    default = "8" 
}

variable "PUBLICLY_ACCESSIBLE" {
    default = true 
}

variable "RDS_USERNAME" {
    type = string 
    default = "" 
}

variable "RDS_PASSWORD" {
    type = string 
    default = ""
}

variable "RDS_MULTI_AZ" {
    default = false 
}

variable "RDS_SNET_GRP_NAME" {
    default = "rds-snet-grp"
}

variable "environment" {
    default = "development"
}