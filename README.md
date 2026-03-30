# Agent Skills

A collection of Claude Code skills, skills.sh skills, and GitHub Copilot agents for codebase analysis - find duplicate code, dead code, and architecture violations.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Compatible-4183C4)](https://claude.ai/code)
[![GitHub Copilot](https://img.shields.io/badge/GitHub_Copilot-Compatible-4183C4)](https://github.com/features/copilot)
[![skills.sh](https://img.shields.io/badge/skills.sh-Compatible-4183C4)](https://skills.sh)
[![pnpm](https://img.shields.io/badge/pnpm-10.24.0-FFA500.svg)](https://pnpm.io)
[![Node.js](https://img.shields.io/badge/Node.js-20+-478C00.svg)](https://nodejs.org)

---

## Overview

This monorepo contains reusable **Claude Code skills**, **skills.sh** skills, and **GitHub Copilot agents** for codebase analysis. Each skill is a reusable workflow that can be invoked via slash commands or automatically through agents.

### What's Included

| Skill | Purpose |
|-------|---------|
| **Duplicate Detection** | Find copy-pasted code blocks using `jscpd` |
| **Dead Code Analysis** | Find unused exports, types, and dependencies using `knip` |
| **Architecture Validation** | Check import rules and circular dependencies using `dependency-cruiser` |
| **Analysis Orchestrator** | Run all tools and synthesize findings |

### Format Support

This repository supports both **Claude Code skills** and **skills.sh** specification:

| Feature | Claude Code | skills.sh |
|---------|-------------|-----------|
| Format | `SKILL.md` with YAML frontmatter | `SKILL.md` with YAML frontmatter |
| Location | `.agent/skills/` | `skills/` at project root |
| Non-standard fields | Supported (`user-invokable`, `argument-hint`) | Standard only (`name`, `description`, `compatibility`, `metadata`) |

### Example Output

**Duplicate Code Detection:**
```
Clone found (typescript):
 - src/services/itemService.ts [42:1 - 55:3] (13 lines, 98 tokens)
   src/services/orderService.ts [71:1 - 84:3]

Found 18 clones.
```

**Dead Code Analysis:**
```
Unused exports (3)
processItem         function  src/services/processor.ts:42:23
CONFIG              const     src/config/settings.ts:5:14
helperFn            function  src/utils/helpers.ts:18:17
```

---

## Quick Start

### Install via skills.sh CLI

```bash
npx skills add kylebrodeur/agent-skills
```

### Install Manually

```bash
git clone https://github.com/kylebrodeur/agent-skills.git
cd agent-skills
pnpm install
```

### Using in Your Project

1. Copy the agent folder to your project:
```bash
cp -r packages/analysis-agent/.agent ../your-project/
```

2. Run setup in your project:
```bash
cd ../your-project
bash .agent/scripts/setup.sh
pnpm install
```

3. Run analysis:
```bash
pnpm analyze:all           # Run all tools
pnpm analyze:deps:validate # Check architecture
pnpm analyze:dead          # Find dead code
pnpm analyze:dupes         # Find duplicates
```

---

## Claude Code vs skills.sh

| Feature | Claude Code | skills.sh |
|---------|-------------|-----------|
| **Location** | `.agent/skills/` in project | `skills/` at project root |
| **Format** | `SKILL.md` with YAML frontmatter | `SKILL.md` with YAML frontmatter |
| **Non-standard fields** | Supported (`user-invokable`, `argument-hint`) | Standard only (`name`, `description`, `compatibility`, `metadata`) |
| **Install** | Copy `.agent/` folder | `npx skills add owner/repo` |

Both versions contain the same content — use the one that matches your platform.

### Claude Code Skills

Located at `.agent/skills/` in your project. Supports full Claude Code skill format including non-standard extensions.

### skills.sh Format

Located at `skills/` at project root. Uses the standard skills.sh specification. Install via:

```bash
npx skills add kylebrodeur/agent-skills
```

## Supported Projects

---

## Configuration

The setup script creates these files in your project:

- `.jscpd.json` - Duplicate code detection
- `knip.json` - Dead code analysis
- `.dependency-cruiser.cjs` - Architecture validation

Each template includes project-specific defaults for Next.js, React, and Node.js.

---

## Claude Code Hooks

When you run the setup script, it creates a `PreToolUse` hook at `.claude/hooks/PreToolUse` that:

- Automatically runs setup if config files are missing
- Detects when tools need to be configured

---

## GitHub Copilot Integration

The agent works with GitHub Copilot. Copy the agent file to `.github/agents/`:

```bash
cp packages/analysis-agent/agents/codebase-analysis.md .github/agents/
```

Copilot will automatically discover the agent and make it available in your IDE.

---

## Adding Your Own Skills

This monorepo uses pnpm workspaces. To add more skills:

1. Create a new package under `packages/`
2. Create a `SKILL.md` file following the format in existing skills
3. Update the package's `.agentrc.json` with skill references

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## skills.sh Plugin Structure

This repository follows the [skills.sh plugin structure](https://skills.sh/anthropics/claude-plugins-official/plugin-structure):

```
agent-skills/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── skills/                  # Skills directory
│   ├── duplicate-detection/
│   ├── dead-code-analysis/
│   └── analysis-orchestrator/
└── packages/                # pnpm workspaces
```

### plugin.json

The `.claude-plugin/plugin.json` manifest defines your plugin:

```json
{
  "name": "agent-skills",
  "version": "1.0.0",
  "description": "Codebase analysis skills",
  "author": "kylebrodeur",
  "repository": "https://github.com/kylebrodeur/agent-skills",
  "skills": {
    "duplicate-detection": "./skills/duplicate-detection",
    "dead-code-analysis": "./skills/dead-code-analysis",
    "analysis-orchestrator": "./skills/analysis-orchestrator"
  }
}
```

---

## License

MIT
