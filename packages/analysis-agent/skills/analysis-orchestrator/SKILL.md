---
name: analysis-orchestrator
description: Orchestrate a full codebase analysis using all static analysis tools (knip, dependency-cruiser, jscpd) and synthesize findings.
compatibility: Requires pnpm. Works with TypeScript/JavaScript projects including Next.js, React, Node.js.
user-invokable: true
argument-hint: "full | deps | dead | dupes (default: full)"
metadata:
  author: codebase-analysis-agent
  version: "1.0"
---

# Analysis Orchestrator

Coordinate all static analysis tools and synthesize their output into a unified picture of codebase health.

## When to use this skill

- "Run a full codebase analysis"
- "Update the findings document"
- "Check if the codebase is clean before merging"
- "What has changed since the last analysis run?"
- "Is this new code following architectural rules?"

## Quick start

```bash
# Run everything
pnpm analyze:all

# Or individually per tool
pnpm analyze:deps:validate
pnpm analyze:dead
pnpm analyze:dupes
```

## Step-by-step orchestration

### Step 1 — Architecture validation (fastest, run first)

```bash
pnpm analyze:deps:validate
```

Expected clean output:
```
✔ no dependency violations found
```

If violations appear, investigate before proceeding.

### Step 2 — Dead code scan

```bash
pnpm analyze:dead
```

knip exits code 1 when findings exist — this is expected, not a failure.

### Step 3 — Duplicate detection

```bash
pnpm analyze:dupes
```

HTML reports are written to `/tmp/jscpd-report/html/`. Open them for detailed side-by-side diff views.

### Step 4 — Cross-reference and synthesize

After running all tools, look for cross-tool patterns:

**Pattern A: Bypassed utility**
```
knip:  "helperFn" — unused export
jscpd: helperFn clones inline code elsewhere
```
→ A utility exists, nobody imports it, and the logic was written inline elsewhere.

**Pattern B: Missing route or export**
```
knip:  "getItemById" — unused export
(no matching route/handler)
```
→ A service function was written but never wired up.

**Pattern C: Orphaned feature**
```
knip: multiple unused exports in same file cluster
jscpd: no clones (unique implementations)
```
→ A complete subsystem with no callers.

## Synthesizing findings into a report

Use a findings document (e.g., `docs/ANALYSIS_FINDINGS.md`). When updating it:

1. **Keep existing comments/annotations** — developer notes are important context
2. **Update the generation timestamp** in the document header
3. **Cross-reference new findings against known findings** before adding them
4. **Preserve open items** from the previous run unless confirmed resolved
5. **Add new findings** in the correct section based on classification

## Key cross-tool signals

| Signal | Meaning | Action |
|---|---|---|
| knip unused + jscpd duplicate | Bypassed utility | Wire the caller to use the utility |
| knip unused + no route | Missing route | Add the route, don't delete the service |
| knip multiple unused + no clones | Orphaned subsystem | Document as future feature |

## Handling project types

### Next.js (App Router)
- Entry points: `app/page.tsx`, `app/layout.tsx`, `app/route.ts`
- Components: `components/**/*.tsx`
- Hooks: `hooks/**/*.ts`, `hooks/**/*.tsx`
- Server actions: `app/actions.ts`, `lib/actions.ts`
- **Important**: Files in `app/` are entry points via routing, not imports

### Next.js (Pages Router)
- Entry points: `pages/_app.tsx`, `pages/_document.tsx`
- API routes: `pages/api/**/*.ts`
- Components: `components/**/*.tsx`

### React Library / Component Library
- Entry point: `src/index.ts`
- Components: `src/components/**/*.tsx`
- Hooks: `src/hooks/**/*.ts`, `src/hooks/**/*.tsx`
- Utils: `src/lib/**/*.ts`

### Node.js / Backend
- Entry point: `src/index.ts`, `src/main.ts`
- Common pattern: `handlers/` → `actions/` → `services/`

### shadcn/ui Component Library
- Ignore `components/ui/` in jscpd (auto-generated boilerplate)
- knip may flag unused exports — check if used via `cn()` utility
- `lib/utils.ts` uses template strings for class names - knip won't trace these

## Output format for findings

```
### P[N] — [Short description]

**File**: `path/to/file.ts:line`
**Status**: [A | B | B (bypassed) | C]

[What the symbol/function does]

[What the tool output showed]

[Why this matters]

**Action needed**: [Specific recommended fix]
```

## What to cross-reference

Before marking anything as new, check existing findings:

- **"Exports That Are Fine" table** — previously reviewed and intentional symbols
- **"Orphaned Subsystems" section** — existing orphaned clusters
- **"Priority Action Items"** — open items still awaiting resolution

## Example agent response

```
**Codebase Analysis — [project name]**
**Run date**: 2026-03-29

**Architecture**: ✔ No violations

**Dead code summary**:
- N unused files, N unused exports, N unused dependencies

**New findings since last run**: [symbols not previously documented]

**Previously documented findings still open**:
- P1: [description]
- P2: [description]

**Cross-tool signals**:
- [Any bypassed utility patterns]

**Recommendation**: [highest priority action]

See docs/ANALYSIS_FINDINGS.md for full details.
```

## Config files reference

See individual skill docs for:
- `.jscpd.json` — Duplicate code detection config
- `knip.json` — Dead code analysis config
- `.dependency-cruiser.cjs` — Architecture validation config

## Next.js/React Quick Start

For **Next.js App Router** projects, use these recommended settings:

### .jscpd.json
```json
{
  "format": ["typescript", "tsx"],
  "output": "/tmp/jscpd-app",
  "ignore": [
    "**/__tests__/**",
    "**/*.test.tsx",
    "**/node_modules/**",
    "app/**/page.tsx",
    "app/**/layout.tsx",
    "components/ui/**"
  ]
}
```

### knip.json (Next.js App Router)
```json
{
  "entry": ["app/page.tsx", "app/layout.tsx", "app/route.ts"],
  "project": ["app/**/*.ts", "app/**/*.tsx", "components/**/*.ts", "components/**/*.tsx", "lib/**/*.ts"],
  "ignore": ["components/ui/**", "app/**/page.tsx", "app/**/layout.tsx", "app/**/not-found.tsx", "app/**/error.tsx", "**/__tests__/**"],
  "ignoreDependencies": ["clsx", "tailwind-merge", "class-variance-authority"],
  "ignoreExportsUsedInFile": true
}
```

### .dependency-cruiser.cjs (Next.js)
```javascript
module.exports = {
  forbidden: [
    {
      name: "no-circular",
      severity: "error",
      from: {},
      to: { circular: true }
    }
  ],
  options: {
    doNotFollow: { path: "node_modules" },
    tsConfig: { fileName: "tsconfig.json" }
  }
};
```
