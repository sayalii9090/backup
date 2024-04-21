variable "project" {
  type        = string
  description = "Name of the project"
  default     = "RST_EKS_Project"
}

variable "region" {
  type        = string
  description = "Region for infra deployment"
}

variable "tag_owner" {
  type        = string
  description = "Owner Name"
}

variable "tag_purpose" {
  type        = string
  description = "Purpose of the project"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR Value for VPC"
}

variable "vpc_tag_name" {
  type        = string
  description = "Name tag value"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of Public CIDR"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of Private CIDR"
}

variable "availability_zone" {
  type        = list(string)
  description = "List of Availability Zone"
}

## Node Group Configuration
variable "desired_size_pvt_ng" {
  type        = number
  description = "Desired Size of the cluster"
}
variable "max_size_pvt_ng" {
  type        = number
  description = "Maximum Size of EC2"
}
variable "min_size_pvt_ng" {
  type        = number
  description = "Minimum size of EC2"
}
variable "desired_size_pub_ng" {
  type        = number
  description = "Desired Size of the cluster"
}
variable "max_size_pub_ng" {
  type        = number
  description = "Maximum Size of EC2"
}
variable "min_size_pub_ng" {
  type        = number
  description = "Minimum size of EC2"
}

## Scaling Configuration
variable "ami_type" {
  type        = string
  description = "Type of the AMI"
}
variable "capacity" {
  type        = string
  description = "Can be ON_DEMAND or SPOT"
  default     = "ON_DEMAND"
}
variable "disk_size" {
  type        = number
  description = "Disk Size of the node"
  default     = 20
}
variable "instance" {
  type        = string
  description = "Type of the instance"
}

## EKS Configuration
variable "eks_version" {
  type        = string
  description = "EKS Version"
  default     = "1.21"
}
