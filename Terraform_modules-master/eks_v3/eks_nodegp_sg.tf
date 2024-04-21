resource "aws_security_group" "worker_node_sg" {
  name   = "${var.project}-worker_node_sg"
  vpc_id = var.vpc_id
  tags = {
    "Name"                                 = "${var.project}-worker_node_sg"
    "kubernetes.io/cluster/${var.project}" = "owned"
  }
}

resource "aws_security_group_rule" "node_communication" {
  description       = "This rule is allow to communicate with each other"
  security_group_id = aws_security_group.worker_node_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = concat(var.public_subnets, var.private_subnets)
}

resource "aws_security_group_rule" "node_inbound" {
  description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id = aws_security_group.worker_node_sg.id
  type              = "ingress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = var.public_subnets
}

resource "aws_security_group_rule" "node_outbound" {
  description       = "worker node outbound"
  security_group_id = aws_security_group.worker_node_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}