resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = var.force_destroy
  // Add other bucket configurations as required
}

resource "google_storage_bucket_iam_binding" "bucket_iam" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.admin"

  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}

