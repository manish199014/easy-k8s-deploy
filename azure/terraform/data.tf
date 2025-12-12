# External data source to read environment configuration
data "external" "environment" {
  program = ["${path.module}/environment.sh"]
}

# Random string for DNS prefix uniqueness
resource "random_string" "dns" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}
