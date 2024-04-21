resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

output "vpc_id" {
  value = aws_vpc.terraform_vpc.id
}