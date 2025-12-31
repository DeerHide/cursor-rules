# Cursor Commit Message Generation

This directory contains scripts to automatically generate git commit messages using Cursor AI capabilities.

## Setup

### Option 1: Automatic (Git Hook)

The `prepare-commit-msg` git hook is already installed. It will automatically generate commit messages when you run:

```bash
git commit
```

The hook will:
- Analyze your staged changes
- Generate a conventional commit message
- Pre-fill the commit message (you can still edit it)

### Option 2: Manual (Wrapper Script)

Use the wrapper script for more control:

```bash
./scripts/cursor-commit.sh
```

This will:
1. Stage all changes (if nothing is staged)
2. Generate a commit message
3. Show you the message and ask for confirmation
4. Allow you to edit, accept, or write your own message

## How It Works

The `generate-commit-message.sh` script:

1. Analyzes `git diff --cached` to understand what changed
2. Determines the commit type (feat, fix, docs, test, refactor, chore)
3. Extracts scope from file paths
4. Generates a concise, conventional commit message

## Commit Message Format

Follows conventional commits format:
```
<type>(<scope>): <description>
```

Examples:
- `feat(auth): add JWT token refresh endpoint`
- `fix(api): resolve null pointer exception`
- `docs(readme): update installation instructions`
- `test(utils): add unit tests for validation`

## CHANGELOG.md Auto-Update

The commit scripts automatically update `CHANGELOG.md` based on your commit messages:

- **Conventional commits** are parsed and added to the appropriate section
- **Commit types** map to changelog sections:
  - `feat` → Added
  - `fix` → Fixed
  - `docs` → Changed (with "Documentation: " prefix)
  - `refactor` → Changed (with "Refactored: " prefix)
  - `test` → Changed (with "Tests: " prefix)
  - `chore` → Skipped (not added to changelog)

**How it works:**
1. User stages their changes
2. User runs `./scripts/cursor-commit.sh`
3. Script generates a tentative commit message
4. CHANGELOG.md is updated based on the message
5. CHANGELOG.md is automatically staged
6. User reviews/edits the commit message
7. If message is edited, CHANGELOG.md is updated again
8. Commit is made with both changes and CHANGELOG.md

**Example:**
```bash
# Commit message: "feat(auth): add JWT token refresh endpoint"
# CHANGELOG.md will be updated with:
# ### Added
# - auth: add JWT token refresh endpoint
```

## Customization

### Using Cursor AI Directly

To use Cursor's AI capabilities more directly, you can:

1. **Open Cursor with the diff**:
   ```bash
   git diff --cached | cursor -
   ```
   Then ask Cursor to generate a commit message.

2. **Create a custom script** that uses Cursor's chat API (if available):
   - Check Cursor's API documentation for chat endpoints
   - Modify `generate-commit-message.sh` to call the API

3. **Use Cursor's Composer**:
   - Stage your changes
   - Open Cursor
   - Use Composer (Cmd/Ctrl+I) with prompt: "Generate a conventional commit message for these changes: [paste git diff]"

## Disabling Auto-Generation

To disable automatic commit message generation:

```bash
# Remove the hook
rm .git/hooks/prepare-commit-msg

# Or rename it
mv .git/hooks/prepare-commit-msg .git/hooks/prepare-commit-msg.disabled
```

## Troubleshooting

### Hook not working
- Ensure the hook is executable: `chmod +x .git/hooks/prepare-commit-msg`
- Check that `scripts/generate-commit-message.sh` exists and is executable

### Python not found
- The script requires Python 3
- Install Python 3 if missing: `sudo apt-get install python3` (Ubuntu/Debian)

### Message not generated
- Check that you have staged changes: `git diff --cached`
- The script will exit silently if there are no changes

