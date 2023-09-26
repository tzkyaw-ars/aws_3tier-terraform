variable "region" {
    type = string
    default = "ap-southeast-1"
}

variable "vpc_cidr_block" {
  type    = string
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "public_cidr_blocks" {
  type    = list(string)
  description = "CIDR blocks for public subnets"
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "private_cidr_blocks" {
  type    = list(string)
  description = "CIDR blocks for private subnets"
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

# rds variables
variable "rds_db_username" {
  type = string
  description = "Username for the RDS instance"
  default = "admin"
}

variable "rds_db_password" {
  type = string
  default = "password"
}

variable "multi_az" {
  type = bool
  description = "Multi-az deployment for RDS"
  default = false
}

variable "db_name" {
  type = string
  description = "Database name for RDS"
  default = "my_db"
}

variable "engine_version" {
  type = string
  description = "database engine version for RDS"
  default = "8.0.33"
}

variable "allocated_storage" {
  type = number
  description = "Storage size for RDS"
  default = 20
}

variable "storage_type" {
  type = string
  description = "Storage type for RDS"
  default = "gp3"
}

variable "instance_class" {
  type = string
  description = "Instance type for RDS"
  default = "db.t3.micro"
}

variable "db_engine" {
  description = "Database engine for RDS"
  default = "mysql"
}