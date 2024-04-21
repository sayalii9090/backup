provider "aws" {
  region = var.region
}

## VPC modules
module "EKS_vpc" {
  source   = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/vpc"
  vpc_cidr = var.vpc_cidr
  Namevpc  = var.Namevpc
  Owner    = var.Owner
  Purpose  = var.Purpose
}

## internet gateway
module "EKS_igw" {
  source  = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/internetgw"
  vpc_id  = module.EKS_vpc.vpc_id
  NameIG  = var.NameIG
  Owner   = var.Owner
  Purpose = var.Purpose
}

# Route table creation
module "EKS_rttbl" {
  source     = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/routetable"
  vpc_id     = module.EKS_vpc.vpc_id
  igw_id     = module.EKS_igw.igw_id
  cidr_block = var.cidr_block
  NameRT     = var.NameRT
  Owner      = var.Owner
  Purpose    = var.Purpose
}

# security group creation
module "EKS_SCGP" {
  source        = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/securitygrp"
  vpc_id        = module.EKS_vpc.vpc_id
  ingress_rules = var.ingress_rules
  NameSG        = var.NameSG
  Owner         = var.Owner
  Purpose       = var.Purpose
  protocal      = var.protocal
  secgrp_id     = module.EKS_SCGP.secgrp_id
}

# Public subnets creation
module "EKS_subnets" {
  source    = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/subnets"
  vpc_id    = module.EKS_vpc.vpc_id
  subnets   = var.subnets
  subnettag = var.subnettag
  Owner     = var.Owner
  Purpose   = var.Purpose
}

# Private subnet creation
module "EKS_Pvtsubnets" {
  source       = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/pvtsubnets"
  vpc_id       = module.EKS_vpc.vpc_id
  pvtsubnets   = var.pvtsubnets
  pvtsubnettag = var.pvtsubnettag
  Owner        = var.Owner
  Purpose      = var.Purpose
}

# Route table association 
module "EKS_routeassociation" {
  source         = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/routeassociation"
  route_table_id = module.EKS_rttbl.route_table_id
  subnet_id      = module.EKS_subnets.subnet_id

}

# Getting all parameters into output
output "infra" {
  value = [var.region, module.EKS_vpc.vpc_id, module.EKS_igw.igw_id, module.EKS_rttbl.route_table_id, module.EKS_subnets.subnet_id, module.EKS_routeassociation.routeassociation_id, module.EKS_Pvtsubnets.pvtsubnet_id]
}