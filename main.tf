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