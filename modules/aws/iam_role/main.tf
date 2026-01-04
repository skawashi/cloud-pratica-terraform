resource "aws_iam_role" "cp_slack_metrics_backend" {
  name        = "cp-slack-metrics-backend-${var.env}"
  description = "Allows ECS tasks to call AWS services on your behalf."
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "cp_slack_metrics_backend_attachments" {
  for_each = {
    ssm_core   = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    cloudwatch = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
    ses        = aws_iam_policy.ses_send_email.arn
    sqs        = aws_iam_policy.sqs_read_write.arn
  }
  policy_arn = each.value
  role       = aws_iam_role.cp_slack_metrics_backend.name
}

resource "aws_iam_role" "cp_bastion" {
  name        = "cp-bastion-${var.env}"
  description = "Allows EC2 instances to call AWS services on your behalf."
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Sid = ""
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "cp_bastion_attachments" {
  for_each = {
    ssm_core = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  policy_arn = each.value
  role       = aws_iam_role.cp_bastion.name
}

resource "aws_iam_role" "cp_db_migrator" {
  name        = "cp-db-migrator-${var.env}"
  description = "Allows ECS tasks to call AWS services on your behalf."
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "cp_db_migrator_attachments" {
  for_each = {
    ecs_task_execution = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    cloudwatch         = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  }
  policy_arn = each.value
  role       = aws_iam_role.cp_db_migrator.name
}
