# -----------------------------------------------------------
# 1. Security group rules for RDS & ElastiCache
# -----------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "rds_ingress" {
  security_group_id = aws_security_group.rds_sg.id

  for_each                     = local.rds_sg_ingress
  description                  = each.value.description
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr_block : null
  referenced_security_group_id = each.value.referenced_security_group_id
}

resource "aws_vpc_security_group_ingress_rule" "redis_ingress" {
  security_group_id = aws_security_group.redis_sg.id

  for_each                     = local.redis_elasticache_ingress
  description                  = each.value.description
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr_block : null
  referenced_security_group_id = each.value.referenced_security_group_id
}
# -----------------------------------------------------------
# 2. Create Security Group Rules for VPC endpoint
# -----------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "endpoint_sg_ingress" {
  security_group_id = aws_security_group.vpc_endpoint_sg.id

  for_each                     = local.endpoint_sg_ingress
  description                  = each.value.description
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr_block : null
  referenced_security_group_id = each.value.referenced_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "endpoint_sg_egress" {
  security_group_id = aws_security_group.vpc_endpoint_sg.id

  for_each                     = local.endpoint_sg_egress
  description                  = each.value.description
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr_block : null
  referenced_security_group_id = each.value.referenced_security_group_id
}

# -----------------------------------------------------------
# 3. Create Security Group Rules for EKS CLUSTER (Control Plane)
# -----------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "cluster_sg_ingress" {
  security_group_id = aws_security_group.eks_cluster_sg.id

  for_each                     = local.cluster_sg_ingress
  description                  = each.value.description
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr_block : null
  referenced_security_group_id = each.value.referenced_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "cluster_sg_egress" {
  security_group_id = aws_security_group.eks_cluster_sg.id

  for_each                     = local.cluster_sg_egress
  description                  = each.value.description
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr_block : null
  referenced_security_group_id = each.value.referenced_security_group_id
}

# -----------------------------------------------------------
# 4. Create Security Group Rules for EKS Worker Nodes
# -----------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "worker_sg_ingress" {
  security_group_id = aws_security_group.eks_worker_sg.id

  for_each                     = local.worker_sg_ingress
  description                  = each.value.description
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr_block : null
  referenced_security_group_id = each.value.referenced_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "worker_sg_egress" {
  security_group_id = aws_security_group.eks_worker_sg.id

  for_each                     = local.worker_sg_egress
  description                  = each.value.description
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.ip_protocol
  cidr_ipv4                    = each.value.use_cidr ? each.value.cidr_block : null
  referenced_security_group_id = each.value.referenced_security_group_id
}