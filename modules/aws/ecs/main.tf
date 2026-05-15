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

resource "aws_ecs_service" "slack_metrics_api" {
  cluster                            = aws_ecs_cluster.cloud-pratica-backend.arn
  name                               = var.slack_metrics_api.name
  task_definition                    = var.slack_metrics_api.task_definition
  desired_count                      = 1
  enable_ecs_managed_tags            = true
  enable_execute_command             = var.slack_metrics_api.enable_execute_command
  availability_zone_rebalancing      = "ENABLED"
  health_check_grace_period_seconds  = 0
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  wait_for_steady_state              = null

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  dynamic "load_balancer" {
    for_each = var.slack_metrics_api.target_group_arn != null ? [1] : []
    content {
      container_name   = "api"
      container_port   = 8080
      target_group_arn = var.slack_metrics_api.target_group_arn
    }
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = var.slack_metrics_api.security_group_ids
    subnets          = var.slack_metrics_api.subnet_ids
  }
  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }
}
