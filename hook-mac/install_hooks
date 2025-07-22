#!/bin/bash

# Git Hooks Installation Script
# Platform: macOS/Linux
# Purpose: Install all Git hooks with proper permissions and configuration

set -e

# Colors for terminal output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print colored output
print_header() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                    Git Hooks Installer                  ║${NC}"
    echo -e "${PURPLE}║                    macOS/Linux Version                  ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check if we're in a Git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "This directory is not a Git repository!"
        echo -e "${YELLOW}Please run this script from the root of your Git repository.${NC}"
        echo -e "${BLUE}Or initialize a new Git repository with: ${GREEN}git init${NC}"
        exit 1
    fi
}

# Function to backup existing hooks
backup_existing_hooks() {
    local hooks_dir=".git/hooks"
    local backup_dir=".git/hooks-backup-$(date +%Y%m%d-%H%M%S)"
    
    if [ -d "$hooks_dir" ] && [ "$(ls -A $hooks_dir)" ]; then
        print_step "Creating backup of existing hooks..."
        mkdir -p "$backup_dir"
        cp -r "$hooks_dir"/* "$backup_dir/" 2>/dev/null || true
        print_success "Existing hooks backed up to: $backup_dir"
    fi
}

# Function to install a single hook
install_hook() {
    local hook_name="$1"
    local source_file="$2"
    local hooks_dir=".git/hooks"
    local target_file="$hooks_dir/$hook_name"
    
    if [ -f "$source_file" ]; then
        print_step "Installing $hook_name hook..."
        cp "$source_file" "$target_file"
        chmod +x "$target_file"
        print_success "$hook_name hook installed successfully"
    else
        print_warning "$hook_name hook source file not found: $source_file"
    fi
}

# Function to create hooks directory if it doesn't exist
ensure_hooks_directory() {
    local hooks_dir=".git/hooks"
    if [ ! -d "$hooks_dir" ]; then
        mkdir -p "$hooks_dir"
        print_success "Created hooks directory: $hooks_dir"
    fi
}

# Function to test hooks
test_hooks() {
    print_step "Testing installed hooks..."
    
    local hooks_dir=".git/hooks"
    local hooks=("pre-commit" "pre-push" "commit-msg")
    local all_working=true
    
    for hook in "${hooks[@]}"; do
        local hook_file="$hooks_dir/$hook"
        if [ -f "$hook_file" ] && [ -x "$hook_file" ]; then
            print_success "$hook hook is installed and executable"
        else
            print_error "$hook hook is missing or not executable"
            all_working=false
        fi
    done
    
    if [ "$all_working" = true ]; then
        print_success "All hooks are properly installed and configured"
    else
        print_error "Some hooks are not properly configured"
        return 1
    fi
}

# Function to display installation summary
show_summary() {
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║                   Installation Complete                 ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}📋 Installed Hooks:${NC}"
    echo -e "• ${BLUE}pre-commit${NC}  - Prevents commits to main/develop branches"
    echo -e "                - Validates commit message format"
    echo -e "• ${BLUE}pre-push${NC}    - Prevents pushes to main/develop branches"
    echo -e "                - Blocks force pushes and detects rebases"
    echo -e "• ${BLUE}commit-msg${NC}  - Validates commit message rules and format"
    echo ""
    echo -e "${GREEN}🛡️  Protection Rules Active:${NC}"
    echo -e "• ${RED}❌${NC} Direct commits to main/master branches"
    echo -e "• ${RED}❌${NC} Direct commits to develop/dev branches"
    echo -e "• ${RED}❌${NC} Direct pushes to main/master branches"
    echo -e "• ${RED}❌${NC} Direct pushes to develop/dev branches"
    echo -e "• ${RED}❌${NC} Force pushes (--force, --force-with-lease)"
    echo -e "• ${RED}❌${NC} Rebase operations on shared branches"
    echo -e "• ${RED}❌${NC} Commit messages shorter than 10 characters"
    echo -e "• ${RED}❌${NC} Commit messages not starting with capital letter"
    echo ""
    echo -e "${YELLOW}💡 Recommended Workflow:${NC}"
    echo -e "1. ${GREEN}git checkout -b feature/your-feature${NC}"
    echo -e "2. ${GREEN}git add .${NC}"
    echo -e "3. ${GREEN}git commit -m \"Add your feature description\"${NC}"
    echo -e "4. ${GREEN}git push origin feature/your-feature${NC}"
    echo -e "5. Create Pull Request for code review"
    echo ""
    echo -e "${BLUE}📖 For detailed documentation, see: README-vi.md${NC}"
}

# Main installation process
main() {
    print_header
    
    # Check if we're in a Git repository
    check_git_repo
    
    # Backup existing hooks
    backup_existing_hooks
    
    # Ensure hooks directory exists
    ensure_hooks_directory
    
    # Install hooks
    install_hook "pre-commit" "$SCRIPT_DIR/pre-commit"
    install_hook "pre-push" "$SCRIPT_DIR/pre-push"
    install_hook "commit-msg" "$SCRIPT_DIR/commit-msg"
    
    # Test hooks
    if test_hooks; then
        show_summary
        echo -e "${GREEN}🎉 Git hooks installation completed successfully!${NC}"
        echo -e "${BLUE}Your repository is now protected with comprehensive Git hooks.${NC}"
    else
        print_error "Installation completed with errors. Please check the hooks manually."
        exit 1
    fi
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "Git Hooks Installation Script"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --test         Test existing hooks without installation"
        echo "  --uninstall    Remove all installed hooks"
        echo ""
        echo "This script installs Git hooks that protect your repository from:"
        echo "• Direct commits/pushes to main and develop branches"
        echo "• Force pushes and dangerous rebase operations"  
        echo "• Invalid commit messages"
        ;;
    --test)
        print_header
        check_git_repo
        test_hooks
        ;;
    --uninstall)
        print_header
        check_git_repo
        print_step "Removing installed hooks..."
        rm -f .git/hooks/pre-commit .git/hooks/pre-push .git/hooks/commit-msg
        print_success "All hooks have been removed"
        ;;
    *)
        main
        ;;
esac