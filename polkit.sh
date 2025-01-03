#!/bin/bash

# Define source and destination directories
SOURCE_DIR="./polkit-rules"
DEST_DIR="/etc/polkit-1/rules.d"

# Copy files with sudo tee
echo "Copying files from $SOURCE_DIR to $DEST_DIR using sudo tee..."
for file in "$SOURCE_DIR"/*; do
    if [ -f "$file" ]; then
        file_name=$(basename "$file")
        sudo tee "$DEST_DIR/$file_name" < "$file" > /dev/null
        echo "Copied $file_name to $DEST_DIR"
        
        # Set permissions for the copied file
        sudo chmod 644 "$DEST_DIR/$file_name"
        echo "Permissions set for $file_name in $DEST_DIR"
    fi
done

echo "Script completed."
exit 0
