
# If you need to call the VPC Module here
# module "web-srv-vpc" {
#     source      = "../vpc"

#     ENVIRONMENT = var.ENVIRONMENT
#     AWS_REGION  = var.AWS_REGION
# }


# Database Subnet Group. This should be part of the private subnets
resource "aws_db_subnet_group" "rds-snet-grp" {

    name          = "${var.environment}-rds-subnet-group"
    description   = "Database for Web Server"
    subnet_ids    = [
      "${var.rds_subnet1}",
      "${var.rds_subnet2}",
    ]
    tags = {
        Name         = "${var.ENVIRONMENT}-${var.RDS_SNET_GRP_NAME}"
    }
}

# RDS uses port 3306. Access should be restricted to Instances in Private Subnet
resource "aws_security_group" "rds-sg" {

  name = "${var.ENVIRONMENT}-rds-sg"
  description = "DB Instance Security Group"
  vpc_id      = var.vpc_id 

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.RDS_CIDR}"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "${var.ENVIRONMENT}-rds-sg"
   }
}

# Database instance (here is MySQL)
resource "aws_db_instance" "web_srv_rds" {
  identifier = "${var.environment}-srv-rds"
  allocated_storage = var.RDS_ALLOCATED_STORAGE
  storage_type = var.RDS_STORAGE_TYPE 
  engine = var.RDS_ENGINE
  engine_version = var.RDS_ENGINE_VERSION
  instance_class = var.RDS_INSTANCE_CLASS
  backup_retention_period = var.RDS_BACKUP_RETENTION_PERIOD
  publicly_accessible = var.PUBLICLY_ACCESSIBLE
  username = var.RDS_USERNAME
  password = var.RDS_PASSWORD
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds-snet-grp.name
  multi_az = var.RDS_MULTI_AZ 
}

# Output of Database endpoint for use in child modules
output "rds_db_endpoint" {
    value = aws_db_instance.web_srv_rds.endpoint 
}
