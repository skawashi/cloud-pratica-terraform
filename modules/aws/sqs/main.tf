resource "aws_sqs_queue" "slack_metrics" {
  name                       = "slack-metrics-${var.env}"
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 600
  redrive_policy = jsonencode(
    {
      deadLetterTargetArn = aws_sqs_queue.slack_metrics_dlq.arn
      maxReceiveCount     = 3
    }
  )
}

resource "aws_sqs_queue_policy" "slack_metrics" {
  queue_url = aws_sqs_queue.slack_metrics.url
  policy = jsonencode({
    Statement = [{
      Action = "SQS:*"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${var.account_id}:root"
      }
      Resource = aws_sqs_queue.slack_metrics.arn
    }]
    Version = "2012-10-17"
  })
}

resource "aws_sqs_queue" "slack_metrics_dlq" {
  name = "slack-metrics-dlq-${var.env}"
}

resource "aws_sqs_queue_policy" "slack_metrics_dlq" {
  queue_url = aws_sqs_queue.slack_metrics_dlq.url
  policy = jsonencode({
    Statement = [{
      Action = "SQS:*"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${var.account_id}:root"
      }
      Resource = aws_sqs_queue.slack_metrics_dlq.arn
    }]
    Version = "2012-10-17"
  })
}
