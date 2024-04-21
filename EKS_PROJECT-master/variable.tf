
//////Infra tags
variable "Namevpc" {
 default = "EKS_VPC"
}
variable "NameIG" {
 default = "EKS_INTGW"
}
variable "NameSG" {
  default = "EKS_SecurityGrp"
}
variable "NameRT" {
   default = "EKS_RouteTable"
}
variable "Owner" {
  type = string
  description = "Value used for tagging Owner"
  default = "RadhikaN"
}

variable "Purpose" {
  type = string
  description = "Purpose of the infrastructure creation"
  default = "EKSProject"
}


variable "subnettag" {
  type = string
   default = "EKS_Public"
}
variable "pvtsubnettag" {
  type = string
   default = "EKS_Private"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
#map of maps for create subnets
variable "subnets" {
   type = map
   default = {
      sub-1 = {
         az1 = "aps1-az1"
         cidr = "10.0.198.0/24"
      }
      sub-2 = {
         az1 = "aps1-az2"
         cidr = "10.0.199.0/24"
      }
}
}
variable "pvtsubnets" {
   type = map
   default = {
      sub-3 = {
         az2 = "aps1-az1"
         cidr2 = "10.0.200.0/24"
      }
      sub-4 = {
         az2 = "aps1-az2"
         cidr2 = "10.0.201.0/24"
      }
}
}


### Route Tables
variable "cidr_block" {
    type = string
    default = "0.0.0.0/0"
  
}
////security grp///
variable "protocal"{
    type = string  
    default = "tcp"
}

variable "ingress_rules" {
  default     = {
    "my ingress rule" = {
    
      "from_port"   = "80"
      "to_port"     = "80"
 
      "cidr_blocks" = ["0.0.0.0/0"]
    },
    "my other ingress rule" = {
      "from_port"   = "22"
      "to_port"     = "22"
      "cidr_blocks" = ["0.0.0.0/0"]
    }
  }
  type        = map(any)
  description = "Security group rules"
}
////eks needed 
variable "capacity" {
  type = string
  description = "Can be On Demand or Spot"
  default = "ON_DEMAND"
}   

variable "instance" {
  type = string
  description = "Instance Type"
  default = "t3a.medium"
}
variable "project" {
  type = string
  description = "Name of the Project and Cluster"
  default = "tj-eks-project"
}


### EKS 
# variable  "eks_Subnet"{
#   type  = any
# }
