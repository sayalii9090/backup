## Provider Block Configuration
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Owner   = var.tag_owner
      Purpose = var.tag_purpose
    }
  }
}

## S3 Backend Configuration
terraform {
  backend "s3" {
    bucket         = "rst-eks-project-state-file"
    region         = "ap-south-1"
    key            = "RST/EKS/terraform.tfstate"
    dynamodb_table = "rst-eks-state-lock"
    encrypt        = true
  }
}

## VPC Creation
module "vpc" {
  source   = "git::https://github.com/tejasacharekar1/Terraform_modules.git//vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_tag_name
}

## Subnet, IGW, NAT and Route Table Assosiation
module "Subnet" {
  source             = "git::https://github.com/tejasacharekar1/Terraform_modules.git//Subnets_igw_nat"
  vpc_id             = module.vpc.vpc_id
  project            = var.project
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zone
}

## Module for Security Group
module "infra-sg" {
  source  = "git::https://github.com/tejasacharekar1/Terraform_modules.git//security-gp"
  vpc_id  = module.vpc.vpc_id
  project = var.project
}

## EKS Cluster Creation
module "tj_test" {
  source              = "git::https://github.com/tejasacharekar1/Terraform_modules.git//eks_v3"
  project             = var.project
  vpc_id              = module.vpc.vpc_id
  eks_version         = var.eks_version
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  desired_size_pub_ng = var.desired_size_pub_ng
  max_size_pub_ng     = var.max_size_pub_ng
  min_size_pub_ng     = var.min_size_pub_ng
  desired_size_pvt_ng = var.desired_size_pvt_ng
  max_size_pvt_ng     = var.max_size_pvt_ng
  min_size_pvt_ng     = var.min_size_pvt_ng
  ami_type            = var.ami_type
  capacity            = var.capacity
  disk_size           = var.disk_size
  instance_types      = var.instance
  public_subnet_ids   = module.Subnet.public_subnet_ids
  private_subnet_ids  = module.Subnet.private_subnet_ids
}
