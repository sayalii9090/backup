resource "aws_eks_cluster" "tj-eks-cluster" {
  name     = "${var.project}-cluster"
  role_arn = aws_iam_role.cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,
  ]

  tags = {
    "Name" = "${var.project}-cluster"
  }
}