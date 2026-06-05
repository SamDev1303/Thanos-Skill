#!/usr/bin/env bash
# THANOS E2E Test Suite — standalone, no dependency on thanos.sh internals
# FIX: Use PASS=$((PASS+1)) not ((PASS++)) — arithmetic 0 is falsy, kills script under set -e
set -uo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'
YELLOW='\033[1;33m'; RESET='\033[0m'; BOLD='\033[1m'

PASS=0; FAIL=0
TEST_DIR=$(mktemp -d /tmp/thanos_e2e_XXXXXX)
ORIGINAL_DIR="$PWD"
THANOS_DIR="$TEST_DIR/.thanos"
# Resolve the repo root NOW (before any cd) so v3 socket tests can find thanos.sh/tools/.
SKILL_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cleanup() { rm -rf "$TEST_DIR"; cd "$ORIGINAL_DIR" 2>/dev/null || true; }
trap cleanup EXIT

assert() {
  local desc="$1" cond="$2"
  if [[ "$cond" == "true" ]]; then
    echo -e "${GREEN}[\u2713] PASS${RESET}: $desc"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}[\u2717] FAIL${RESET}: $desc"
    FAIL=$((FAIL + 1))
  fi
}

has_file() { [[ -f "$1" ]] && [[ -s "$1" ]] && echo true || echo false; }
has_content() { grep -q "$2" "$1" 2>/dev/null && echo true || echo false; }

echo -e "${BOLD}${CYAN}\n\U0001f9ea THANOS E2E TEST SUITE${RESET}"
printf '%.0s\u2501' {1..55}; echo

# ----------------------------------------------------------------
# SETUP: fake Node.js project with intentional bugs
# ----------------------------------------------------------------
cd "$TEST_DIR"
mkdir -p src tests

cat > package.json <<'PKG'
{"name":"test-app","version":"1.0.0","scripts":{"test":"echo 'test-ok' && exit 0","lint":"echo 'lint-ok' && exit 0"}}
PKG

cat > src/auth.js <<'AUTH'
// auth module
const SECRET = 'hardcoded-secret-123'
const DB_PASS = 'password123'
function login(user) { return { token: SECRET + user } }
module.exports = { login }
AUTH

cat > src/app.js <<'APP'
const auth = require('./auth')
module.exports = { auth }
APP

cat > tests/auth.test.js <<'TEST'
const { login } = require('../src/auth')
test('login returns token', () => { expect(login('alice').token).toBeTruthy() })
TEST

# ----------------------------------------------------------------
# GROUP 1: Stone directory and file creation
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 1 ] Stone Initialisation${RESET}"
mkdir -p "$THANOS_DIR"

cat > "$THANOS_DIR/SOUL.md" <<'EOF'
# SOUL STONE
## STATUS: UNSET
## GOAL
[NOT YET DEFINED]
## STOP CONDITION
[NOT YET DEFINED]
## VERIFIER COMMAND
npm test
EOF

cat > "$THANOS_DIR/REALITY.md" <<'EOF'
# REALITY STONE
## Language: Node.js
## Verifier: npm test
EOF

cat > "$THANOS_DIR/POWER.md" <<'EOF'
# POWER STONE
## Loop 0
- Build: UNKNOWN
- Tests: UNKNOWN
EOF

cat > "$THANOS_DIR/TIME.md" <<'EOF'
# TIME STONE
## Loop Counter: 0
## Session Started: 2026-05-10T08:00:00Z
EOF

cat > "$THANOS_DIR/SPACE.md" <<'EOF'
# SPACE STONE
## Current Phase: 0 -- DISCUSS
EOF

cat > "$THANOS_DIR/MIND.md" <<'EOF'
# MIND STONE
## Scoring Rubric
All scores must be >= 95 to snap.
EOF

