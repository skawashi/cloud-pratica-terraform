resource "aws_ecr_repository" "slack_metrics" {
  name                 = "slack-metrics-${var.env}"
  region               = "ap-northeast-1"
  image_tag_mutability = var.image_tag_mutability
}

resource "aws_ecr_repository" "db_migrator" {
  name                 = "db-migrator-${var.env}"
  region               = "ap-northeast-1"
  image_tag_mutability = var.image_tag_mutability
}

resource "aws_ecr_lifecycle_policy" "db_migrator" {
  repository = aws_ecr_repository.db_migrator.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "最新の3世代のイメージのみを保持"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 3
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
