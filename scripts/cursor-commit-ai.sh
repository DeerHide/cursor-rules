#!/bin/bash
#
# Cursor Commit AI - Advanced version using Cursor's AI capabilities
# This script opens Cursor with the git diff and prompts for commit message generation
#
# Usage: ./scripts/cursor-commit-ai.sh
#

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

# Check if there are staged changes
if git diff --quiet --cached; then
    echo "No staged changes. Staging all changes..."
    git add -A
fi

# Get the diff
DIFF_STAT=$(git diff --cached --stat)
DIFF_CONTENT=$(git diff --cached)

if [ -z "$DIFF_STAT" ] && [ -z "$DIFF_CONTENT" ]; then
    echo "No changes to commit."
    exit 0
fi

# Create a temporary file with the prompt
TEMP_FILE=$(mktemp)
cat > "$TEMP_FILE" <<EOF
# Generate Git Commit Message

## Staged Changes
\`\`\`
$DIFF_STAT
\`\`\`

## Full Diff
\`\`\`
$DIFF_CONTENT
\`\`\`

## Task
Generate a conventional commit message following this format:
- Format: \`<type>(<scope>): <description>\`
- Types: feat, fix, docs, refactor, test, chore
- Keep description under 50 characters
- Use imperative mood (e.g., "add" not "added")
- Be concise and descriptive

## Output
Provide ONLY the commit message, no explanations or markdown formatting.
EOF

# Check if Cursor CLI is available
CURSOR_CLI=$(which cursor 2>/dev/null || echo "")

if [ -z "$CURSOR_CLI" ]; then
    # Try common Cursor installation paths
    if [ -d "$HOME/.cursor-server/bin" ]; then
        CURSOR_CLI=$(find "$HOME/.cursor-server/bin" -name cursor -type f -path "*/remote-cli/cursor" 2>/dev/null | head -1)
    fi
fi

if [ -z "$CURSOR_CLI" ]; then
    echo "Error: Cursor CLI not found."
    echo "Please install Cursor IDE or use the fallback script: ./scripts/cursor-commit.sh"
    exit 1
fi

echo "Opening commit message prompt in current Cursor window..."
echo "The file contains a prompt for generating a commit message."
echo "Use Cursor's Composer (Cmd/Ctrl+I) to generate the message, then:"
echo "1. Copy the generated message"
echo "2. Close the file"
echo "3. Run: git commit -m 'your message here'"
echo ""
read -p "Press Enter to open in Cursor..."

# Open the file in the current Cursor window (reuse existing window)
"$CURSOR_CLI" --reuse-window "$TEMP_FILE" --wait

# Ask if user wants to commit now
echo ""
read -p "Do you want to commit now? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter commit message: " COMMIT_MSG
    if [ -n "$COMMIT_MSG" ]; then
        git commit -m "$COMMIT_MSG"
    else
        echo "No commit message provided. Aborting."
    fi
fi

# Clean up
rm -f "$TEMP_FILE"

