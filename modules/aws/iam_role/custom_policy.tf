resource "aws_iam_policy" "ses_send_email" {
  name = "ses-send-email-stg"
  policy = jsonencode({
    Statement = [{
      Action = [
        "ses:SendEmail",
        "ses:SendRawEmail",
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}


resource "aws_iam_policy" "sqs_read_write" {
  name = "sqs-read-write-stg"
  policy = jsonencode({
    Statement = [{
      Action = [
        "sqs:SendMessage",
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "ec2_start_stop" {
  name = "ec2-start-stop-stg"
  policy = jsonencode({
    Statement = [{
      Action = [
        "ec2:StartInstances",
        "ec2:StopInstances",
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "ecs_write" {
  name = "ecs-write-stg"
  policy = jsonencode({
    Statement = [{
      Action = [
        "ecs:UpdateService",
        "ecs:RunTask",
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "rds_start_stop" {
  name = "rds-start-stop-stg"
  policy = jsonencode({
    Statement = [{
      Action = [
        "rds:StartDBInstance",
        "rds:StopDBInstance",
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "ecs_run_task" {
  name = "ecs-run-task-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action   = "ecs:RunTask"
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "pass_role_to_ecs_task" {
  name = "pass-role-to-ecs-task-${var.env}"
  policy = jsonencode({
    Statement = [{
      Action = "iam:PassRole"
      Condition = {
        StringEquals = {
          "iam:PassedToService" = "ecs-tasks.amazonaws.com"
        }
      }
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}
