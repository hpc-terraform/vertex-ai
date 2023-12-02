#output "assigned_roles" {
#  value = [for role in google_project_iam_member.group_role : role.role]
#}

output "group_email" {
  description = "The email of the group to which roles are assigned"
  value       = var.group_email
}