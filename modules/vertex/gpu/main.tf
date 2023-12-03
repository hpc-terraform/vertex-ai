provider "google" {
  # Define your GCP project and region if not set via gcloud or environment variables
  project              = var.project_id
  region               = var.region
}

resource "google_notebooks_instance" "vertex_ai_instance" {
  # Replace with the appropriate project and location
  project  = var.project_id
  location = var.zone

  name = var.hostname

  # Machine type specification
  machine_type = var.machine_type # Example machine type, adjust as necessary for 16 cores

  # Specify the service account to use
  service_account = var.service_account_email

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
  scratch_bucket     = var.scratch_bucket
  share_bucket       = var.share_bucket

  startup-script     = <<-EOT
    #!/bin/bash
    # Update the package list
    sudo apt-get update

    # Install NFS client to mount a filestore
    sudo apt-get install -y nfs-common bc

    USER=${var.user}
    echo "after user $USER"


    echo "about to copy"
    # Download data or scripts from the GitHub repository
    echo "about to download scripts"
    curl -o /usr/local/bin/check-load.sh https://raw.githubusercontent.com/hpc-terraform/vertex-ai/main/scripts/check-load.sh
    curl -o /usr/local/bin/gcs_fuse.sh https://raw.githubusercontent.com/hpc-terraform/vertex-ai/main/scripts/gcs_fuse.sh
    SCRATCH_BUCKET_NAME=${var.scratch_bucket}
    sed -i "s|@SCRATCH_BUCKET@|${SCRATCH_BUCKET_NAME}|g" /usr/local/bin/gcs_fuse.sh
    SHARE_BUCKET_NAME=${var.scratch_bucket}
    sed -i "s|@SHARE_BUCKET@|${SHARE_BUCKET_NAME}|g" /usr/local/bin/gcs_fuse.sh

    echo "about to set permissions and execute scripts"
    chmod +x /usr/local/bin/check-load.sh
    chmod +x /usr/local/bin/gcs_fuse.sh

    echo "downloading system service files"
    curl -o /etc/systemd/system/check-load.service https://raw.githubusercontent.com/hpc-terraform/vertex-ai/main/scripts/check-load.service
    curl -o /etc/systemd/system/check-load.timer https://raw.githubusercontent.com/hpc-terraform/vertex-ai/main/scripts/check-load.timer
    curl -o /etc/systemd/system/gcs_fuse_mount.service https://raw.githubusercontent.com/hpc-terraform/vertex-ai/main/scripts/gcs_fuse_mount.service

    sudo systemctl enable check-load.timer
    sudo systemctl start check-load.timer
    sudo systemctl enable gcs_fuse_mount.service
    sudo systemctl start gcs_fuse_mount.service

    # Step 5: Create a symbolic link if it doesn't exist
    SYMLINK_NAME="/home/jupyter/shared"
    SYMLINK_TARGET="/mnt/share/$USER"

    # Create the symlink if it does not exist
    if [ ! -L "$SYMLINK_NAME" ]; then
       mkdir "$SYMLINK_TARGET" 
       ln -s "$SYMLINK_TARGET" "$SYMLINK_NAME"
       echo "Symbolic link created from $SYMLINK_TARGET to $SYMLINK_NAME."
    else
       echo "Symbolic link $SYMLINK_NAME already exists."
    fi

    SYMLINK_NAME="/home/jupyter/scratch"
    SYMLINK_TARGET="/mnt/scratch/$USER"

    # Create the symlink if it does not exist
    if [ ! -L "$SYMLINK_NAME" ]; then
       mkdir "$SYMLINK_TARGET" 
       ln -s "$SYMLINK_TARGET" "$SYMLINK_NAME"
       echo "Symbolic link created from $SYMLINK_TARGET to $SYMLINK_NAME."
    else
       echo "Symbolic link $SYMLINK_NAME already exists."
    fi

    apt-get update --allow-releaseinfo-change
    sed -i "s/http:/https:/" /etc/apt/sources.list.d/gcsfuse.list

    echo "Startup script execution completed"
  EOT
}


  
  network              = var.network
  subnet               = var.subnetwork

  
}






