resource "aws_launch_template" "eks_nodes" {
  name          = "${var.project}-node"
  image_id      = "ami-0d13e3e640877b0b9"
  instance_type = var.instance_family
  key_name      = var.key
  block_device_mappings {
    ebs {
      volume_size = var.disk_size
    }
  }

  instance_market_options {
    market_type = var.capacity
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "EKS-Cluster-Node"
    }
  }
}

output "launch_template_id" {
  value = aws_launch_template.eks_nodes.id
}