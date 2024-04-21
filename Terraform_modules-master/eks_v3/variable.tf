variable "project" {
  type        = string
  description = "Name of the project"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

## Subnet for Public Subnet
variable "private_subnets" {
  type        = list(string)
  description = "CIDR Block of Public Subnet"
}

## Subnet for Private Subnet
variable "public_subnets" {
  type        = list(string)
  description = "CIDR Block of Private Subnet"
}

## Subnet IDs
variable "private_subnet_ids" {
  type        = list(string)
  description = "IDs of Public Subnet"
}
variable "public_subnet_ids" {
  type        = list(string)
  description = "IDs of Private Subnet"
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
variable "instance_types" {
  type        = string
  description = "Type of the instance"
}

## EKS Configuration
variable "eks_version" {
  type        = string
  description = "EKS Version"
  default     = "1.21"
}