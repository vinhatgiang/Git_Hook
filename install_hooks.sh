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

# Array to track installed hooks for rollback
INSTALLED_HOOKS=()

# Function to rollback installed hooks
rollback_hooks() {
    echo "Error occurred! Rolling back installed hooks..."
    for hook in "${INSTALLED_HOOKS[@]}"; do
        if [ -f "$HOOKS_DIR/$hook" ]; then
            rm -f "$HOOKS_DIR/$hook"
            echo "Removed: $hook"
        fi
    done
    echo "Rollback completed!"
    exit 1
}

# Install hooks
for hook in commit-msg pre-commit pre-push pre-rebase; do
    src="$SOURCE_DIR/$hook"
    dst="$HOOKS_DIR/$hook"
    
    if [ ! -f "$src" ]; then
        echo "Error: Missing hook file - $hook"
        rollback_hooks
    fi
    
    echo "Installing $hook..."
    
    # Copy hook and handle errors
    if ! cp "$src" "$dst"; then
        echo "Error: Failed to copy $hook"
        rollback_hooks
    fi
    
    # Set execute permissions for all hooks
    if ! chmod +x "$dst"; then
        echo "Error: Failed to set permissions for $hook"
        rollback_hooks
    fi
    
    # Add to installed hooks list for potential rollback
    INSTALLED_HOOKS+=("$hook")
    
    echo "Installed: $hook"
done

echo
echo "All Git hooks installed successfully!"
echo "====================================="
