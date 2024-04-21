resource "aws_security_group" "EKS_SCGP" {
vpc_id = "${var.vpc_id}"
 dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port        = lookup(ingress.value, "from_port", null)
      to_port          = lookup(ingress.value, "to_port", null)
      protocol         = "${var.protocal}"
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
    }
  }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "${var.NameSG}"
    Purpose ="${var.Purpose}"
    Owner = "${var.Owner}"
  }
}

output "secgrp_id" {
  value = "${aws_security_group.EKS_SCGP.id}"
}