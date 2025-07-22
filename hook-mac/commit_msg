#!/bin/bash

# Git Hook: commit-msg
# Platform: macOS/Linux  
# Purpose: Validate commit message format and rules

set -e

# Colors for terminal output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Get commit message file
COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Remove comments and empty lines for validation
CLEAN_MSG=$(echo "$COMMIT_MSG" | sed '/^#/d' | sed '/^$/d' | head -1)

# Check if message is empty
if [ -z "$CLEAN_MSG" ]; then
    echo -e "${RED}❌ COMMIT MESSAGE ERROR${NC}"
    echo -e "${YELLOW}Commit message cannot be empty.${NC}"
    
    show_alert_dialog "Empty Commit Message" "Commit message cannot be empty.\n\nPlease provide a descriptive commit message."
    
    exit 1
fi

# Get message length
MSG_LENGTH=${#CLEAN_MSG}

# Check minimum length (10 characters)
if [ "$MSG_LENGTH" -lt 10 ]; then
    echo -e "${RED}❌ COMMIT MESSAGE TOO SHORT${NC}"
    echo -e "${YELLOW}Commit message must be at least 10 characters long.${NC}"
    echo -e "${YELLOW}Current message: '$CLEAN_MSG' ($MSG_LENGTH characters)${NC}"
    echo ""
    echo -e "${BLUE}📋 Commit Message Rules:${NC}"
    echo -e "• ${GREEN}Minimum 10 characters${NC}"
    echo -e "• ${GREEN}Start with capital letter${NC}"
    echo -e "• ${GREEN}Use present tense (e.g., 'Add feature' not 'Added feature')${NC}"
    echo -e "• ${GREEN}Be descriptive and clear${NC}"
    echo -e "• ${GREEN}Use imperative mood${NC}"
    echo ""
    echo -e "${BLUE}✅ Good examples:${NC}"
    echo -e "• ${GREEN}Add user authentication system${NC}"
    echo -e "• ${GREEN}Fix memory leak in data processor${NC}"
    echo -e "• ${GREEN}Update API documentation${NC}"
    echo -e "• ${GREEN}Refactor database connection logic${NC}"
    
    show_alert_dialog "Commit Message Too Short" "Commit message must be at least 10 characters long.\n\nRules:\n• Minimum 10 characters\n• Start with capital letter\n• Use present tense\n• Be descriptive\n\nCurrent: '$CLEAN_MSG' ($MSG_LENGTH chars)"
    
    exit 1
fi

# Check maximum length (72 characters for first line)
if [ "$MSG_LENGTH" -gt 72 ]; then
    echo -e "${YELLOW}⚠️  COMMIT MESSAGE WARNING${NC}"
    echo -e "${YELLOW}First line is longer than 72 characters ($MSG_LENGTH characters).${NC}"
    echo -e "${YELLOW}Consider keeping the first line under 72 characters for better readability.${NC}"
    echo -e "${YELLOW}Current message: '$CLEAN_MSG'${NC}"
    echo ""
    echo -e "${BLUE}💡 Tip: Use additional lines for detailed explanation${NC}"
fi

# Check if message starts with capital letter
FIRST_CHAR=$(echo "$CLEAN_MSG" | cut -c1)
if [[ ! "$FIRST_CHAR" =~ [A-Z] ]]; then
    echo -e "${RED}❌ COMMIT MESSAGE FORMAT ERROR${NC}"
    echo -e "${YELLOW}Commit message must start with a capital letter.${NC}"
    echo -e "${YELLOW}Current message: '$CLEAN_MSG'${NC}"
    echo -e "${YELLOW}First character: '$FIRST_CHAR'${NC}"
    
    show_alert_dialog "Invalid Message Format" "Commit message must start with a capital letter.\n\nCurrent: '$CLEAN_MSG'"
    
    exit 1
fi

# Check for common anti-patterns
if echo "$CLEAN_MSG" | grep -q "^wip\|^WIP\|^temp\|^TEMP\|^tmp\|^TMP"; then
    echo -e "${YELLOW}⚠️  TEMPORARY COMMIT DETECTED${NC}"
    echo -e "${YELLOW}This appears to be a temporary/work-in-progress commit.${NC}"
    echo -e "${YELLOW}Consider using a more descriptive message.${NC}"
    echo -e "${YELLOW}Current message: '$CLEAN_MSG'${NC}"
fi

# Check for ending punctuation (should not end with period for subject line)
if echo "$CLEAN_MSG" | grep -q "\.$"; then
    echo -e "${YELLOW}⚠️  COMMIT MESSAGE STYLE${NC}"
    echo -e "${YELLOW}Subject line should not end with a period.${NC}"
    echo -e "${YELLOW}Current message: '$CLEAN_MSG'${NC}"
fi

# Check for past tense (common mistakes)
if echo "$CLEAN_MSG" | grep -qi "added\|fixed\|updated\|changed\|removed\|deleted\|created"; then
    echo -e "${YELLOW}⚠️  COMMIT MESSAGE TENSE${NC}"
    echo -e "${YELLOW}Consider using present tense/imperative mood.${NC}"
    echo -e "${YELLOW}Use 'Add' instead of 'Added', 'Fix' instead of 'Fixed', etc.${NC}"
    echo -e "${YELLOW}Current message: '$CLEAN_MSG'${NC}"
fi

echo -e "${GREEN}✅ Commit message validation passed${NC}"
echo -e "${GREEN}Message: '$CLEAN_MSG' ($MSG_LENGTH characters)${NC}"
exit 0