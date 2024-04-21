variable "project" {
  type        = string
  description = "Name of the project"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_sub_1" {
  type        = string
  description = "Public Subnet 1"
  default     = "10.20.0.0/18"
}

variable "public_sub_2" {
  type        = string
  description = "Public Subnet 1"
  default     = "10.20.64.0/18"
}

variable "private_sub_1" {
  type        = string
  description = "Private Subnet 1"
  default     = "10.20.128.0/18"
}

variable "private_sub_2" {
  type        = string
  description = "Private Subnet 2"
  default     = "10.20.192.0/18"
}

variable "az1" {
  type        = string
  description = "AZ for Subnet 1"
  default     = "ap-south-1a"
}

variable "az2" {
  type        = string
  description = "AZ for Subnet 1"
  default     = "ap-south-1b"
}
