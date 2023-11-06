#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Step 1: Update /etc/fuse.conf to allow other users
if grep -xqFe "user_allow_other" /etc/fuse.conf; then
   echo "'user_allow_other' is already set in /etc/fuse.conf."
else
   echo "user_allow_other" >> /etc/fuse.conf
   echo "'user_allow_other' added to /etc/fuse.conf."
fi

# Step 2: Create mount point directory
MOUNT_POINT="/mnt/sep_bucket"
MOUNT_POINT2="/mnt/scratch_bucket"

mkdir -p "$MOUNT_POINT"
chmod 777 "$MOUNT_POINT"

mkdir -p "$MOUNT_POINT2"
chmod 777 "$MOUNT_POINT2"

# Step 3: Add mount entry to /etc/fstab if not already present
FSTAB_ENTRY="sep-bucket-home /mnt/sep_bucket gcsfuse _netdev,allow_other,file_mode=666,dir_mode=777 0 0"
FSTAB2_ENTRY="scratch-sep /mnt/scratch_bucket gcsfuse _netdev,allow_other,file_mode=666,dir_mode=777 0 0"

if grep -Fxq "$FSTAB_ENTRY" /etc/fstab; then
   echo "fstab entry is already present."
else
   echo "$FSTAB_ENTRY" >> /etc/fstab
   echo "$FSTAB2_ENTRY" >> /etc/fstab

   echo "fstab entry added."
fi

# Step 4: Mount the filesystem
mount "$MOUNT_POINT"
mount "$MOUNT_POINT2"
