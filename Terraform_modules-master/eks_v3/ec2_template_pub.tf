resource "aws_launch_template" "ec2LaunchTemp_pub" {
  name          = "ec2_launch_template_pub"
  # image_id      = "ami-046ed6d847a81ccff"
  instance_type = var.instance_types
  key_name      = "Sayali-m"
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "tj_eks_pub"
      Owner   = "Tejas"
      Purpose = "EKS_Project"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      Name    = "tj_eks_pub"
      Owner   = "Tejas"
      Purpose = "EKS_Project"
    }
  }
}