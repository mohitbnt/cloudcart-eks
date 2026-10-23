# --------------------------------------------------------------------------------
# 1. One private ECR repository per service  (<project>/<service>)
#    Worker nodes already pull from ECR via AmazonEC2ContainerRegistryReadOnly
#    (see modules/iam/eks-worker-iam.tf).
# --------------------------------------------------------------------------------
resource "aws_ecr_repository" "service" {
  for_each = toset(var.repositories)

  name                 = "${var.project_name}/${each.value}"
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(var.common_tags, {
    Name    = "${var.project_name}/${each.value}"
    Service = each.value
  })
}

# --------------------------------------------------------------------------------
# 2. Lifecycle: expire untagged images quickly, keep the last N images otherwise
# --------------------------------------------------------------------------------
resource "aws_ecr_lifecycle_policy" "service" {
  for_each   = aws_ecr_repository.service
  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images after 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Keep only the last ${var.max_image_count} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.max_image_count
        }
        action = { type = "expire" }
      }
    ]
  })
}
