# Cursor Rules Collection

A curated collection of reusable Cursor rules (`.mdc` files) for different programming languages, frameworks, and development practices. Use these rules to enhance your AI-assisted coding experience across multiple projects.

## 📚 What are Cursor Rules?

Cursor rules are configuration files that guide Cursor AI's code suggestions and completions. They help maintain consistency, follow best practices, and enforce project-specific conventions.

## 🗂️ Repository Structure

```
rules/
├── template.mdc              # Template for creating new rules
├── general/                  # General-purpose rules
│   └── clean-code.mdc       # Clean code principles
├── languages/                # Language-specific rules
│   ├── python.mdc           # Python development rules
│   └── javascript.mdc       # JavaScript/TypeScript rules
└── frameworks/               # Framework-specific rules
    └── react.mdc            # React development rules
```

## 🚀 How to Use

### Option 1: Copy Individual Rules
1. Browse the `rules/` directory
2. Find the rule file that matches your needs
3. Copy the content to your project's `.cursorrules` file
4. Or copy to `.cursor/rules/[name].mdc` in your project
5. Restart Cursor or reload the workspace

### Option 2: Clone the Entire Repository
```bash
git clone https://github.com/DeerHide/cursor-rules.git
cd cursor-rules
```

Then reference the rules you need from this central location.

### Option 3: Use as Git Submodule
```bash
# In your project directory
git submodule add https://github.com/DeerHide/cursor-rules.git .cursor-rules
```

Then symlink or copy specific rules to your project.

## 📝 Available Rules

### General
- **clean-code.mdc** - Universal clean code principles for any language

### Languages
- **python.mdc** - Python best practices (PEP 8, type hints, modern Python)
- **javascript.mdc** - JavaScript/TypeScript modern development practices

### Frameworks
- **react.mdc** - React development with hooks and modern patterns

## 🤝 Contributing

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

## 📖 Creating Your Own Rules

Use the `rules/template.mdc` as a starting point:

```bash
cp rules/template.mdc rules/[category]/[your-rule].mdc
```

Then customize it for your specific needs.

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🔗 Related Resources

- [Cursor Documentation](https://cursor.sh/docs)
- [Cursor AI](https://cursor.sh)

## ⭐ Star This Repo

If you find these rules helpful, please star this repository to help others discover it!

---

**Note**: These rules are community-driven and may need customization for your specific project requirements.
