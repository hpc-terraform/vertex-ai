
variable "hostname" {
  description = "Name of the webserver instance"
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
