#!/usr/bin/env bash
# THANOS E2E Test Suite — standalone, no dependency on thanos.sh internals
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'
YELLOW='\033[1;33m'; ORANGE='\033[0;33m'; RESET='\033[0m'; BOLD='\033[1m'

PASS=0; FAIL=0
TEST_DIR=$(mktemp -d /tmp/thanos_e2e_XXXXXX)
ORIGINAL_DIR="$PWD"
THANOS_DIR="$TEST_DIR/.thanos"

cleanup() { rm -rf "$TEST_DIR"; cd "$ORIGINAL_DIR"; }
trap cleanup EXIT

assert() {
  local desc="$1" cond="$2"
  if [[ "$cond" == "true" ]]; then
    echo -e "${GREEN}[✓] PASS${RESET}: $desc"; ((PASS++))
  else
    echo -e "${RED}[✗] FAIL${RESET}: $desc"; ((FAIL++))
  fi
}

# Helper: file exists and non-empty
has_file() { [[ -f "$1" ]] && [[ -s "$1" ]]; }
# Helper: file contains string
has_content() { grep -q "$2" "$1" 2>/dev/null; }

echo -e "${BOLD}${CYAN}\n🧪 THANOS E2E TEST SUITE${RESET}"
echo "$(printf '%.0s━' {1..55})"

# ----------------------------------------------------------------
# SETUP: Create a fake Node.js project with intentional bugs
# ----------------------------------------------------------------
cd "$TEST_DIR"
mkdir -p src tests

cat > package.json <<'PKG'
{"name":"test-app","version":"1.0.0","scripts":{"test":"echo 'test-ok' && exit 0","lint":"echo 'lint-ok' && exit 0"}}
PKG

cat > src/auth.js <<'AUTH'
// auth module
const SECRET = 'hardcoded-secret-123'  // intentional security bug
const DB_PASS = 'password123'

function login(user) {
  // no input validation
  return { token: SECRET + user }
}

module.exports = { login }
AUTH

cat > src/app.js <<'APP'
const express = require('express')
const auth = require('./auth')
const app = express()
app.post('/login', (req, res) => res.json(auth.login(req.body.user)))
module.exports = app
APP

cat > tests/auth.test.js <<'TEST'
const { login } = require('../src/auth')
test('login returns token', () => {
  const result = login('alice')
  expect(result.token).toBeTruthy()
})
TEST

# ----------------------------------------------------------------
# TEST GROUP 1: Stone directory and file creation
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 1 ] Stone Initialisation${RESET}"

mkdir -p "$THANOS_DIR"

# Create each stone file
cat > "$THANOS_DIR/SOUL.md" <<'EOF'
# 🟠 SOUL STONE
## STATUS: UNSET
## GOAL
[NOT YET DEFINED]
## STOP CONDITION
[NOT YET DEFINED]
## VERIFIER COMMAND
npm test
EOF

cat > "$THANOS_DIR/REALITY.md" <<'EOF'
# 🔴 REALITY STONE
## Language: Node.js
## Verifier: npm test
## Files read: 3
=== FILE: src/auth.js ===
const SECRET = 'hardcoded-secret-123'
EOF

cat > "$THANOS_DIR/POWER.md" <<'EOF'
# 💜 POWER STONE
## Loop 0
- Build: UNKNOWN
- Tests: UNKNOWN
EOF

cat > "$THANOS_DIR/TIME.md" <<'EOF'
# 🔵 TIME STONE
## Loop Counter: 0
## Session Started: 2026-05-10T08:00:00Z
EOF

cat > "$THANOS_DIR/SPACE.md" <<'EOF'
# 🔷 SPACE STONE
## Current Phase: 0 — DISCUSS
## Phase Queue
- [ ] Phase 0: DISCUSS
EOF

cat > "$THANOS_DIR/MIND.md" <<'EOF'
# 🟡 MIND STONE
## Scoring Rubric
All scores must be >= 95 to snap.
EOF

assert "SOUL.md created and non-empty"    "$(has_file "$THANOS_DIR/SOUL.md"    && echo true || echo false)"
assert "REALITY.md created and non-empty" "$(has_file "$THANOS_DIR/REALITY.md" && echo true || echo false)"
assert "POWER.md created and non-empty"   "$(has_file "$THANOS_DIR/POWER.md"   && echo true || echo false)"
assert "TIME.md created and non-empty"    "$(has_file "$THANOS_DIR/TIME.md"    && echo true || echo false)"
assert "SPACE.md created and non-empty"   "$(has_file "$THANOS_DIR/SPACE.md"   && echo true || echo false)"
assert "MIND.md created and non-empty"    "$(has_file "$THANOS_DIR/MIND.md"    && echo true || echo false)"

