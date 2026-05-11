resource "aws_ecs_cluster" "cloud-pratica-backend" {
  name = "cloud-pratica-backend-${var.env}"
  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cloud-pratica-backend" {
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  cluster_name       = aws_ecs_cluster.cloud-pratica-backend.name
}
