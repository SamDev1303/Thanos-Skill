#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║  ████████╗██╗  ██╗ █████╗ ███╗   ██╗ ██████╗ ███████╗                  ║
# ║     ██╗   ██║  ██║██╔══██╗████╗  ██║██╔═══██╗██╔════╝                  ║
# ║     ██╗   ███████║███████║██╔██╗ ██║██║   ██║███████╗                  ║
# ║     ██╗   ██╔══██║██╔══██║██║╚██╗██║██║   ██║╚════██║                  ║
# ║     ██╗   ██║  ██║██║  ██║██║ ╚████║╚██████╔╝███████║                  ║
# ║     ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝                  ║
# ║                                                                          ║
# ║  THE INFINITY AGENT HARNESS — v2.0                                       ║
# ║  Autonomous. Self-healing. Ruthlessly correct.                           ║
# ║  Works with: claude | codex | gemini | cursor | aider                   ║
# ╚══════════════════════════════════════════════════════════════════════════╝
#
# USAGE:
#   thanos                          # auto-detect CLI, interactive
#   thanos claude                   # force Claude Code
#   thanos codex "fix the auth"     # Codex with inline goal
#   thanos gemini                   # Gemini CLI
#   thanos --test                   # run E2E test suite
#   thanos --status                 # print all six stones
#   thanos --reset                  # wipe .thanos/ and start fresh
#   thanos --resume                 # resume from last checkpoint
#   thanos --version                # print version
#
# INSTALL:
#   curl -fsSL https://raw.githubusercontent.com/SamDev1303/Thanos-Skill/main/install.sh | bash

set -euo pipefail

# ─── CONSTANTS ────────────────────────────────────────────────────────────────
THANOS_VERSION="2.0.0"
THANOS_DIR=".thanos"
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_FILE="$SKILL_DIR/THANOS.md"

# Stone files
SOUL="$THANOS_DIR/SOUL.md"
REALITY="$THANOS_DIR/REALITY.md"
POWER="$THANOS_DIR/POWER.md"
TIME_STONE="$THANOS_DIR/TIME.md"
SPACE="$THANOS_DIR/SPACE.md"
MIND="$THANOS_DIR/MIND.md"

# Colours
RED='\033[0;31m'; ORANGE='\033[0;33m'; YELLOW='\033[1;33m'
GREEN='\033[0;32m'; CYAN='\033[0;36m'; PURPLE='\033[0;35m'
BOLD='\033[1m'; DIM='\033[2m'; RESET='\033[0m'

# ─── BANNER ───────────────────────────────────────────────────────────────────
banner() {
  echo -e "${PURPLE}"
  echo "  ████████╗██╗  ██╗ █████╗ ███╗   ██╗ ██████╗ ███████╗"
  echo "     ██╔══╝██║  ██║██╔══██╗████╗  ██║██╔═══██╗██╔════╝"
  echo "     ██║   ███████║███████║██╔██╗ ██║██║   ██║███████╗"
  echo "     ██║   ██╔══██║██╔══██║██║╚██╗██║██║   ██║╚════██║"
  echo "     ██║   ██║  ██║██║  ██║██║ ╚████║╚██████╔╝███████║"
  echo "     ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝"
  echo -e "${DIM}  The Infinity Agent Harness — v${THANOS_VERSION}${RESET}"
  echo -e "${DIM}  Autonomous. Self-healing. Ruthlessly correct.${RESET}"
  echo ""
}

# ─── HELPERS ──────────────────────────────────────────────────────────────────
log()     { echo -e "${CYAN}[THANOS]${RESET} $*"; }
success() { echo -e "${GREEN}[✓]${RESET} $*"; }
warn()    { echo -e "${ORANGE}[⚠]${RESET} $*"; }
error()   { echo -e "${RED}[✗]${RESET} $*" >&2; }
stone()   { echo -e "${PURPLE}[∞]${RESET} $*"; }
loop_()   { echo -e "${YELLOW}[↩]${RESET} $*"; }
snap()    { echo -e "${ORANGE}[💥]${RESET} $*"; }

die() { error "$1"; exit 1; }

require() {
  command -v "$1" &>/dev/null || die "Required command not found: $1 — please install it first."
}

# ─── CLI DETECTION ────────────────────────────────────────────────────────────
detect_cli() {
  local preference="${1:-auto}"
  if [[ "$preference" != "auto" ]]; then
    command -v "$preference" &>/dev/null || die "CLI '$preference' not found in PATH."
    echo "$preference"
    return
  fi
  # Priority: claude > codex > gemini > aider > cursor
  for cli in claude codex gemini aider cursor; do
    if command -v "$cli" &>/dev/null; then
      echo "$cli"
      return
    fi
  done
  die "No supported CLI found. Install one of: claude, codex, gemini, aider, cursor"
}

