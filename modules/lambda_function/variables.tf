variable "function_name" {
  type        = string
  description = "The name of the Lambda function"
}

variable "handler" {
  type        = string
  default     = "index.handler"
  description = "Handler for the Lambda function (fileName.handlerName)"
}

variable "runtime" {
  type        = string
  default     = "nodejs16.x"
  description = "The AWS Lambda runtime"
}

variable "source_dir" {
  type        = string
  description = "Path to the folder containing the Lambda code (index.js, etc.)"
}

variable "dynamodb_table_arn" {
  type        = string
  default     = ""
  description = "ARN of the DynamoDB table (if needed). If empty, no DynamoDB actions are applied."
}

variable "dynamodb_actions" {
  type        = list(string)
  default     = []
  description = "List of allowed DynamoDB actions (e.g. [\"dynamodb:Scan\"])."
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "Environment variables for the Lambda function"
}