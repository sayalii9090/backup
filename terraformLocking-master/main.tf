terraform {
  backend "s3" {
    bucket = "tejastest1"
    key = "path/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "ST-Test"
  }
}

provider "aws" {
  region = var.region
}

locals {
  tName = var.tName
  tOwner = var.tOwner
  tPurpose = var.tPurpose
}
resource "aws_instance" "tejasEc2" {
  ami = var.ec2AMI
  instance_type = var.ec2Type
  availability_zone = var.ec2AZ
  vpc_security_group_ids = ["sg-0efc02319e1096486"]
  key_name = "tjkey"
  count = 2
  tags = {
    "Name" = local.tName
    "Owner" = local.tOwner
    "Purpose" = local.tPurpose
  }
  user_data = <<-EOF
  #! /bin/bash
  sudo yum update -y
  sudo yum upgrade -y
  sudo yum install httpd -y
  sudo systemctl enable httpd
  sudo systemctl start httpd
  echo "Welcome to my webpage" > /var/www/html/index.html
  EOF
}