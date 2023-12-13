resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = var.force_destroy
}

resource "google_storage_bucket_iam_binding" "service_account_iam" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  members = ["serviceAccount:${var.service_account_email}"]
}

resource "google_storage_bucket_iam_binding" "group_iam" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  members = ["group:${var.group_email}"]
}
