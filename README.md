# CloudCart EKS

CloudCart is a containerized online retail application used as a hands-on
AWS, Kubernetes, and DevOps portfolio project.

This repository contains the AWS/EKS implementation of CloudCart.

## Project Goals

The primary focus of this project is:

- AWS
- Terraform
- Amazon EKS
- Kubernetes
- IAM
- AWS networking
- Security
- EBS
- RDS
- Managed Redis
- AWS Secrets Manager / Parameter Store
- Amazon ECR
- Cloudflare
- GitHub Actions
- Argo CD
- Prometheus
- Grafana
- CloudWatch

The application itself remains intentionally simple. The main objective is
to build and operate a realistic production-oriented infrastructure stack.

## Repository Structure

```text
cloudcart-eks/
├── terraform/       # AWS infrastructure
├── kubernetes/      # Kubernetes manifests and overlays
├── application/     # Application-related configuration
├── diagrams/        # Architecture diagrams
└── README.md