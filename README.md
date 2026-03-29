# Agent Skills

A collection of Claude Code and GitHub Copilot agent skills for codebase analysis - find duplicate code, dead code, and architecture violations.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Compatible-4183C4)](https://claude.ai/code)
[![GitHub Copilot](https://img.shields.io/badge/GitHub_Copilot-Compatible-4183C4)](https://github.com/features/copilot)

---

## Overview

This monorepo contains reusable **Claude Code skills** and **GitHub Copilot agents** - predefined workflows and analysis tools that you can invoke via slash commands or automatically through agents.

### Current Skills

| Skill | Purpose |
|-------|---------|
| **Duplicate Detection** | Find copy-pasted code blocks using `jscpd` |
| **Dead Code Analysis** | Find unused exports, types, and dependencies using `knip` |
| **Architecture Validation** | Check import rules and circular dependencies using `dependency-cruiser` |
| **Analysis Orchestrator** | Run all tools and synthesize findings |

---

## Supported Projects

| Project Type | Entry Points | Notes |
|--------------|--------------|-------|
| **Node.js** | `src/index.ts`, `src/main.ts` | Service → Action → Handler patterns |
| **Next.js (App Router)** | `app/page.tsx`, `app/layout.tsx` | Files in `app/` are routing entry points |
| **Next.js (Pages Router)** | `pages/_app.tsx`, `pages/_document.tsx` | Legacy routing |
| **React Libraries** | `src/index.ts` | Component library patterns |
| **shadcn/ui** | - | Components in `components/ui/` are auto-generated |
| **Generic TS/JS** | - | Works with any structure |

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
- Automatically detects when config files are missing

---

## GitHub Copilot Integration

This agent works with GitHub Copilot:

1. Copy the agent file to your project:
```bash
cp packages/analysis-agent/agents/codebase-analysis.md .github/agents/
```

2. Configure Copilot to use the agent in `.github/copilot.json`:
```json
{
  "agents": [".github/agents/codebase-analysis.md"]
}
```

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

## Configuration Files

The setup script creates the following configuration files:

- `.jscpd.json` - Duplicate code detection settings
- `knip.json` - Dead code analysis settings
- `.dependency-cruiser.cjs` - Architecture validation rules

See the [templates](packages/analysis-agent/templates/) for examples.

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
