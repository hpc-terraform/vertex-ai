variable "role_id" {
  description = "The ID of the role."
  type        = string
}

variable "title" {
  description = "The title of the role."
  type        = string
}

variable "description" {
  description = "The description of the role."
  type        = string
}

variable "permissions" {
  description = "The list of permissions for the role."
  type        = list(string)
}

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "deployment_name" {
  description = "The name of the deployment"
  type        = string
}

