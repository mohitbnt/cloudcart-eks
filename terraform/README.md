# CloudCart – AWS Infrastructure (Terraform)

Terraform configuration for provisioning the AWS infrastructure for **CloudCart** using reusable modules and separate Terraform states for shared infrastructure and environment-specific data services.

![Architecture diagram](diagrams/architecture.png)

## Architecture Overview

- **VPC** with configurable public and private subnets across the configured Availability Zones.
- **Optional NAT Gateway** controlled by `enable_nat_gateway`. It is disabled by default and can be temporarily enabled for bootstrapping or workloads that require internet egress.
- **VPC Endpoints** provide private access to AWS services such as EKS, ECR, STS, SSM, Secrets Manager, CloudWatch Logs, ELB and Auto Scaling. S3 uses a Gateway endpoint.
- **Amazon EKS** runs worker nodes in private subnets using an EKS managed node group with a configurable `SPOT` or `ON_DEMAND` capacity type.
- **EKS managed add-ons** include VPC CNI, CoreDNS, kube-proxy, EKS Pod Identity Agent, AWS EBS CSI Driver and Metrics Server.
- **AWS Load Balancer Controller** is installed through Helm and uses EKS Pod Identity for AWS access.
- **External Secrets Operator (ESO)** is installed through Helm. A custom Helm chart creates the AWS `ClusterSecretStore` configuration.
- **Amazon RDS PostgreSQL** and **Amazon ElastiCache Redis** are deployed separately for each environment.
- **Secrets Manager** stores database credentials and the Redis connection URL. ESO accesses Secrets Manager using a scoped IAM role through EKS Pod Identity.

## Repository Layout

```text
terraform/
├── core-infra/                # Shared infrastructure and EKS platform
│   ├── eso-config/            # Helm chart for ESO ClusterSecretStore
│   ├── main.tf
│   ├── variables.tf
│   ├── locals.tf
│   ├── providers.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── terraform.tfvars.example
│
├── environments/
│   ├── dev/                   # Development RDS and Redis
│   └── prod/                  # Production RDS and Redis
│
└── modules/
    ├── networking/            # VPC, subnets, routes, endpoints and optional NAT
    ├── security/              # Security groups and rules
    ├── iam/                   # EKS, worker, EBS CSI, ESO and LB Controller IAM
    ├── eks/                   # EKS cluster, node group and managed add-ons
    ├── database/              # RDS PostgreSQL and Secrets Manager
    └── cache/                 # ElastiCache Redis and Secrets Manager
```

`core-infra` and each environment are independent Terraform root modules with separate state files. The environment layers consume required outputs from `core-infra` using `terraform_remote_state`.

## Terraform Layers

### `core-infra`

Creates the shared platform:

- VPC and networking
- VPC endpoints
- Optional NAT Gateway
- Security groups
- IAM roles and policies
- EKS cluster
- EKS managed node group
- EKS managed add-ons
- EKS Pod Identity associations
- AWS Load Balancer Controller Helm release
- External Secrets Operator Helm release
- ESO ClusterSecretStore Helm chart

### `environments/dev`

Creates development data services:

- RDS PostgreSQL
- ElastiCache Redis

### `environments/prod`

Creates production data services using the same modules with production-specific values.

## Module Reference

| Module | Creates |
|---|---|
| `networking` | VPC, public/private subnets, route tables, Internet Gateway, VPC endpoints and optional NAT Gateway |
| `security` | EKS, worker, RDS, Redis and VPC endpoint security groups and rules |
| `iam` | EKS cluster/worker roles, EBS CSI role, ESO role and Load Balancer Controller role |
| `eks` | EKS cluster, EC2 launch template, managed node group, managed add-ons and Pod Identity associations |
| `database` | RDS PostgreSQL, subnet/parameter groups, generated password and Secrets Manager secret |
| `cache` | ElastiCache Redis, subnet/parameter groups and Secrets Manager Redis URL secret |

## EKS Configuration

The EKS platform currently includes:

```text
Kubernetes version       1.36
Worker subnets           Private
Node AMI                 AL2023
Capacity                 SPOT / ON_DEMAND
Node scaling             Configurable
EBS volumes              Encrypted gp3
Instance metadata        IMDSv2 required
```

Managed add-ons:

```text
vpc-cni
aws-ebs-csi-driver
coredns
kube-proxy
eks-pod-identity-agent
metrics-server
```