resource "google_notebooks_instance" "vertex_ai_instance" {
  # Replace with the appropriate project and location
  project  = var.project_id
  location = var.zone

  name = var.hostname

  # Machine type specification
  machine_type = var.machine_type # Example machine type, adjust as necessary for 16 cores

  # Specify the service account to use
  service_account = var.service_account_email

  # Boot disk configuration
  boot_disk_type    = "PD_STANDARD"
  boot_disk_size_gb = var.boot_disk_size_gb # Adjust the size as necessary

  vm_image {

    project    = var.image_project
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
  network  = var.network_self_link
  subnet = var.subnetwork_self_link

metadata = {
  proxy-mode         = "project-editors"
  user               = var.user
  scratch_bucket     = var.scratch_bucket
  share_bucket       = var.share_bucket

  startup-script     = <<-EOT
    #!/bin/bash
    # Update the package list
    sudo apt-get update

    # Install NFS client to mount a filestore
    sudo apt-get install -y nfs-common bc

    USER=${var.user}
    echo "after user $USER"
    
    echo "about to copy"
    # Download data or scripts from the GitHub repository
    echo "about to download scripts"
    curl -o /usr/local/bin/check-load.sh https://raw.githubusercontent.com/hpc-terraform/vertex-ai/main/scripts/check-load.sh
    curl -o /usr/local/bin/gcs_fuse.sh https://raw.githubusercontent.com/hpc-terraform/vertex-ai/main/scripts/gcs_fuse.sh
    SCRATCH_BUCKET_NAME="${var.scratch_bucket}"
    SHARE_BUCKET_NAME="${var.share_bucket}"

    # Using double dollar signs to prevent Terraform from interpreting these as its own variables
    sed -i "s|@SCRATCH_BUCKET@|$${SCRATCH_BUCKET_NAME}|g" /usr/local/bin/gcs_fuse.sh
    sed -i "s|@SHARE_BUCKET@|$${SHARE_BUCKET_NAME}|g" /usr/local/bin/gcs_fuse.sh


    echo "about to set permissions and execute scripts"
    chmod +x /usr/local/bin/check-load.sh
    chmod +x /usr/local/bin/gcs_fuse.sh

    echo "downloading system service files"
    curl -o /etc/systemd/system/check-load.service https://raw.githubusercontent.com/hpc-terraform/vertex-ai/main/scripts/check-load.service
    curl -o /etc/systemd/system/check-load.timer https://raw.githubusercontent.com/hpc-terraform/vertex-ai/main/scripts/check-load.timer
    curl -o /etc/systemd/system/gcs_fuse_mount.service https://raw.githubusercontent.com/hpc-terraform/vertex-ai/main/scripts/gcs_fuse_mount.service

    sudo systemctl enable check-load.timer
    sudo systemctl start check-load.timer
    sudo systemctl enable gcs_fuse_mount.service
    sudo systemctl start gcs_fuse_mount.service

    # Step 5: Create a symbolic link if it doesn't exist
    SYMLINK_NAME="/home/jupyter/shared"
    SYMLINK_TARGET="/mnt/share/$USER"

    # Create the symlink if it does not exist
    if [ ! -L "$SYMLINK_NAME" ]; then
       mkdir "$SYMLINK_TARGET" 
       ln -s "$SYMLINK_TARGET" "$SYMLINK_NAME"
       echo "Symbolic link created from $SYMLINK_TARGET to $SYMLINK_NAME."
    else
       echo "Symbolic link $SYMLINK_NAME already exists."
    fi

    SYMLINK_NAME="/home/jupyter/scratch"
    SYMLINK_TARGET="/mnt/scratch/$USER"

    # Create the symlink if it does not exist
    if [ ! -L "$SYMLINK_NAME" ]; then
       mkdir "$SYMLINK_TARGET" 
       ln -s "$SYMLINK_TARGET" "$SYMLINK_NAME"
       echo "Symbolic link created from $SYMLINK_TARGET to $SYMLINK_NAME."
    else
       echo "Symbolic link $SYMLINK_NAME already exists."
    fi

    apt-get update --allow-releaseinfo-change
    sed -i "s/http:/https:/" /etc/apt/sources.list.d/gcsfuse.list

    echo "Startup script execution completed"
  EOT
}


}


