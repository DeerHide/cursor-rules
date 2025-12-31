#!/bin/bash
#
# Generate commit message using Cursor AI
# This script analyzes git diff and generates a conventional commit message
#

set -e

COMMIT_MSG_FILE="$1"
COMMIT_SOURCE="$2"
SHA1="$3"

# Only generate message if it's a new commit (not amend, merge, etc.)
if [ "$COMMIT_SOURCE" != "" ] && [ "$COMMIT_SOURCE" != "message" ]; then
    exit 0
fi

# Get the git diff for staged changes
DIFF=$(git diff --cached --stat)
DIFF_CONTENT=$(git diff --cached)

# If no staged changes, exit
if [ -z "$DIFF" ] && [ -z "$DIFF_CONTENT" ]; then
    exit 0
fi

# Check if Cursor CLI is available (optional - script works without it)
CURSOR_CLI=$(which cursor 2>/dev/null || echo "")

if [ -z "$CURSOR_CLI" ]; then
    # Try common Cursor installation paths
    if [ -d "$HOME/.cursor-server/bin" ]; then
        CURSOR_CLI=$(find "$HOME/.cursor-server/bin" -name cursor -type f -path "*/remote-cli/cursor" 2>/dev/null | head -1)
    fi
fi

# If Cursor is available and user wants to use it, we can use it
# For now, we'll use the heuristic-based approach which works without Cursor

# Note: To use Cursor AI in the current window, you can:
# 1. Use cursor-commit-ai.sh which opens a temp file in the current window
# 2. Or manually use Cursor's Composer with the git diff
# For now, we use a heuristic-based approach that works reliably

# For now, let's create a simple heuristic-based commit message generator
# You can enhance this to use Cursor's AI capabilities when available

# Safely pass diff content to Python using base64 encoding to avoid syntax errors
# Use tr to remove newlines for portability (works on both Linux and macOS)
DIFF_B64=$(echo "$DIFF" | base64 | tr -d '\n')
DIFF_CONTENT_B64=$(echo "$DIFF_CONTENT" | base64 | tr -d '\n')

COMMIT_MSG=$(python3 - <<PYTHON
import sys
import re
import subprocess
import base64

# Decode diff stats and content
try:
    diff_stat = base64.b64decode("$DIFF_B64").decode('utf-8', errors='ignore')
    diff_content = base64.b64decode("$DIFF_CONTENT_B64").decode('utf-8', errors='ignore')
except:
    # Fallback if base64 decode fails
    diff_stat = ""
    diff_content = ""

# Analyze changes
files_changed = len([line for line in diff_stat.split('\n') if line.strip() and '|' in line])
additions = 0
deletions = 0

for line in diff_stat.split('\n'):
    if '|' in line:
        match = re.search(r'(\d+)\s+\+', line)
        if match:
            additions += int(match.group(1))
        match = re.search(r'(\d+)\s+-', line)
        if match:
            deletions += int(match.group(1))

# Determine commit type and scope
commit_type = "chore"
scope = ""
description = ""

# Check file patterns
if any(f in diff_stat for f in ['test', 'spec', '__tests__']):
    commit_type = "test"
elif any(f in diff_stat for f in ['.md', 'docs/', 'README']):
    commit_type = "docs"
elif 'fix' in diff_content.lower() or 'bug' in diff_content.lower() or 'error' in diff_content.lower():
    commit_type = "fix"
elif any(word in diff_content.lower() for word in ['add', 'new', 'implement', 'create', 'feature']):
    commit_type = "feat"
elif any(word in diff_content.lower() for word in ['refactor', 'restructure', 'reorganize']):
    commit_type = "refactor"

# Extract scope from file paths
if diff_stat:
    first_file = diff_stat.split('\n')[0].split()[0] if diff_stat.split('\n')[0] else ""
    if '/' in first_file:
        scope = first_file.split('/')[0]
    elif '.' in first_file:
        scope = first_file.split('.')[-1] if first_file.split('.')[-1] in ['py', 'ts', 'js', 'tsx', 'jsx'] else ""

# Generate description
if additions > deletions and additions > 10:
    description = "add new functionality"
elif deletions > additions and deletions > 10:
    description = "remove unused code"
elif 'fix' in diff_content.lower():
    description = "fix issue"
elif 'test' in diff_stat.lower():
    description = "add tests"
elif 'docs' in diff_stat.lower():
    description = "update documentation"
else:
    description = "update code"

# Format commit message
if scope:
    msg = f"{commit_type}({scope}): {description}"
else:
    msg = f"{commit_type}: {description}"

print(msg)
PYTHON
)

# Write the generated message to the commit message file
echo "$COMMIT_MSG" > "$COMMIT_MSG_FILE"

exit 0

