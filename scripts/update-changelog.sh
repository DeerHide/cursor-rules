#!/bin/bash
#
# Update CHANGELOG.md based on commit message
# Parses conventional commit format and adds entry to [Unreleased] section
#
# Usage: ./scripts/update-changelog.sh "<commit message>"
#

set -e

COMMIT_MSG="$1"
CHANGELOG_FILE="CHANGELOG.md"

if [ -z "$COMMIT_MSG" ]; then
    echo "Error: Commit message required" >&2
    exit 1
fi

if [ ! -f "$CHANGELOG_FILE" ]; then
    echo "Warning: CHANGELOG.md not found. Skipping update." >&2
    exit 0
fi

# Parse conventional commit message: <type>(<scope>): <description>
# Examples:
#   feat(auth): add JWT token refresh
#   fix(api): resolve null pointer
#   docs(readme): update installation

COMMIT_TYPE=""
SCOPE=""
DESCRIPTION=""

# Extract type, scope, and description using regex
if echo "$COMMIT_MSG" | grep -qE '^(feat|fix|docs|refactor|test|chore)(\([^)]+\))?:'; then
    # Extract type
    COMMIT_TYPE=$(echo "$COMMIT_MSG" | sed -E 's/^([^(:]+).*/\1/')
    
    # Extract scope (if present)
    if echo "$COMMIT_MSG" | grep -qE '^[^(]+\([^)]+\)'; then
        SCOPE=$(echo "$COMMIT_MSG" | sed -E 's/^[^(]+\(([^)]+)\).*/\1/')
    fi
    
    # Extract description (everything after ": ")
    DESCRIPTION=$(echo "$COMMIT_MSG" | sed -E 's/^[^(]+(\([^)]+\))?:\s*//')
else
    # Not a conventional commit, skip
    exit 0
fi

# Map commit types to changelog sections
case "$COMMIT_TYPE" in
    feat)
        SECTION="Added"
        ;;
    fix)
        SECTION="Fixed"
        ;;
    docs)
        SECTION="Changed"
        PREFIX="Documentation: "
        ;;
    refactor)
        SECTION="Changed"
        PREFIX="Refactored: "
        ;;
    test)
        SECTION="Changed"
        PREFIX="Tests: "
        ;;
    chore)
        # Skip chore commits in changelog (usually not user-facing)
        exit 0
        ;;
    *)
        # Unknown type, skip
        exit 0
        ;;
esac

# Format the changelog entry
if [ -n "$SCOPE" ]; then
    ENTRY="- ${SCOPE}: ${DESCRIPTION}"
else
    ENTRY="- ${DESCRIPTION}"
fi

# Add prefix if set (for docs, refactor, test)
if [ -n "$PREFIX" ]; then
    ENTRY="- ${PREFIX}${DESCRIPTION}"
fi

# Update CHANGELOG.md using Python for better text manipulation
python3 <<PYTHON
import re
import sys

changelog_file = "$CHANGELOG_FILE"
section = "$SECTION"
entry = """$ENTRY"""

try:
    with open(changelog_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find the [Unreleased] section
    unreleased_pattern = r'(## \[Unreleased\]\s*\n)'
    match = re.search(unreleased_pattern, content)
    
    if not match:
        # If [Unreleased] section doesn't exist, add it
        content = f"## [Unreleased]\n\n### {section}\n{entry}\n\n{content}"
    else:
        # Find the section within [Unreleased]
        unreleased_start = match.end()
        
        # Look for the section header (### Added, ### Changed, etc.)
        section_pattern = rf'(### {re.escape(section)}\s*\n)'
        section_match = re.search(section_pattern, content[unreleased_start:])
        
        if section_match:
            # Section exists, add entry at the beginning
            section_start = unreleased_start + section_match.end()
            content = (
                content[:section_start] +
                entry + "\n" +
                content[section_start:]
            )
        else:
            # Section doesn't exist, add it after [Unreleased]
            # Find the next section or end of [Unreleased] block
            next_section = re.search(r'\n## \[', content[unreleased_start:])
            if next_section:
                insert_pos = unreleased_start + next_section.start()
                content = (
                    content[:insert_pos] +
                    f"\n### {section}\n{entry}\n" +
                    content[insert_pos:]
                )
            else:
                # No next section, add at end
                content = (
                    content[:unreleased_start] +
                    f"\n### {section}\n{entry}\n" +
                    content[unreleased_start:]
                )
    
    # Write back
    with open(changelog_file, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"Updated CHANGELOG.md: Added to {section} section")
    
except Exception as e:
    print(f"Error updating CHANGELOG.md: {e}", file=sys.stderr)
    sys.exit(1)
PYTHON

exit 0

