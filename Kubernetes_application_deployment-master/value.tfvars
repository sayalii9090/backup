## Project
project     = "RST_EKS_Project"
region      = "ap-south-1"
tag_owner   = "Tejas"
tag_purpose = "EKS_Infra"

## Variabels for VPC
vpc_cidr     = "10.0.0.0/16"
vpc_tag_name = "EKS VPC"

## Values for Subnets
public_subnets    = ["10.0.0.0/18", "10.0.64.0/18"]
private_subnets   = ["10.0.128.0/18", "10.0.192.0/18"]
availability_zone = ["ap-south-1a", "ap-south-1b"]

## EKS Required Values
eks_version         = "1.27"
desired_size_pub_ng = 1
max_size_pub_ng     = 3
min_size_pub_ng     = 1
desired_size_pvt_ng = 1
max_size_pvt_ng     = 2
min_size_pvt_ng     = 1
ami_type            = "AL2_x86_64"
instance            = "t3a.small"
capacity            = "instance_type"
disk_size           = 20
