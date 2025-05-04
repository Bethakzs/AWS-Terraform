module "label" {
  source  = "git::https://github.com/cloudposse/terraform-null-label.git"
  # ref   = "tags/0.25.0"
  name    = var.table_name
}

resource "aws_dynamodb_table" "this" {
  name         = module.label.id
  billing_mode = var.billing_mode
  hash_key     = var.hash_key

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }
}