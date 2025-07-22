#!/bin/bash

# Git Hook: pre-commit
# Platform: macOS/Linux
# Purpose: Prevent direct commits to main and develop branches, validate commit messages

set -e

# Colors for terminal output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Get current branch name
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Function to show alert dialog on macOS
show_alert_dialog() {
    local title="$1"
    local message="$2"
    if command -v osascript >/dev/null 2>&1; then
        osascript -e "display alert \"$title\" message \"$message\" buttons {\"OK\"} default button \"OK\" as critical"
    elif command -v zenity >/dev/null 2>&1; then
        zenity --error --title="$title" --text="$message" --width=400
    elif command -v kdialog >/dev/null 2>&1; then
        kdialog --error "$message" --title "$title"
    fi
}

# Function to validate commit message
validate_commit_message() {
    local commit_msg_file="$1"
    local commit_msg=$(cat "$commit_msg_file")
    
    # Remove comments and empty lines
    commit_msg=$(echo "$commit_msg" | sed '/^#/d' | sed '/^$/d')
    
    # Check minimum length (10 characters)
    if [ ${#commit_msg} -lt 10 ]; then
        echo -e "${RED}❌ COMMIT MESSAGE ERROR${NC}"
        echo -e "${YELLOW}Commit message must be at least 10 characters long.${NC}"
        echo -e "${YELLOW}Current message: '$commit_msg' (${#commit_msg} characters)${NC}"
        echo ""
        echo -e "${GREEN}Commit Message Rules:${NC}"
        echo -e "• Minimum 10 characters"
        echo -e "• Use present tense (e.g., 'Add feature' not 'Added feature')"
        echo -e "• Start with capital letter"
        echo -e "• Be descriptive and clear"
        echo -e "• Example: 'Add user authentication system'"
        
        show_alert_dialog "Commit Message Error" "Commit message must be at least 10 characters long.\n\nRules:\n• Minimum 10 characters\n• Use present tense\n• Start with capital letter\n• Be descriptive\n\nCurrent: '$commit_msg' (${#commit_msg} chars)"
        
        exit 1
    fi
    
    # Check if message starts with capital letter
    first_char=$(echo "$commit_msg" | cut -c1)
    if [[ ! "$first_char" =~ [A-Z] ]]; then
        echo -e "${RED}❌ COMMIT MESSAGE ERROR${NC}"
        echo -e "${YELLOW}Commit message must start with a capital letter.${NC}"
        echo -e "${YELLOW}Current message: '$commit_msg'${NC}"
        
        show_alert_dialog "Commit Message Error" "Commit message must start with a capital letter.\n\nCurrent: '$commit_msg'"
        
        exit 1
    fi
}

# Check if committing to protected branches
if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
    echo -e "${RED}❌ COMMIT TO MAIN BRANCH BLOCKED${NC}"
    echo -e "${YELLOW}You are trying to commit directly to the '$BRANCH' branch.${NC}"
    echo -e "${YELLOW}This action is prohibited for code safety and review process.${NC}"
    echo ""
    echo -e "${GREEN}Recommended workflow:${NC}"
    echo -e "1. Create a feature branch: ${GREEN}git checkout -b feature/your-feature${NC}"
    echo -e "2. Make your changes and commit"
    echo -e "3. Push the branch: ${GREEN}git push origin feature/your-feature${NC}"
    echo -e "4. Create a Pull Request for code review"
    
    show_alert_dialog "Direct Commit to Main Branch Blocked" "You are trying to commit directly to the '$BRANCH' branch.\n\nThis action is prohibited for code safety.\n\nPlease:\n1. Create a feature branch\n2. Make changes there\n3. Create a Pull Request"
    
    exit 1
fi

if [[ "$BRANCH" == "develop" || "$BRANCH" == "dev" ]]; then
    echo -e "${RED}❌ COMMIT TO DEVELOP BRANCH BLOCKED${NC}"
    echo -e "${YELLOW}You are trying to commit directly to the '$BRANCH' branch.${NC}"
    echo -e "${YELLOW}This action is prohibited for development workflow integrity.${NC}"
    echo ""
    echo -e "${GREEN}Recommended workflow:${NC}"
    echo -e "1. Create a feature branch: ${GREEN}git checkout -b feature/your-feature${NC}"
    echo -e "2. Make your changes and commit"
    echo -e "3. Push the branch: ${GREEN}git push origin feature/your-feature${NC}"
    echo -e "4. Create a Pull Request to merge into develop"
    
    show_alert_dialog "Direct Commit to Develop Branch Blocked" "You are trying to commit directly to the '$BRANCH' branch.\n\nThis action is prohibited for development workflow.\n\nPlease:\n1. Create a feature branch\n2. Make changes there\n3. Create a Pull Request"
    
    exit 1
fi

# Validate commit message if .git/COMMIT_EDITMSG exists
if [ -f ".git/COMMIT_EDITMSG" ]; then
    validate_commit_message ".git/COMMIT_EDITMSG"
fi

echo -e "${GREEN}✅ Pre-commit checks passed for branch: $BRANCH${NC}"
exit 0