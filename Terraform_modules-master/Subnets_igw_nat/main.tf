## Public Subnet Creation
resource "aws_subnet" "public_sub" {
  for_each                = toset(var.public_subnets)
  vpc_id                  = var.vpc_id
  cidr_block              = each.key
  availability_zone       = var.availability_zones[index(var.public_subnets, each.key) % length(var.availability_zones)]
  map_public_ip_on_launch = true
  tags = {
    Name                                           = "PublicSubnet-${index(var.public_subnets, each.key) + 1}"
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
    "kubernetes.io/role/elb"                       = "1"
  }
}

## Private Subnet Creation
resource "aws_subnet" "private_sub" {
  for_each          = toset(var.private_subnets)
  vpc_id            = var.vpc_id
  cidr_block        = each.key
  availability_zone = var.availability_zones[index(var.private_subnets, each.key) % length(var.availability_zones)]
  tags = {
    Name                                           = "PrivateSubnet-${index(var.private_subnets, each.key) + 1}"
    "kubernetes.io/cluster/${var.project}-cluster" = "shared"
    "kubernetes.io/role/elb"                       = "1"
  }
}

## Internet Gateway Creation
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.project}-igw"
  }
}

## Route Table Creation
resource "aws_route_table" "public-rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project}-public-rt"
  }
}

## Route Table Assosiation
resource "aws_route_table_association" "public_route_table_assosiation" {
  for_each       = aws_subnet.public_sub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public-rt.id
}

output "public_subnet_ids" {
  value = values({
    for k, s in aws_subnet.public_sub : k => s.id
  })
}

output "private_subnet_ids" {
  value = values({
    for k, s in aws_subnet.private_sub : k => s.id
  })
}

//////////////////////////// NAT GW Creation ///////////////
resource "aws_eip" "eip" {
  tags = {
    Name = "${var.project}-eip"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = values(aws_subnet.public_sub)[0].id
  tags = {
    Name = "${var.project}-nat-gw"
  }
}

resource "aws_route_table" "pvt-rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "${var.project}-pvt-rt"
  }
}

resource "aws_route_table_association" "pvt_sub_association" {
  for_each       = aws_subnet.private_sub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.pvt-rt.id
}
