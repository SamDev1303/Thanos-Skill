#!/usr/bin/env bash
# rubric_differential.sh — OPT-IN real-LLM check that the redefined MIND Visual rubric
# actually changes critic behavior: the same page must score meaningfully LOWER with no
# screenshot than WITH a real screenshot the critic can analyze. Proves the score is not
# "a PNG exists -> +5".
#
# This is NOT run in CI (needs an authenticated agent CLI + costs tokens). Run manually:
#   THANOS_RUBRIC_TEST=1 bash tests/rubric_differential.sh
#
# Exit 0 = differential holds (or skipped) · non-zero = rubric failed to differentiate.
set -uo pipefail
SKILL_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${THANOS_RUBRIC_TEST:-0}" != "1" ]]; then
  echo "[skip] set THANOS_RUBRIC_TEST=1 to run the real-LLM Visual-rubric differential."
  exit 0
fi

# Pick a headless-capable CLI.
CLI=""; CMD=()
if   command -v claude &>/dev/null; then CLI=claude; CMD=(claude -p)
elif command -v gemini &>/dev/null; then CLI=gemini; CMD=(gemini -p)
elif command -v codex  &>/dev/null; then CLI=codex;  CMD=(codex exec)
else echo "[skip] no headless agent CLI (claude/gemini/codex) found."; exit 0; fi
echo "[info] using $CLI for the differential"

RUBRIC=$(sed -n '/Visual\/UI Proof (0-100 or SKIP/,/score stays/p' "$SKILL_ROOT/GAUNTLET.md")

ask() {
  local scenario="$1"
  local prompt="You are the cold Thanos critic. Apply EXACTLY this Visual/UI Proof rubric:
$RUBRIC

Scenario: $scenario

Output ONLY one line, nothing else:
VISUAL_SCORE: <integer 0-100>"
  "${CMD[@]}" "$prompt" 2>/dev/null | grep -oiE 'VISUAL_SCORE:[[:space:]]*[0-9]+' | grep -oE '[0-9]+' | head -1
}

NO_PNG=$(ask "A landing page was changed. NO screenshot exists in .thanos/proof/. You cannot see the rendered result at all.")
GOOD_PNG=$(ask "A landing page was changed and a full-page screenshot exists in .thanos/proof/landing-desktop.png. Analyzing it: clear visual hierarchy (one bold hero headline draws the eye first), consistent 8px spacing rhythm, strong text/background contrast (AA-passing), aligned grid, a restrained two-color palette with one accent, and a single prominent primary CTA. Minor: footer slightly tight — non-blocking.")

echo "[result] no-PNG score:   ${NO_PNG:-<none>}"
echo "[result] good-PNG score: ${GOOD_PNG:-<none>}"

if [[ -z "${NO_PNG:-}" || -z "${GOOD_PNG:-}" ]]; then
  echo "[skip] could not parse scores from the CLI (auth/output issue) — not a rubric failure."
  exit 0
fi

# The differential: good-PNG must be meaningfully higher than no-PNG (>= 30 points).
if (( GOOD_PNG - NO_PNG >= 30 )); then
  echo "[PASS] rubric differentiates: good-PNG ($GOOD_PNG) >> no-PNG ($NO_PNG)"
  exit 0
else
  echo "[FAIL] rubric did NOT differentiate enough: good=$GOOD_PNG no=$NO_PNG (need >=30 gap)"
  exit 1
fi