# ─── STACK DETECTION ─────────────────────────────────────────────────────────
detect_stack() {
  local verifier=""
  if [[ -f "package.json" ]];          then verifier="npm test"; fi
  if [[ -f "Cargo.toml" ]];            then verifier="cargo test"; fi
  if [[ -f "go.mod" ]];                then verifier="go test ./..."; fi
  if [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]]; then verifier="pytest"; fi
  if [[ -f "pom.xml" ]];               then verifier="mvn test"; fi
  if [[ -f "Gemfile" ]];               then verifier="bundle exec rspec"; fi
  if [[ -f "Makefile" ]];              then verifier="${verifier:-make test}"; fi
  echo "${verifier:-echo 'No verifier detected — add one to SOUL.md'}"
}

detect_lang() {
  if [[ -f "package.json" ]];          then echo "Node.js/TypeScript"; return; fi
  if [[ -f "Cargo.toml" ]];            then echo "Rust"; return; fi
  if [[ -f "go.mod" ]];                then echo "Go"; return; fi
  if [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]]; then echo "Python"; return; fi
  if [[ -f "pom.xml" ]];               then echo "Java"; return; fi
  if [[ -f "Gemfile" ]];               then echo "Ruby"; return; fi
  echo "Unknown"
}

# ─── PROJECT SCAN ─────────────────────────────────────────────────────────────
# Reads EVERY code file and embeds them into the REALITY stone.
# This is what makes Thanos different — it doesn't guess, it reads.
scan_project() {
  log "Scanning project..."
  local file_count=0
  local code_content=""
  local file_tree=""

  # Build file tree (respecting .gitignore if git is available)
  if command -v git &>/dev/null && [[ -d ".git" ]]; then
    file_tree=$(git ls-files 2>/dev/null | head -200 || find . -type f | grep -v '.git' | grep -v 'node_modules' | grep -v '.thanos' | head -200)
  else
    file_tree=$(find . -type f \
      ! -path './.git/*' \
      ! -path './node_modules/*' \
      ! -path './.thanos/*' \
      ! -path './dist/*' \
      ! -path './build/*' \
      ! -path './.next/*' \
      ! -name '*.png' ! -name '*.jpg' ! -name '*.gif' ! -name '*.ico' \
      ! -name '*.lock' ! -name '*.sum' \
      2>/dev/null | head -200)
  fi

  # Read code files (up to 50, skip binaries and lock files)
  local read_count=0
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    [[ ! -f "$f" ]] && continue
    # Skip binary/large/lock files
    case "$f" in
      *.png|*.jpg|*.gif|*.ico|*.woff|*.ttf|*.eot|*.svg) continue ;;
      *.lock|*.sum|package-lock.json|yarn.lock) continue ;;
    esac
    local size
    size=$(wc -c < "$f" 2>/dev/null || echo 0)
    [[ "$size" -gt 50000 ]] && continue  # skip files > 50KB
    
    code_content+=$'\n'"=== FILE: $f ==="$'\n'
    code_content+=$(cat "$f" 2>/dev/null || echo "[unreadable]")
    code_content+=$'\n'
    ((read_count++))
    ((file_count++))
    [[ "$read_count" -ge 50 ]] && break
  done <<< "$file_tree"

  # Write to REALITY stone
  cat > "$REALITY" << REALITY_EOF
# 🔴 REALITY STONE — Project Snapshot
## Scanned: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
## Language: $(detect_lang)
## Verifier: $(detect_stack)
## Files in tree: $(echo "$file_tree" | wc -l)
## Files read: $read_count

