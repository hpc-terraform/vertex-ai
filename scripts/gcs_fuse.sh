#!/bin/bash


# Step 1: Update /etc/fuse.conf to allow other users
if grep -xqFe "user_allow_other" /etc/fuse.conf; then
   sudo echo "'user_allow_other' is already set in /etc/fuse.conf."
else
   sudo echo "user_allow_other" | sudo tee -a /etc/fuse.conf
   echo "'user_allow_other' added to /etc/fuse.conf."
fi

# Step 2: Create mount point directory
MOUNT_POINT="/mnt/share"
MOUNT_POINT2="/mnt/scratch"

sudo mkdir -p "$MOUNT_POINT"
sudo chmod 777 "$MOUNT_POINT"

sudo mkdir -p "$MOUNT_POINT2"
sudo chmod 777 "$MOUNT_POINT2"


gcsfuse  --file-mode 666 --dir-mode 777  @SCRATCH_BUCKET@ /mnt/scratch
gcsfuse  --file-mode 666 --dir-mode 777  @SHARE_BUCKET@ /mnt/share