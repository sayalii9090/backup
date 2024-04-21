variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "project" {
  type        = string
  description = "Name of the project"
}

# variable "owner" {
#   type    = string
#   default = "Tejas"
# }

# variable "purpose" {
#   type    = string
#   default = "Project"
# }

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

# variable "vpc_cidr" {
#   type    = string
#   default = "10.30.0.0/16"
# }

# variable "vpc_name" {
#   type    = string
#   default = "tj-vpc"
# }

variable "public_subnets" {
  type        = list(string)
  description = "List of the Public IP CIDR blocks"
  #   default = ["10.30.1.0/24", "10.30.2.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "List of the Private IP CIDR block"
  #   default = ["10.30.10.0/24", "10.30.20.0/24"]
}

variable "availability_zones" {
  type = list(string)
  #   default = ["ap-south-1a", "ap-south-1b"]
}