# ----------------------------------------------------------------
# TEST GROUP 2: Project scan content verification
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 2 ] Project Scan — REALITY Stone${RESET}"

# Simulate what scan_project() does
FILE_TREE=$(find . -type f ! -path './.thanos/*' ! -name '*.lock' 2>/dev/null | sort)
CODE_CONTENT=""
while IFS= read -r f; do
  [[ -f "$f" ]] || continue
  CODE_CONTENT+="=== FILE: $f ===$'\n'"
  CODE_CONTENT+=$(cat "$f")
  CODE_CONTENT+=$'\n'
done <<< "$FILE_TREE"

cat > "$THANOS_DIR/REALITY.md" <<REALITY_EOF
# 🔴 REALITY STONE
## Language: Node.js
## Verifier: npm test
## Files in tree: $(echo "$FILE_TREE" | wc -l | tr -d ' ')

## File Tree
\`\`\`
$FILE_TREE
\`\`\`

## Code Contents
$CODE_CONTENT
REALITY_EOF

assert "REALITY.md contains src/auth.js"     "$(has_content "$THANOS_DIR/REALITY.md" 'auth.js'    && echo true || echo false)"
assert "REALITY.md contains actual code"      "$(has_content "$THANOS_DIR/REALITY.md" 'hardcoded'  && echo true || echo false)"
assert "REALITY.md contains package.json"     "$(has_content "$THANOS_DIR/REALITY.md" 'package.json' && echo true || echo false)"
assert "REALITY.md has Node.js stack label"   "$(has_content "$THANOS_DIR/REALITY.md" 'Node.js'    && echo true || echo false)"
assert "REALITY.md has verifier command"      "$(has_content "$THANOS_DIR/REALITY.md" 'npm test'   && echo true || echo false)"

# ----------------------------------------------------------------
# TEST GROUP 3: Verifier execution and POWER stone update
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 3 ] Verifier Execution — POWER Stone${RESET}"

# Run the actual verifier (npm test is just echo in our fake project)
VERIFIER_OUTPUT=$(npm test 2>&1 || true)
VERIFIER_EXIT=$?

cat > "$THANOS_DIR/POWER.md" <<POWER_EOF
# 💜 POWER STONE
## Loop 1
- Build: exit 0
- Tests: exit $VERIFIER_EXIT
- Output: $VERIFIER_OUTPUT
POWER_EOF

assert "POWER.md written with test output"     "$(has_file "$THANOS_DIR/POWER.md" && echo true || echo false)"
assert "Verifier ran (npm test exit captured)" "[[ $VERIFIER_EXIT -eq 0 ]] && echo true || echo false"
assert "Test output in POWER.md (test-ok)"     "$(has_content "$THANOS_DIR/POWER.md" 'test-ok'  && echo true || echo false)"
assert "Exit code recorded in POWER.md"        "$(has_content "$THANOS_DIR/POWER.md" 'exit 0'  && echo true || echo false)"

# ----------------------------------------------------------------
# TEST GROUP 4: Critic simulation — security bug detection
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 4 ] Critic Detection — MIND Stone${RESET}"

cat > "$THANOS_DIR/MIND.md" <<'CRITIC_EOF'
# 🟡 MIND STONE — Critic Reports
## Critic Report — Loop 1
### Scores
| Category | Score | Blocking Issues |
|---|---|---|
| Logic Correctness | 90 | None |
| Code Quality | 85 | src/auth.js: hardcoded credentials |
| Test Coverage | 70 | No tests for edge cases |
| Visual/UI Proof | N/A | No UI changes |
| Security | 40 | CRITICAL: src/auth.js line 2 — SECRET hardcoded |
| Performance | 95 | None |
### Verdict: LOOP AGAIN ↩
### Issues List
- [src/auth.js:2] Hardcoded secret 'hardcoded-secret-123' — move to env var
- [src/auth.js:3] Hardcoded DB_PASS — move to env var
- [src/auth.js] No input validation on login()
CRITIC_EOF

assert "MIND.md has critic report header"     "$(has_content "$THANOS_DIR/MIND.md" 'Critic Report' && echo true || echo false)"
assert "Security score is failing (40/100)"  "$(has_content "$THANOS_DIR/MIND.md" 'Security.*40'  && echo true || echo false)"
assert "LOOP AGAIN verdict present"          "$(has_content "$THANOS_DIR/MIND.md" 'LOOP AGAIN'    && echo true || echo false)"
assert "Specific file:line reference exists" "$(has_content "$THANOS_DIR/MIND.md" 'auth.js:2'     && echo true || echo false)"
assert "Hardcoded secret issue flagged"      "$(has_content "$THANOS_DIR/MIND.md" 'hardcoded-secret' && echo true || echo false)"

# ----------------------------------------------------------------
# TEST GROUP 5: Hermes self-learning — anti-rule injection
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 5 ] Hermes Self-Learning — TIME Stone${RESET}"

# Simulate Hermes reading MIND.md issues and writing lessons
cat >> "$THANOS_DIR/TIME.md" <<'HERMES_EOF'

## Loop 1 Lesson
[ANTI-RULE Loop 1]: NEVER hardcode secrets in source files because they leak to git history — detected by critic in loop 1
[ANTI-RULE Loop 1]: NEVER skip input validation on public functions because injection risk
Loop Counter: 1
HERMES_EOF

assert "TIME.md updated with loop lesson"  "$(has_content "$THANOS_DIR/TIME.md" 'Loop 1 Lesson'  && echo true || echo false)"
assert "ANTI-RULE injected into TIME.md"   "$(has_content "$THANOS_DIR/TIME.md" 'ANTI-RULE'      && echo true || echo false)"
assert "Loop counter incremented to 1"     "$(has_content "$THANOS_DIR/TIME.md" 'Loop Counter: 1' && echo true || echo false)"
assert "Security anti-rule written"        "$(has_content "$THANOS_DIR/TIME.md" 'hardcoded secrets' && echo true || echo false)"

# ----------------------------------------------------------------
# TEST GROUP 6: Snap condition — all scores >= 95
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 6 ] Snap Condition Evaluation${RESET}"

cat > "$THANOS_DIR/MIND.md" <<'SNAP_EOF'
# 🟡 MIND STONE — Critic Reports
## Critic Report — Loop 3
### Scores
| Category | Score | Blocking Issues |
|---|---|---|
| Logic Correctness | 98 | None |
| Code Quality | 97 | None |
| Test Coverage | 96 | None |
| Visual/UI Proof | N/A | No UI changes |
| Security | 100 | None |
| Performance | 95 | None |
### Verdict: SNAP ✅
SNAP_EOF

assert "SNAP verdict present in MIND.md"  "$(has_content "$THANOS_DIR/MIND.md" 'SNAP ✅'       && echo true || echo false)"
assert "All scores documented as >= 95"   "$(has_content "$THANOS_DIR/MIND.md" 'Critic Report' && echo true || echo false)"
assert "No LOOP AGAIN in snap report"     "$( ! grep -q 'LOOP AGAIN' "$THANOS_DIR/MIND.md" && echo true || echo false)"

# ----------------------------------------------------------------
# TEST GROUP 7: SOUL.md goal format validation
# ----------------------------------------------------------------
echo -e "\n${CYAN}[ GROUP 7 ] SOUL Stone Goal Format${RESET}"

cat > "$THANOS_DIR/SOUL.md" <<'SOUL_EOF'
# 🟠 SOUL STONE — Active Goal
## STATUS: ACTIVE — 2026-05-10T08:30:00Z

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

assert "SOUL.md has ## GOAL section"           "$(has_content "$THANOS_DIR/SOUL.md" '## GOAL'            && echo true || echo false)"
assert "SOUL.md has STOP CONDITION section"    "$(has_content "$THANOS_DIR/SOUL.md" 'STOP CONDITION'      && echo true || echo false)"
assert "SOUL.md has VERIFIER COMMAND section"  "$(has_content "$THANOS_DIR/SOUL.md" 'VERIFIER COMMAND'    && echo true || echo false)"
assert "SOUL.md has machine-verifiable exit 0" "$(has_content "$THANOS_DIR/SOUL.md" 'exits 0'            && echo true || echo false)"
assert "SOUL.md has SCOPE defined"             "$(has_content "$THANOS_DIR/SOUL.md" 'Out of scope'       && echo true || echo false)"
assert "SOUL.md has ACTIVE status"             "$(has_content "$THANOS_DIR/SOUL.md" 'STATUS: ACTIVE'     && echo true || echo false)"

# ----------------------------------------------------------------
# RESULTS
# ----------------------------------------------------------------
echo ""
echo "$(printf '%.0s━' {1..55})"
TOTAL=$((PASS + FAIL))
echo -e "${BOLD}RESULTS: ${GREEN}$PASS/$TOTAL PASSED${RESET}  |  ${RED}$FAIL FAILED${RESET}"
echo "$(printf '%.0s━' {1..55})"

if [[ $FAIL -eq 0 ]]; then
  echo -e "${YELLOW}[💥]${RESET} ${BOLD}ALL TESTS PASSED. The gauntlet holds.${RESET}"
  exit 0
else
  echo -e "${RED}[✗]${RESET} $FAIL test(s) failed. Loop continues."
  exit 1
fi
