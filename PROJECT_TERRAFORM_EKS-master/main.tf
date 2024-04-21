provider "aws" {
  region = var.region
}

variable "region" {}

variable "capacity" {}


#E VPC modules
module "EKS_vpc" {
  source   = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/vpc"
  vpc_cidr = var.vpc_cidr
  Namevpc  = var.Namevpc
  Owner    = var.Owner
  Purpose  = var.Purpose
}

## internet gateway
module "EKS_igw" {
  source  = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/internetgw"
  vpc_id  = module.EKS_vpc.vpc_id
  NameIG  = var.NameIG
  Owner   = var.Owner
  Purpose = var.Purpose
}

# Route table creation
module "EKS_rttbl" {
  source     = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/routetable"
  vpc_id     = module.EKS_vpc.vpc_id
  igw_id     = module.EKS_igw.igw_id
  cidr_block = var.cidr_block
  NameRT     = var.NameRT
  Owner      = var.Owner
  Purpose    = var.Purpose
}

# security group creation
# module "EKS_SCGP" {
# source      = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/securitygrp"
# vpc_id      = "${module.EKS_vpc.vpc_id}"
# ingress_rules    = var.ingress_rules
# NameSG  = var.NameSG
# Owner  = var.Owner
# Purpose  = var.Purpose
# protocal = var.protocal
# secgrp_id   = "${module.EKS_SCGP.secgrp_id}"
# }

# Public subnets creation
module "EKS_subnets" {
  source    = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/subnets"
  vpc_id    = module.EKS_vpc.vpc_id
  subnets   = var.subnets
  subnettag = var.subnettag
  Owner     = var.Owner
  Purpose   = var.Purpose
}

# Private subnet creation
module "EKS_Pvtsubnets" {
  source       = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/pvtsubnets"
  vpc_id       = module.EKS_vpc.vpc_id
  pvtsubnets   = var.pvtsubnets
  pvtsubnettag = var.pvtsubnettag
  Owner        = var.Owner
  Purpose      = var.Purpose
}

# Route table association 
module "EKS_routeassociation" {
  source         = "git::https://github.com/radhikaepiq/EKS_PROJECT.git//modules/routeassociation"
  route_table_id = module.EKS_rttbl.route_table_id
  subnet_id      = module.EKS_subnets.subnet_id

}

# Getting all parameters into output
output "infra" {
  value = [var.region, module.EKS_vpc.vpc_id, module.EKS_igw.igw_id, module.EKS_rttbl.route_table_id, module.EKS_subnets.subnet_id, module.EKS_routeassociation.routeassociation_id, module.EKS_Pvtsubnets.pvtsubnet_id]
}

//// create elastic ip for EKS
resource "aws_eip" "eip_eks" {
  vpc = true
  tags = {
    "Name" = "${var.project}-eip"
  }
}

///IAM role for EKS cluster
resource "aws_iam_role" "cluster_role" {
  name               = "${var.project}-Cluster-Role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster_role.name
}
//////EKS cluster creation

resource "aws_eks_cluster" "tj-eks-cluster" {
  name     = "${var.project}-cluster"
  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.22"

  vpc_config {
    subnet_ids = module.EKS_subnets.subnet_id_2
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,
  ]

  tags = {
    "Name" = "${var.project}-cluster"
  }

}
/////eks node iam role
resource "aws_iam_role" "node" {
  name = "${var.project}-worker-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

///EKS node SG
resource "aws_security_group" "eks_nodes" {
  name        = "${var.project}-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = module.EKS_vpc.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Egress for nodes"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    "Name"                                         = "${var.project}-node-sg"
    "kubernetes.io/cluster/${var.project}-cluster" = "owned"
  }
}

resource "aws_security_group_rule" "node_internal" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "node_cluster_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}

///eks node group
resource "aws_eks_node_group" "tj_eks_node_group" {
  cluster_name    = aws_eks_cluster.tj-eks-cluster.name
  node_group_name = var.project
  node_role_arn   = aws_iam_role.node.arn

  subnet_ids = module.EKS_subnets.subnet_id_2

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  ami_type       = "AL2_x86_64"
  capacity_type  = var.capacity
  disk_size      = 20
  instance_types = [var.instance]

  tags = {
    "Name"                                             = "${var.project}-node_group"
    "k8s.io/cluster-autoscaler/${var.project}-cluster" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                = "true"
    "kubernetes.io/cluster/${var.project}-cluster"     = "owned"
    "Owner"                                            = var.Owner
    "Purpose"                                          = var.Purpose
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}

////SG for control plane
resource "aws_security_group" "control_plane_sg" {
  name   = "${var.project}-ControlPlane-sg"
  vpc_id = module.EKS_vpc.vpc_id
  tags = {
    "Name" = "${var.project}-ControlPlane-sg"
  }
}

resource "aws_security_group_rule" "control_plane_inbound" {
  security_group_id = aws_security_group.control_plane_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["10.0.1.0/26", "10.0.1.64/26", "10.0.1.128/26", "10.0.1.192/26"]
}

resource "aws_security_group_rule" "control_plane_outbound" {
  security_group_id = aws_security_group.control_plane_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

////SG of EKS cluster

resource "aws_security_group" "eks_cluster" {
  name        = "${var.project}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = module.EKS_vpc.vpc_id
  tags = {
    "Name" = "${var.project}-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communication with cluster API server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.worker_node_sg.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow clsuter API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.worker_node_sg.id
  to_port                  = 65535
  type                     = "egress"
}

/////SG of Nodes 
resource "aws_security_group" "worker_node_sg" {
  name   = "${var.project}-worker_node_sg"
  vpc_id = module.EKS_vpc.vpc_id
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
  cidr_blocks       = ["10.0.1.0/26", "10.0.1.64/26", "10.0.1.128/26", "10.0.1.192/26"]
}

resource "aws_security_group_rule" "node_inbound" {
  description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id = aws_security_group.worker_node_sg.id
  type              = "ingress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["10.0.1.128/26", "10.0.1.192/26"]
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