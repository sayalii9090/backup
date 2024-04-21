variable "project" {
  type        = string
  description = "Name of the project"
}

variable "pub_subnet_id" {
  type        = string
  description = "Subnet ID for NAT gateway"
}

variable "pvt_subnet_id1" {
  type        = string
  description = "Subnet ID for NAT gateway"
}

variable "pvt_subnet_id2" {
  type        = string
  description = "Subnet ID for NAT gateway"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}