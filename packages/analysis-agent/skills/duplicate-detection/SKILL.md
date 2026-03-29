---
name: duplicate-detection
description: Find copy-pasted code blocks and similar patterns in your project using jscpd. Use when asked to find duplicate code, identify refactoring targets, or check if a utility should be extracted because it appears in multiple places.
compatibility: Requires pnpm. Generates an HTML report for review.
user-invokable: true
argument-hint: "directory path (default: ./src)"
metadata:
  author: codebase-analysis-agent
  version: "1.0"
---

# Duplicate Code Detection

Use jscpd to find copy-pasted code blocks using token comparison.

## Supported Projects

This skill works with any TypeScript/JavaScript project:
- **Node.js** backends
- **Next.js** applications
- **React** libraries
- **shadcn/ui** component libraries
- **Generic** monorepos

## Configuration

jscpd reads from `.jscpd.json` at the project root. Default excludes:
- `**/__tests__/**` - test files
- `**/*.test.ts` / `**/*.test.js` - test files
- `**/node_modules/**` - dependencies
- `**/dist/**` / `**/build/**` - build output

## Commands

```bash
# Run detection + generate HTML report
pnpm analyze:dupes

# Open the HTML report (side-by-side diff per clone group)
open /tmp/jscpd-report/html/index.html
```

## Example output

```
Clone found (typescript):
 - src/services/itemService.ts [42:1 - 55:3] (13 lines, 98 tokens)
   src/services/orderService.ts [71:1 - 84:3]

Found 18 clones.
```

## What is excluded

- `src/components/ui/` or `packages/ui/` — auto-generated component library files (would produce false positives)
- All `__tests__/` directories and `*.test.ts` / `*.spec.ts` files
- Build output (`dist/`, `build/`, `lib/`)

## Interpreting results

jscpd reports "clone groups" — sets of code blocks that are structurally near-identical based on token comparison, not exact text. It detects structural similarity even when variable names differ.

**Important**: jscpd cannot determine intent. It reports *what looks similar*, not *whether it should be different*. Every clone group requires manual review.

## Clone group investigation workflow

For each flagged group:

**Step 1 — Read both sides**

Use the HTML report or read the files directly. Are these two blocks doing the *same job*, or *similar jobs with different concerns*?

**Step 2 — Check if a utility already exists**

```bash
grep -rn "functionNameHint\|keyTermFromLogic" src/shared/ src/utils/ --include="*.ts"
```

If a utility exists but neither caller uses it, this is a "bypassed utility" — not just a jscpd finding. See the dead-code-analysis skill.

**Step 3 — Classify the clone**

See the classification guide below.

**Step 4 — Act or suppress**

- **Extract** → create a shared utility and replace both blocks
- **Accept** → add the path pattern to `"ignore"` in `.jscpd.json` and document why
- **Investigate** → if the blocks are nearly identical but semantically different, document the difference

## Clone classification guide

### False positive: uniform structural patterns

When a codebase enforces a consistent shape across many similar files, jscpd will report those files as duplicates even though the duplication is intentional.

**Example** — action file entry points or component definitions with the same pattern.

The outer shell is identical. jscpd flags it. But this uniformity is the point — every item follows the same contract, which makes adding new items predictable and safe. **Do not refactor.**

### False positive: protocol/shape boilerplate

When a response type or protocol requires the same fields to be assembled in every consumer, the assembly code will look duplicated.

**Example** — response builders with the same shape but different content.

**Opportunity**: Consider a TypeScript interface or builder function to enforce the shape. Not because the duplication is wrong, but because if the response shape changes, every handler will need independent updating.

### False positive: parallel strategy implementations

When two code paths implement the same *kind* of operation but for different *cases*, jscpd will flag the retry/fallback scaffold as a duplicate.

**Investigate before accepting.** Ask: should there be a single function that tries multiple strategies? If the codebase has a consolidated utility already, check whether these are bypassing it.

### Genuine target: same logic duplicated across feature modules

When two *different* feature areas contain the same block of logic, that logic belongs in `shared/utils/`.

## Acting on a clone group

1. **Extract a utility** — If `services/A.ts` and `services/B.ts` share logic, create `shared/utils/sharedHelper.ts`
2. **Create a higher-order function** — If two functions share an outer retry/error-handling shell but differ in the inner operation
3. **Enforce via TypeScript** — If two blocks share a *shape*, create a shared interface or builder
4. **Accept and suppress** — If structural/intentional, add the path to `"ignore"` in `.jscpd.json`

## What is excluded and why

- Auto-generated component library files produce high false-positive volume since they're intentionally boilerplate-heavy
- All `__tests__/` directories and `*.test.ts` / `*.spec.ts` files — test setup blocks and mock patterns are expected to repeat

## Cross-tool interpretation

jscpd findings gain more meaning when combined with knip results.

**jscpd flags two blocks as duplicates + knip flags one of them as an unused export = strong signal of a bypassed utility**

```
jscpd: src/utils/validator.ts:14-28 clones src/handlers/items.ts:67-81
knip:  "validateItemInput" — unused export in src/utils/validator.ts
```

This combination means: a utility exists for this validation, nobody imports it, and the validation logic was written inline in the handler. The correct fix is to replace the inline handler code with a call to the utility — not to delete either.

## Config files

Create a `.jscpd.json` file at project root:

```json
{
  "threshold": 5,
  "reporters": ["html", "console"],
  "ignore": [
    "**/__tests__/**",
    "**/*.test.ts",
    "**/*.test.js",
    "**/dist/**",
    "**/node_modules/**"
  ],
  "gitignore": true,
  "minLines": 8,
  "minTokens": 50,
  "format": ["typescript", "javascript"],
  "output": "/tmp/jscpd-report"
}
```

## Adjusting sensitivity

Default: `threshold: 5` (report if >5% of a file is duplicated), `minLines: 8`.

```json
{
  "threshold": 3,
  "minLines": 5,
  "minTokens": 30
}
```

Lower values find more patterns; raise them to reduce noise. When investigating a specific suspected duplication, temporarily lower both values.

---

## Project-Specific Notes

### Next.js Applications (App Router)

For Next.js with the App Router, configure jscpd to analyze the `app/` directory:

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

**Note**: Pages and layouts often have similar structure (`<main>`, `<header>`, `<footer>`). These are intentional — focus on finding duplicate business logic, not layout patterns.

### React Component Libraries

For libraries using `src/components/`:

```json
{
  "ignore": [
    "**/__tests__/**",
    "**/*.test.tsx",
    "**/node_modules/**",
    "src/components/ui/**",
    "src/stories/**"
  ]
}
```

shadcn/ui components are intentionally similar — each is a self-contained primitive. Don't try to consolidate them.

### Tailwind CSS / shadcn/ui

When analyzing projects that use **Tailwind CSS** or **shadcn/ui**:

- Component files often have similar JSX structure (intentional)
- Utility classes are distributed across files (expected)
- Focus on finding duplicate **logic**, not **styles**

The `.jscpd.json` should exclude `components/ui/` to avoid false positives from auto-generated component primitives.
