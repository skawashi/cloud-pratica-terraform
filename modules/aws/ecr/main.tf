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
