
variable "vpc_cidr" {
  # default = "10.0.0.0/16"
  type = string
}


variable "Namevpc" {
 #default = "EKS_vpc"
}
variable "Owner" {
  type = string
  description = "Value used for tagging Owner"
# default = "RadhikaN"
}
#
variable "Purpose" {
  type = string
  description = "Purpose of the infrastructure creation"
#  default = "EKSProject"
}