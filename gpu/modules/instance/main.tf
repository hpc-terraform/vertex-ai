provider "google" {
  # Define your GCP project and region if not set via gcloud or environment variables
  project              = "sep-storage"
  region               = "us-central1"
}

resource "google_notebooks_instance" "vertex_ai_instance" {
  # Replace with the appropriate project and location
  project  ="sep-storage"
  location = "us-central1-c"

  name = var.hostname

  # Machine type specification
  machine_type = var.machine_type # Example machine type, adjust as necessary for 16 cores

  # Specify the service account to use
  service_account = "sep-cluster-access@sep-storage.iam.gserviceaccount.com"

  # Boot disk configuration
  boot_disk_type    = "PD_STANDARD"
  boot_disk_size_gb = var.boot_disk_size_gb # Adjust the size as necessary

  # Container image configuration for Python 3.12
  # Please note: At my last knowledge cutoff in January 2022, Python 3.12 was not released,
  # so you would typically reference an existing container image that has the Python version
  # you require. You might need to build a custom container image with Python 3.12 if it's
  # available and not provided by Google in their default container images.
  vm_image {
    project    = "deeplearning-platform-release"
    image_name = var.image_name # You may need to change this to a custom image with Python 3.12
  }

    accelerator_config {
    core_count = var.gpu_count
    type       = var.gpu_type
  }
  
  labels = {
    "user" = var.user
    "machine_type" = "gpu"
  }


  metadata = {
    proxy-mode         = "project-editors"
    user               = var.user
    startup-script-url = "gs://sep-build-scripts/vertex_startup.sh" # If you have a startup script in GCS
  }

  # Network configuration (use default VPC or specify another)
  
  network              = "https://www.googleapis.com/compute/v1/projects/sep-storage/global/networks/sep-cluster-net"
  subnet               = "https://www.googleapis.com/compute/v1/projects/sep-storage/regions/us-central1/subnetworks/sep-cluster-sub"

  
}


