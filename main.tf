# Get current AWS account ID
data "aws_caller_identity" "current" {}

module "frontend_s3" {
  source       = "./modules/s3"
  bucket_name  = "frontend-${random_id.suffix.hex}"
  index_document = "index.html"
  error_document = "index.html"
}
 
module "frontend_cdn" {
  source              = "./modules/cloudfront"
  s3_website_endpoint = module.frontend_s3.website_endpoint
}

resource "random_id" "suffix" {
  byte_length = 4
}

# Backend Infrastructure
module "authors" {
  source       = "./modules/dynamodb-table"
  table_name   = "authors"
  billing_mode = "PAY_PER_REQUEST"
  attributes   = [{ name = "id", type = "S" }]
}

module "courses" {
  source       = "./modules/dynamodb-table"
  table_name   = "courses"
  billing_mode = "PAY_PER_REQUEST"
  attributes   = [{ name = "id", type = "S" }]
}