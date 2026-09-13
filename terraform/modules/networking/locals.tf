locals {
  #-----------------------------------------------------------
  # Interaface endpoints for EKS cluster
  #-----------------------------------------------------------
  interface_endpoints = {
    eks                  = "com.amazonaws.${var.region}.eks"
    eks-auth             = "com.amazonaws.${var.region}.eks-auth"
    ec2                  = "com.amazonaws.${var.region}.ec2"
    ssm                  = "com.amazonaws.${var.region}.ssm"
    ssmmessages          = "com.amazonaws.${var.region}.ssmmessages"
    ecr-api              = "com.amazonaws.${var.region}.ecr.api"
    ecr-dkr              = "com.amazonaws.${var.region}.ecr.dkr"
    sts                  = "com.amazonaws.${var.region}.sts"
    logs                 = "com.amazonaws.${var.region}.logs"
    secretsmanager       = "com.amazonaws.${var.region}.secretsmanager"
    elasticloadbalancing = "com.amazonaws.${var.region}.elasticloadbalancing"
    autoscaling          = "com.amazonaws.${var.region}.autoscaling"
  }
}