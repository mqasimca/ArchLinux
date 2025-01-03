#!/bin/bash

# Define the target directory and script path
BIN_DIR="$HOME/bin"
SCRIPT_PATH="$BIN_DIR/ensure_installed"

# Ensure the bin directory exists
if [ ! -d "$BIN_DIR" ]; then
    echo "Creating bin directory at $BIN_DIR..."
    mkdir -p "$BIN_DIR"
fi

# Create the ensure_installed script
echo "Creating ensure_installed script in $SCRIPT_PATH..."
cat << 'EOF' > "$SCRIPT_PATH"
#!/bin/bash

# Function to ensure packages are installed
ensure_installed() {
    local manager=$1
    shift
    local packages=("$@")
    local to_install=()

    case "$manager" in
        pacman)
            for package in "${packages[@]}"; do
                if ! pacman -Qi "$package" &> /dev/null; then
                    to_install+=("$package")
                else
                    echo "$package is already installed via pacman."
                fi
            done

            if [ "${#to_install[@]}" -ne 0 ]; then
                echo "Installing packages: ${to_install[*]} using pacman..."
                sudo pacman -S "${to_install[@]}" || {
                    echo "Failed to install packages using pacman. Please check the package names or your internet connection."
                    exit 1
                }
                echo "Packages installed successfully via pacman."
            else
                echo "All packages are already installed."
            fi
            ;;
        paru)
            if ! command -v paru &> /dev/null; then
                echo "paru is not installed. Please install paru first to proceed."
                exit 1
            fi
            for package in "${packages[@]}"; do
                if ! paru -Qi "$package" &> /dev/null; then
                    to_install+=("$package")
                else
                    echo "$package is already installed via paru."
                fi
            done

            if [ "${#to_install[@]}" -ne 0 ]; then
                echo "Installing packages: ${to_install[*]} using paru..."
                paru -S "${to_install[@]}" || {
                    echo "Failed to install packages using paru. Please check the package names or your internet connection."
                    exit 1
                }
                echo "Packages installed successfully via paru."
            else
                echo "All packages are already installed."
            fi
            ;;
        *)
            echo "Invalid package manager specified. Use 'pacman' or 'paru'."
            exit 1
            ;;
    esac
}

# Call the function with the provided arguments
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <manager> <package1> [package2 ... packageN]"
    exit 1
fi

manager="$1"
shift
packages=("$@")

ensure_installed "$manager" "${packages[@]}"
EOF

# Make the script executable
echo "Setting executable permission for $SCRIPT_PATH..."
chmod +x "$SCRIPT_PATH"

# Add the bin directory to the PATH if not already present
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    echo "Adding $BIN_DIR to PATH in ~/.zshrc..."
    echo "export PATH=\"\$HOME/bin:\$PATH\"" >> ~/.zshrc
fi

echo "The ensure_installed script is ready and available as a system-wide command."
