# Codebase Analysis & Refactoring

Claude Code skills and plugins for codebase analysis - detect duplication, find dead code, validate architecture, and guide refactoring.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Compatible-4183C4)](https://claude.ai/code)
[![GitHub Copilot](https://img.shields.io/badge/GitHub_Copilot-Compatible-4183C4)](https://github.com/features/copilot)
[![skills.sh](https://img.shields.io/badge/skills.sh-Compatible-4183C4)](https://skills.sh)
[![CLI](https://img.shields.io/badge/CLI-Compatible-4183C4)](https://github.com/kylebrodeur/codebase-analysis#cli)
[![pnpm](https://img.shields.io/badge/pnpm-10.24.0-FFA500.svg)](https://pnpm.io)
[![Node.js](https://img.shields.io/badge/Node.js-20+-478C00.svg)](https://nodejs.org)

---

## Overview

This repository contains reusable **Claude Code skills**, **skills.sh** skills, and **GitHub Copilot agents** for codebase analysis and refactoring. Each skill helps identify issues and guides the refactoring process.

### What's Included

| Skill | Purpose |
|-------|---------|
| **Duplicate Detection** | Find copy-pasted code blocks using `jscpd` |
| **Dead Code Analysis** | Find unused exports, types, and dependencies using `knip` |
| **Architecture Validation** | Check import rules and circular dependencies using `dependency-cruiser` |
| **Analysis Orchestrator** | Run all tools and synthesize findings for refactoring |

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

## Claude Code

### Install as skills (skills.sh)

```bash
npx skills add kylebrodeur/codebase-analysis
```

### Install as Claude Code plugin

First add the marketplace:
```bash
claude plugin marketplace add kylebrodeur/codebase-analysis
```

Then install the plugin:
```bash
claude plugin install codebase-analysis@codebase-analysis
```

Or manually copy `.agent/` folder to `~/.claude/plugins/` or your project's `.claude/plugins/`.

---

## GitHub Copilot

### Plugin installation

The GitHub Copilot plugin system follows the same format as Claude Code. If your Copilot CLI supports plugins:

```bash
copilot plugin install kylebrodeur/codebase-analysis
```

Or install as a skill using `skills.sh`:

```bash
npx skills add kylebrodeur/codebase-analysis
```

### Manual installation (all versions)

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

Note: If the plugin command doesn't work, ensure you have the latest Copilot CLI. The plugin format is compatible with Claude Code's plugin structure.

---

## Quick Start

### Install as skills (skills.sh)

```bash
npx skills add kylebrodeur/codebase-analysis
```

### Install as Claude Code plugin

```bash
claude plugin install codebase-analysis@codebase-analysis
```

### Install as GitHub Copilot plugin

```bash
copilot plugin install kylebrodeur/codebase-analysis
```

Copilot plugins can be installed directly from the GitHub repo - no marketplace needed.

### Manual installation

Copy `.agent/` folder and run setup:

```bash
cp -r packages/analysis-agent/.agent ../your-project/
bash ../your-project/.agent/scripts/setup.sh
pnpm install
```

---

## CLI

A simple CLI is available for common tasks:

```bash
npx codebase-analysis install    # Run setup script
npx codebase-analysis check      # Check config files
npx codebase-analysis help       # Show all commands
```

After installation, use pnpm scripts:
```bash
pnpm analyze:all            # Run all analyses
pnpm analyze:dead           # Find dead code
pnpm analyze:dupes          # Find duplicate code
pnpm analyze:deps:validate  # Check architecture
```

---

## Refactoring Process

This plugin supports a systematic refactoring process:

### Overview

1. **Detect duplication** - Use `pnpm analyze:dupes` and `pnpm analyze:dead` to find duplicate logic
2. **Extract to shared module** - Create `lib/utils.ts` (client-side) or `lib/shared.ts` (shared)
3. **Update consumers** - Replace duplicate code with imports from the shared module
4. **Verify correctness** - Run `pnpm analyze:all` to confirm no regressions
5. **Document changes** - Update TODO-REVIEW.md with architectural improvements

### Process Steps

| Step | Command/Action |
|------|----------------|
| 1. Identify duplicates | `pnpm analyze:dupes` + `pnpm analyze:dead` |
| 2. Extract utility | Create new module in `lib/` directory |
| 3. Update consumers | Replace inline code with imports |
| 4. Verify | `pnpm analyze:all` + tests + typecheck |
| 5. Document | Update TODO-REVIEW.md |

### Anti-Patterns to Avoid

- Creating too many small modules - group related functionality
- Circular dependencies - ensure import graph is acyclic
- Mixing concerns - keep client/server code separate
- Over-engineering - only extract when there are 2+ consumers
- Premature abstraction - wait until pattern is clear

### Checksum for Refactoring

Before merging, verify:
- No duplicate code remains in original files
- All imports use the shared module
- Typecheck passes with no errors
- All tests pass (80%+ coverage)
- Linting passes
- TODO-REVIEW.md updated

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
codebase-analysis/
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
  "name": "codebase-analysis",
  "version": "1.0.0",
  "description": "Codebase analysis and refactoring skills",
  "author": "kylebrodeur",
  "repository": "https://github.com/kylebrodeur/codebase-analysis",
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
