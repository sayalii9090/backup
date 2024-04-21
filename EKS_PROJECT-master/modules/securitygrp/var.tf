variable "vpc_id" { type = string}
variable "secgrp_id" { type = string}
variable "NameSG" {
  type = string
}
variable "protocal"{
    type = string
   
}
variable "Owner" {
  type = string
}

variable "Purpose" {
  type = string
}
variable "ingress_rules" {
  type        = map(any)
}