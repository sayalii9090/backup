
variable "route_table_id" {
    type = string
}
variable "subnet_id" {
    type = map
}

variable "subnets" {
   type = map
   default = {
      sub-1 = {
            "subId" = "subnet-09747f4641bfff80f"}
      sub-2 = {
            "subId" =   "subnet-079b0539c957791e7"}
   }
}
