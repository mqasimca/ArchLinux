#!/bin/bash

# Ensure the ensure_installed script is in PATH
if ! command -v ensure_installed &> /dev/null; then
    echo "The ensure_installed script is not found in PATH. Please make sure it is installed and available."
    exit 1
fi

# Define packages required for Hyprland
ensure_installed pacman hyprcursor hyprlock hypridle hyprpaper hyprland hyprgraphics hyprland-qtutils hyprlang hyprpicker brightnessctl waybar wofi wayland wlroots xdg-desktop-portal-hyprland mako alacritty rofi playerctl brightnessctl xsensors lm_sensors wlogout swaylock-fancy-git polkit-kde-agent

# Define the source directory (repository's config directory)
REPO_CONFIG_DIR="$(pwd)/config"

# Define the target directory (user's .config directory)
TARGET_CONFIG_DIR="$HOME/.config"

# Ensure the source directory exists
if [ ! -d "$REPO_CONFIG_DIR" ]; then
    echo "Source directory $REPO_CONFIG_DIR does not exist."
    exit 1
fi

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_CONFIG_DIR"

# Loop through each file and folder in the source config directory
for item in "$REPO_CONFIG_DIR"/*; do
    item_name=$(basename "$item")
    target_item="$TARGET_CONFIG_DIR/$item_name"

    if [ -L "$target_item" ]; then
        # If a symlink exists, check if it points to the same source
        if [ "$(readlink -f "$target_item")" != "$item" ]; then
            echo "Updating symlink for $target_item to point to $item"
            ln -sf "$item" "$target_item"
        else
            echo "Symlink for $target_item already points to $item, no action needed."
        fi
    elif [ -e "$target_item" ]; then
        # If a file or folder exists, back it up and create a new symlink
        echo "Moving existing $target_item to ${target_item}-bk"
        mv "$target_item" "${target_item}-bk"
        echo "Creating symlink for $target_item"
        ln -sf "$item" "$target_item"
    else
        # If no file or link exists, create a new symlink
        echo "Creating symlink for $target_item"
        ln -sf "$item" "$target_item"
    fi
done

echo "All links have been processed."
