#!/bin/bash

# Update the package list
sudo apt-get update

# Install NFS client to mount a filestore
sudo apt-get install -y nfs-common bc

# Create a directory for the filestore
sudo mkdir -p /sep

# Mount the filestore
sudo mount -t nfs -o rw 10.67.27.10:/sep_shared_disk /sep

# Make sure that the filestore stays mounted after reboot
echo "10.67.27.10:/fileshare /sep nfs defaults 0 0" | sudo tee -a /etc/fstab

echo "before grab user"
USER=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/user -H "Metadata-Flavor: Google")
echo "after user $USER"j

# Install additional dependencies or run scripts
# sudo apt-get install -y your-package-name

# Any additional user commands can go here

# If you have any cron jobs to set up, you can add them here
# echo "0 * * * * /path/to/your/script.sh" | sudo tee -a /var/spool/cron/crontabs/root

# Download data or scripts from a GCS bucket
# Assumes that the service account has read access to the bucket
echo "abouut to copy"
gsutil cp gs://sep-build-scripts/check-load.sh /usr/local/bin
gsutil cp gs://sep-build-scripts/gcs_fuse.sh /usr/local/bin




echo "abouut2to copy"
# Execute a script downloaded from GCS
chmod +x /usr/local/bin/check-load.sh
chmod +x /usr/local/bin/gcs_fuse.sh

echo "try2"
gsutil cp gs://sep-build-scripts/check-load.service /etc/systemd/system/
gsutil cp gs://sep-build-scripts/check-load.timer /etc/systemd/system/
gsutil cp gs://sep-build-scripts/gcs_fuse_mount.service /etc/systemd/system/

sudo systemctl enable check-load.timer
sudo systemctl start check-load.timer
sudo systemctl enable gcs_fuse_mount.service
sudo systemctl start gcs_fuse_mount.service
touch /tmp/REMOVE_ME



gsutil cp /tmp/REMOVE_ME gs://sep-bucket-home/$USER/


# Step 5: Create a symbolic link if it doesn't exist
SYMLINK_NAME="/home/jupyter/shared"
SYMLINK_TARGET="/mnt/sep_bucket/$USER"


# Create the symlink if it does not exist
if [ ! -L "$SYMLINK_NAME" ]; then
   ln -s "$SYMLINK_TARGET" "$SYMLINK_NAME"
   echo "Symbolic link created from $SYMLINK_TARGET to $SYMLINK_NAME."
else
   echo "Symbolic link $SYMLINK_NAME already exists."
fi


SYMLINK_NAME="/home/jupyter/scratch"
SYMLINK_TARGET="/mnt/scratch_bucket/$USER"


# Create the symlink if it does not exist
if [ ! -L "$SYMLINK_NAME" ]; then
   ln -s "$SYMLINK_TARGET" "$SYMLINK_NAME"
   echo "Symbolic link created from $SYMLINK_TARGET to $SYMLINK_NAME."
else
   echo "Symbolic link $SYMLINK_NAME already exists."
fi



echo "Startup script execution completed"
