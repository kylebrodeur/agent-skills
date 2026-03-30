# Agent Skills

A collection of Claude Code skills, skills.sh skills, and GitHub Copilot agents for codebase analysis - find duplicate code, dead code, and architecture violations.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Compatible-4183C4)](https://claude.ai/code)
[![GitHub Copilot](https://img.shields.io/badge/GitHub_Copilot-Compatible-4183C4)](https://github.com/features/copilot)
[![skills.sh](https://img.shields.io/badge/skills.sh-Compatible-4183C4)](https://skills.sh)
[![CLI](https://img.shields.io/badge/CLI-Compatible-4183C4)](https://github.com/kylebrodeur/agent-skills#cli)
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

## Claude Code Installation

### With skills.sh (recommended)

```bash
npx skills add kylebrodeur/agent-skills
```

### Manual installation

1. Copy the `.agent/` folder to your project:
```bash
cp -r packages/analysis-agent/.agent ../your-project/
```

2. Run setup:
```bash
cd ../your-project
bash .agent/scripts/setup.sh
pnpm install
```

### Hook configuration

The setup script automatically creates `.claude/hooks/PreToolUse` for automatic configuration.

---

## GitHub Copilot Installation

### With skills.sh (recommended)

```bash
npx skills add kylebrodeur/agent-skills
```

### Manual installation

1. Copy the agent file to your project:
```bash
mkdir -p ../your-project/.github/agents
cp packages/analysis-agent/agents/codebase-analysis.md ../your-project/.github/agents/
```

2. Run setup (creates hooks automatically):
```bash
cd ../your-project
bash .agent/scripts/setup.sh
pnpm install
```

### Hook configuration

The setup script creates `.github/hooks/hooks.json` with `preToolUse` hook for automatic configuration.

---

## Quick Start

```bash
npx skills add kylebrodeur/agent-skills
```

Or manually copy `.agent/` and run setup:

```bash
cp -r packages/analysis-agent/.agent ../your-project/
bash ../your-project/.agent/scripts/setup.sh
pnpm install
```

---

## CLI

A simple CLI is available for common tasks:

```bash
npx agent-skills install    # Run setup script
npx agent-skills check      # Check config files
npx agent-skills help       # Show all commands
```

After installation, use pnpm scripts:
```bash
pnpm analyze:all            # Run all analyses
pnpm analyze:dead           # Find dead code
pnpm analyze:dupes          # Find duplicate code
pnpm analyze:deps:validate  # Check architecture
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
