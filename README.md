# Cursor Rules

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A curated collection of reusable Cursor AI rules for software development projects. These rules provide consistent coding standards, architectural patterns, and best practices that can be easily integrated into any project using Cursor IDE.

## Overview

This repository contains `.mdc` (Markdown Cursor) rule files organized by category:

- **Software Rules**: Language-agnostic principles (architecture, testing fundamentals)
- **Python Rules**: Python-specific patterns (Clean Architecture with Pydantic, FastAPI, pytest)

## Available Rules

### Software (Language-Agnostic)

| Rule | Description |
|------|-------------|
| [architecture.mdc](src/software/architecture.mdc) | Dependency Injection principles and patterns |
| [testing.mdc](src/software/testing.mdc) | Testing pyramid, test organization, and best practices |

### Python

| Rule | Description |
|------|-------------|
| [python.mdc](src/python/python.mdc) | Project structure, tooling (Poetry, Ruff, Mypy), and conventions |
| [architecture.mdc](src/python/architecture.mdc) | Clean/Hexagonal Architecture with Pydantic models |
| [testing.mdc](src/python/testing.mdc) | pytest patterns, fixtures, and Clean Architecture testing |
| [fastapi_factory_utilities.mdc](src/python/fastapi_factory_utilities.mdc) | FastAPI Factory Utilities framework patterns |
| [error_handling.mdc](src/python/error_handling.mdc) | Exception patterns, custom exceptions, API error responses |
| [logging.mdc](src/python/logging.mdc) | Structured logging with structlog, correlation IDs |
| [security.mdc](src/python/security.mdc) | Input validation, secrets management, authentication |

## Installation

### Option 1: Copy Individual Rules

1. Browse the `src/` directory and find the rules you need
2. Copy the `.mdc` files to your project's `.cursor/rules/` directory
3. Cursor will automatically apply rules with `alwaysApply: true`

### Option 2: Git Submodule

```bash
# Add as a submodule
git submodule add https://github.com/DeerHide/cursor-rules.git .cursor/shared-rules

# Create symlinks to desired rules
ln -s ../shared-rules/src/python/architecture.mdc .cursor/rules/architecture.mdc
```

### Option 3: Direct Download

```bash
# Download a specific rule
curl -o .cursor/rules/python.mdc \
  https://raw.githubusercontent.com/DeerHide/cursor-rules/main/src/python/python.mdc
```

## Directory Structure

```
cursor-rules/
├── src/
│   ├── python/                    # Python-specific rules
│   │   ├── architecture.mdc       # Clean Architecture + Pydantic
│   │   ├── error_handling.mdc     # Exception patterns
│   │   ├── fastapi_factory_utilities.mdc  # FastAPI framework
│   │   ├── logging.mdc            # Structured logging
│   │   ├── python.mdc             # Core Python conventions
│   │   ├── security.mdc           # Security best practices
│   │   └── testing.mdc            # pytest best practices
│   └── software/                  # Language-agnostic rules
│       ├── architecture.mdc       # DI principles
│       └── testing.mdc            # Testing fundamentals
├── CHANGELOG.md                   # Version history
├── CONTRIBUTING.md                # Contribution guidelines
├── LICENSE                        # MIT License
└── README.md                      # This file
```

## Usage Guide

### Rule Frontmatter

Each rule file includes YAML frontmatter:

```yaml
---
alwaysApply: true
description: "Rule description"
tags: ["python", "architecture"]
version: "1.0.0"
---
```

- `alwaysApply: true` - Rule is always active in Cursor
- `alwaysApply: false` - Rule must be manually referenced

### Combining Rules

For a Python FastAPI project, you might use:

1. `src/software/architecture.mdc` - General DI principles
2. `src/software/testing.mdc` - Testing fundamentals
3. `src/python/python.mdc` - Python tooling and structure
4. `src/python/architecture.mdc` - Python-specific Clean Architecture
5. `src/python/testing.mdc` - pytest patterns
6. `src/python/fastapi_factory_utilities.mdc` - FastAPI patterns

### Rule Relationships

```
software/                          python/
├── architecture.mdc ─────────────► architecture.mdc
│   (DI principles)                 (Pydantic implementation)
│
└── testing.mdc ──────────────────► testing.mdc
    (Testing pyramid)               (pytest patterns)
```

The `software/` rules provide foundational concepts, while `python/` rules extend them with language-specific implementations.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:

- Adding new rules
- Rule file format and conventions
- Pull request process

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Cursor IDE](https://cursor.sh/) for the AI-powered development environment
- [FastAPI Factory Utilities](https://github.com/DeerHide/fastapi_factory_utilities) for the microservice framework
