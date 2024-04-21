variable "project" {
  type        = string
  description = "Name of the project"
}

variable "key" {
  type        = string
  description = "Key Name"
}

variable "instance_family" {
  type        = string
  description = "Type of the instance family"
}

variable "disk_size" {
  type        = number
  description = "Disk Size of the node"
  default     = 20
}

variable "capacity" {
  type        = string
  description = "Can be ON_DEMAND or SPOT"
  default     = "ON_DEMAND"
}