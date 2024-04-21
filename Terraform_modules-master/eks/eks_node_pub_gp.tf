resource "aws_eks_node_group" "RST_eks_node_pub_group" {
  cluster_name    = aws_eks_cluster.RST-eks-cluster.name
  node_group_name = "${var.project}-pub-ng"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = [var.pub_sub1_id, var.pub_sub2_id]

  scaling_config {
    desired_size = var.desired_size_pub_ng
    max_size     = var.max_size_pub_ng
    min_size     = var.min_size_pub_ng
  }

  ami_type       = "AL2_x86_64"
  capacity_type  = var.capacity
  disk_size      = var.disk_size
  instance_types = [var.instance_types]

  tags = {
    "Name"                                             = "${var.project}-node_group"
    "k8s.io/cluster-autoscaler/${var.project}-cluster" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                = "true"
    "kubernetes.io/cluster/${var.project}-cluster"     = "owned"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}