# AWS region
variable "aws_region" {
  default = "us-west-2"
}

# Network
variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "az1"      { default = "us-west-2a" }
variable "az2"      { default = "us-west-2b" }

# Subnets Dashboard
variable "dashboard_subnet_az1" { default = "10.0.1.0/24" }
variable "dashboard_subnet_az2" { default = "10.0.2.0/24" }

# Subnets Backend
variable "backend_subnet_az1" { default = "10.0.3.0/24" }
variable "backend_subnet_az2" { default = "10.0.4.0/24" }

# Subnets Database
variable "db_subnet_az1" { default = "10.0.5.0/24" }
variable "db_subnet_az2" { default = "10.0.6.0/24" }

# Compute
variable "ami_id"         { default = "ami-0c94855ba95c71c99" }
variable "instance_type"  { default = "t2.micro" }
variable "key_name" { default = "pfa-key" }
# Database
variable "db_name"     { default = "mydb" }
variable "db_user"     { default = "admin" }
variable "db_password" { default = "Admin123!" }

variable "db_instance_class" { default = "db.t3.micro" }