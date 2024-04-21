resource "aws_subnet" "EKS_pvtsubnets" {
  for_each = var.pvtsubnets
 
  availability_zone = each.value["az2"]
  cidr_block = each.value["cidr2"]
  vpc_id = "${var.vpc_id}"
  tags = {
    Name = "${var.pvtsubnettag}-${each.key}"
    Purpose ="${var.Purpose}"
    Owner = "${var.Owner}"
  }  
}
output "pvtsubnet_id" {
    value = tomap({
        for i, j in aws_subnet.EKS_pvtsubnets : i => j.id
    })
}
