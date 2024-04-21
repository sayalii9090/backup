
resource "aws_vpc" "EKSVPC" {
  cidr_block       = "${var.vpc_cidr}"
  tags = {
    Name = "${var.Namevpc}"
    Purpose ="${var.Purpose}"
    Owner = "${var.Owner}"
  }
}

# ///output

output "vpc_id" {
  value = "${aws_vpc.EKSVPC.id}"
}
