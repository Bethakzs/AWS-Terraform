resource "aws_sns_topic" "course_creation" {
  name = "${var.project_name}-course-creation-notifications"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.course_creation.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Create CloudWatch alarm based on Lambda invocations
resource "aws_cloudwatch_metric_alarm" "course_creation_alarm" {
  alarm_name          = "${var.project_name}-course-creation-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Invocations"
  namespace          = "AWS/Lambda"
  period             = "30"
  statistic          = "Sum"
  threshold          = "1"
  alarm_description  = "This metric monitors course creation Lambda invocations"
  alarm_actions      = [aws_sns_topic.course_creation.arn]
  treat_missing_data = "notBreaching"

  dimensions = {
    FunctionName = var.lambda_function_name
  }
}

# Add CloudWatch permission to publish to SNS
resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.course_creation.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatchPublish"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.course_creation.arn
      }
    ]
  })
}

# Add Lambda permission to publish to CloudWatch
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowCloudWatchInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "cloudwatch.amazonaws.com"
  source_arn    = aws_cloudwatch_metric_alarm.course_creation_alarm.arn
}
