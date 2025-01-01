#!/bin/bash

# Ensure vim is installed using the reusable function
ensure_installed pacman vim

# Directory for GitHub Copilot Vim plugin
COPILOT_DIR="$HOME/.vim/pack/github/start/copilot.vim"

# Install GitHub Copilot plugin for Vim
if [ -d "$COPILOT_DIR" ]; then
    echo "GitHub Copilot is already installed in $COPILOT_DIR."
else
    echo "Installing GitHub Copilot..."
    git clone https://github.com/github/copilot.vim.git "$COPILOT_DIR" || {
        echo "Failed to clone GitHub Copilot repository. Please check your internet connection."
        exit 1
    }
    echo "GitHub Copilot installed successfully!"
    echo "Start Vim/Neovim and invoke :Copilot setup"
fi
