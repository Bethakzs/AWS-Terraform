module "get_all_authors" {
  source = "./modules/lambda_function"

  function_name = "get-all-authors"
  source_dir    = "${path.module}/lambda/get-all-authors"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  dynamodb_table_arn = module.authors.arn
  dynamodb_actions   = ["dynamodb:Scan"]

  environment_variables = {
    DYNAMODB_REGION = var.aws_region
  }
}

module "get_all_courses" {
  source = "./modules/lambda_function"

  function_name = "get-all-courses"
  source_dir    = "${path.module}/lambda/get-all-courses"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  dynamodb_table_arn = module.courses.arn
  dynamodb_actions   = ["dynamodb:Scan"]

  environment_variables = {
    DYNAMODB_REGION = var.aws_region
  }
}

module "get_course" {
  source = "./modules/lambda_function"

  function_name = "get-course"
  source_dir    = "${path.module}/lambda/get-course"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  dynamodb_table_arn = module.courses.arn
  dynamodb_actions   = ["dynamodb:GetItem"]

  environment_variables = {
    DYNAMODB_REGION = var.aws_region
  }
}

module "save_course" {
  source = "./modules/lambda_function"

  function_name = "save-course"
  source_dir    = "${path.module}/lambda/save-course"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  dynamodb_table_arn = module.courses.arn
  dynamodb_actions   = ["dynamodb:PutItem"]

  environment_variables = {
    DYNAMODB_REGION = var.aws_region
  }
}

module "update_course" {
  source = "./modules/lambda_function"

  function_name = "update-course"
  source_dir    = "${path.module}/lambda/update-course"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  dynamodb_table_arn = module.courses.arn
  dynamodb_actions   = ["dynamodb:PutItem"]

  environment_variables = {
    DYNAMODB_REGION = var.aws_region
  }
}

module "delete_course" {
  source = "./modules/lambda_function"

  function_name = "delete-course"
  source_dir    = "${path.module}/lambda/delete-course"
  handler       = "index.handler"
  runtime       = "nodejs16.x"

  dynamodb_table_arn = module.courses.arn
  dynamodb_actions   = ["dynamodb:DeleteItem"]

  environment_variables = {
    DYNAMODB_REGION = var.aws_region
  }
}