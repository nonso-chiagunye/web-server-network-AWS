

variable "ENVIRONMENT" {
  type    = string
  default = "Development"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-053b0d53c279acc90"
    us-east-2 = "ami-024e6efaf93d85776"
    us-west-1 = "ami-0f8e81a3da6e2510a"
    eu-west-1 = "ami-01dd271720c1ba44f"
  }
}

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}
