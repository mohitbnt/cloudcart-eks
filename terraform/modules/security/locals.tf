locals {
  # -----------------------------------------------------------
  # 1. Security group rules for VPC Interface Endpoints
  # -----------------------------------------------------------
  endpoint_sg_ingress = {
    https = {
      description                  = "Allow inbound HTTPS traffic from EKS cluster security group"
      from_port                    = 443
      to_port                      = 443
      ip_protocol                  = "tcp"
      use_cidr                     = false
      cidr_block                   = null
      referenced_security_group_id = aws_security_group.eks_worker_sg.id
    }
  }

  endpoint_sg_egress = {
    all_traffic = {
      description                  = "Allow outbound traffic from VPC endpoint"
      from_port                    = null
      to_port                      = null
      ip_protocol                  = "-1"
      use_cidr                     = true
      cidr_block                   = "0.0.0.0/0"
      referenced_security_group_id = null
    }
  }

  # -----------------------------------------------------------
  # 2. Security group rules for RDS & ElastiCache
  # -----------------------------------------------------------
  rds_sg_ingress = {
    postgres_port = {
      description                  = "Allow inbound PostgreSQL traffic from EKS cluster security group"
      from_port                    = 5432
      to_port                      = 5432
      ip_protocol                  = "tcp"
      use_cidr                     = false
      cidr_block                   = null
      referenced_security_group_id = aws_security_group.eks_worker_sg.id
    }
  }

  redis_elasticache_ingress = {
    redis_port = {
      description                  = "Allow inbound Redis traffic from EKS cluster security group"
      from_port                    = 6379
      to_port                      = 6379
      ip_protocol                  = "tcp"
      use_cidr                     = false
      cidr_block                   = null
      referenced_security_group_id = aws_security_group.eks_worker_sg.id
    }
  }

  # -----------------------------------------------------------
  # 3. Security group rules for EKS CLUSTER
  # -----------------------------------------------------------
  cluster_sg_ingress = {
    nodes_to_api = {
      description                  = "Allow EKS nodes to communicate with the Kubernetes API"
      from_port                    = 443
      to_port                      = 443
      ip_protocol                  = "tcp"
      use_cidr                     = false
      cidr_block                   = null
      referenced_security_group_id = aws_security_group.eks_worker_sg.id
    }
  }

  cluster_sg_egress = {
    cluster_traffic = {
      description                  = "Allow EKS cluster resources to communicate with required destinations"
      from_port                    = null
      to_port                      = null
      ip_protocol                  = "-1"
      use_cidr                     = true
      cidr_block                   = "0.0.0.0/0"
      referenced_security_group_id = null
    }
  }

  # -----------------------------------------------------------
  # 4. Security group rules for EKS Worker Nodes
  # -----------------------------------------------------------
  worker_sg_ingress = {
    https = {
      description                  = "Control plane to nodes HTTPS"
      from_port                    = 443
      to_port                      = 443
      ip_protocol                  = "tcp"
      use_cidr                     = false
      cidr_block                   = null
      referenced_security_group_id = aws_security_group.eks_cluster_sg.id
    }
    cp_to_nodes = {
      description                  = "Control plane to nodes port 10250"
      from_port                    = 10250
      to_port                      = 10250
      ip_protocol                  = "tcp"
      use_cidr                     = false
      cidr_block                   = null
      referenced_security_group_id = aws_security_group.eks_cluster_sg.id
    }
  }

  worker_sg_egress = {
    all_traffic = {
      description                  = "Allow node egress (reaches VPC endpoints / local VPC traffic only - no IGW/NAT)"
      from_port                    = null
      to_port                      = null
      ip_protocol                  = "-1"
      use_cidr                     = true
      cidr_block                   = "0.0.0.0/0"
      referenced_security_group_id = null
    }
  }
}