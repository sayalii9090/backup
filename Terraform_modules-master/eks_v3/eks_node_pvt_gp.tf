resource "aws_eks_node_group" "tj_eks_node_pvt_group" {
  cluster_name    = aws_eks_cluster.tj-eks-cluster.name
  node_group_name = "${var.project}-pvt-ng"
  node_role_arn   = aws_iam_role.worker_node.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_size_pvt_ng
    max_size     = var.max_size_pvt_ng
    min_size     = var.min_size_pvt_ng
  }

  ami_type       = "AL2_x86_64"
  capacity_type = var.capacity
  # disk_size      = var.disk_size
  # instance_types = [var.instance_types]

  launch_template {
    name    = aws_launch_template.ec2LaunchTemp_pvt.name
    version = "$Latest"
  }

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