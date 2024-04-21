variable "project" {
  type        = string
  description = "Name of the project"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "pub_sub1" {
  type        = string
  description = "CIDR Block of Public Subnet"
}

variable "pub_sub2" {
  type        = string
  description = "CIDR Block of Public Subnet 2"
}