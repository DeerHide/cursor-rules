# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.3.0] - 2026-07-16

### Added
- BMM agent `product-content-writer` — end-user product presentation, guides, onboarding, FAQ, and help (pivoted from product-writer scaffolding); command, rule, index entry, customize stub, agent manifest, and default party team entry

### Changed
- `tech-writer` — principles and manifests hand off end-user product content to `product-content-writer`
- `documentation-standards.md` — notes both writer agents; Product Content Writer may override tone/audience
- Excalidraw core README — lists Product Content Writer for user-facing diagrams

## [1.2.0] - 2026-07-16

### Added
- Experimental basic scaffolding for C# / .NET rules under `_bmad/bmad-custom/csharp/` (mirrored in `_bmad/_config/custom/bmad-custom/csharp/`):
  - `csharp.mdc` - project layout, tooling, conventions, and `dotnet` CLI
  - `architecture.mdc` - Clean/Hexagonal Architecture with DI
  - `testing.mdc` - xUnit and NSubstitute patterns

### Changed
- `README.md` - mention C# alongside Python
- `CONTRIBUTING.md` - language packs now documented under `_bmad/bmad-custom/<lang>/`

## [1.1.0] - 2024-12-31

### Added
- New Python rule: `error_handling.mdc` - Exception patterns, custom exceptions, and API error responses
- New Python rule: `logging.mdc` - Structured logging with structlog, correlation IDs, and log levels
- New Python rule: `security.mdc` - Input validation, secrets management, authentication patterns
- `CONTRIBUTING.md` with guidelines for adding new rules
- Enhanced frontmatter for all rules with `description`, `tags`, and `version` fields

### Changed
- Updated `README.md` with comprehensive documentation:
  - Installation instructions (copy, submodule, direct download)
  - Complete rule catalog with descriptions
  - Directory structure explanation
  - Rule relationships diagram
  - Usage guide
- Updated `.cursor/rules/project.mdc` to include `software/` directory
- Standardized test directory naming to singular form (`unit/`, `integration/`) in `python.mdc`

### Fixed
- Added missing imports in `architecture.mdc`:
  - `ConfigDict` and `UUID` imports in Entity example
  - `ValueObject` imports in Email and UserName examples
- Added missing `ConfigDict` import in `fastapi_factory_utilities.mdc`
- Improved email validation comment to recommend `email-validator` package

## [1.0.0] - 2024-12-01

### Added
- Initial release with core cursor rules
- Python rules:
  - `architecture.mdc` - Clean/Hexagonal Architecture with Pydantic
  - `fastapi_factory_utilities.mdc` - FastAPI Factory Utilities framework
  - `python.mdc` - Core Python conventions
  - `testing.mdc` - pytest best practices
- Software rules:
  - `architecture.mdc` - Dependency Injection principles
  - `testing.mdc` - Testing fundamentals
- MIT License
- Basic README

[Unreleased]: https://github.com/DeerHide/cursor-rules/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/DeerHide/cursor-rules/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/DeerHide/cursor-rules/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/DeerHide/cursor-rules/releases/tag/v1.0.0


