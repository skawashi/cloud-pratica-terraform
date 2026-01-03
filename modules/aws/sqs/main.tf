resource "aws_sqs_queue" "slack_metrics_dlq" {
  name   = "slack-metrics-dlq-${var.env}"
  region = "ap-northeast-1"
}

resource "aws_sqs_queue_policy" "slack_metrics_dlq" {
  queue_url = aws_sqs_queue.slack_metrics_dlq.url
  region    = "ap-northeast-1"
  policy = jsonencode({
    Statement = [{
      Action = "SQS:*"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::480957638549:root"
      }
      Resource = "arn:aws:sqs:ap-northeast-1:480957638549:slack-metrics-dlq-${var.env}"
    }]
    Version = "2012-10-17"
  })
}
