region = "ap-southeast-1"

Cluster_role_id = "ap-southeast-1"

vpc_cidr = "10.0.0.0/16"

Namevpc = "EKS_VPC"

NameIG = "EKS_INTGW"

NameSG = "EKS_SecurityGrp"

NameRT = "EKS_RouteTable"

Owner = "RadhikaN"

Purpose = "AWS_EKS_Project"

subnettag = "EKS_Public"

pvtsubnettag = "EKS_Private"

subnets = {
  sub-1 = {
    az1  = "ap-southeast-1a"
    cidr = "10.0.198.0/24"
  }
  sub-2 = {
    az1  = "ap-southeast-1b"
    cidr = "10.0.199.0/24"
  }
}

pvtsubnets = {
  sub-3 = {
    az2   = "ap-southeast-1a"
    cidr2 = "10.0.200.0/24"
  }
  sub-4 = {
    az2   = "ap-southeast-1b"
    cidr2 = "10.0.201.0/24"
  }
}