## File Tree
\`\`\`
$file_tree
\`\`\`

## Code Contents (first $read_count files)
$code_content
REALITY_EOF

  success "Scanned $read_count code files → REALITY.md"
}

# ─── STONE INITIALISATION ─────────────────────────────────────────────────────
init_stones() {
  mkdir -p "$THANOS_DIR"

  # SOUL — goal
  if [[ ! -f "$SOUL" ]] || [[ ! -s "$SOUL" ]]; then
    cat > "$SOUL" << 'SOUL_EOF'
# 🟠 SOUL STONE — Active Goal

## STATUS: UNSET — Run THANOS:discuss to define the goal

## GOAL
[NOT YET DEFINED — complete DISCUSS phase]

## STOP CONDITION (machine-verifiable)
[NOT YET DEFINED]

## SCOPE
In scope: [list files/modules]
Out of scope: [list explicitly]

## ASSUMPTIONS
- Language/framework: [detect from REALITY.md]
- [Add assumptions here]

## VERIFIER COMMAND
[detect from REALITY.md]

## SNAP RECORD
[Written here when goal is achieved]
SOUL_EOF
    stone "Initialized SOUL.md"
  fi

  # POWER — test results
  if [[ ! -f "$POWER" ]] || [[ ! -s "$POWER" ]]; then
    cat > "$POWER" << 'POWER_EOF'
# 💜 POWER STONE — Verifier Results

## Loop 0 — Initial State
- Build: UNKNOWN
- Tests: UNKNOWN
- Lint:  UNKNOWN
- Coverage: UNKNOWN

## Raw Output
[No verifier run yet]
POWER_EOF
    stone "Initialized POWER.md"
  fi

  # TIME — loop history
  if [[ ! -f "$TIME_STONE" ]] || [[ ! -s "$TIME_STONE" ]]; then
    cat > "$TIME_STONE" << 'TIME_EOF'
# 🔵 TIME STONE — Loop History & Hermes Lessons

## Loop Counter: 0
## Session Started: TIMESTAMP_PLACEHOLDER

## Loop History
[No loops completed yet]

## Hermes Anti-Rules (injected after failures)
[No anti-rules yet — they accumulate here automatically]

## Recurring Failure Tracker
[Tracks issue categories across loops — 3 recurrences = human escalation]
TIME_EOF
    sed -i.bak "s/TIMESTAMP_PLACEHOLDER/$(date -u +"%Y-%m-%dT%H:%M:%SZ")/" "$TIME_STONE" && rm -f "$TIME_STONE.bak"
    stone "Initialized TIME.md"
  fi

  # SPACE — phase queue
  if [[ ! -f "$SPACE" ]] || [[ ! -s "$SPACE" ]]; then
    cat > "$SPACE" << 'SPACE_EOF'
# 🔷 SPACE STONE — Phase Queue & Task Backlog

## Current Phase: 0 — DISCUSS
## Next Action: Run THANOS:discuss to clarify the real goal

## Phase Queue
- [ ] Phase 0: DISCUSS — clarify goal, write to SOUL.md
- [ ] Phase 1: ASSUMPTIONS — extract and list all assumptions
- [ ] Phase 2: PLAN — write acceptance criteria, break into tasks
- [ ] Phase 3: EXECUTE — sub agent builds
- [ ] Phase 4: VERIFY — run verifier, update POWER.md
- [ ] Phase 5: CRITIQUE — critic agent scores, update MIND.md
- [ ] Phase 6: LEARN — Hermes injects lessons into TIME.md
- [ ] SNAP — goal achieved ✅

## Blockers
[None]

## Task Backlog
[Populated during PLAN phase]
SPACE_EOF
    stone "Initialized SPACE.md"
  fi

  # MIND — critic scores
  if [[ ! -f "$MIND" ]] || [[ ! -s "$MIND" ]]; then
    cat > "$MIND" << 'MIND_EOF'
# 🟡 MIND STONE — Critic Reports

## Scoring Rubric
Each category scored 0-100. ALL must be ≥ 95 to snap.

| Category | Weight | What it checks |
|----------|--------|----------------|
| Logic Correctness | 20% | Does it do what was asked? |
| Code Quality | 20% | DRY, patterns, readability, no anti-patterns |
| Test Coverage | 20% | Edge cases covered, tests are meaningful |
| Visual/UI Proof | 20% | Screenshot or DOM snapshot for any UI change |
| Security | 10% | OWASP top 10, no secrets, no injection |
| Performance | 10% | No N+1, no blocking I/O, no memory leaks |

## Critic Reports
[No reports yet]
MIND_EOF
    stone "Initialized MIND.md"
  fi

  # REALITY — project snapshot
  if [[ ! -f "$REALITY" ]] || [[ ! -s "$REALITY" ]]; then
    scan_project
  fi
}

# ─── STATUS DISPLAY ───────────────────────────────────────────────────────────
print_status() {
  banner
  echo -e "${BOLD}📊 INFINITY STONES STATUS${RESET}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  local stones=("SOUL.md:🟠:Goal" "REALITY.md:🔴:Project" "POWER.md:💜:Tests" "TIME.md:🔵:History" "SPACE.md:🔷:Phases" "MIND.md:🟡:Critics")
  for entry in "${stones[@]}"; do
    IFS=':' read -r file emoji label <<< "$entry"
    if [[ -f "$THANOS_DIR/$file" ]] && [[ -s "$THANOS_DIR/$file" ]]; then
      local lines
      lines=$(wc -l < "$THANOS_DIR/$file")
      success "$emoji  $label ($file) — ${lines} lines"
    else
      warn "$emoji  $label ($file) — MISSING or EMPTY"
    fi
  done

  echo ""
  echo -e "${BOLD}🔍 QUICK READ${RESET}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [[ -f "$SOUL" ]]; then
    echo -e "${ORANGE}Goal:${RESET}"
    grep -A 2 "## GOAL" "$SOUL" 2>/dev/null | tail -2 | sed 's/^/  /'
  fi
  if [[ -f "$TIME_STONE" ]]; then
    echo -e "${CYAN}Loop count:${RESET} $(grep 'Loop Counter:' "$TIME_STONE" 2>/dev/null | awk '{print $NF}')"
  fi
  if [[ -f "$MIND" ]]; then
    local last_verdict
    last_verdict=$(grep "Verdict:" "$MIND" 2>/dev/null | tail -1)
    [[ -n "$last_verdict" ]] && echo -e "${YELLOW}Last critic verdict:${RESET} $last_verdict"
  fi
  echo ""
}

# ─── RESET ────────────────────────────────────────────────────────────────────
do_reset() {
  echo -e "${RED}${BOLD}⚠  RESET: This will wipe all six stones in .thanos/${RESET}"
  read -r -p "Are you sure? Type 'snap' to confirm: " confirm
  if [[ "$confirm" == "snap" ]]; then
    rm -rf "$THANOS_DIR"
    success "All stones wiped. Run thanos to start fresh."
  else
    log "Reset cancelled."
  fi
}

# ─── BUILD SYSTEM PROMPT ──────────────────────────────────────────────────────
# This is the core: embed all six stones + THANOS.md into the agent's context
build_system_prompt() {
  local goal="${1:-}"
  local prompt=""

  # Load THANOS.md skill
  if [[ -f "$SKILL_FILE" ]]; then
    prompt+="$(cat "$SKILL_FILE")"$'\n\n'
  fi

  prompt+="---"$'\n'
  prompt+="# CURRENT PROJECT STATE — READ ALL SIX STONES BEFORE PROCEEDING"$'\n\n'

  # Embed all stones
  for stone_file in SOUL REALITY POWER TIME SPACE MIND; do
    local path="$THANOS_DIR/${stone_file}.md"
    if [[ -f "$path" ]]; then
      prompt+="## ${stone_file} STONE"$'\n'
      prompt+="$(cat "$path")"$'\n\n'
    fi
  done

  # Inline goal if provided
  if [[ -n "$goal" ]]; then
    prompt+="---"$'\n'
    prompt+="# INLINE GOAL FROM CLI"$'\n'
    prompt+="$goal"$'\n\n'
    prompt+="Write this goal to SOUL.md, extract verifier command, and begin the Thanos loop immediately."$'\n'
  fi

  prompt+="---"$'\n'
  prompt+="# BEGIN"$'\n'
  prompt+="Read all six stones above. Run THANOS:discuss if the goal is unclear. Start the full Thanos loop."$'\n'

  echo "$prompt"
}

# ─── LAUNCH CLAUDE ────────────────────────────────────────────────────────────
launch_claude() {
  local goal="${1:-}"
  require claude
  log "Launching Claude Code with Thanos context..."
  
  local sys_prompt
  sys_prompt=$(build_system_prompt "$goal")

  # Write the system prompt to a temp file for Claude to load
  local tmp_prompt
  tmp_prompt=$(mktemp /tmp/thanos_prompt_XXXXXX.md)
  echo "$sys_prompt" > "$tmp_prompt"

  log "System prompt: $tmp_prompt ($(wc -l < "$tmp_prompt") lines)"
  
  if [[ -n "$goal" ]]; then
    claude --system-prompt "$tmp_prompt" "$goal"
  else
    claude --system-prompt "$tmp_prompt"
  fi
  rm -f "$tmp_prompt"
}

# ─── LAUNCH CODEX ─────────────────────────────────────────────────────────────
launch_codex() {
  local goal="${1:-}"
  require codex
  log "Launching Codex with Thanos context..."
  
  local sys_prompt
  sys_prompt=$(build_system_prompt "$goal")
  local tmp_prompt
  tmp_prompt=$(mktemp /tmp/thanos_prompt_XXXXXX.md)
  echo "$sys_prompt" > "$tmp_prompt"

  # Codex supports --instructions file
  if [[ -n "$goal" ]]; then
    codex --instructions "$tmp_prompt" "$goal"
  else
    codex --instructions "$tmp_prompt"
  fi
  rm -f "$tmp_prompt"
}

# ─── LAUNCH GEMINI ────────────────────────────────────────────────────────────
launch_gemini() {
  local goal="${1:-}"
  require gemini
  log "Launching Gemini CLI with Thanos context..."
  
  local sys_prompt
  sys_prompt=$(build_system_prompt "$goal")
  local tmp_prompt
  tmp_prompt=$(mktemp /tmp/thanos_prompt_XXXXXX.md)
  echo "$sys_prompt" > "$tmp_prompt"

  if [[ -n "$goal" ]]; then
    gemini --system "$tmp_prompt" "$goal"
  else
    gemini --system "$tmp_prompt"
  fi
  rm -f "$tmp_prompt"
}

# ─── LAUNCH AIDER ─────────────────────────────────────────────────────────────
launch_aider() {
  local goal="${1:-}"
  require aider
  log "Launching Aider with Thanos context..."
  
  local sys_prompt
  sys_prompt=$(build_system_prompt "$goal")
  echo "$sys_prompt" > "$THANOS_DIR/SYSTEM_PROMPT.md"

  if [[ -n "$goal" ]]; then
    aider --read "$THANOS_DIR/SYSTEM_PROMPT.md" --message "$goal"
  else
    aider --read "$THANOS_DIR/SYSTEM_PROMPT.md"
  fi
}

# ─── E2E TEST SUITE ───────────────────────────────────────────────────────────
run_tests() {
  banner
  echo -e "${BOLD}🧪 THANOS E2E TEST SUITE${RESET}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  local pass=0 fail=0
  local test_dir
  test_dir=$(mktemp -d /tmp/thanos_test_XXXXXX)
  local original_dir="$PWD"

  assert() {
    local desc="$1" result="$2"
    if [[ "$result" == "0" ]]; then
      success "PASS: $desc"
      ((pass++))
    else
      error "FAIL: $desc"
      ((fail++))
    fi
  }

  # ── Test 1: Stone initialisation ──────────────────────────────────────────
  echo ""
  echo -e "${CYAN}[ TEST GROUP 1 ] Stone Initialisation${RESET}"
  cd "$test_dir"
  # Create a fake Node.js project
  echo '{"name":"test-app","scripts":{"test":"echo test-ok && exit 0","lint":"echo lint-ok && exit 0"}}' > package.json
  echo "const x = require('express')" > app.js
  echo "// auth module" > auth.js
  echo "const SECRET = 'hardcoded-secret-123'" >> auth.js  # intentional security bug
  
  bash "$SKILL_DIR/thanos.sh" --init-only 2>/dev/null || true
  
  assert "SOUL.md created"    "$([[ -f .thanos/SOUL.md    ]] && echo 0 || echo 1)"
  assert "REALITY.md created" "$([[ -f .thanos/REALITY.md ]] && echo 0 || echo 1)"
  assert "POWER.md created"   "$([[ -f .thanos/POWER.md   ]] && echo 0 || echo 1)"
  assert "TIME.md created"    "$([[ -f .thanos/TIME.md    ]] && echo 0 || echo 1)"
  assert "SPACE.md created"   "$([[ -f .thanos/SPACE.md   ]] && echo 0 || echo 1)"
  assert "MIND.md created"    "$([[ -f .thanos/MIND.md    ]] && echo 0 || echo 1)"

  # ── Test 2: Project scan reads actual code ─────────────────────────────────
  echo ""
  echo -e "${CYAN}[ TEST GROUP 2 ] Project Scan${RESET}"
  assert "REALITY.md contains app.js"  "$( grep -q 'app.js' .thanos/REALITY.md && echo 0 || echo 1)"
  assert "REALITY.md contains auth.js" "$( grep -q 'auth.js' .thanos/REALITY.md && echo 0 || echo 1)"
  assert "REALITY.md contains code"    "$( grep -q 'hardcoded-secret' .thanos/REALITY.md && echo 0 || echo 1)"
  assert "Stack detected as Node.js"   "$( grep -q 'Node.js' .thanos/REALITY.md && echo 0 || echo 1)"
  assert "Verifier detected: npm test" "$( grep -q 'npm test' .thanos/REALITY.md && echo 0 || echo 1)"

  # ── Test 3: Verifier run ───────────────────────────────────────────────────
  echo ""
  echo -e "${CYAN}[ TEST GROUP 3 ] Verifier Execution${RESET}"
  npm test > /tmp/thanos_test_out.txt 2>&1 || true
  local test_exit=$?
  cat > .thanos/POWER.md << POWER_EOF
# 💜 POWER STONE — Verifier Results
## Loop 1
- Build: exit 0
- Tests: exit $test_exit
- Output: $(cat /tmp/thanos_test_out.txt | head -3)
POWER_EOF
  assert "POWER.md written"                 "$([[ -s .thanos/POWER.md ]] && echo 0 || echo 1)"
  assert "Test output captured in POWER.md" "$(grep -q 'test-ok' .thanos/POWER.md && echo 0 || echo 1)"

  # ── Test 4: Simulated critic detects security bug ─────────────────────────
  echo ""
  echo -e "${CYAN}[ TEST GROUP 4 ] Critic Detection (Simulated)${RESET}"
  cat > .thanos/MIND.md << 'CRITIC_EOF'
# 🟡 MIND STONE — Critic Reports
## Critic Report — Loop 1
### Scores
| Category | Score | Blocking Issues |
|---|---|---|
| Logic Correctness | 90 | None |
| Code Quality | 85 | auth.js: hardcoded credentials |
| Test Coverage | 70 | No tests for auth module |
| Visual/UI Proof | N/A | No UI changes |
| Security | 40 | CRITICAL: auth.js line 2 — SECRET hardcoded in plain text |
| Performance | 95 | None |
### Verdict: LOOP AGAIN ↩
### Issues List
- [auth.js:2] Hardcoded secret 'hardcoded-secret-123' — move to env var
- [auth.js] No input validation on any exported functions
- [app.js] Missing error handling middleware
CRITIC_EOF
  
  assert "MIND.md contains critic report"     "$( grep -q 'Critic Report' .thanos/MIND.md && echo 0 || echo 1)"
  assert "Security score detected as failing" "$( grep -q 'Security.*40' .thanos/MIND.md && echo 0 || echo 1)"
  assert "LOOP AGAIN verdict present"         "$( grep -q 'LOOP AGAIN' .thanos/MIND.md && echo 0 || echo 1)"
  assert "Specific file:line issue present"   "$( grep -q 'auth.js:2' .thanos/MIND.md && echo 0 || echo 1)"

  # ── Test 5: Hermes anti-rule injection ────────────────────────────────────
  echo ""
  echo -e "${CYAN}[ TEST GROUP 5 ] Hermes Self-Learning${RESET}"
  # Simulate Hermes writing a lesson
  echo "" >> .thanos/TIME.md
  echo "## Loop 1 Lesson" >> .thanos/TIME.md
  echo "[ANTI-RULE Loop 1]: NEVER hardcode secrets in source files because they leak to git history — detected by critic in loop 1" >> .thanos/TIME.md
  echo "Loop Counter: 1" >> .thanos/TIME.md

  assert "TIME.md updated with loop lesson"    "$( grep -q 'Loop 1 Lesson' .thanos/TIME.md && echo 0 || echo 1)"
  assert "ANTI-RULE injected"                  "$( grep -q 'ANTI-RULE' .thanos/TIME.md && echo 0 || echo 1)"
  assert "Loop counter incremented"            "$( grep -q 'Loop Counter: 1' .thanos/TIME.md && echo 0 || echo 1)"

  # ── Test 6: Snap condition evaluation ─────────────────────────────────────
  echo ""
  echo -e "${CYAN}[ TEST GROUP 6 ] Snap Condition${RESET}"
  # All scores >= 95 = snap
  cat > .thanos/MIND.md << 'SNAP_CRITIC_EOF'
## Critic Report — Loop 3
### Scores
| Category | Score | Blocking Issues |
|---|---|---|
| Logic Correctness | 98 | None |
| Code Quality | 96 | None |
| Test Coverage | 97 | None |
| Visual/UI Proof | N/A | No UI changes this loop |
| Security | 100 | None |
| Performance | 95 | None |
### Verdict: SNAP ✅
SNAP_CRITIC_EOF

  assert "SNAP verdict present in MIND.md"    "$( grep -q 'SNAP ✅' .thanos/MIND.md && echo 0 || echo 1)"
  assert "All scores ≥ 95 in SNAP report"     "$( grep -vE '^###|^\||^$' .thanos/MIND.md | grep -vq '[0-9][0-9]\b.*[0-5][0-9]\b' && echo 0 || echo 1)"

  # ── Test 7: SOUL.md goal format ───────────────────────────────────────────
  echo ""
  echo -e "${CYAN}[ TEST GROUP 7 ] SOUL Goal Format${RESET}"
  cat > .thanos/SOUL.md << 'SOUL_TEST_EOF'
# 🟠 SOUL STONE — Active Goal
## STATUS: ACTIVE
## GOAL
Refactor auth.js to use environment variables for secrets
## STOP CONDITION (machine-verifiable)
- npm test exits 0
- grep -r 'hardcoded-secret' src/ returns empty
- npm run lint exits 0
## SCOPE
In: auth.js, .env.example
Out of scope: frontend, database
## ASSUMPTIONS
- Node.js 20
- dotenv available
## VERIFIER COMMAND
npm test
SOUL_TEST_EOF

  assert "SOUL.md has GOAL section"            "$( grep -q '## GOAL' .thanos/SOUL.md && echo 0 || echo 1)"
  assert "SOUL.md has STOP CONDITION"          "$( grep -q 'STOP CONDITION' .thanos/SOUL.md && echo 0 || echo 1)"
  assert "SOUL.md has VERIFIER COMMAND"        "$( grep -q 'VERIFIER COMMAND' .thanos/SOUL.md && echo 0 || echo 1)"
  assert "SOUL.md has machine-verifiable exit" "$( grep -q 'exits 0' .thanos/SOUL.md && echo 0 || echo 1)"

  # ── Summary ───────────────────────────────────────────────────────────────
  cd "$original_dir"
  rm -rf "$test_dir"
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e "${BOLD}RESULTS: ${GREEN}$pass PASSED${RESET} | ${RED}$fail FAILED${RESET}"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  if [[ "$fail" -eq 0 ]]; then
    snap "ALL TESTS PASSED. The gauntlet holds. 💥"
    exit 0
  else
    error "$fail tests failed. Loop continues."
    exit 1
  fi
}

# ─── DISCUSS PHASE (interactive) ─────────────────────────────────────────────
# This is the key insight from the user: humans are confused the first time.
# One loop is never enough. We keep asking until we have a real goal.
run_discuss() {
  echo -e "${BOLD}${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${BOLD}🎯 THANOS DISCUSS PHASE — Clarifying the Real Goal${RESET}"
  echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${DIM}One loop is never enough. Humans are always confused the first time.${RESET}"
  echo -e "${DIM}Answer each question carefully. Type 'skip' to use auto-detected value.${RESET}"
  echo ""

  local goal="" verifier="" scope_in="" scope_out="" constraints=""

  # Q1: Real goal
  echo -e "${YELLOW}Q1. What is the REAL goal? (not the surface ask — dig deeper)${RESET}"
  echo -e "${DIM}    Bad: 'fix the app' | Good: 'auth tokens expire silently, users can't log back in'${RESET}"
  read -r -p "    → " goal
  [[ "$goal" == "skip" ]] && goal="[Goal not defined — run THANOS:discuss again]"

  # Q2: Done condition
  echo ""
  echo -e "${YELLOW}Q2. What does DONE look like? What machine output proves it works?${RESET}"
  echo -e "${DIM}    Example: 'npm test exits 0 AND curl /auth/refresh returns 200'${RESET}"
  read -r -p "    → " done_condition
  [[ "$done_condition" == "skip" ]] && done_condition="[Not defined — auto-detect from test suite]"

  # Q3: Verifier command
  local detected_verifier
  detected_verifier=$(detect_stack)
  echo ""
  echo -e "${YELLOW}Q3. What command verifies success? (detected: ${detected_verifier})${RESET}"
  echo -e "${DIM}    Press Enter to use detected, or type your own${RESET}"
  read -r -p "    → " verifier
  [[ -z "$verifier" ]] && verifier="$detected_verifier"

  # Q4: Scope
  echo ""
  echo -e "${YELLOW}Q4. What files/modules are IN scope?${RESET}"
  read -r -p "    → " scope_in
  echo -e "${YELLOW}Q5. What is EXPLICITLY out of scope? (prevents scope creep)${RESET}"
  read -r -p "    → " scope_out

  # Q6: Constraints
  echo ""
  echo -e "${YELLOW}Q6. Any hard constraints? (performance, security, deadlines, must-not-break)${RESET}"
  read -r -p "    → " constraints

  # Q7: Confirmation loop — the key insight
  echo ""
  echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${BOLD}CONFIRMING GOAL:${RESET}"
  echo ""
  echo -e "  ${ORANGE}Goal:${RESET}      $goal"
  echo -e "  ${ORANGE}Done when:${RESET} $done_condition"
  echo -e "  ${ORANGE}Verifier:${RESET}  $verifier"
  echo -e "  ${ORANGE}In scope:${RESET}  $scope_in"
  echo -e "  ${ORANGE}Out scope:${RESET} $scope_out"
  echo -e "  ${ORANGE}Constraints:${RESET} $constraints"
  echo ""
  read -r -p "Is this correct? (y/n/refine): " confirm

  if [[ "$confirm" == "n" ]] || [[ "$confirm" == "refine" ]]; then
    log "Re-running discuss phase..."
    run_discuss
    return
  fi

  # Write to SOUL stone
  cat > "$SOUL" << SOUL_WRITE_EOF
# 🟠 SOUL STONE — Active Goal
## STATUS: ACTIVE — $(date -u +"%Y-%m-%dT%H:%M:%SZ")

## GOAL
$goal

## STOP CONDITION (machine-verifiable)
$done_condition

## SCOPE
In scope: $scope_in
Out of scope: $scope_out

## CONSTRAINTS
$constraints

## ASSUMPTIONS
- Language: $(detect_lang)
- Stack: $(detect_stack)
- [Review REALITY.md for full project context]

## VERIFIER COMMAND
$verifier

## SNAP RECORD
[Written here when goal is achieved]
SOUL_WRITE_EOF

  success "Goal written to SOUL.md"
  success "Ready to run: thanos claude | thanos codex | thanos gemini"
}

# ─── MAIN ─────────────────────────────────────────────────────────────────────
main() {
  local cli_arg="${1:-auto}"
  local goal_arg="${2:-}"

  # Handle flags
  case "$cli_arg" in
    --version|-v)
      echo "thanos v$THANOS_VERSION"
      exit 0
      ;;
    --test|-t)
      # Init stones in temp project just for test bootstrap
      run_tests
      exit $?
      ;;
    --status|-s)
      init_stones
      print_status
      exit 0
      ;;
    --reset|-r)
      do_reset
      exit 0
      ;;
    --resume)
      init_stones
      log "Resuming from last checkpoint..."
      if [[ -f "$SPACE" ]]; then
        grep "Current Phase" "$SPACE" || true
      fi
      # Fall through to launch with existing stone state
      cli_arg="auto"
      ;;
    --discuss|-d)
      init_stones
      scan_project
      run_discuss
      exit 0
      ;;
    --init-only)
      # Used internally by test suite
      init_stones
      scan_project
      exit 0
      ;;
    --help|-h)
      banner
      echo "USAGE:"
      echo "  thanos                     auto-detect CLI, interactive"
      echo "  thanos claude [goal]       Claude Code"
      echo "  thanos codex [goal]        OpenAI Codex CLI"
      echo "  thanos gemini [goal]       Gemini CLI"
      echo "  thanos aider [goal]        Aider"
      echo "  thanos --discuss           Run goal clarification Q&A"
      echo "  thanos --status            Print all six stones"
      echo "  thanos --reset             Wipe .thanos/ and start fresh"
      echo "  thanos --resume            Resume from last checkpoint"
      echo "  thanos --test              Run E2E test suite"
      echo "  thanos --version           Print version"
      echo ""
      echo "COMMANDS (inside any agent):"
      echo "  THANOS:discuss   Force Q&A goal clarification"
      echo "  THANOS:plan      Write phase plan to SPACE.md"
      echo "  THANOS:execute   Run one sub-agent execution cycle"
      echo "  THANOS:verify    Run verifier, update POWER.md"
      echo "  THANOS:critique  Spawn critic, score, update MIND.md"
      echo "  THANOS:learn     Run Hermes, inject lessons"
      echo "  THANOS:snap      Force-evaluate snap condition"
      echo "  THANOS:status    Print all six stone summaries"
      exit 0
      ;;
  esac

  # ── Normal launch flow ───────────────────────────────────────────────────
  banner

  # 1. Initialise stones
  init_stones

  # 2. Rescan project every launch (fresh reality)
  log "Re-scanning project for latest state..."
  scan_project

  # 3. If no goal in SOUL.md, run discuss phase
  local soul_status
  soul_status=$(grep "STATUS:" "$SOUL" 2>/dev/null | head -1 || echo "UNSET")
  if echo "$soul_status" | grep -q "UNSET"; then
    warn "No goal defined in SOUL.md — running DISCUSS phase first"
    echo ""
    run_discuss
    echo ""
  fi

  # 4. Print status before launch
  print_status

  # 5. Detect CLI
  local cli
  cli=$(detect_cli "$cli_arg")
  log "Using CLI: ${BOLD}$cli${RESET}"

  # 6. Launch
  echo ""
  log "Launching $cli with full Thanos context (all 6 stones loaded)..."
  echo -e "${DIM}The agent will run the full loop: Discuss → Plan → Execute → Verify → Critique → Learn → Snap${RESET}"
  echo ""

  case "$cli" in
    claude)  launch_claude  "$goal_arg" ;;
    codex)   launch_codex   "$goal_arg" ;;
    gemini)  launch_gemini  "$goal_arg" ;;
    aider)   launch_aider   "$goal_arg" ;;
    *)
      # Generic: just pass the system prompt as first message
      log "Generic CLI: $cli — passing system prompt as context file"
      local sys_prompt
      sys_prompt=$(build_system_prompt "$goal_arg")
      echo "$sys_prompt" > "$THANOS_DIR/SYSTEM_PROMPT.md"
      log "System prompt saved to .thanos/SYSTEM_PROMPT.md"
      log "Pass this to your CLI: $cli < .thanos/SYSTEM_PROMPT.md"
      ;;
  esac
}

main "$@"
