variable "env" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "secrets_manager_arn_db_main_instance" {
  type = string
}

variable "arn_cp_config_bucket" {
  type = string
}

variable "ecs_task_specs" {
  type = object({
    slack_metrics_api = object({
      cpu    = number
      memory = number
    })
    slack_metrics_batch = object({
      cpu    = number
      memory = number
    })
    db_migrator = object({
      cpu    = number
      memory = number
    })
  })
}

/*************************
 * ECR (imageタグを含むURL)
 *************************/
variable "ecr_url_slack_metrics" {
  type = string
}

variable "ecr_url_db_migrator" {
  type = string
}

/******************************************************
 * slack_metrics_api
 ******************************************************/
resource "aws_ecs_task_definition" "slack_metrics_api" {
  family                   = "slack-metrics-api-${var.env}"
  cpu                      = var.ecs_task_specs.slack_metrics_api.cpu
  memory                   = var.ecs_task_specs.slack_metrics_api.memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name      = "api"
      image     = "${var.ecr_url_slack_metrics}:0b717b4"
      essential = true
      portMappings = [
        {
          appProtocol   = "http"
          containerPort = 8080
          hostPort      = 8080
          name          = "api-8080-tcp"
          protocol      = "tcp"
        }
      ]
      secrets = [
        {
          name      = "POSTGRES_MAIN_HOST"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:host::"
        },
        {
          name      = "POSTGRES_MAIN_PASSWORD"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:slack_metrics_password::"
        },
        {
          name      = "POSTGRES_MAIN_USER"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:slack_metrics_user::"
        }
      ]
      environmentFiles = [{
        type  = "s3"
        value = "${var.arn_cp_config_bucket}/slack-metrics-${var.env}.env"
      }]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8080/api/health || exit 1"]
        interval    = 30
        retries     = 3
        startPeriod = 0
        timeout     = 5
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/slack-metrics-api-${var.env}"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
        secretOptions = []
      }
      readonlyRootFilesystem = false
    },
    {
      name         = "worker"
      image        = "${var.ecr_url_slack_metrics}:0b717b4"
      essential    = true
      portMappings = []
      secrets = [
        {
          name      = "POSTGRES_MAIN_HOST"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:host::"
        },
        {
          name      = "POSTGRES_MAIN_PASSWORD"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:slack_metrics_password::"
        },
        {
          name      = "POSTGRES_MAIN_USER"
          valueFrom = "${var.secrets_manager_arn_db_main_instance}:slack_metrics_user::"
        }
      ]
      environment = [{
        name  = "MODE"
        value = "sqs"
      }]
      environmentFiles = [{
        type  = "s3"
        value = "${var.arn_cp_config_bucket}/slack-metrics-${var.env}.env"
      }]
      healthCheck = {
        command     = ["CMD-SHELL", "ps aux | grep main | grep -v grep || exit 1"]
        interval    = 10
        retries     = 3
        startPeriod = 0
        timeout     = 5
      }
      stopTimeout = 120
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/slack-metrics-worker-${var.env}"
          awslogs-stream-prefix = "ecs"
          awslogs-region        = "ap-northeast-1"
        }
        secretOptions = []
      }
      readonlyRootFilesystem = true
    }
  ])
  lifecycle {
    ignore_changes = [container_definitions]
  }
}

/******************************************************
 * slack_metrics_batch
 ******************************************************/
resource "aws_ecs_task_definition" "slack_metrics_batch" {
  family                   = "slack-metrics-batch-${var.env}"
  cpu                      = var.ecs_task_specs.slack_metrics_batch.cpu
  memory                   = var.ecs_task_specs.slack_metrics_batch.memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([{
    name         = "batch"
    image        = "${var.ecr_url_slack_metrics}:0b717b4"
    essential    = true
    portMappings = []
    secrets = [
      {
        name      = "POSTGRES_MAIN_HOST"
        valueFrom = "${var.secrets_manager_arn_db_main_instance}:host::"
      },
      {
        name      = "POSTGRES_MAIN_PASSWORD"
        valueFrom = "${var.secrets_manager_arn_db_main_instance}:slack_metrics_password::"
      },
      {
        name      = "POSTGRES_MAIN_USER"
        valueFrom = "${var.secrets_manager_arn_db_main_instance}:slack_metrics_user::"
      }
    ]
    environment = [
      {
        name  = "MODE"
        value = "batch"
      }
    ]
    environmentFiles = [
      {
        type  = "s3"
        value = "${var.arn_cp_config_bucket}/slack-metrics-${var.env}.env"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group  = "true"
        awslogs-group         = "/ecs/slack-metrics-batch-${var.env}"
        awslogs-region        = "ap-northeast-1"
        awslogs-stream-prefix = "ecs"
      }
      secretOptions = []
    }
    readonlyRootFilesystem = true
  }])
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  lifecycle {
    ignore_changes = [container_definitions]
  }
}

/******************************************************
 * db_migrator
 ******************************************************/
resource "aws_ecs_task_definition" "db_migrator" {
  family                   = "db-migrator-stg"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::480957638549:role/ecs-task-execution-stg"
  task_role_arn            = "arn:aws:iam::480957638549:role/cp-db-migrator-stg"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "480957638549.dkr.ecr.ap-northeast-1.amazonaws.com/db-migrator-stg:0b717b4"
      essential = true
      secrets = [
        {
          name      = "DB_HOST"
          valueFrom = "arn:aws:secretsmanager:ap-northeast-1:480957638549:secret:db-main-instance-stg-SeLIA5:host::"
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = "arn:aws:secretsmanager:ap-northeast-1:480957638549:secret:db-main-instance-stg-SeLIA5:operator_password::"
        },
        {
          name      = "DB_USER"
          valueFrom = "arn:aws:secretsmanager:ap-northeast-1:480957638549:secret:db-main-instance-stg-SeLIA5:operator_user::"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/db-migrator-stg"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
        secretOptions = []
      }
      environmentFiles = [{
        type  = "s3"
        value = "arn:aws:s3:::cp-kawashima-config-stg/db-migrator-stg.env"
      }]
    }
  ])
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  lifecycle {
    ignore_changes = [container_definitions]
  }
}
