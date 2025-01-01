#!/bin/bash

# Define the journal directory
JOURNAL_DIR="/var/log/journal"

# Check if the directory exists
if [ -d "$JOURNAL_DIR" ]; then
    echo "Directory $JOURNAL_DIR exists. Removing it..."
    
    # Remove the directory
    sudo rm -rf "$JOURNAL_DIR"
    
    # Confirm removal
    if [ ! -d "$JOURNAL_DIR" ]; then
        echo "Successfully removed $JOURNAL_DIR."
        echo "Logging will now occur in /run/log/journal (in-memory)."
    else
        echo "Failed to remove $JOURNAL_DIR. Please check your permissions."
        exit 1
    fi
else
    echo "Directory $JOURNAL_DIR does not exist. Logging is already in /run/log/journal (in-memory)."
fi

# Restart systemd-journald to apply changes
echo "Restarting systemd-journald service to apply changes..."
sudo systemctl restart systemd-journald

