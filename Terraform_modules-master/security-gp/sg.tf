resource "aws_security_group" "EKS-SG" {
  name        = "EKS-SG"
  description = "Allow input trafic"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.project}-SG"
  }
  dynamic "ingress" {
    for_each = [80, 443, 22, 3306]
    iterator = port
    content {
      description = "TLS for VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}