variable "region" {
  description = "Region for AWS"
  type = string
  default = "ap-south-1"
}

variable "ec2AMI" {
    description = "ec2InstanceAMI"
    type = string
    default = "ami-079b5e5b3971bd10d"
}

variable "ec2Type" {
  description = "ec2Type"
  type = string
  default = "t2.micro"
}

variable "ec2AZ" {
  description = "ec2 AZ"
  type = string
  default = "ap-south-1a"
}

variable "tName" {
  description = "Tag Name"
  type = string
  default = "Tejas_test"
}

variable "tOwner" {
  description = "Tag Owner"
  type = string
  default = "Tejas"
}

variable "tPurpose" {
  description = "Tag Purpose"
  type = string
  default = "Terraform_practical"
}