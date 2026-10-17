# CloudCart EKS

![Status](https://img.shields.io/badge/status-work%20in%20progress-orange)
![Cloud](https://img.shields.io/badge/cloud-AWS-232F3E?logo=amazonaws)
![IaC](https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform)
![Orchestration](https://img.shields.io/badge/orchestration-Amazon%20EKS-326CE5?logo=kubernetes&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions%20%2B%20Argo%20CD-2088FF?logo=githubactions&logoColor=white)

CloudCart is a containerized online retail application built as a hands-on **AWS, Kubernetes, and DevOps portfolio project**. This repository contains the **AWS / Amazon EKS implementation** of CloudCart.

The application itself is intentionally simple. The real goal is to design, provision, and operate a realistic, production-oriented infrastructure stack end to end.

> 🚧 **Project status:** This project is under active development. Some sections below are placeholders and will be filled in as each component is completed. See the [Roadmap](#roadmap) for progress.

---

## Table of Contents

- [Project Goals](#project-goals)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [CI/CD](#cicd)
- [Observability](#observability)
- [Security](#security)
- [Roadmap](#roadmap)
- [Cost Considerations](#cost-considerations)
- [Cleanup](#cleanup)
- [Lessons Learned](#lessons-learned)
- [Author](#author)

---

## Project Goals

- Provision AWS infrastructure entirely with **Terraform** (Infrastructure as Code)
- Run a containerized application on **Amazon EKS**
- Design secure AWS networking (VPC, subnets, routing, security groups)
- Apply least-privilege **IAM** (including IAM Roles for Service Accounts)
- Use managed AWS data services (**RDS**, managed **Redis**) and **EBS** for persistent storage
- Manage secrets with **AWS Secrets Manager / Parameter Store**
- Automate builds and deployments with **GitHub Actions** and **Argo CD** (GitOps)
- Monitor the platform with **Prometheus**, **Grafana**, and **CloudWatch**
- Expose the application securely through **Cloudflare**

---

## Tech Stack

| Area | Technology |
|------|------------|
| Cloud provider | AWS |
| Infrastructure as Code | Terraform |
| Container orchestration | Amazon EKS (Kubernetes) |
| Container registry | Amazon ECR |
| Database | Amazon RDS |
| Cache | Managed Redis |
| Storage | Amazon EBS |
| Secrets | AWS Secrets Manager / Parameter Store |
| DNS / Edge | Cloudflare |
| CI | GitHub Actions |
| CD / GitOps | Argo CD |
| Monitoring | Prometheus, Grafana, CloudWatch |

---

## Architecture

> _Architecture diagram coming soon._

<!-- Add your diagram here once ready, e.g.:
![CloudCart EKS Architecture](diagrams/architecture.png)
-->

**High-level flow (planned):**

```
User
  │
  ▼
Cloudflare (DNS / proxy)
  │
  ▼
AWS Load Balancer ──► Amazon EKS cluster
                         │
                         ├── CloudCart application pods
                         ├── Amazon RDS (database)
                         ├── Managed Redis (cache)
                         └── EBS volumes (persistent storage)
```

---

## Repository Structure

```
cloudcart-eks
├── .github/workflows   # GitHub Actions CI/CD pipelines
├── bootstrap           # Bootstrap infrastructure (e.g. Terraform remote state)
├── cloudcart-app       # CloudCart application source and Dockerfile(s)
├── kubernetes          # Kubernetes manifests and overlays
├── terraform           # AWS infrastructure (VPC, EKS, RDS, IAM, etc.)
├── .gitignore
└── README.md
```

| Directory | Description |
|-----------|-------------|
| `.github/workflows` | Pipelines to build, test, and push images and run Terraform checks |
| `bootstrap` | One-time setup required before the main infrastructure (e.g. state backend) |
| `cloudcart-app` | The sample retail application that gets containerized and deployed |
| `kubernetes` | Deployments, Services, Ingress, and environment overlays |
| `terraform` | Modules and configuration for all AWS resources |

---

## Prerequisites

Make sure you have the following installed and configured:

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) with credentials configured
- [Terraform](https://developer.hashicorp.com/terraform/install) (version: _TBD_)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Docker](https://docs.docker.com/get-docker/)
- [Helm](https://helm.sh/docs/intro/install/) (if used)
- An AWS account with permissions to create the resources listed above
- A Cloudflare account and domain (optional, for public access)

---

## Getting Started

> _Detailed instructions will be added as each component is completed._

### 1. Clone the repository

```bash
git clone https://github.com/mohitbnt/cloudcart-eks.git
cd cloudcart-eks
```

### 2. Bootstrap the backend

```bash
cd bootstrap
terraform init
terraform apply
```

### 3. Provision the infrastructure

```bash
cd ../terraform
terraform init
terraform plan
terraform apply
```

### 4. Configure kubectl

```bash
aws eks update-kubeconfig --region <region> --name <cluster-name>
```

### 5. Deploy the application

```bash
kubectl apply -k kubernetes/<overlay>
```

_Or via Argo CD once GitOps is set up._

---

## CI/CD

> _To be documented._

Planned workflow:

1. **GitHub Actions** builds the Docker image and pushes it to **Amazon ECR**
2. Image tag is updated in the Kubernetes manifests
3. **Argo CD** detects the change and syncs it to the EKS cluster

---

## Observability

> _To be documented._

Planned tooling:

- **Prometheus**: metrics collection
- **Grafana**: dashboards and visualization
- **CloudWatch**: AWS-level logs and metrics

---

## Security

> _To be documented._

Planned practices:

- Private subnets for workloads and databases
- Pod Identity agent with least privileges
- Secrets stored in AWS Secrets Manager / Parameter Store, never in Git
- Security groups restricted to required traffic only
- Container images stored in private ECR repositories

---

## Roadmap

- [x] Repository structure and project scaffolding
- [x] Terraform remote state bootstrap
- [x] VPC and networking
- [x] EKS cluster and node groups
- [x] IAM roles and pod identity agent
- [x] RDS and managed Redis
- [x] Secrets management
- [ ] ECR and image build pipeline
- [ ] Kubernetes manifests and helm charts
- [ ] Argo CD (GitOps)
- [ ] Cloudflare DNS and edge configuration
- [ ] Prometheus and Grafana monitoring
- [ ] CloudWatch logging and alerts
- [ ] Architecture diagrams
- [ ] Full documentation

---

## Cost Considerations

> _To be documented._

Running EKS, RDS, NAT gateways, and load balancers on AWS incurs charges. Remember to destroy resources when you are not using them.

---

## Cleanup

To avoid unnecessary AWS charges, destroy the resources when finished:

```bash
cd terraform
terraform destroy

cd ../bootstrap
terraform destroy
```

---

## Lessons Learned

> _Will be added as the project progresses._

---

## Author

**Mohit**
GitHub: [@mohitbnt](https://github.com/mohitbnt)
