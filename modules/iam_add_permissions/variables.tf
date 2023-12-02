variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "group_email" {
  description = "The email of the GCP group to which permissions will be added"
  type        = string
}

variable "roles" {
  description = "List of roles to be assigned to the group"
  type        = map
}
