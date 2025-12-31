# Contributing to Cursor Rules

Thank you for your interest in contributing to this cursor rules repository! This document provides guidelines for adding new rules or improving existing ones.

## Table of Contents

- [Getting Started](#getting-started)
- [Rule File Format](#rule-file-format)
- [Adding New Rules](#adding-new-rules)
- [Improving Existing Rules](#improving-existing-rules)
- [Pull Request Process](#pull-request-process)
- [Code of Conduct](#code-of-conduct)

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/cursor-rules.git
   cd cursor-rules
   ```
3. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Rule File Format

### File Structure

All rule files use the `.mdc` (Markdown Cursor) format with YAML frontmatter:

```markdown
---
alwaysApply: true
description: "Brief description of what this rule covers"
tags: ["tag1", "tag2"]
version: "1.0.0"
---

# Rule Title

Rule content in Markdown format...
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `alwaysApply` | Yes | `true` = always active, `false` = manual reference |
| `description` | Yes | One-line description (< 100 chars) |
| `tags` | Yes | Array of relevant tags for categorization |
| `version` | Yes | Semantic version (MAJOR.MINOR.PATCH) |

### Content Guidelines

1. **Use Clear Headers**: Organize content with proper heading hierarchy (H1 for title, H2 for sections)

2. **Include Code Examples**: Always provide copy-paste ready code snippets
   ```python
   # Include necessary imports
   from typing import Annotated
   
   # Show complete, working examples
   def example_function(param: str) -> str:
       return param.upper()
   ```

3. **Use Tables for Comparisons**: When comparing options or listing items
   | Option | Use Case |
   |--------|----------|
   | A | Description of A |
   | B | Description of B |

4. **Mark Good/Bad Practices**: Use clear indicators
   ```python
   # ✅ Good
   def typed_function(x: int) -> int:
       return x * 2
   
   # ❌ Bad
   def untyped_function(x):
       return x * 2
   ```

## Adding New Rules

### Step 1: Choose the Right Directory

- `src/software/` - Language-agnostic principles
- `src/python/` - Python-specific patterns
- Create new directories for other languages (e.g., `src/typescript/`)

### Step 2: Create the Rule File

```bash
# Example: Adding a new Python rule
touch src/python/my-new-rule.mdc
```

### Step 3: Write the Content

Follow the [Rule File Format](#rule-file-format) guidelines above.

### Step 4: Update Documentation

1. Add the rule to the README.md table
2. Update the CHANGELOG.md

### Step 5: Test Your Rule

1. Copy the rule to a test project's `.cursor/rules/` directory
2. Verify Cursor recognizes and applies the rule
3. Test that code examples work correctly

## Improving Existing Rules

### Types of Improvements

1. **Bug Fixes**: Correct errors in code examples
2. **Clarifications**: Improve unclear explanations
3. **Additions**: Add missing patterns or examples
4. **Updates**: Reflect changes in tools/frameworks

### Version Bumping

- **Patch** (1.0.x): Bug fixes, typos, minor clarifications
- **Minor** (1.x.0): New sections, significant additions
- **Major** (x.0.0): Breaking changes, major restructuring

## Pull Request Process

### Before Submitting

- [ ] Rule follows the file format guidelines
- [ ] All code examples are complete and tested
- [ ] README.md is updated (if adding new rules)
- [ ] CHANGELOG.md is updated
- [ ] Version number is bumped appropriately

### PR Title Format

Use conventional commit format:

```
feat(python): add database migration patterns
fix(software): correct testing pyramid percentages
docs(readme): update installation instructions
```

### PR Description Template

```markdown
## Description
Brief description of changes.

## Type of Change
- [ ] New rule
- [ ] Bug fix
- [ ] Improvement to existing rule
- [ ] Documentation update

## Checklist
- [ ] Code examples tested
- [ ] README updated
- [ ] CHANGELOG updated
- [ ] Version bumped
```

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the content, not the person
- Accept feedback graciously

### Reporting Issues

If you encounter behavior that violates these standards, please open an issue or contact the maintainers.

## Questions?

If you have questions about contributing, please open an issue with the `question` label.

---

Thank you for contributing to make this repository better for everyone!


