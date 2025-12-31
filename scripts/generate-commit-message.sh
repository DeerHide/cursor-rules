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
from collections import Counter

# Decode diff stats and content
try:
    diff_stat = base64.b64decode("$DIFF_B64").decode('utf-8', errors='ignore')
    diff_content = base64.b64decode("$DIFF_CONTENT_B64").decode('utf-8', errors='ignore')
except:
    # Fallback if base64 decode fails
    diff_stat = ""
    diff_content = ""

# Analyze changes
files_changed = [line for line in diff_stat.split('\n') if line.strip() and '|' in line]
file_paths = [line.split()[0] for line in files_changed if line.split()[0]]
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

# Extract file information
def extract_file_info(file_paths):
    """Extract scope and context from file paths"""
    scopes = []
    file_types = []
    
    for path in file_paths:
        # Extract directory scope
        if '/' in path:
            parts = path.split('/')
            # Skip common prefixes
            if parts[0] not in ['src', 'lib', 'app', 'test', 'tests', 'spec', 'specs']:
                scopes.append(parts[0])
            elif len(parts) > 1:
                scopes.append(parts[1])
        
        # Extract file type
        if '.' in path:
            ext = path.split('.')[-1]
            if ext in ['py', 'ts', 'js', 'tsx', 'jsx', 'java', 'go', 'rs', 'rb']:
                file_types.append(ext)
    
    # Get most common scope
    scope = Counter(scopes).most_common(1)[0][0] if scopes else ""
    return scope, file_types

# Analyze code changes for context
def analyze_code_changes(diff_content):
    """Extract meaningful context from code changes"""
    context = {
        'functions_added': [],
        'functions_modified': [],
        'classes_added': [],
        'imports_added': [],
        'keywords': []
    }
    
    lines = diff_content.split('\n')
    current_file = ""
    
    for i, line in enumerate(lines):
        # Track file changes
        if line.startswith('+++ b/') or line.startswith('--- a/'):
            current_file = line.split('/')[-1] if '/' in line else ""
        
        # Detect new functions/methods
        if line.startswith('+') and not line.startswith('+++'):
            stripped = line[1:].strip()
            
            # Python functions
            if re.match(r'^\s*def\s+\w+', stripped):
                func_match = re.search(r'def\s+(\w+)', stripped)
                if func_match:
                    context['functions_added'].append(func_match.group(1))
            
            # Python classes
            if re.match(r'^\s*class\s+\w+', stripped):
                class_match = re.search(r'class\s+(\w+)', stripped)
                if class_match:
                    context['classes_added'].append(class_match.group(1))
            
            # JavaScript/TypeScript functions
            if re.match(r'^\s*(export\s+)?(async\s+)?function\s+\w+', stripped):
                func_match = re.search(r'function\s+(\w+)', stripped)
                if func_match:
                    context['functions_added'].append(func_match.group(1))
            
            # Arrow functions (const/let name = ...)
            if re.match(r'^\s*(export\s+)?(const|let)\s+\w+\s*=\s*(\([^)]*\)\s*)?=>', stripped):
                var_match = re.search(r'(const|let)\s+(\w+)', stripped)
                if var_match:
                    context['functions_added'].append(var_match.group(2))
            
            # Detect imports
            if re.match(r'^\s*import\s+', stripped) or re.match(r'^\s*from\s+', stripped):
                import_match = re.search(r'import\s+.*?\s+from\s+['"]([^'"]+)['"]', stripped)
                if not import_match:
                    import_match = re.search(r'from\s+['"]([^'"]+)['"]', stripped)
                if import_match:
                    context['imports_added'].append(import_match.group(1).split('/')[-1])
        
        # Detect modified functions (function name appears in both + and -)
        if line.startswith('+') and 'def ' in line:
            func_match = re.search(r'def\s+(\w+)', line)
            if func_match:
                func_name = func_match.group(1)
                # Check if this function was also removed
                for j, other_line in enumerate(lines[max(0, i-10):i+10]):
                    if other_line.startswith('-') and f'def {func_name}' in other_line:
                        if func_name not in context['functions_modified']:
                            context['functions_modified'].append(func_name)
                        break
    
    # Extract keywords from diff
    keywords = ['error', 'exception', 'fix', 'bug', 'test', 'validate', 'auth', 'security', 
                'config', 'setup', 'init', 'refactor', 'optimize', 'performance', 'api', 'endpoint']
    for keyword in keywords:
        if keyword in diff_content.lower():
            context['keywords'].append(keyword)
    
    return context

