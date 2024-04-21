
//////Infra tags

variable "region" {}

variable "Namevpc" {
}
variable "NameIG" {
}
variable "NameSG" {
}
variable "NameRT" {
}
variable "Owner" {
  type        = string
  description = "Value used for tagging Owner"
}

variable "Purpose" {
  type        = string
  description = "Purpose of the infrastructure creation"
}

variable "subnettag" {
  type = string
}
variable "pvtsubnettag" {
  type = string
}
variable "vpc_cidr" {
}
#map of maps for create subnets
variable "subnets" {
  type = map(any)
}
variable "pvtsubnets" {
  type = map(any)
}


### Route Tables
variable "cidr_block" {
  type    = string
  default = "0.0.0.0/0"

}
////security grp///
variable "protocal" {
  type    = string
  default = "tcp"
}

variable "ingress_rules" {
  default = {
    "my ingress rule" = {

      "from_port" = "80"
      "to_port"   = "80"

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
variable "instance" {
  type        = string
  description = "Instance Type"
  default     = "t3a.medium"
}
variable "project" {
  type        = string
  description = "Name of the Project and Cluster"
  default     = "tj-eks-project"
}

variable "Cluster_role_id" {
  type        = string
  description = "Name of the Project and Cluster"

}