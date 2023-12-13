resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = var.service_account_name
  display_name = var.service_account_name
}

resource "google_project_iam_member" "service_account_iam" {
  for_each =  var.roles
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

