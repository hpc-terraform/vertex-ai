

locals {
  description  = "${var.description} (${var.deployment_name})"
}

resource "google_project_iam_custom_role" "custom_role" {
  description        = local.description
  role_id     = var.role_id
  title       = var.title
  permissions = var.permissions
  project     = var.project_id
}

