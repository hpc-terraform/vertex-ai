variable "service_account_name" {
  description = "The name of the service account"
  type        = string
}

variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "roles" {
  description = "Map of roles to assign to the service account"
  type        = map(any)
}

