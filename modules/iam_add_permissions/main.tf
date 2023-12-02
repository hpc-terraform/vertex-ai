resource "google_project_iam_member" "group_roles" {
  for_each =  var.roles
  project = var.project_id
  role    = each.value
  member  = "group:${var.group_email}"
}
