variable "project_name" {
  description = "Project name"
  type        = string
  default     = "courses-api"
}

variable "alert_email" {
  description = "Email"
  type        = string
  default     = "romanwdwd@gmail.com"
}

variable "lambda_function_name" {
  description = "Function name"
  type        = string
  default     = "save-course"
}

variable "billing_threshold" {
  description = "The billing amount in USD that triggers the billing alarm"
  type        = number
  default     = 10
} 