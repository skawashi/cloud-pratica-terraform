resource "aws_ecs_task_definition" "slack_metrics_api" {
  family                   = "slack-metrics-api-stg"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::480957638549:role/ecs-task-execution-stg"
  task_role_arn            = "arn:aws:iam::480957638549:role/cp-slack-metrics-backend-stg"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name      = "api"
      image     = "480957638549.dkr.ecr.ap-northeast-1.amazonaws.com/slack-metrics-stg:0b717b4"
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
          valueFrom = "arn:aws:secretsmanager:ap-northeast-1:480957638549:secret:db-main-instance-stg-SeLIA5:host::"
        },
        {
          name      = "POSTGRES_MAIN_PASSWORD"
          valueFrom = "arn:aws:secretsmanager:ap-northeast-1:480957638549:secret:db-main-instance-stg-SeLIA5:slack_metrics_password::"
        },
        {
          name      = "POSTGRES_MAIN_USER"
          valueFrom = "arn:aws:secretsmanager:ap-northeast-1:480957638549:secret:db-main-instance-stg-SeLIA5:slack_metrics_user::"
        }
      ]
      environmentFiles = [{
        type  = "s3"
        value = "arn:aws:s3:::cp-kawashima-config-stg/slack-metrics-stg.env"
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
          awslogs-group         = "/ecs/slack-metrics-api-stg"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
        secretOptions = []
      }
      readonlyRootFilesystem = false
    },
    {
      name         = "worker"
      image        = "480957638549.dkr.ecr.ap-northeast-1.amazonaws.com/slack-metrics-stg:0b717b4"
      essential    = true
      portMappings = []
      secrets = [
        {
          name      = "POSTGRES_MAIN_HOST"
          valueFrom = "arn:aws:secretsmanager:ap-northeast-1:480957638549:secret:db-main-instance-stg-SeLIA5:host::"
        },
        {
          name      = "POSTGRES_MAIN_PASSWORD"
          valueFrom = "arn:aws:secretsmanager:ap-northeast-1:480957638549:secret:db-main-instance-stg-SeLIA5:slack_metrics_password::"
        },
        {
          name      = "POSTGRES_MAIN_USER"
          valueFrom = "arn:aws:secretsmanager:ap-northeast-1:480957638549:secret:db-main-instance-stg-SeLIA5:slack_metrics_user::"
        }
      ]
      environment = [{
        name  = "MODE"
        value = "sqs"
      }]
      environmentFiles = [{
        type  = "s3"
        value = "arn:aws:s3:::cp-kawashima-config-stg/slack-metrics-stg.env"
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
          awslogs-group         = "/ecs/slack-metrics-worker-stg"
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

resource "aws_ecs_task_definition" "slack_metrics_batch" {
  family                   = "slack-metrics-batch-stg"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::480957638549:role/ecs-task-execution-stg"
  task_role_arn            = "arn:aws:iam::480957638549:role/cp-slack-metrics-backend-stg"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([{
    name         = "batch"
    image        = "480957638549.dkr.ecr.ap-northeast-1.amazonaws.com/slack-metrics-stg:0b717b4"
    essential    = true
    portMappings = []
    secrets = [
      {
        name      = "POSTGRES_MAIN_HOST"
        valueFrom = "arn:aws:secretsmanager:ap-northeast-1:480957638549:secret:db-main-instance-stg-SeLIA5:host::"
      },
      {
        name      = "POSTGRES_MAIN_PASSWORD"
        valueFrom = "arn:aws:secretsmanager:ap-northeast-1:480957638549:secret:db-main-instance-stg-SeLIA5:slack_metrics_password::"
      },
      {
        name      = "POSTGRES_MAIN_USER"
        valueFrom = "arn:aws:secretsmanager:ap-northeast-1:480957638549:secret:db-main-instance-stg-SeLIA5:slack_metrics_user::"
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
        value = "arn:aws:s3:::cp-kawashima-config-stg/slack-metrics-stg.env"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group  = "true"
        awslogs-group         = "/ecs/slack-metrics-batch-stg"
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
