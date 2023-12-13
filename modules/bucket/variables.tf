variable "service_account_email" {
  description = "Email of the service account to have access to the bucket"
  type        = string
}

variable "group_email" {
  description = "Email of the Google Group to have access to the bucket"
  type        = string
}

variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "bucket_name" {
  description = "The name of the bucket to create"
  type        = string
}

variable "location" {
  description = "The location where the bucket will be created"
  type        = string
  default     = "US"
}

variable "force_destroy" {
  description = "When deleting the bucket, delete all objects in the bucket first"
  type        = bool
  default     = false
}
