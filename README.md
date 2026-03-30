# Agent Skills

A collection of Claude Code and GitHub Copilot agent skills for codebase analysis - find duplicate code, dead code, and architecture violations.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Compatible-4183C4)](https://claude.ai/code)
[![GitHub Copilot](https://img.shields.io/badge/GitHub_Copilot-Compatible-4183C4)](https://github.com/features/copilot)
[![pnpm](https://img.shields.io/badge/pnpm-10.24.0-FFA500.svg)](https://pnpm.io)
[![Node.js](https://img.shields.io/badge/Node.js-20+-478C00.svg)](https://nodejs.org)

---

## Overview

This monorepo contains reusable **Claude Code skills** and **GitHub Copilot agents** for codebase analysis. Each skill is a reusable workflow that can be invoked via slash commands or automatically through agents.

### What's Included

| Skill | Purpose |
|-------|---------|
| **Duplicate Detection** | Find copy-pasted code blocks using `jscpd` |
| **Dead Code Analysis** | Find unused exports, types, and dependencies using `knip` |
| **Architecture Validation** | Check import rules and circular dependencies using `dependency-cruiser` |
| **Analysis Orchestrator** | Run all tools and synthesize findings |

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

### Installation

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

## Supported Projects

| Project Type | Entry Points | Notes |
|--------------|--------------|-------|
| **Node.js** | `src/index.ts`, `src/main.ts` | Service → Action → Handler |
| **Next.js (App Router)** | `app/page.tsx`, `app/layout.tsx` | Routing entry points |
| **Next.js (Pages Router)** | `pages/_app.tsx`, `pages/_document.tsx` | Legacy routing |
| **React Libraries** | `src/index.ts` | Component library patterns |
| **shadcn/ui** | - | Auto-generated components |
| **Generic TS/JS** | - | Works with any structure |

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

## License

MIT
