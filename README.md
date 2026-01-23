# Cursor Configs

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A repository of Cursor IDE rules (`.mdc` files) for software development, including the BMAD (Build, Manage, Architect, Deploy) methodology framework with agents, workflows, and tasks, plus Python and general software engineering good practices.

## How to Use

### Option 1: Copy Individual Rules

1. Browse the `rules/` directory
2. Find the rule file that matches your needs
3. Copy the content to your project's `.cursorrules` file
4. Or copy to `.cursor/rules/[name].mdc` in your project
5. Restart Cursor or reload the workspace

### Option 2: Use as Git Submodule

```bash
# In your project directory
git submodule add https://github.com/DeerHide/cursor-rules.git .cursor-rules
```

## Contributing

Contributions are welcome! If you have cursor rules that would benefit others:

1. Fork this repository
2. Create a new `.mdc` file in the appropriate category
3. Follow the template structure (see `rules/template.mdc`)
4. Submit a pull request

### Guidelines

- Keep rules clear and concise
- Include practical examples
- Organize by category (language/framework/general)
- Add usage instructions
- Test your rules before submitting

## License

MIT License - see [LICENSE](LICENSE) file for details.

---
**Note**: These rules are community-driven and may need customization for your specific project requirements.
