# Contributing to Agent Skills

Thanks for your interest in contributing to Agent Skills! Here's how to get started.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/codebase-analysis.git`
3. Create a branch for your changes: `git checkout -b feature/your-feature-name`

## Development Workflow

### Adding a New Skill

1. Create a new skill file: `packages/analysis-agent/skills/my-new-skill/SKILL.md`
2. Follow the SKILL.md format:
```markdown
---
name: my-new-skill
description: What this skill does
compatibility: Requirements (e.g., pnpm, Node 20+)
user-invokable: true
argument-hint: "usage hint"
metadata:
  author: your-name
  version: "1.0"
---
```

3. Test in a sample project

### Adding a New Agent

1. Create a new agent file: `packages/analysis-agent/agents/my-new-agent.md`
2. Reference the skills it uses
3. Update `.github/copilot.json` if applicable

### Code Style

- Follow the existing structure
- Use clear, descriptive names
- Document all public-facing files

## Submitting Changes

1. Commit your changes: `git commit -m "Add feature: describe your change"`
2. Push to your fork: `git push origin feature/your-feature-name`
3. Open a pull request

## Questions?

Open an issue or reach out to the maintainers.
