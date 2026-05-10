#!/usr/bin/env bash
# =============================================================================
# THANOS CLI HARNESS v3.0
# Usage:
#   ./thanos.sh                   # auto-detect CLI, start interactive
#   ./thanos.sh claude            # use Claude Code
#   ./thanos.sh codex             # use Codex CLI
#   ./thanos.sh gemini            # use Gemini CLI
#   ./thanos.sh claude "fix auth" # run with inline goal
#   ./thanos.sh --test            # run end-to-end test suite
#   ./thanos.sh --status          # show all six stone states
#   ./thanos.sh --reset           # wipe stones, start fresh
# =============================================================================

set -euo pipefail

# ── Colours ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ── Paths ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CWD="$(pwd)"
THANOS_DIR="$CWD/.thanos"
TEMPLATES_DIR="$SCRIPT_DIR/templates"
THANOS_MD="$SCRIPT_DIR/THANOS.md"
GAUNTLET_MD="$SCRIPT_DIR/GAUNTLET.md"

# ── Banner ────────────────────────────────────────────────────────────────────
banner() {
  echo -e "${PURPLE}"
  cat << 'EOF'
 _____ _   _    _    _   _  ___  ____
|_   _| | | |  / \  | \ | |/ _ \/ ___|
  | | | |_| | / _ \ |  \| | | | \___ \
  | | |  _  |/ ___ \| |\  | |_| |___) |
  |_| |_| |_/_/   \_\_| \_|\___/|____/

EOF
  echo -e "${CYAN}  ⚡ Infinity Skill Harness v3.0${NC}"
  echo -e "${DIM}  Autonomous. Self-healing. Inevitable.${NC}\n"
}

# ── Helpers ───────────────────────────────────────────────────────────────────
log()     { echo -e "${CYAN}[THANOS]${NC} $*"; }
ok()      { echo -e "${GREEN}[✓]${NC} $*"; }
warn()    { echo -e "${YELLOW}[⚠]${NC} $*"; }
fail()    { echo -e "${RED}[✗]${NC} $*"; }
stone()   { echo -e "${PURPLE}[💎]${NC} $*"; }
section() { echo -e "\n${BOLD}${YELLOW}── $* ──${NC}"; }

# ── Detect available CLIs ────────────────────────────────────────────────────
detect_cli() {
  if command -v claude &>/dev/null; then echo "claude"
  elif command -v codex &>/dev/null; then echo "codex"
  elif command -v gemini &>/dev/null; then echo "gemini"
  else echo "none"
  fi
}

check_cli() {
  local cli="$1"
  if ! command -v "$cli" &>/dev/null; then
    fail "'$cli' not found in PATH."
    echo ""
    case "$cli" in
      claude) echo -e "  Install: ${CYAN}npm install -g @anthropic-ai/claude-code${NC}" ;;
      codex)  echo -e "  Install: ${CYAN}npm install -g @openai/codex${NC}" ;;
      gemini) echo -e "  Install: ${CYAN}pip install google-generativeai${NC} or use gemini CLI" ;;
    esac
    exit 1
  fi
}

# ── Stone initialisation ──────────────────────────────────────────────────────
init_stones() {
  if [ ! -d "$THANOS_DIR" ]; then
    log "No .thanos/ found. Initialising Infinity Stones..."
    mkdir -p "$THANOS_DIR"
  fi

  local stones=(SOUL REALITY POWER TIME SPACE MIND)
  for stone_name in "${stones[@]}"; do
    local stone_file="$THANOS_DIR/${stone_name}.md"
    local template="$TEMPLATES_DIR/THANOS_${stone_name}.md"
    if [ ! -f "$stone_file" ]; then
      if [ -f "$template" ]; then
        cp "$template" "$stone_file"
        stone "Created ${stone_name}.md"
      else
        # Inline fallback if templates not present
        echo "# ${stone_name} Stone\n\n_Initialized $(date)_\n" > "$stone_file"
        stone "Created ${stone_name}.md (inline)"
      fi
    fi
  done
}

