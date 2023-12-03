variable "bucket_name" {
  description = "The name of the bucket to create"
  type        = string
}

variable "service_account_email" {
  description = "The email of the service account which will have access to the bucket"
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