Workload AWS access uses **EKS Pod Identity** rather than IRSA.

## Network Design

Private subnets do not require a NAT Gateway for the AWS services covered by the configured VPC endpoints.

```text
Private Subnets
      │
      ├── EKS
      ├── RDS
      ├── Redis
      │
      └── VPC Endpoints
            ├── ECR
            ├── EKS
            ├── STS
            ├── SSM
            ├── Secrets Manager
            ├── CloudWatch Logs
            ├── ELB
            └── Auto Scaling
```

`enable_nat_gateway = true` can temporarily add a NAT Gateway and a default route from the private route table to the NAT Gateway. Keep it disabled when private AWS-service connectivity through endpoints is sufficient.

## Secrets

RDS credentials are generated by Terraform and stored in AWS Secrets Manager.

Redis connection information is also stored in Secrets Manager.

External Secrets Operator uses a dedicated IAM role through EKS Pod Identity and a `ClusterSecretStore` configured for AWS Secrets Manager.

The IAM policy is scoped to secrets using the project-name prefix rather than granting account-wide Secrets Manager access.

## Backend & State

Each Terraform root uses a separate S3 state key:

| Root | State key |
|---|---|
| `core-infra` | `cloudcart-eks/core-infra/terraform.tfstate` |
| `environments/dev` | `cloudcart-eks/environments/dev/terraform.tfstate` |
| `environments/prod` | `cloudcart-eks/environments/prod/terraform.tfstate` |

The S3 backend uses encryption and the native S3 lockfile mechanism.

## Prerequisites

- Terraform `>= 1.5`
- AWS CLI
- AWS credentials with permissions to create the required resources
- Existing S3 bucket configured in the Terraform backend
- `kubectl` for EKS access
- A trusted public IP/CIDR for `public_access_cidr`

## Usage

### Deploy Core Infrastructure

```bash
cd terraform/core-infra

cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars

terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

### Deploy Development

```bash
cd terraform/environments/dev

cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars

terraform init
terraform validate
terraform plan
terraform apply
```

### Deploy Production

```bash
cd terraform/environments/prod

cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars

terraform init
terraform validate
terraform plan
terraform apply
```

### Configure kubectl

```bash
aws eks update-kubeconfig \
  --name <eks-cluster-name> \
  --region <region>
```

## Important Variables

### Core Infrastructure

| Variable | Description |
|---|---|
| `region` | AWS deployment region |
| `project_name` | Resource naming prefix |
| `vpc_cidr` | VPC CIDR |
| `public_subnet_cidrs` | Public subnet CIDRs |
| `private_subnet_cidrs` | Private subnet CIDRs |
| `enable_nat_gateway` | Enables/disables the temporary NAT Gateway |
| `kubernetes_version` | EKS Kubernetes version |
| `public_access_cidr` | CIDRs allowed to access the public EKS API |
| `min_size` / `max_size` / `desired_size` | EKS node group scaling |
| `instance_types` | Worker EC2 instance types |
| `disk_size` | Worker root volume size |
| `capacity_type` | `SPOT` or `ON_DEMAND` |

### Environment Configuration

`dev` and `prod` configure their own:

- `db_instance_config`
- `cache_config`

See the corresponding `terraform.tfvars.example` files for annotated configuration.

## Security

- EKS workers, RDS and Redis run in private subnets.
- RDS and Redis are not publicly accessible.
- EKS public API access is restricted through `public_access_cidr`.
- Worker EBS volumes are encrypted.
- IMDSv2 is required on worker nodes.
- Workload AWS permissions use dedicated EKS Pod Identity roles.
- ESO Secrets Manager permissions are scoped to project-prefixed secrets.
- Terraform state is stored remotely in an encrypted S3 backend.

## Future Improvements

- [ ] Review and harden production RDS settings
- [ ] Review Redis HA and enable transit encryption where required
- [ ] Review VPC endpoint policies
- [ ] Add VPC Flow Logs
- [ ] Add EKS control-plane logging
- [ ] Further reduce IAM permissions where possible
- [ ] Add Terraform CI validation and security scanning
- [ ] Review state bucket backup and recovery controls
- [ ] Remove the temporary NAT Gateway when no longer required

## Cost Notes

- NAT Gateway is disabled by default and can be enabled temporarily when required.
- Interface VPC endpoints have hourly and data-processing costs.
- EKS workers use SPOT capacity by default.
- Development RDS and Redis configurations are intentionally cost-conscious.