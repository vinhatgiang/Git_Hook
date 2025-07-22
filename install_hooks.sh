#!/bin/bash

# Script to install Git hooks
# Platform: Windows (Git Bash) / macOS

echo "====================================="
echo "        Git Hooks Installer"
echo "====================================="

# Simple path setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_DIR=".git"
HOOKS_DIR=".git/hooks"

# Check if we're in a Git repository
if [ ! -d "$GIT_DIR" ]; then
    echo "Error: Run this script from Git repository root"
    exit 1
fi

# Create hooks directory
mkdir -p "$HOOKS_DIR"

# Force Git to track file modes on Windows
git config core.fileMode true

# Determine source directory based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    SOURCE_DIR="$SCRIPT_DIR/hook-mac"
    echo "macOS detected"
else
    SOURCE_DIR="$SCRIPT_DIR/hook-win"
    echo "Windows detected"
fi

echo "Installing Git hooks..."

# Install hooks
for hook in commit-msg pre-commit pre-push pre-rebase; do
    src="$SOURCE_DIR/$hook"
    dst="$HOOKS_DIR/$hook"
    
    if [ ! -f "$src" ]; then
        echo "Missing hook: $hook"
        continue
    fi
    
    echo "Installing $hook..."
    
    # Copy hook and handle errors
    cp "$src" "$dst" || {
        echo "Failed to copy $hook"
        continue
    }
    
    # Fix line endings and set permissions
    if [[ "$OSTYPE" != "darwin"* ]]; then
        # For Windows: Remove CRLF and try multiple permission methods
        sed -i 's/\r$//' "$dst" 2>/dev/null
        
        # Try multiple permission methods
        chmod +x "$dst" 2>/dev/null || \
        /c/Windows/System32/icacls.exe "$dst" //grant "${USERNAME}:RX" >/dev/null 2>&1
        
        # Ensure Git tracks the executable bit
        git update-index --chmod=+x "$dst" 2>/dev/null
    else
        # For macOS: Simple permission setting
        chmod 755 "$dst" 2>/dev/null
    fi

    # Add to Git to track permissions
    git add "$dst" >/dev/null 2>&1
    
    echo "Installed: $hook"
done

echo
echo "Git hooks installed successfully!"
echo "====================================="