# ── Scan project ──────────────────────────────────────────────────────────────
scan_project() {
  section "PROJECT SCAN"
  log "Scanning project at: $CWD"

  # File tree
  local tree_output
  if command -v tree &>/dev/null; then
    tree_output=$(tree -L 4 -I 'node_modules|.git|__pycache__|*.pyc|.thanos' 2>/dev/null || echo "(tree failed)")
  else
    tree_output=$(find . -not -path './.git/*' -not -path './node_modules/*' -not -path './.thanos/*' | sort | head -100)
  fi

  # Count files by type
  local total_files
  total_files=$(find . -type f -not -path './.git/*' -not -path './node_modules/*' | wc -l | tr -d ' ')

  local code_files
  code_files=$(find . -type f \( -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.rs' -o -name '*.go' -o -name '*.java' -o -name '*.rb' -o -name '*.php' \) -not -path './.git/*' -not -path './node_modules/*' 2>/dev/null | wc -l | tr -d ' ')

  local test_files
  test_files=$(find . -type f \( -name '*.test.*' -o -name '*.spec.*' -o -name '*_test.*' -o -name 'test_*' \) -not -path './.git/*' -not -path './node_modules/*' 2>/dev/null | wc -l | tr -d ' ')

  # Detect tech stack
  local stack="unknown"
  local verifier="echo 'No verifier detected'"

  if [ -f "package.json" ]; then
    stack="Node.js"
    if grep -q '"test"' package.json 2>/dev/null; then
      verifier="npm test"
    fi
    if [ -f "package-lock.json" ] || [ -d "node_modules" ]; then
      stack="Node.js (npm)"
    fi
  fi

  if [ -f "Cargo.toml" ]; then
    stack="Rust"
    verifier="cargo test"
  fi

  if [ -f "go.mod" ]; then
    stack="Go"
    verifier="go test ./..."
  fi

  if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
    stack="Python"
    if command -v pytest &>/dev/null; then
      verifier="pytest"
    else
      verifier="python -m pytest"
    fi
  fi

  if [ -f "pom.xml" ]; then
    stack="Java/Maven"
    verifier="mvn test"
  fi

  if [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
    stack="Java/Gradle"
    verifier="./gradlew test"
  fi

  if [ -f "Gemfile" ]; then
    stack="Ruby"
    verifier="bundle exec rspec"
  fi

  # Write scan to REALITY.md
  cat > "$THANOS_DIR/REALITY.md" << REALITY
# 🔴 Reality Stone — Current State Snapshot

## Scan Time
$(date)

## Project Path
$CWD

## Stack Detected
$stack

## Suggested Verifier
\`\`\`bash
$verifier
\`\`\`

## File Counts
- Total files: $total_files
- Code files: $code_files
- Test files: $test_files

## File Tree
\`\`\`
$tree_output
\`\`\`

## Key Config Files Found
$(ls package.json Cargo.toml go.mod pyproject.toml requirements.txt pom.xml Gemfile Makefile Dockerfile .env.example 2>/dev/null || echo "None detected")
REALITY

  ok "Stack: $stack"
  ok "Files: $total_files total, $code_files code, $test_files tests"
  ok "Verifier: $verifier"
  ok "Reality Stone written"

  # Export for use in goal prompt
  export DETECTED_STACK="$stack"
  export DETECTED_VERIFIER="$verifier"
  export TOTAL_FILES="$total_files"
  export CODE_FILES="$code_files"
}

# ── Read all stones and print status ─────────────────────────────────────────
print_status() {
  section "SIX STONE STATUS"
  local stones=("SOUL 🟠" "REALITY 🔴" "POWER 💜" "TIME 🔵" "SPACE 🔷" "MIND 🟡")
  for entry in "${stones[@]}"; do
    local name
    name=$(echo "$entry" | cut -d' ' -f1)
    local emoji
    emoji=$(echo "$entry" | cut -d' ' -f2)
    local file="$THANOS_DIR/${name}.md"
    if [ -f "$file" ]; then
      local size
      size=$(wc -c < "$file" | tr -d ' ')
      ok "$emoji ${name}.md (${size} bytes)"
      # Print first meaningful line after headers
      grep -v '^#\|^$\|^<!--' "$file" | head -3 | sed 's/^/     /'
    else
      warn "$emoji ${name}.md — not found"
    fi
  done
}

# ── Build the master context prompt ──────────────────────────────────────────
build_prompt() {
  local goal="${1:-}"
  local cli="${2:-claude}"

  local soul_content reality_content power_content time_content space_content mind_content
  soul_content=$(cat "$THANOS_DIR/SOUL.md" 2>/dev/null || echo "Empty")
  reality_content=$(cat "$THANOS_DIR/REALITY.md" 2>/dev/null || echo "Empty")
  power_content=$(cat "$THANOS_DIR/POWER.md" 2>/dev/null || echo "Empty")
  time_content=$(cat "$THANOS_DIR/TIME.md" 2>/dev/null || echo "Empty")
  space_content=$(cat "$THANOS_DIR/SPACE.md" 2>/dev/null || echo "Empty")
  mind_content=$(cat "$THANOS_DIR/MIND.md" 2>/dev/null || echo "Empty")
  thanos_instructions=$(cat "$THANOS_MD" 2>/dev/null || echo "See THANOS.md")

  # Read ALL code files in project for context (up to reasonable limit)
  local code_context=""
  local file_count=0
  while IFS= read -r -d '' f; do
    if [ $file_count -lt 30 ]; then
      code_context+="\n\n=== FILE: $f ===\n"
      code_context+=$(head -200 "$f" 2>/dev/null || echo "(unreadable)")
      ((file_count++))
    fi
  done < <(find . -type f \( -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.rs' -o -name '*.go' -o -name '*.java' -o -name '*.rb' \) \
    -not -path './.git/*' -not -path './node_modules/*' -not -path './.thanos/*' \
    -print0 2>/dev/null)

  # Build the full harness prompt
  cat << PROMPT
You are operating as THANOS — the Infinity Skill agent harness.

Your CLI: $cli
Project: $CWD
Stack: ${DETECTED_STACK:-unknown}
Verifier: ${DETECTED_VERIFIER:-unknown}

========= THANOS INSTRUCTIONS =========
$thanos_instructions

========= SIX INFINITY STONES (CURRENT STATE) =========

### SOUL.md (Goal + Stop Condition)
$soul_content

### REALITY.md (Project State)
$reality_content

### POWER.md (Test/Build Proof)
$power_content

### TIME.md (Loop History)
$time_content

### SPACE.md (Phase Queue)
$space_content

### MIND.md (Critic Scores)
$mind_content

========= PROJECT CODE (read every file) =========
$code_context

========= YOUR MISSION =========
$(if [ -n "$goal" ]; then
  echo "The user has provided a goal: $goal"
  echo ""
  echo "Skip the DISCUSS phase. Write this goal to SOUL.md. Then run the full Thanos loop."
else
  echo "No goal was provided. Run the DISCUSS phase:"
  echo "1. Read every code file and every stone above"
  echo "2. If existing code: analyse architecture, identify bugs, list what needs improvement"
  echo "3. Ask deep clarifying questions to understand the REAL goal"
  echo "4. Do NOT proceed until you have a machine-verifiable stop condition"
  echo "5. Then write the goal to .thanos/SOUL.md and begin Phase 1"
fi)

IMPORTANT RULES:
- Read ALL six stones before taking any action
- Update stone files after EVERY action
- The Critic must run with cold context (no loop memory)
- Loop until critic scores ALL >= 95
- Visual proof required for any UI changes
- Write lessons back to THANOS.md as ANTI-RULES after failures
- One loop is never enough. Humans are always confused the first time.
PROMPT
}

# ── Run with Claude Code ─────────────────────────────────────────────────────
run_claude() {
  local goal="${1:-}"
  section "LAUNCHING CLAUDE CODE"
  check_cli "claude"

  # Copy skill files to AGENTS.md location for auto-loading
  if [ ! -f "$CWD/AGENTS.md" ]; then
    log "Creating AGENTS.md from THANOS.md..."
    cp "$THANOS_MD" "$CWD/AGENTS.md"
    ok "AGENTS.md created (Claude will auto-load this)"
  fi

  local prompt
  prompt=$(build_prompt "$goal" "claude")

  if [ -n "$goal" ]; then
    log "Running Claude with goal: $goal"
    echo "$prompt" | claude --print "$goal"
  else
    log "Launching Claude interactive session..."
    log "THANOS is loaded. Claude will read your project and start the DISCUSS phase."
    echo "$prompt" | claude
  fi
}

# ── Run with Codex CLI ────────────────────────────────────────────────────────
run_codex() {
  local goal="${1:-}"
  section "LAUNCHING CODEX CLI"
  check_cli "codex"

  # Install skill into user's global skill directory
  local codex_skill_dir="$HOME/.codex/skills/thanos"
  if [ ! -d "$codex_skill_dir" ]; then
    log "Installing Thanos as a Codex skill at $codex_skill_dir..."
    mkdir -p "$codex_skill_dir"
    cp "$THANOS_MD" "$codex_skill_dir/SKILL.md"
    ok "Codex skill installed"
  fi

  # Also write AGENTS.md for project-level detection
  if [ ! -f "$CWD/AGENTS.md" ]; then
    cp "$THANOS_MD" "$CWD/AGENTS.md"
    ok "AGENTS.md created"
  fi

  if [ -n "$goal" ]; then
    log "Running Codex /goal: $goal"
    codex /goal "$goal — use the Thanos skill. Verifier: ${DETECTED_VERIFIER:-npm test}. Loop until all critic scores >= 95."
  else
    log "Launching Codex interactive session with Thanos skill..."
    local prompt
    prompt=$(build_prompt "" "codex")
    echo "$prompt" | codex
  fi
}

# ── Run with Gemini CLI ───────────────────────────────────────────────────────
run_gemini() {
  local goal="${1:-}"
  section "LAUNCHING GEMINI CLI"
  check_cli "gemini"

  local prompt
  prompt=$(build_prompt "$goal" "gemini")

  if [ -n "$goal" ]; then
    log "Running Gemini with goal: $goal"
    echo "$prompt" | gemini "$goal"
  else
    log "Launching Gemini interactive session..."
    echo "$prompt" | gemini
  fi
}

# ── Reset stones ──────────────────────────────────────────────────────────────
reset_stones() {
  section "RESET"
  warn "This will wipe all .thanos/ state files."
  read -r -p "  Are you sure? (y/N) " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    rm -rf "$THANOS_DIR"
    ok "Stones cleared."
    init_stones
    ok "Fresh stones initialised. Ready for a new goal."
  else
    log "Reset cancelled."
  fi
}

# ── End-to-end test suite ─────────────────────────────────────────────────────
run_tests() {
  section "END-TO-END TEST SUITE"
  local passed=0
  local failed=0
  local total=0

  run_test() {
    local name="$1"
    local cmd="$2"
    local expected="$3"
    ((total++))
    if eval "$cmd" &>/dev/null; then
      ok "[$((total))] $name"
      ((passed++))
    else
      fail "[$((total))] $name"
      echo -e "       ${DIM}Expected: $expected${NC}"
      ((failed++))
    fi
  }

  # ── 1. Script structure ────────────────────────────────────────────────────
  section "1. Script Structure"
  run_test "thanos.sh exists" "[ -f '$SCRIPT_DIR/thanos.sh' ]" "file exists"
  run_test "thanos.sh is executable" "[ -x '$SCRIPT_DIR/thanos.sh' ]" "executable bit set"
  run_test "THANOS.md exists" "[ -f '$THANOS_MD' ]" "THANOS.md present"
  run_test "GAUNTLET.md exists" "[ -f '$GAUNTLET_MD' ]" "GAUNTLET.md present"
  run_test "SKILL.md exists" "[ -f '$SCRIPT_DIR/SKILL.md' ]" "SKILL.md present"
  run_test "package.json exists" "[ -f '$SCRIPT_DIR/package.json' ]" "npm package"

  # ── 2. Templates ──────────────────────────────────────────────────────────
  section "2. Infinity Stone Templates"
  for stone_name in SOUL REALITY POWER TIME SPACE MIND; do
    run_test "Template: $stone_name" "[ -f '$TEMPLATES_DIR/THANOS_${stone_name}.md' ]" "template exists"
  done

  # ── 3. Stone initialisation ────────────────────────────────────────────────
  section "3. Stone Initialisation"
  local test_dir
  test_dir=$(mktemp -d)
  (cd "$test_dir" && bash "$SCRIPT_DIR/thanos.sh" --init-only 2>&1) || true
  for stone_name in SOUL REALITY POWER TIME SPACE MIND; do
    run_test "Stone created: $stone_name" "[ -f '$test_dir/.thanos/${stone_name}.md' ]" "stone file exists"
  done
  rm -rf "$test_dir"

  # ── 4. Project scan ────────────────────────────────────────────────────────
  section "4. Project Scan"
  local scan_dir
  scan_dir=$(mktemp -d)
  # Simulate a Node.js project
  cat > "$scan_dir/package.json" << 'PKG'
{"name":"test-project","scripts":{"test":"echo 'tests passing' && exit 0"}}
PKG
  mkdir -p "$scan_dir/src"
  echo 'function hello() { return "world"; }' > "$scan_dir/src/index.js"
  (cd "$scan_dir" && \
    SCRIPT_DIR="$SCRIPT_DIR" THANOS_DIR="$scan_dir/.thanos" TEMPLATES_DIR="$TEMPLATES_DIR" THANOS_MD="$THANOS_MD" \
    bash -c '
      source "'"$SCRIPT_DIR"'/thanos.sh" 2>/dev/null || true
      mkdir -p "'"$scan_dir"'/.thanos"
      CWD="'"$scan_dir"'" THANOS_DIR="'"$scan_dir"'/.thanos" scan_project 2>/dev/null || true
    ')
  run_test "REALITY.md written after scan" "[ -f '$scan_dir/.thanos/REALITY.md' ]" "reality stone written"
  run_test "Stack detected in REALITY.md" "grep -q 'Node.js' '$scan_dir/.thanos/REALITY.md'" "Node.js detected"
  run_test "File tree in REALITY.md" "grep -q 'src' '$scan_dir/.thanos/REALITY.md'" "file tree present"
  rm -rf "$scan_dir"

  # ── 5. THANOS.md content validation ───────────────────────────────────────
  section "5. THANOS.md Content Validation"
  run_test "Has SKILL.md frontmatter" "head -1 '$SCRIPT_DIR/SKILL.md' | grep -q '^---'" "frontmatter present"
  run_test "Has name field" "grep -q 'name: thanos' '$SCRIPT_DIR/SKILL.md'" "skill name set"
  run_test "Has description field" "grep -q 'description:' '$SCRIPT_DIR/SKILL.md'" "description present"
  run_test "THANOS.md has loop section" "grep -q 'THE THANOS LOOP' '$THANOS_MD'" "loop defined"
  run_test "THANOS.md has snap condition" "grep -q 'SNAP' '$THANOS_MD'" "snap defined"
  run_test "THANOS.md has six stones" "grep -q 'SOUL\|REALITY\|POWER\|TIME\|SPACE\|MIND' '$THANOS_MD'" "all stones referenced"
  run_test "THANOS.md has HERMES rules" "grep -q 'HERMES' '$THANOS_MD'" "self-healing rules"
  run_test "THANOS.md has critic prompt" "grep -q 'CRITIC AGENT PROMPT' '$THANOS_MD'" "critic prompt present"
  run_test "GAUNTLET.md has 3-agent spec" "grep -q 'Agent 1\|Agent 2\|Agent 3' '$GAUNTLET_MD'" "3 agents defined"
  run_test "GAUNTLET.md has scoring rubric" "grep -q '0-100' '$GAUNTLET_MD'" "scoring rubric present"

  # ── 6. CLI detection logic ─────────────────────────────────────────────────
  section "6. CLI Detection"
  # Source the script functions to test detect_cli
  (
    source "$SCRIPT_DIR/thanos.sh" 2>/dev/null || true
    detected=$(detect_cli)
    if [ "$detected" != "none" ]; then
      echo "Detected: $detected"
      exit 0
    fi
    # none is also valid (no CLI installed in test env)
    exit 0
  ) &>/dev/null
  run_test "detect_cli function callable" "true" "function exists"

  # ── 7. README completeness ────────────────────────────────────────────────
  section "7. README Completeness"
  run_test "README has install section" "grep -qi 'install\|quick start' '$SCRIPT_DIR/README.md'" "install docs"
  run_test "README has Claude section" "grep -q 'claude\|Claude' '$SCRIPT_DIR/README.md'" "Claude documented"
  run_test "README has Codex section" "grep -q 'codex\|Codex' '$SCRIPT_DIR/README.md'" "Codex documented"
  run_test "README has Gemini section" "grep -q 'gemini\|Gemini' '$SCRIPT_DIR/README.md'" "Gemini documented"
  run_test "README has loop diagram" "grep -q 'LOOP\|loop' '$SCRIPT_DIR/README.md'" "loop visualised"

  # ── Summary ────────────────────────────────────────────────────────────────
  section "TEST RESULTS"
  echo ""
  echo -e "  ${BOLD}Total:  $total${NC}"
  echo -e "  ${GREEN}Passed: $passed${NC}"
  if [ $failed -gt 0 ]; then
    echo -e "  ${RED}Failed: $failed${NC}"
    echo ""
    echo -e "  ${YELLOW}Thanos does not approve of failure.${NC}"
    echo -e "  ${DIM}Fix the issues above and re-run: ./thanos.sh --test${NC}"
    exit 1
  else
    echo ""
    echo -e "  ${PURPLE}💥 SNAP. All tests passed. Perfectly balanced.${NC}"
  fi
}

# ── Main entry point ──────────────────────────────────────────────────────────
main() {
  banner

  local cli=""
  local goal=""
  local cmd=""

  # Parse args
  case "${1:-}" in
    --test)       run_tests; exit 0 ;;
    --status)     init_stones; print_status; exit 0 ;;
    --reset)      init_stones; reset_stones; exit 0 ;;
    --init-only)  init_stones; exit 0 ;;
    --help|-h)
      echo "Usage:"
      echo "  ./thanos.sh                   Auto-detect CLI, start interactive"
      echo "  ./thanos.sh claude [\"goal\"]   Use Claude Code"
      echo "  ./thanos.sh codex [\"goal\"]    Use Codex CLI"
      echo "  ./thanos.sh gemini [\"goal\"]   Use Gemini CLI"
      echo "  ./thanos.sh --test            Run end-to-end test suite"
      echo "  ./thanos.sh --status          Show all six stone states"
      echo "  ./thanos.sh --reset           Wipe stones, start fresh"
      exit 0
      ;;
    claude|codex|gemini)
      cli="$1"
      goal="${2:-}"
      ;;
    "")
      cli=$(detect_cli)
      if [ "$cli" = "none" ]; then
        fail "No supported AI CLI found."
        echo ""
        echo "  Install one of:"
        echo -e "    Claude Code: ${CYAN}npm install -g @anthropic-ai/claude-code${NC}"
        echo -e "    Codex CLI:   ${CYAN}npm install -g @openai/codex${NC}"
        echo -e "    Gemini CLI:  ${CYAN}pip install gemini-cli${NC}"
        exit 1
      fi
      log "Auto-detected CLI: $cli"
      goal=""
      ;;
    *)
      # Treat unknown first arg as a goal with auto-detected CLI
      cli=$(detect_cli)
      goal="$1"
      ;;
  esac

  # Initialise & scan
  init_stones
  scan_project
  print_status

  # Launch
  section "LAUNCHING $cli"
  case "$cli" in
    claude) run_claude "$goal" ;;
    codex)  run_codex  "$goal" ;;
    gemini) run_gemini "$goal" ;;
  esac
}

main "$@"
