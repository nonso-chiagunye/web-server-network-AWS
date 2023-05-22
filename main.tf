
# Declare Provider
provider "aws" {
  region = var.AWS_REGION
}

# Call VPC Module
module "web-srv-vpc" {
  source = "./modules/vpc"

  ENVIRONMENT = var.ENVIRONMENT
  AWS_REGION  = var.AWS_REGION
}

# Call Webserver Module
module "web-server" {
  source = "./server-instance"

  ENVIRONMENT     = var.ENVIRONMENT
  AWS_REGION      = var.AWS_REGION
  rds_subnet1     = module.web-srv-vpc.priv_subnet1_id
  rds_subnet2     = module.web-srv-vpc.priv_subnet2_id
  vpc_id          = module.web-srv-vpc.web_srv_vpc_id
  web_srv_subnet1 = module.web-srv-vpc.pub_subnet1_id
  web_srv_subnet2 = module.web-srv-vpc.pub_subnet2_id

}

# Output Load Balancer Parameters 
output "load_balancer_details" {
  description = "Load Balancer Details"
  value       = module.web-server.load_balancer_dns
}
