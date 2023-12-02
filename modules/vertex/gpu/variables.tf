
variable "hostname" {
  description = "Name of the webserver instance"
  type        = string
}


variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default      = "sdss-ching-yao"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}
variable "zone" {
  description = "The GCP region"
  type        = string
  default     = "us-central1-c"
}

variable "service_account_email" {
  description = "Email of the service account"
  type        = string
}


variable "machine_type" {
  description = "Type of machine (e.g., 'n1-standard-16')"
  type        = string
  default     = "n1-standard-16"
}


variable "boot_disk_size_gb" {
  description = "Size of boot disk in GB"
  type        = string
  default     = 100
}



variable "image_name" {
  description = "The name of the VM image to use for the instance"
  type        = string
}

variable "user" {
  description = "The primary use for this instance"
  type        = string
}

variable "gpu_count" {
  description = "The number of GPUs"
  type        = string
  default     = "1"
}

variable "gpu_type" {
  description = "The number of GPUs"
  type        = string
  default     = "NVIDIA_TESLA_V100"
}
variable "network" {
  description = "The name of the network"
  type        = string
  default      = "https://www.googleapis.com/compute/v1/projects/sdss-ching-yao/global/networks/yao-net"
}

variable "subnetwork" {
  description = "The name of the sub-network"
  type        = string
  default      = "https://www.googleapis.com/compute/v1/projects/sdss-ching-yao/regions/us-central1/subnetworks/yao-sub"
}
variable "build_bucket" {
  description = "The name of the second storage bucket"
  type        = string
  default     = "yao-build"
}
