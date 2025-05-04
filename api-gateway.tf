data "aws_region" "current" {}

module "api_gateway" {
  source           = "./modules/api-gateway"
  api_name         = "courses-api"
  stage_name       = "dev"
  website_endpoint = module.frontend_s3.website_endpoint
  
  endpoints = [
    "get-all-authors",
    "get-all-courses",
    "get-course",
    "save-course",
    "update-course",
    "delete-course"
  ]

  lambda_uri_map = {
    "get-all-authors" = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${module.get_all_authors.function_arn}/invocations"
    "get-all-courses" = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${module.get_all_courses.function_arn}/invocations"
    "get-course"      = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${module.get_course.function_arn}/invocations"
    "save-course"     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${module.save_course.function_arn}/invocations"
    "update-course"   = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${module.update_course.function_arn}/invocations"
    "delete-course"   = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${module.delete_course.function_arn}/invocations"
  }

  lambda_function_arns = {
    "get-all-authors" = module.get_all_authors.function_name
    "get-all-courses" = module.get_all_courses.function_name
    "get-course"      = module.get_course.function_name
    "save-course"     = module.save_course.function_name
    "update-course"   = module.update_course.function_name
    "delete-course"   = module.delete_course.function_name
  }
}