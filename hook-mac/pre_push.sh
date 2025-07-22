#!/bin/bash

# Git Hook: pre-push
# Platform: macOS/Linux
# Purpose: Prevent pushes to main and develop branches, detect force pushes and rebases

set -e

# Colors for terminal output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
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

# Check for force push by examining command line arguments
if echo "$@" | grep -q "\-\-force\|--force-with-lease\|-f"; then
    echo -e "${RED}❌ FORCE PUSH BLOCKED${NC}"
    echo -e "${YELLOW}Force push detected and blocked for repository safety.${NC}"
    echo -e "${YELLOW}Force pushes can overwrite history and cause data loss.${NC}"
    echo ""
    echo -e "${GREEN}Safer alternatives:${NC}"
    echo -e "1. Resolve conflicts properly: ${GREEN}git pull --rebase${NC}"
    echo -e "2. Create a new branch if needed"
    echo -e "3. Coordinate with your team before force pushing"
    echo -e "4. If absolutely necessary, use: ${GREEN}git push --force-with-lease${NC}"
    
    show_alert_dialog "Force Push Blocked" "Force push detected and blocked for repository safety.\n\nForce pushes can overwrite history and cause data loss.\n\nSafer alternatives:\n1. Resolve conflicts properly\n2. Create a new branch if needed\n3. Coordinate with your team"
    
    exit 1
fi

# Read push information from stdin
while read local_ref local_sha remote_ref remote_sha; do
    # Extract branch name from remote ref
    if [[ "$remote_ref" =~ refs/heads/(.*) ]]; then
        remote_branch="${BASH_REMATCH[1]}"
    else
        continue
    fi
    
    # Check if pushing to protected branches
    if [[ "$remote_branch" == "main" || "$remote_branch" == "master" ]]; then
        echo -e "${RED}❌ PUSH TO MAIN BRANCH BLOCKED${NC}"
        echo -e "${YELLOW}You are trying to push directly to the '$remote_branch' branch.${NC}"
        echo -e "${YELLOW}This action is prohibited for code safety and review process.${NC}"
        echo ""
        echo -e "${GREEN}Recommended workflow:${NC}"
        echo -e "1. Push to a feature branch: ${GREEN}git push origin feature/your-feature${NC}"
        echo -e "2. Create a Pull Request for code review"
        echo -e "3. Merge through PR after approval"
        
        show_alert_dialog "Push to Main Branch Blocked" "You are trying to push directly to the '$remote_branch' branch.\n\nThis action is prohibited for code safety.\n\nPlease:\n1. Push to a feature branch\n2. Create a Pull Request\n3. Merge through PR after approval"
        
        exit 1
    fi
    
    if [[ "$remote_branch" == "develop" || "$remote_branch" == "dev" ]]; then
        echo -e "${RED}❌ PUSH TO DEVELOP BRANCH BLOCKED${NC}"
        echo -e "${YELLOW}You are trying to push directly to the '$remote_branch' branch.${NC}"
        echo -e "${YELLOW}This action is prohibited for development workflow integrity.${NC}"
        echo ""
        echo -e "${GREEN}Recommended workflow:${NC}"
        echo -e "1. Push to a feature branch: ${GREEN}git push origin feature/your-feature${NC}"
        echo -e "2. Create a Pull Request to merge into develop"
        echo -e "3. Merge through PR after review"
        
        show_alert_dialog "Push to Develop Branch Blocked" "You are trying to push directly to the '$remote_branch' branch.\n\nThis action is prohibited for development workflow.\n\nPlease:\n1. Push to a feature branch\n2. Create a Pull Request\n3. Merge through PR after review"
        
        exit 1
    fi
    
    # Check for potential rebase by examining commit history
    if [[ "$local_sha" != "0000000000000000000000000000000000000000" && "$remote_sha" != "0000000000000000000000000000000000000000" ]]; then
        # Check if this is a non-fast-forward push (potential rebase/force)
        merge_base=$(git merge-base "$local_sha" "$remote_sha" 2>/dev/null || echo "")
        if [[ -n "$merge_base" && "$merge_base" != "$remote_sha" ]]; then
            # This might be a rebase if the remote SHA is not an ancestor of local SHA
            if ! git merge-base --is-ancestor "$remote_sha" "$local_sha" 2>/dev/null; then
                echo -e "${RED}❌ POTENTIAL REBASE DETECTED${NC}"
                echo -e "${YELLOW}This push appears to contain rebased commits.${NC}"
                echo -e "${YELLOW}Rebasing can rewrite history and cause collaboration issues.${NC}"
                echo ""
                echo -e "${GREEN}Safer alternatives:${NC}"
                echo -e "1. Use merge commits: ${GREEN}git merge${NC}"
                echo -e "2. Create a new branch for rebased changes"
                echo -e "3. Coordinate with team before rebasing shared branches"
                
                show_alert_dialog "Potential Rebase Detected" "This push appears to contain rebased commits.\n\nRebasing can rewrite history and cause collaboration issues.\n\nSafer alternatives:\n1. Use merge commits\n2. Create a new branch\n3. Coordinate with team"
                
                exit 1
            fi
        fi
    fi
done

echo -e "${GREEN}✅ Pre-push checks passed${NC}"
exit 0