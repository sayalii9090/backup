region = "ap-south-1"

Cluster_role_id = "ap-south-1"

vpc_cidr = "10.0.0.0/16"

Namevpc = "Ansible_VPC"

NameIG = "Ansible_INTGW"

NameSG = "Ansible_SecurityGrp"

NameRT = "Ansible_RouteTable"

Owner = "RadhikaN"

Purpose = "AWS_Ansible_Project"

subnettag = "Ansible_Public"

pvtsubnettag = "Ansible_Private"

subnets = {
  sub-1 = {
    az1  = "ap-south-1a"
    cidr = "10.0.198.0/24"
  }
  sub-2 = {
    az1  = "ap-south-1b"
    cidr = "10.0.199.0/24"
  }
}

pvtsubnets = {
  sub-3 = {
    az2   = "ap-south-1a"
    cidr2 = "10.0.200.0/24"
  }
  sub-4 = {
    az2   = "ap-south-1b"
    cidr2 = "10.0.201.0/24"
  }
}