# --------------------------------------------------------------------------------
# 1. Create launch template for EKS worker nodes
# --------------------------------------------------------------------------------
resource "aws_launch_template" "node_lt" {
  name_prefix = "${aws_eks_cluster.main_eks_cluster.name}-eks-lt"

  vpc_security_group_ids = [var.eks_worker_sg_id]

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.disk_size
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, {
      Name = "${aws_eks_cluster.main_eks_cluster.name}-eks-node"
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(var.common_tags, {
      Name = "${aws_eks_cluster.main_eks_cluster.name}-eks-node-volume"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-eks-node-lt"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "main_eks_node_group" {
  cluster_name    = aws_eks_cluster.main_eks_cluster.name
  node_group_name = "${var.project_name}-eks-node-group"
  node_role_arn   = var.eks_worker_role_arn
  subnet_ids      = var.private_subnet_ids

  capacity_type  = var.capacity_type
  ami_type       = "AL2023_x86_64_STANDARD"
  instance_types = var.instance_types

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  launch_template {
    id      = aws_launch_template.node_lt.id
    version = aws_launch_template.node_lt.latest_version
  }
  depends_on = [
    aws_eks_cluster.main_eks_cluster,
    aws_launch_template.node_lt
  ]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-eks-node-group"
  })
}