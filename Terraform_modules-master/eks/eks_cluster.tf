resource "aws_eks_cluster" "RST-eks-cluster" {
  name     = "${var.project}-cluster"
  role_arn = aws_iam_role.cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = [var.pub_sub1_id, var.pub_sub2_id, var.pvt_sub1_id, var.pvt_sub2_id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,
  ]

  tags = {
    "Name" = "${var.project}-cluster"
  }
}