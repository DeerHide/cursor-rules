# Cursor Commit Message Setup

This project includes scripts to automatically generate git commit messages using Cursor AI.

## Quick Start

### Method 1: Automatic (Recommended)

The git hook is already installed. Just commit normally:

```bash
git add .
git commit
# Commit message will be auto-generated and pre-filled
# You can edit it before saving
```

### Method 2: Interactive Script

Use the wrapper script for more control:

```bash
./scripts/cursor-commit.sh
```

This will:
- Show you the generated message
- Ask if you want to use, edit, or write your own

### Method 3: Cursor AI Integration

For full Cursor AI integration:

```bash
./scripts/cursor-commit-ai.sh
```

This opens Cursor with a prompt file where you can use Composer (Cmd/Ctrl+I) to generate the commit message with AI.

## Git Aliases (Optional)

Add these to your `~/.gitconfig` for convenience:

```bash
git config --global alias.cc '!f() { cd "$(git rev-parse --show-toplevel)" && ./scripts/cursor-commit.sh "$@"; }; f'
git config --global alias.ccai '!f() { cd "$(git rev-parse --show-toplevel)" && ./scripts/cursor-commit-ai.sh; }; f'
```

Then use:
```bash
git cc          # Interactive commit with auto-generated message
git ccai        # Open Cursor for AI-generated message
```

## How It Works

1. **Git Hook** (`.git/hooks/prepare-commit-msg`):
   - Automatically runs on `git commit`
   - Generates commit message from staged changes
   - Pre-fills the commit message editor

2. **Generation Script** (`scripts/generate-commit-message.sh`):
   - Analyzes `git diff --cached`
   - Determines commit type and scope
   - Generates conventional commit message

3. **Wrapper Scripts**:
   - `cursor-commit.sh`: Interactive wrapper with confirmation
   - `cursor-commit-ai.sh`: Opens Cursor for AI-assisted generation

## CHANGELOG.md Auto-Update

The commit process automatically updates `CHANGELOG.md` based on your commit messages:

- **Conventional commits** are parsed and added to the `[Unreleased]` section
- **Commit types** map to changelog sections:
  - `feat` → **Added** section
  - `fix` → **Fixed** section
  - `docs` → **Changed** section (with "Documentation: " prefix)
  - `refactor` → **Changed** section (with "Refactored: " prefix)
  - `test` → **Changed** section (with "Tests: " prefix)
  - `chore` → Skipped (not added to changelog)

**How it works:**
1. User stages their changes
2. User runs `git cc` (or `./scripts/cursor-commit.sh`)
3. Script generates a tentative commit message
4. CHANGELOG.md is updated based on the message
5. CHANGELOG.md is automatically staged
6. User reviews/edits the commit message
7. If message is edited, CHANGELOG.md is updated again
8. Commit is made with both changes and CHANGELOG.md

Only conventional commit format is processed.

**Example:**
```bash
# Commit: "feat(auth): add JWT token refresh endpoint"
# CHANGELOG.md gets:
# ### Added
# - auth: add JWT token refresh endpoint
```

## Commit Message Format

Follows [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `chore`: Build, config, dependencies

**Examples:**
- `feat(auth): add JWT token refresh endpoint`
- `fix(api): resolve null pointer exception`
- `docs(readme): update installation instructions`
- `test(utils): add unit tests for validation`

## Disabling Auto-Generation

To disable the automatic hook:

```bash
# Remove the hook
rm .git/hooks/prepare-commit-msg

# Or disable temporarily
chmod -x .git/hooks/prepare-commit-msg
```

## Troubleshooting

**Hook not working:**
```bash
# Make sure it's executable
chmod +x .git/hooks/prepare-commit-msg
chmod +x scripts/generate-commit-message.sh
```

**Python not found:**
```bash
# Install Python 3 (if missing)
sudo apt-get install python3  # Ubuntu/Debian
brew install python3          # macOS
```

**No message generated:**
- Ensure you have staged changes: `git diff --cached`
- The hook only runs for new commits (not --amend or merges)

## Advanced: Using Cursor Composer Directly

1. Stage your changes:
   ```bash
   git add .
   ```

2. Get the diff:
   ```bash
   git diff --cached > /tmp/commit-diff.txt
   ```

3. Open in Cursor:
   ```bash
   cursor /tmp/commit-diff.txt
   ```

4. Use Composer (Cmd/Ctrl+I) with prompt:
   ```
   Generate a conventional commit message for these changes. 
   Format: <type>(<scope>): <description>
   ```

5. Copy the generated message and commit:
   ```bash
   git commit -m "your generated message"
   ```

