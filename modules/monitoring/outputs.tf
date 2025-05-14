output "course_creation_sns_topic_arn" {
  description = "ARN of the SNS topic for course creation notifications"
  value       = aws_sns_topic.course_creation.arn
}

output "course_creation_alarm_arn" {
  description = "ARN of the course creation CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.course_creation_alarm.arn
} 