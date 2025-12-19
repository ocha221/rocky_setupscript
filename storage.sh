#!/bin/bash

LABEL="MyStorage"
MOUNT_POINT="/home/rocky/my-drive"
USER="rocky"
FSTYPE="ext4"

if [ "$EUID" -ne 0 ]; then 
    echo "ERROR: Please run as root (use sudo)"
    exit 1
fi

echo "Creating mount point: $MOUNT_POINT"
mkdir -p "$MOUNT_POINT"

if grep -q "LABEL=$LABEL" /etc/fstab; then
    echo "WARNING: fstab entry for LABEL=$LABEL already exists"
    echo "Skipping fstab modification"
else
    echo "Adding entry to /etc/fstab"
    echo "LABEL=$LABEL  $MOUNT_POINT  $FSTYPE  defaults,nofail  0  2" >> /etc/fstab
    echo "fstab entry added successfully"
fi

echo "Mounting the drive..."
mount -a

if mountpoint -q "$MOUNT_POINT"; then
    echo "Drive mounted successfully"
  
    echo "Setting ownership to $USER:$USER"
    chown -R "$USER:$USER" "$MOUNT_POINT"
    chmod 755 "$MOUNT_POINT"
    
    echo "=== Setup Complete ==="
    echo "Drive is mounted at: $MOUNT_POINT"
    echo "Ownership set to: $USER"
    df -h "$MOUNT_POINT"
else
    echo "ERROR: Failed to mount drive"
    echo "Check if the drive with LABEL=$LABEL is attached"
    exit 1
fi
