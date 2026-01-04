#########################################################################
# cp-slack-metrics-backend
#########################################################################
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

#########################################################################
# cp-bastion
#########################################################################
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

#########################################################################
# db-migrator
#########################################################################
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

#########################################################################
# cp-nat
#########################################################################
resource "aws_iam_role" "cp_nat" {
  name        = "cp-nat-${var.env}"
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

resource "aws_iam_role_policy_attachment" "cp_nat_attachments" {
  for_each = {
    ssm_core = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  policy_arn = each.value
  role       = aws_iam_role.cp_nat.name
}

#########################################################################
# cp-scheduler-cost-cutter
#########################################################################
resource "aws_iam_role" "cp_scheduler_cost_cutter" {
  name = "cp-scheduler-cost-cutter-${var.env}"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "cp_scheduler_cost_cutter_attachments" {
  for_each = {
    ec2_start_stop = aws_iam_policy.ec2_start_stop.arn
    ecs_write      = aws_iam_policy.ecs_write.arn
    rds_start_stop = aws_iam_policy.rds_start_stop.arn
  }
  policy_arn = each.value
  role       = aws_iam_role.cp_scheduler_cost_cutter.name
}

#########################################################################
# cp-scheduler-slack-metrics
#########################################################################
resource "aws_iam_role" "cp_scheduler_slack_metrics" {
  name = "cp-scheduler-slack-metrics-stg"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "scheduler.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "cp_scheduler_slack_metrics_attachments" {
  for_each = {
    ecs_run_task = aws_iam_policy.ecs_run_task.arn
    pass_role    = aws_iam_policy.pass_role_to_ecs_task.arn
  }
  policy_arn = each.value
  role       = aws_iam_role.cp_scheduler_slack_metrics.name
}
