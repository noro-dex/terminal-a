#!/bin/bash

# Script to install Go 1.25.2 on macOS

# Variables
URL="https://go.dev/dl/go1.25.2.darwin-amd64.tar.gz"
FILE="go1.25.2.darwin-amd64.tar.gz"
INSTALL_DIR="/usr/local"
SHELL_CONFIG="$HOME/.bash_profile"  # Use ~/.zshrc if you use Zsh

# Exit on error
set -e

# Step 1: Download the Go binary
echo "Downloading Go 1.25.2..."
curl -LO "$URL"

# Step 2: Verify checksum (optional, requires manual comparison)
echo "Verifying checksum..."
shasum -a 256 "$FILE"
echo "Please compare the above checksum with the one on https://go.dev/dl/"

# Step 3: Remove existing Go installation (if any)
if [ -d "$INSTALL_DIR/go" ]; then
    echo "Removing existing Go installation..."
    sudo rm -rf "$INSTALL_DIR/go"
fi

# Step 4: Extract the tarball
echo "Installing Go to $INSTALL_DIR..."
sudo tar -C "$INSTALL_DIR" -xzf "$FILE"

# Step 5: Set up environment variables
echo "Configuring environment variables..."
cat << EOF >> "$SHELL_CONFIG"
export PATH=\$PATH:$INSTALL_DIR/go/bin
export GOPATH=\$HOME/go
export PATH=\$PATH:\$GOPATH/bin
EOF

# Step 6: Apply environment changes
echo "Applying environment changes..."
source "$SHELL_CONFIG"

# Step 7: Verify installation
echo "Verifying Go installation..."
go version

# Step 8: Clean up
echo "Cleaning up..."
rm "$FILE"

echo "Go 1.25.2 installation completed successfully!"