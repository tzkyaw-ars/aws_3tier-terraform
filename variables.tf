variable "region" {
    type = string
    default = "ap-northeast-1"
}

variable "instance_type" {
  description = "Aws Instance Type"
  type = string
  default = "t3.micro"  
}

variable "bastion_instance_type" {
  description = "Bastion Instance type"
  type = string
  default = "t2.micro"
  
}

variable "aws_ami" {
  type = string
  default = "ami-0b20f552f63953f0e"
  
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

variable "key_name" {
  type = string
  default = "lab"
  
}

variable "role_name" {
  description = "Instance Login role name"
  type = string
  default = "Instance-Login"
  
}

# rds variables
variable "rds_db_username" {
  type = string
  description = "Username for the RDS instance"
  default = "admin"
}

variable "rds_db_password" {
  type = string
  default = "admin123"
}

variable "multi_az" {
  type = bool
  description = "Multi-az deployment for RDS"
  default = true
}

variable "replica_multi_az" {
  description = "Multiaz deployment for Replica"
  type = bool
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

variable "instance_class"{
  type = string
  description = "Instance type for RDS"
  default = "db.t3.large"
}

variable "replica_instance_class" {
  type = string
  description = "Instance type for rds replica"
  default = "db.t3.medium"
  
}

variable "db_engine" {
  description = "Database engine for RDS"
  default = "mysql"
}

variable "environment" {
  type = string
  description = "DB environment"
  default = "prod"
  
}

variable "max_allocated_storage" {
  type = number
  description = "DB maximum storage"
  default = 100
  
}