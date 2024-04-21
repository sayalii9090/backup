resource "aws_eip" "eip" {
  tags = {
    Name = "${var.project}-eip"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = var.pub_subnet_id
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

resource "aws_route_table_association" "pvt_sub1_association" {
  subnet_id      = var.pvt_subnet_id1
  route_table_id = aws_route_table.pvt-rt.id
}

resource "aws_route_table_association" "pvt_sub2_association" {
  subnet_id      = var.pvt_subnet_id2
  route_table_id = aws_route_table.pvt-rt.id
}