assert "SOUL.md created and non-empty"    "$(has_file "$THANOS_DIR/SOUL.md")"
assert "REALITY.md created and non-empty" "$(has_file "$THANOS_DIR/REALITY.md")"
assert "POWER.md created and non-empty"   "$(has_file "$THANOS_DIR/POWER.md")"
assert "TIME.md created and non-empty"    "$(has_file "$THANOS_DIR/TIME.md")"
assert "SPACE.md created and non-empty"   "$(has_file "$THANOS_DIR/SPACE.md")"
assert "MIND.md created and non-empty"    "$(has_file "$THANOS_DIR/MIND.md")"

# ----------------------------------------------------------------
# GROUP 2: Project scan content verification
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 2 ] Project Scan -- REALITY Stone${RESET}"

FILE_TREE=$(find . -type f ! -path './.thanos/*' ! -name '*.lock' 2>/dev/null | sort)
CODE_CONTENT=""
while IFS= read -r f; do
  [[ -f "$f" ]] || continue
  CODE_CONTENT+="=== FILE: $f ==="$'\n'
  CODE_CONTENT+=$(cat "$f")
  CODE_CONTENT+=$'\n'
done <<< "$FILE_TREE"

FILE_COUNT=$(echo "$FILE_TREE" | wc -l | tr -d ' ')

cat > "$THANOS_DIR/REALITY.md" <<REALITY_EOF
# REALITY STONE
## Language: Node.js
## Verifier: npm test
## Files in tree: $FILE_COUNT