# Determine commit type
commit_type = "chore"
scope = ""
description_parts = []

# Analyze file patterns for type detection
test_files = any('test' in f.lower() or 'spec' in f.lower() for f in file_paths)
doc_files = any('.md' in f or 'docs' in f.lower() or 'readme' in f.lower() for f in file_paths)
config_files = any(f.endswith(('.json', '.yaml', '.yml', '.toml', '.ini', '.conf', '.env')) for f in file_paths)

if test_files:
    commit_type = "test"
elif doc_files:
    commit_type = "docs"
elif config_files:
    commit_type = "chore"
else:
    # Analyze code content
    code_context = analyze_code_changes(diff_content)
    
    # Check for bug fixes
    if any(kw in code_context['keywords'] for kw in ['error', 'exception', 'fix', 'bug']):
        commit_type = "fix"
    # Check for new features
    elif code_context['functions_added'] or code_context['classes_added']:
        commit_type = "feat"
    # Check for refactoring
    elif code_context['functions_modified'] or 'refactor' in code_context['keywords']:
        commit_type = "refactor"
    # Check content keywords
    elif any(word in diff_content.lower() for word in ['add', 'new', 'implement', 'create', 'feature']):
        commit_type = "feat"
    elif any(word in diff_content.lower() for word in ['refactor', 'restructure', 'reorganize', 'optimize']):
        commit_type = "refactor"

# Extract scope from file paths
scope, file_types = extract_file_info(file_paths)

# Build detailed description
code_context = analyze_code_changes(diff_content)

# Add function/class context
if code_context['functions_added']:
    funcs = code_context['functions_added'][:2]  # Limit to 2 most relevant
    if len(funcs) == 1:
        description_parts.append(f"add {funcs[0]} function")
    elif len(funcs) == 2:
        description_parts.append(f"add {funcs[0]} and {funcs[1]} functions")
    else:
        description_parts.append(f"add {len(code_context['functions_added'])} functions")

if code_context['classes_added']:
    classes = code_context['classes_added'][:1]
    if classes:
        description_parts.append(f"add {classes[0]} class")

if code_context['functions_modified']:
    funcs = code_context['functions_modified'][:1]
    if funcs:
        description_parts.append(f"update {funcs[0]} function")

# Add keyword-based context
if 'error' in code_context['keywords'] or 'exception' in code_context['keywords']:
    description_parts.append("error handling")
if 'validate' in code_context['keywords']:
    description_parts.append("validation")
if 'auth' in code_context['keywords'] or 'security' in code_context['keywords']:
    description_parts.append("authentication")
if 'api' in code_context['keywords'] or 'endpoint' in code_context['keywords']:
    description_parts.append("API")

# Add file-based context
if test_files:
    description_parts.append("test coverage")
elif doc_files:
    description_parts.append("documentation")
elif config_files:
    description_parts.append("configuration")

# Fallback descriptions based on change patterns
if not description_parts:
    if additions > deletions and additions > 20:
        description_parts.append("implement new functionality")
    elif deletions > additions and deletions > 20:
        description_parts.append("remove deprecated code")
    elif code_context['imports_added']:
        imports = code_context['imports_added'][:2]
        description_parts.append(f"integrate {', '.join(imports)}")
    else:
        description_parts.append("update implementation")

# Combine description parts
if len(description_parts) == 1:
    description = description_parts[0]
elif len(description_parts) == 2:
    description = f"{description_parts[0]} and {description_parts[1]}"
else:
    # Take the most relevant parts
    description = f"{description_parts[0]} and {description_parts[1]}"

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

