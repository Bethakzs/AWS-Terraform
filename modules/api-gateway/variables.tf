variable "api_name" {
  type        = string
  description = "Name of the API Gateway"
}

variable "stage_name" {
  type        = string
  description = "Name of the API Gateway stage"
  default     = "dev"
}

variable "endpoints" {
  type        = list(string)
  description = "List of API endpoints"
}

variable "lambda_uri_map" {
  type        = map(string)
  description = "Map of Lambda function names to their invoke URIs"
}

variable "lambda_function_arns" {
  type        = map(string)
  description = "Map of Lambda function names to their ARNs"
}

variable "website_endpoint" {
  type        = string
  description = "S3 website endpoint for CORS configuration"
} 