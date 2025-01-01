#!/bin/bash

# Define the target directory and script path
BIN_DIR="$HOME/bin"
SCRIPT_PATH="$BIN_DIR/link_files"

# Ensure the bin directory exists
if [ ! -d "$BIN_DIR" ]; then
    echo "Creating bin directory at $BIN_DIR..."
    mkdir -p "$BIN_DIR"
fi

# Create the link_files script
echo "Creating link_files script in $SCRIPT_PATH..."
cat << 'EOF' > "$SCRIPT_PATH"
#!/bin/bash

# Function to create symbolic links for files from a source directory to a destination directory
link_files() {
    local src_dir=$1
    local dest_dir=$2
    local pattern=${3:-*} # Default pattern matches all files if not specified

    # Check if source directory exists
    if [ ! -d "$src_dir" ]; then
        echo "Source directory $src_dir does not exist."
        return 1
    fi

    # Create destination directory if it doesn't exist
    if [ ! -d "$dest_dir" ]; then
        echo "Destination directory $dest_dir does not exist. Creating it..."
        sudo mkdir -p "$dest_dir" || {
            echo "Failed to create destination directory $dest_dir."
            return 1
        }
    fi

    # Link matching files from the source to the destination
    echo "Linking files from $src_dir to $dest_dir with pattern '$pattern'..."
    local files=("$src_dir"/$pattern)

    if [ "${#files[@]}" -eq 0 ]; then
        echo "No files matching pattern '$pattern' found in $src_dir."
        return 0
    fi

    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            local base_file=$(basename "$file")
            sudo ln -sf "$file" "$dest_dir/$base_file" || {
                echo "Failed to link $file to $dest_dir/$base_file"
                return 1
            }
            echo "Linked $file to $dest_dir/$base_file"
        fi
    done
}

# Call the function with the provided arguments
link_files "$@"
EOF

# Make the script executable
echo "Setting executable permission for $SCRIPT_PATH..."
chmod +x "$SCRIPT_PATH"

# Add the bin directory to the PATH if not already present
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "Adding $BIN_DIR to PATH in ~/.zshrc..."
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> ~/.zshrc
    source ~/.zshrc
fi

echo "The link_files script is ready and available as a system-wide command."