## File Tree
\`\`\`
$FILE_TREE
\`\`\`

## Code Contents
$CODE_CONTENT
REALITY_EOF

assert "REALITY.md contains src/auth.js"     "$(has_content "$THANOS_DIR/REALITY.md" 'auth.js')"
assert "REALITY.md contains actual code"      "$(has_content "$THANOS_DIR/REALITY.md" 'hardcoded')"
assert "REALITY.md contains package.json"     "$(has_content "$THANOS_DIR/REALITY.md" 'package.json')"
assert "REALITY.md has Node.js stack label"   "$(has_content "$THANOS_DIR/REALITY.md" 'Node.js')"
assert "REALITY.md has verifier command"      "$(has_content "$THANOS_DIR/REALITY.md" 'npm test')"

# ----------------------------------------------------------------
# GROUP 3: Verifier execution and POWER stone update
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 3 ] Verifier Execution -- POWER Stone${RESET}"

VERIFIER_OUTPUT=$(npm test 2>&1) || true
VERIFIER_EXIT=$?

cat > "$THANOS_DIR/POWER.md" <<POWER_EOF
# POWER STONE
## Loop 1
- Build: exit 0
- Tests: exit $VERIFIER_EXIT
- Output: $VERIFIER_OUTPUT
POWER_EOF

assert "POWER.md written with test output"     "$(has_file "$THANOS_DIR/POWER.md")"
assert "Verifier ran successfully (exit 0)"    "$( [[ $VERIFIER_EXIT -eq 0 ]] && echo true || echo false )"
assert "Test output in POWER.md (test-ok)"     "$(has_content "$THANOS_DIR/POWER.md" 'test-ok')"
assert "Exit code recorded in POWER.md"        "$(has_content "$THANOS_DIR/POWER.md" 'exit 0')"

# ----------------------------------------------------------------
# GROUP 4: Critic simulation -- security bug detection
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 4 ] Critic Detection -- MIND Stone${RESET}"

cat > "$THANOS_DIR/MIND.md" <<'CRITIC_EOF'
# MIND STONE -- Critic Reports
## Critic Report -- Loop 1
### Scores
| Category | Score | Blocking Issues |
|---|---|---|
| Logic Correctness | 90 | None |
| Code Quality | 85 | src/auth.js: hardcoded credentials |
| Test Coverage | 70 | No tests for edge cases |
| Security | 40 | CRITICAL: src/auth.js line 2 -- SECRET hardcoded |
| Performance | 95 | None |
### Verdict: LOOP AGAIN
### Issues List
- [src/auth.js:2] Hardcoded secret 'hardcoded-secret-123' -- move to env var
- [src/auth.js:3] Hardcoded DB_PASS -- move to env var
- [src/auth.js] No input validation on login()
CRITIC_EOF

assert "MIND.md has critic report header"     "$(has_content "$THANOS_DIR/MIND.md" 'Critic Report')"
assert "Security score failing flagged"        "$(has_content "$THANOS_DIR/MIND.md" 'Security')"
assert "LOOP AGAIN verdict present"           "$(has_content "$THANOS_DIR/MIND.md" 'LOOP AGAIN')"
assert "Specific file:line reference exists"  "$(has_content "$THANOS_DIR/MIND.md" 'auth.js')"
assert "Hardcoded secret issue flagged"       "$(has_content "$THANOS_DIR/MIND.md" 'hardcoded-secret')"

# ----------------------------------------------------------------
# GROUP 5: Hermes self-learning -- anti-rule injection
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 5 ] Hermes Self-Learning -- TIME Stone${RESET}"

cat >> "$THANOS_DIR/TIME.md" <<'HERMES_EOF'

## Loop 1 Lesson
[ANTI-RULE Loop 1]: NEVER hardcoded secrets in source files because they leak to git history
[ANTI-RULE Loop 1]: NEVER skip input validation on public functions because injection risk
Loop Counter: 1
HERMES_EOF

assert "TIME.md updated with loop lesson"  "$(has_content "$THANOS_DIR/TIME.md" 'Loop 1 Lesson')"
assert "ANTI-RULE injected into TIME.md"   "$(has_content "$THANOS_DIR/TIME.md" 'ANTI-RULE')"
assert "Loop counter incremented to 1"     "$(has_content "$THANOS_DIR/TIME.md" 'Loop Counter: 1')"
assert "Security anti-rule written"        "$(has_content "$THANOS_DIR/TIME.md" 'hardcoded secret')"

# ----------------------------------------------------------------
# GROUP 6: Snap condition -- all scores >= 95
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 6 ] Snap Condition Evaluation${RESET}"

cat > "$THANOS_DIR/MIND.md" <<'SNAP_EOF'
# MIND STONE -- Critic Reports
## Critic Report -- Loop 3
### Scores
| Category | Score | Blocking Issues |
|---|---|---|
| Logic Correctness | 98 | None |
| Code Quality | 97 | None |
| Test Coverage | 96 | None |
| Security | 100 | None |
| Performance | 95 | None |
### Verdict: SNAP
SNAP_EOF

assert "SNAP verdict present in MIND.md"  "$(has_content "$THANOS_DIR/MIND.md" 'SNAP')"
assert "No LOOP AGAIN in snap report"     "$( ! grep -q 'LOOP AGAIN' "$THANOS_DIR/MIND.md" 2>/dev/null && echo true || echo false )"
assert "Scores documented correctly"      "$(has_content "$THANOS_DIR/MIND.md" 'Critic Report')"

# ----------------------------------------------------------------
# GROUP 7: SOUL.md goal format validation
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 7 ] SOUL Stone Goal Format${RESET}"

cat > "$THANOS_DIR/SOUL.md" <<'SOUL_EOF'
# SOUL STONE -- Active Goal
## STATUS: ACTIVE -- 2026-05-10T08:30:00Z

## GOAL
Refactor auth.js to use environment variables for secrets

## STOP CONDITION (machine-verifiable)
- npm test exits 0
- grep -r 'hardcoded-secret' src/ returns empty
- npm run lint exits 0

## SCOPE
In scope: src/auth.js, .env.example
Out of scope: frontend, database

## ASSUMPTIONS
- Node.js 20, dotenv available

## VERIFIER COMMAND
npm test
SOUL_EOF

assert "SOUL.md has ## GOAL section"           "$(has_content "$THANOS_DIR/SOUL.md" '## GOAL')"
assert "SOUL.md has STOP CONDITION section"    "$(has_content "$THANOS_DIR/SOUL.md" 'STOP CONDITION')"
assert "SOUL.md has VERIFIER COMMAND section"  "$(has_content "$THANOS_DIR/SOUL.md" 'VERIFIER COMMAND')"
assert "SOUL.md has machine-verifiable exit 0" "$(has_content "$THANOS_DIR/SOUL.md" 'exits 0')"
assert "SOUL.md has SCOPE defined"             "$(has_content "$THANOS_DIR/SOUL.md" 'Out of scope')"
assert "SOUL.md has ACTIVE status"             "$(has_content "$THANOS_DIR/SOUL.md" 'STATUS: ACTIVE')"

# ================================================================
# v3 \u2014 CAPABILITY SOCKET (MOBILIZE) TESTS
# ================================================================

# ----------------------------------------------------------------
# GROUP 11: Injection hook \u2014 MOBILIZE concatenates the chosen skill
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 11 ] Capability Socket -- Injection Hook${RESET}"
MOB_PROJ="$TEST_DIR/mob_proj"
mkdir -p "$MOB_PROJ"; ( cd "$MOB_PROJ" && echo '{"name":"mob"}' > package.json )
# Guard: if setup failed, fail loudly rather than letting downstream cd-failures
# make the invalid-id exit-code assert pass for the wrong reason.
assert "MOBILIZE test project was created" "$([[ -d "$MOB_PROJ" ]] && echo true || echo false)"
MOB_RC=0
( cd "$MOB_PROJ" && bash "$SKILL_ROOT/thanos.sh" --mobilize "visual-proof" >/dev/null 2>&1 </dev/null ) || MOB_RC=$?
assert "MOBILIZE happy-path (visual-proof) exits 0"     "$([[ $MOB_RC -eq 0 ]] && echo true || echo false)"
MOB_FILE="$MOB_PROJ/.thanos/MOBILIZED.md"
assert "MOBILIZE builds .thanos/MOBILIZED.md"            "$(has_file "$MOB_FILE")"
assert "injection hook: MOBILIZED.md has visual-proof skill header" "$(has_content "$MOB_FILE" 'SKILL: visual-proof')"
assert "injection hook: visual-proof BODY content injected"          "$(has_content "$MOB_FILE" 'not proof')"
assert "MOBILIZE records chosen skill"                   "$(has_content "$MOB_FILE" 'Mobilized skills: visual-proof')"

# Invalid explicit id must NOT silently succeed (exit-code contract)
INVALID_RC=0
( cd "$MOB_PROJ" && bash "$SKILL_ROOT/thanos.sh" --mobilize "no-such-skill" >/dev/null 2>&1 </dev/null ) || INVALID_RC=$?
assert "MOBILIZE returns non-zero for an invalid explicit skill id" "$([[ $INVALID_RC -ne 0 ]] && echo true || echo false)"

# ----------------------------------------------------------------
# GROUP 8: Detect-gate contract (blocking, not silent)
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 12 ] Tool Adapters -- Detect Gate${RESET}"

# notes: zero-dependency, must always be ready (exit 0)
NOTES_RC=0; bash "$SKILL_ROOT/tools/notes.sh" --detect >/dev/null 2>&1 </dev/null || NOTES_RC=$?
assert "notes.sh --detect ready (exit 0)"               "$([[ $NOTES_RC -eq 0 ]] && echo true || echo false)"

# email: force the "absent" scenario with a stripped PATH so the test is deterministic
# whether or not react-email happens to be installed on the host.
EMAIL_ERR=$(PATH="/usr/bin:/bin" bash "$SKILL_ROOT/tools/email.sh" --detect 2>&1 >/dev/null </dev/null) || true
EMAIL_RC=0; PATH="/usr/bin:/bin" bash "$SKILL_ROOT/tools/email.sh" --detect >/dev/null 2>&1 </dev/null || EMAIL_RC=$?
assert "email.sh --detect blocks when react-email absent (non-zero)" "$([[ $EMAIL_RC -ne 0 ]] && echo true || echo false)"
assert "email.sh --detect emits an install hint"        "$(echo "$EMAIL_ERR" | grep -qi 'install' && echo true || echo false)"

# screenshot: with Playwright hidden from PATH, must block + emit a hint (the plan's gate)
SHOT_ERR=$(PATH="/usr/bin:/bin" bash "$SKILL_ROOT/tools/screenshot.sh" --detect 2>&1 >/dev/null </dev/null) || true
SHOT_RC=0; PATH="/usr/bin:/bin" bash "$SKILL_ROOT/tools/screenshot.sh" --detect >/dev/null 2>&1 </dev/null || SHOT_RC=$?
assert "screenshot.sh --detect blocks when Playwright absent (non-zero)" "$([[ $SHOT_RC -ne 0 ]] && echo true || echo false)"
assert "screenshot.sh --detect emits an install hint"   "$(echo "$SHOT_ERR" | grep -qi 'install\|playwright' && echo true || echo false)"

# ----------------------------------------------------------------
# GROUP 9: Screenshot smoke (guarded \u2014 needs Playwright + python3)
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 13 ] Screenshot Smoke (served, not file://)${RESET}"
if bash "$SKILL_ROOT/tools/screenshot.sh" --detect >/dev/null 2>&1 </dev/null; then
  SHOT_DIR="$TEST_DIR/shot"; mkdir -p "$SHOT_DIR"
  cat > "$SHOT_DIR/index.html" <<'HTML'
<!doctype html><html><head><meta charset="utf-8"><title>t</title></head>
<body style="margin:0;background:#6366f1;color:#fff;font:48px system-ui;display:flex;align-items:center;justify-content:center;height:100vh">OK</body></html>
HTML
  bash "$SKILL_ROOT/tools/screenshot.sh" "$SHOT_DIR/index.html" "$SHOT_DIR/out.png" 800 600 >/dev/null 2>&1 </dev/null || true
  assert "screenshot.sh produces a non-empty PNG from a served page" "$(has_file "$SHOT_DIR/out.png")"
  assert "captured file is a real PNG" "$(file "$SHOT_DIR/out.png" 2>/dev/null | grep -qi 'PNG image' && echo true || echo false)"
else
  echo -e "${YELLOW}[skip]${RESET} Playwright not installed \u2014 screenshot smoke skipped (detect-gate covers absence)"
fi

# ----------------------------------------------------------------
# GROUP 10: Visual-rubric differential property (deterministic)
# The redefined MIND Visual rubric must forbid "PNG exists -> high score".
# (The real LLM differential is the opt-in tests/rubric_differential.sh.)
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 14 ] Redefined Visual Rubric${RESET}"
GA="$SKILL_ROOT/GAUNTLET.md"
assert "rubric: no-PNG UI change is blocking (score 0)"  "$(grep -q 'NO visual proof' "$GA" && echo true || echo false)"
assert "rubric: bare PNG existence is capped low (<=30)" "$(grep -q 'caps here' "$GA" && echo true || echo false)"
assert "rubric: forbids raising score just because a PNG exists" "$(grep -q 'may NOT raise this score just because a PNG exists' "$GA" && echo true || echo false)"
assert "rubric: high score requires evidence-based justification" "$(grep -q 'evidence-based justification' "$GA" && echo true || echo false)"

# ----------------------------------------------------------------
# RESULTS
# ----------------------------------------------------------------
echo ""
printf '%.0s\u2501' {1..55}; echo
TOTAL=$((PASS + FAIL))
echo -e "${BOLD}RESULTS: ${GREEN}$PASS/$TOTAL PASSED${RESET}  |  ${RED}$FAIL FAILED${RESET}"
printf '%.0s\u2501' {1..55}; echo

if [[ $FAIL -eq 0 ]]; then
  echo -e "${YELLOW}[SNAP]${RESET} ${BOLD}ALL TESTS PASSED. The gauntlet holds.${RESET}"
  exit 0
else
  echo -e "${RED}[FAIL]${RESET} $FAIL test(s) failed. Loop continues."
  exit 1
fi
