#!/bin/bash

# Script to install Git hooks to prevent unsafe Git operations
# Platform: Windows (Git Bash) / macOS
# Purpose: Install and configure multiple Git hooks with permissions

# Display header
echo "====================================="
echo "        Git Hooks Installer"
echo "====================================="
echo

# Check if we're in a Git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: This script must be run from the root of a Git repository."
    echo "Current directory does not appear to be a Git repository (no .git directory found)."
    exit 1
fi

# Set hooks directory
hooks_dir=".git/hooks"

# Create hooks directory if it doesn't exist
mkdir -p "$hooks_dir"

echo "🔧 Installing Git hooks..."

# Define hooks to install
hook_files=("pre-commit" "commit-msg" "pre-push" "pre-rebase")

# Install hooks
failed=""
for hook in "${hook_files[@]}"; do
    source_file="hook-win/$hook"
    target_file="$hooks_dir/$hook"
    
    # Check if source file exists
    if [ ! -f "$source_file" ]; then
        failed="$failed $hook"
        continue
    fi
    
    # Copy and set permissions
    cp "$source_file" "$target_file" 2>/dev/null && chmod +x "$target_file" 2>/dev/null || failed="$failed $hook"
done

if [ ! -z "$failed" ]; then
    echo "❌ Failed to install hooks:$failed"
    exit 1
fi

# Display installation result
echo
echo "✅ Git hooks installed successfully!"
echo
echo "📋 Installed hooks:"
echo "• pre-commit  : Prevents commits to protected branches"
echo "• commit-msg  : Enforces commit message format rules"
echo "• pre-push    : Prevents pushes to protected branches"
echo "• pre-rebase  : Prevents rebase operations"
echo
echo "🛡️  Active protection rules:"
echo "• No direct commits to main/develop branches"
echo "• No pushes to protected branches"
echo "• No force pushes"
echo "• No rebase operations"
echo "• Commit message format validation"
    echo
    echo "💡 To create a new feature:"
    echo "  git checkout -b feature/your-feature"
    echo "  git add ."
    echo "  git commit -m \"type: your message\""
    echo "  git push origin feature/your-feature"
    echo
    echo "⚠️  To bypass hooks in emergency situations:"
    echo "  git commit --no-verify"
    echo "  git push --no-verify"
    echo
else
    echo
    echo "❌ Installation failed! Please check the error messages above."
    exit 1
fi
