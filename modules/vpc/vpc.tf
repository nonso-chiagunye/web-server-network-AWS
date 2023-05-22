# Resource Provider
provider "aws" {
  region     = var.AWS_REGION
}


# Availability Zone Data source
data "aws_availability_zones" "available" {
  state = "available"
}

# Create VPC
resource "aws_vpc" "web_srv_vpc" {
  cidr_block       = var.WEB_SRV_VPC_CIDR
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-vpc"
  }
}

# 2 Public subnets in 2 AZs
resource "aws_subnet" "web_srv_pub_subnet1" {
  vpc_id     = aws_vpc.web_srv_vpc.id
  cidr_block = var.WEB_SRV_PUB_SUBNET1_CIDR
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-vpc-pub-subnet1"
  }
}

resource "aws_subnet" "web_srv_pub_subnet2" {
  vpc_id     = aws_vpc.web_srv_vpc.id
  cidr_block = var.WEB_SRV_PUB_SUBNET2_CIDR
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.ENVIRONMENT}-vpc-pub-subnet2"
  }
}

# 2 Private Subnets in 2 AZs
resource "aws_subnet" "web_srv_priv_subnet1" {
  vpc_id     = aws_vpc.web_srv_vpc.id
  cidr_block = var.WEB_SRV_PRIV_SUBNET1_CIDR
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.ENVIRONMENT}-vpc-priv-subnet1"
  }
}


resource "aws_subnet" "web_srv_priv_subnet2" {
  vpc_id     = aws_vpc.web_srv_vpc.id
  cidr_block = var.WEB_SRV_PRIV_SUBNET2_CIDR
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.ENVIRONMENT}-vpc-priv-subnet2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "web_srv_igw" {
  vpc_id = aws_vpc.web_srv_vpc.id

  tags = {
    Name = "${var.ENVIRONMENT}-vpc-igw"
  }
}

# Elastic IP
resource "aws_eip" "web_srv_eip" {
  vpc      = true
  depends_on = [aws_internet_gateway.web_srv_igw]
}

# NAT Gateway 
resource "aws_nat_gateway" "web_srv_ngw" {
  allocation_id = aws_eip.web_srv_eip.id
  subnet_id     = aws_subnet.web_srv_pub_subnet1.id
  depends_on = [aws_internet_gateway.web_srv_igw]
  tags = {
    Name = "${var.ENVIRONMENT}-vpc-NAT-gateway"
  }
}

# Public Subnet Route Table
resource "aws_route_table" "pub_subnets_route" {
  vpc_id = aws_vpc.web_srv_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_srv_igw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-vpc-public-route-table"
  }
}

# Private Subnet Route Table
resource "aws_route_table" "priv_subnets_route" {
  vpc_id = aws_vpc.web_srv_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.web_srv_ngw.id
  }

  tags = {
    Name = "${var.ENVIRONMENT}-vpc-private-route-table"
  }
}

# Public Subnet Route Table Association
resource "aws_route_table_association" "assoc_to_pub_subnet1" {
  subnet_id      = aws_subnet.web_srv_pub_subnet1.id
  route_table_id = aws_route_table.pub_subnets_route.id
}

resource "aws_route_table_association" "assoc_to_pub_subnet2" {
  subnet_id      = aws_subnet.web_srv_pub_subnet2.id
  route_table_id = aws_route_table.pub_subnets_route.id
}

# Private Subnet Route Table Association
resource "aws_route_table_association" "assoc_to_priv_subnet1" {
  subnet_id      = aws_subnet.web_srv_priv_subnet1.id
  route_table_id = aws_route_table.priv_subnets_route.id
}

resource "aws_route_table_association" "assoc_to_priv_subnet2" {
  subnet_id      = aws_subnet.web_srv_priv_subnet2.id
  route_table_id = aws_route_table.priv_subnets_route.id
}

# Module Outputs for Child Modules 

# VPC ID
output "web_srv_vpc_id" {
    description = "ID for Web Srv VPC"
    value = aws_vpc.web_srv_vpc.id
}

# Public Subnet1 ID
output "pub_subnet1_id" {
    description = "ID for Public Subnet1"
    value = aws_subnet.web_srv_pub_subnet1.id
}

# Public Subnet2 ID
output "pub_subnet2_id" {
    description = "ID for Public Subnet2"
    value = aws_subnet.web_srv_pub_subnet2.id 
}

# Private Subnet1 ID
output "priv_subnet1_id" {
    description = "ID for Private Subnet1"
    value = aws_subnet.web_srv_priv_subnet1.id 
}

# Private Subnet2 ID 
output "priv_subnet2_id" {
    description = "ID for Private Subnet2"
    value = aws_subnet.web_srv_priv_subnet2.id 
}