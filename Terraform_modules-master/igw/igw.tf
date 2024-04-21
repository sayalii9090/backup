resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.project}-igw"
  }
}

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

resource "aws_route_table_association" "public1_rt_association" {
  subnet_id      = var.pub_sub1
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public2_rt_association" {
  subnet_id      = var.pub_sub2
  route_table_id = aws_route_table.public-rt.id
}