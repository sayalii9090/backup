resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_sub_1
  availability_zone       = var.az1
  map_public_ip_on_launch = true
  tags = {
    "Name"                                         = "public_subnet_1"
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
    "kubernetes.io/role/elb"                       = "1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_sub_2
  availability_zone       = var.az2
  map_public_ip_on_launch = true
  tags = {
    "Name"                                         = "public_subnet_2"
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
    "kubernetes.io/role/elb"                       = "1"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_sub_1
  availability_zone = var.az1
  tags = {
    "Name"                                         = "private_subnet_1"
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
    "kubernetes.io/role/elb"                       = "1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_sub_2
  availability_zone = var.az2
  tags = {
    "Name"                                         = "private_subnet_2"
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
    "kubernetes.io/role/elb"                       = "1"
  }
}

output "pub_sub_id1" {
  value = aws_subnet.public_subnet_1.id
}

output "pub_sub_id2" {
  value = aws_subnet.public_subnet_2.id
}

output "pvt_sub_id1" {
  value = aws_subnet.private_subnet_1.id
}

output "pvt_sub_id2" {
  value = aws_subnet.private_subnet_2.id
}