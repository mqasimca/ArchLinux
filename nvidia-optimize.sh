#!/bin/bash

# Check if NVIDIA drivers are installed
if ! command -v nvidia-smi &> /dev/null; then
    echo "NVIDIA driver is not installed. Please install it first."
    exit 1
fi

# Optimize NVIDIA settings
echo "Checking NVIDIA persistence daemon..."
if systemctl is-active --quiet nvidia-persistenced.service; then
    echo "NVIDIA persistence daemon is already active."
else
    echo "Starting NVIDIA persistence daemon..."
    sudo systemctl enable --now nvidia-persistenced.service || {
        echo "Failed to enable and start NVIDIA persistence daemon."
        exit 1
    }
    echo "NVIDIA persistence daemon started and enabled."
fi

# Link NVIDIA modprobe configuration files
link_files /usr/lib/modprobe.d /etc/modprobe.d "nvidia*.conf"

sudo mkinitcpio -P
echo "NVIDIA optimization completed successfully."
