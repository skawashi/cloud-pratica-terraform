resource "aws_ecr_repository" "main" {
  name                 = var.name
  region               = "ap-northeast-1"
  image_tag_mutability = var.image_tag_mutability
}

resource "aws_ecr_lifecycle_policy" "retain_latest_images" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "最新の${var.retained_image_count}世代のイメージのみを保持"
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
