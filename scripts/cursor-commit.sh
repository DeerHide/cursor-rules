#!/bin/bash
#
# Cursor Commit - Wrapper script to generate commit messages with Cursor AI
# Usage: ./scripts/cursor-commit.sh [git commit options]
#
# Workflow:
# 1. User stages their changes
# 2. Script generates a tentative commit message
# 3. CHANGELOG.md is updated based on the message
# 4. CHANGELOG.md is automatically staged
# 5. User reviews/edits the commit message
# 6. If message is edited, CHANGELOG.md is updated again
# 7. Commit is made with both changes and CHANGELOG.md
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

# Check if there are any changes to commit
if git diff --quiet --cached && git diff --quiet; then
    echo "No changes to commit."
    exit 0
fi

# Check for staged changes
if git diff --quiet --cached; then
    echo "No staged changes. Staging all changes..."
    git add -A
fi

# Generate commit message first (tentative)
TEMP_MSG=$(mktemp)
"$SCRIPT_DIR/generate-commit-message.sh" "$TEMP_MSG" "template" ""

if [ -f "$TEMP_MSG" ] && [ -s "$TEMP_MSG" ]; then
    GENERATED_MSG=$(cat "$TEMP_MSG")
    
    # Update CHANGELOG.md based on the generated message
    echo "Updating CHANGELOG.md..."
    "$SCRIPT_DIR/update-changelog.sh" "$GENERATED_MSG" || true
    
    # Stage CHANGELOG.md if it was modified
    if ! git diff --quiet "$PROJECT_ROOT/CHANGELOG.md" 2>/dev/null; then
        git add "$PROJECT_ROOT/CHANGELOG.md"
        echo "  ✓ CHANGELOG.md updated and staged"
    fi
    
    echo ""
    echo "Generated commit message:"
    echo "  $GENERATED_MSG"
    echo ""
    
    # Ask user if they want to use this message
    read -p "Use this message? (Y/n/e to edit): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Ee]$ ]]; then
        # Edit the message
        ${EDITOR:-nano} "$TEMP_MSG"
        FINAL_MSG=$(cat "$TEMP_MSG")
        
        # Update CHANGELOG.md again if message changed
        if [ "$FINAL_MSG" != "$GENERATED_MSG" ]; then
            echo "Updating CHANGELOG.md with edited message..."
            # Remove the previous entry and add the new one
            # For simplicity, we'll just update it (the script handles duplicates reasonably)
            "$SCRIPT_DIR/update-changelog.sh" "$FINAL_MSG" || true
            if ! git diff --quiet "$PROJECT_ROOT/CHANGELOG.md" 2>/dev/null; then
                git add "$PROJECT_ROOT/CHANGELOG.md"
            fi
        fi
        
        git commit -F "$TEMP_MSG" "$@"
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
        # User wants to write their own message
        # Unstage CHANGELOG.md since we don't know the final message
        if ! git diff --quiet --cached "$PROJECT_ROOT/CHANGELOG.md" 2>/dev/null; then
            # CHANGELOG was staged, unstage it
            git reset HEAD "$PROJECT_ROOT/CHANGELOG.md" 2>/dev/null || true
            echo "  ℹ CHANGELOG.md unstaged (you can update it manually if needed)"
        fi
        git commit "$@"
    else
        # Use the generated message
        git commit -m "$GENERATED_MSG" "$@"
    fi
else
    # Fallback to regular git commit
    echo "Could not generate commit message. Falling back to regular commit."
    git commit "$@"
fi

rm -f "$TEMP_MSG"

