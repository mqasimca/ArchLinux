#!/bin/bash

# Define source and destination directories
SOURCE_UDEV_DIR="$(pwd)/udev-rules"
DEST_UDEV_DIR="/etc/udev/rules.d"

# Call the link_files function to link all `.rules` files
link_files "$SOURCE_UDEV_DIR" "$DEST_UDEV_DIR" "*.rules"

# Reload udev rules
echo "Reloading udev rules..."
sudo udevadm control --reload-rules && sudo udevadm trigger

echo "All udev rules have been linked and reloaded."
