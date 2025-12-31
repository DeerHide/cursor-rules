# Contributing to Cursor Rules Collection

Thank you for your interest in contributing! This document provides guidelines for contributing cursor rules to this repository.

## 🎯 What to Contribute

We welcome cursor rules for:
- **Programming languages** (Python, JavaScript, Go, Rust, etc.)
- **Frameworks** (React, Vue, Django, FastAPI, etc.)
- **Development practices** (Testing, Security, Documentation, etc.)
- **Tools and platforms** (Docker, Kubernetes, CI/CD, etc.)
- **Coding standards** (Clean code, design patterns, etc.)

## 📋 Before You Start

1. **Check existing rules** - Browse the `rules/` directory to avoid duplicates
2. **Use the template** - Start with `rules/template.mdc` for consistency
3. **Be specific** - Focus on practical, actionable guidance
4. **Test your rules** - Verify they work in Cursor before submitting

## 🚀 How to Contribute

### 1. Fork and Clone
```bash
# Fork the repository on GitHub
git clone https://github.com/YOUR_USERNAME/cursor-rules.git
cd cursor-rules
```

### 2. Create a Branch
```bash
git checkout -b add-[language/framework]-rules
```

### 3. Add Your Rule File

Create your `.mdc` file in the appropriate directory:
- `rules/languages/` - For language-specific rules
- `rules/frameworks/` - For framework-specific rules
- `rules/general/` - For general development practices
- `rules/tools/` - For tools and platforms (create if needed)

### 4. Follow the Template Structure

Your `.mdc` file should include:

```markdown
# [Rule Name]

## Description
Brief description of what this cursor rule does and when to use it.

## Usage
1. Copy this file to your project's `.cursorrules` or `.cursor/rules/` directory
2. Customize the rules below based on your project needs
3. Restart Cursor or reload the workspace

## Rules

```
[Your cursor rules here - specific, actionable guidance]
```

## Notes
- Add any additional context
- List dependencies or requirements
- Mention known limitations
```

### 5. Test Your Rules

1. Copy your rule file to a test project
2. Restart Cursor
3. Verify the rules work as expected
4. Check for any conflicts or issues

### 6. Update Documentation

If you're adding a new category or significant rule:
1. Update the README.md to list your new rule
2. Keep the structure consistent

### 7. Submit a Pull Request

```bash
git add rules/[category]/[your-rule].mdc
git commit -m "Add [language/framework] cursor rules"
git push origin add-[language/framework]-rules
```

Then create a pull request on GitHub with:
- **Clear title**: "Add [Language/Framework] cursor rules"
- **Description**: What the rules cover and why they're useful
- **Testing notes**: How you tested the rules

## ✅ Quality Guidelines

### Content
- **Be concise** - Focus on the most important practices
- **Be specific** - Provide actionable guidance, not vague principles
- **Be practical** - Include real-world examples and use cases
- **Be current** - Use modern, up-to-date practices

### Formatting
- Use clear, consistent markdown formatting
- Follow the template structure
- Use proper grammar and spelling
- Include code examples where helpful

### Organization
- One rule file per language/framework/topic
- Place files in the correct category directory
- Use descriptive, lowercase-with-hyphens filenames
- Keep related rules together

## 🔍 Review Process

1. **Automated checks** - Basic validation of file structure
2. **Manual review** - Maintainers review for quality and relevance
3. **Feedback** - You may be asked to make changes
4. **Merge** - Once approved, your contribution will be merged

## 💡 Tips for Great Contributions

- **Start small** - One well-crafted rule is better than many incomplete ones
- **Be opinionated** - It's okay to recommend specific approaches
- **Explain why** - Help users understand the reasoning behind rules
- **Include examples** - Show what good code looks like
- **Consider conflicts** - Note any conflicts with other common practices
- **Link to resources** - Reference official documentation or style guides

## ❓ Questions?

If you have questions or need help:
1. Check existing issues on GitHub
2. Open a new issue with your question
3. Tag it as "question"

## 📜 Code of Conduct

- Be respectful and constructive
- Focus on what's best for the community
- Accept feedback gracefully
- Help others when you can

## 🙏 Thank You!

Every contribution makes this collection more valuable for the community. Thank you for taking the time to contribute!

---

**Remember**: The goal is to help developers write better code with AI assistance. Keep rules practical, tested, and useful!