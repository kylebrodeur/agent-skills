# Agent Skills

A collection of Claude Code agent skills and utilities. Currently includes tools for codebase analysis.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Compatible-4183C4)](https://claude.ai/code)

---

## Overview

This monorepo contains reusable **Claude Code skills** - predefined workflows and analysis tools that you can invoke via slash commands or automatically through agents.

### Current Skills

| Skill | Purpose |
|-------|---------|
| **Duplicate Detection** | Find copy-pasted code blocks using `jscpd` |
| **Dead Code Analysis** | Find unused exports, types, and dependencies using `knip` |
| **Architecture Validation** | Check import rules and circular dependencies using `dependency-cruiser` |
| **Analysis Orchestrator** | Run all tools and synthesize findings |

---

## Installation

### Clone and Setup

```bash
# Clone this repository
git clone https://github.com/YOUR_USERNAME/agent-skills.git
cd agent-skills

# Install dependencies
pnpm install
```

### Using in Another Project

1. Copy the skill files to your project:
```bash
cp -r packages/analysis-agent/.agent ../your-project/
```

2. Run setup in your project:
```bash
cd ../your-project
bash .agent/scripts/setup.sh
pnpm install
```

3. Use the skills:
```bash
pnpm analyze:all           # Run all analysis
pnpm analyze:deps:validate # Check architecture
pnpm analyze:dead          # Find dead code
pnpm analyze:dupes         # Find duplicates
```

---

## Claude Code Hooks

The setup script creates hooks that automatically run analysis tools:

- **PreToolUse** - Runs setup if needed before tool execution
- **PostToolUse** - Generates summary reports after analysis

---

## Agent Integration

The `codebase-analysis` agent can be added to your project:

```bash
# For Claude Code (.claude/agents/)
cp packages/analysis-agent/agents/codebase-analysis.md .claude/agents/

# For GitHub Copilot (.github/agents/)
cp packages/analysis-agent/agents/codebase-analysis.md .github/agents/
```

---

## Adding Your Own Skills

This monorepo uses pnpm workspaces. To add more skills:

1. Create a new package under `packages/`:
```bash
mkdir -p packages/my-new-skill
```

2. Create your skill file:
```bash
packages/my-new-skill/SKILL.md
```

3. Update workspace in root `package.json` if needed

---

## License

MIT
