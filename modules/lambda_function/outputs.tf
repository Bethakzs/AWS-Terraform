output "role_arn" {
  description = "ARN of the IAM Role for this Lambda"
  value       = aws_iam_role.this.arn
}

output "function_name" {
  description = "Name of the created Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "ARN of the created Lambda function"
  value       = aws_lambda_function.this.arn
}