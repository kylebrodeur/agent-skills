#!/usr/bin/env bash
# Run all three static analysis tools
# Usage: bash packages/analysis-agent/scripts/run-analysis.sh

set -e

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

PASS=0
FAIL=0

section() { echo ""; echo "━━━ $1 ━━━"; }
ok()      { echo "  ✔ $1"; PASS=$((PASS+1)); }
fail()    { echo "  ✘ $1"; FAIL=$((FAIL+1)); }

echo "=== Codebase Analysis ==="

# ── Dependency Architecture ───────────────────────────────────────────────────
section "Dependency Architecture"

if pnpm analyze:deps:validate 2>&1; then
  ok "No violations"
else
  fail "Violations found (see above)"
fi

# ── Dead Code ─────────────────────────────────────────────────────────────────
section "Dead Code (knip)"

if pnpm analyze:dead 2>&1; then
  ok "No issues"
else
  fail "Issues found (see above)"
fi

# ── Duplicate Code ────────────────────────────────────────────────────────────
section "Duplicate Code (jscpd)"

if pnpm analyze:dupes 2>&1 | tail -5; then
  ok "Analysis complete"
else
  fail "Issues found (see above)"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
section "Summary"
echo "  Passed: $PASS   Failed: $FAIL"
if [ "$FAIL" -gt 0 ]; then
  echo "  → Review output above."
  exit 1
else
  echo "  → All checks passed."
fi
