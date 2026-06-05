# 🧤 THE GAUNTLET — 3-Agent Critic Protocol

This document defines how the three-agent system operates. Reference this when setting up Thanos in a new environment.

---

## Agent 1: The Architect (Main)

**Model:** Claude Opus 4 / o3 / Gemini 2.5 Pro  
**Token budget:** Unlimited (it plans, it doesn't execute)  
**Context:** Reads all 6 stones every loop. Maintains full project understanding.

**Responsibilities:**
- Runs the DISCUSS phase — asks deep questions until the real goal is known
- Writes SOUL.md goal and stop condition
- Plans phases and writes SPACE.md queue
- Reads MIND.md critic report and decides: fix or snap
- Runs Hermes learning cycle after each critic check
- Makes the final SNAP decision

**Never does:** Write production code, run shell commands, produce output files.

---

## Agent 2: The Builder (Sub)

**Model:** Claude Sonnet 4.5 / GPT-4.1 / Gemini 2.5 Flash  
**Token budget:** Per-task scoped (fresh context per execution)  
**Context:** Receives task description + relevant file context only.

**Responsibilities:**
- Executes one scoped task at a time
- Writes/edits files
- Runs shell commands (build, test, lint)
- Writes exit codes and results to POWER.md
- Updates REALITY.md with changed files

**Never does:** Decide what to build, evaluate quality, make architectural decisions.

**Power Stone Protocol (after every action):**
```bash
# Run verifier and capture result
{VERIFIER_COMMAND} 2>&1 | tee .thanos/power_output.txt
echo "EXIT: $?" >> .thanos/power_output.txt

# Write to POWER.md
echo "Loop {N} — $(date)" >> .thanos/POWER.md
echo "Command: {VERIFIER_COMMAND}" >> .thanos/POWER.md
cat .thanos/power_output.txt >> .thanos/POWER.md
```

---

## Agent 3: The Critic (Cold)

**Model:** Claude Haiku 3.5 / GPT-4o-mini / Gemini 2.0 Flash-Lite  
**Token budget:** Minimal (fast and cheap — runs every loop)  
**Context:** ZERO loop history. Current filesystem state + MIND.md rubric only.

**The Golden Rule:** The critic has never seen this project before. It judges what exists RIGHT NOW against the goal in SOUL.md. Memory of previous loops is not allowed — this prevents the model from grading its own past work leniently.

**Scoring Rubric:**

```
Logic Correctness (0-100)
  100: Perfectly implements the stated goal
   90: Works correctly, minor edge cases missing
   80: Core logic correct, some error cases unhandled  
   <80: Functional bugs present → BLOCKING
   <95: Loop continues

Code Quality (0-100)
  100: Clean, idiomatic, well-named, DRY
   90: Good quality, minor improvements possible
   80: Works but has code smells
   <80: Significant refactor needed → BLOCKING
   <95: Loop continues

Test Coverage (0-100)
  100: All paths covered, meaningful assertions, edge cases
   90: Good coverage, minor gaps
   80: Happy path covered, edge cases missing
   <80: Insufficient tests → BLOCKING
   <95: Loop continues

Visual/UI Proof (0-100 or SKIP if no UI changes)  ── REDEFINED in v3 ──
  A screenshot is the EVIDENCE, not the score. Existence of a PNG proves the page
  rendered; it says NOTHING about whether the design is good. The score measures
  how well you can JUSTIFY the visual result against the goal.

     0: UI change made but NO visual proof (.thanos/proof/*.png) → ALWAYS BLOCKING
   1-30: A PNG exists but the critique is "a screenshot is present" with no design
         reasoning. Mere existence caps here. Still BLOCKING (< 95).
  31-70: PNG present AND you confirm it renders correctly (no overflow, no broken
         layout, content visible) — but you have NOT articulated why it is GOOD.
  71-94: PNG present AND you articulate SPECIFIC design strengths and weaknesses:
         visual hierarchy, spacing rhythm, contrast/legibility, alignment, balance,
         responsive behavior — citing what you see in the image.
  95-100: PNG present AND a thorough, evidence-based justification of why the design
         achieves the goal: every claim ties to something visible in the screenshot,
         weaknesses are named and judged non-blocking. "It looks fine" never scores here.
  SKIP: No UI changes in this loop

  RULE: You may NOT raise this score just because a PNG exists. If you cannot point
  to specific, visible design qualities in the proof image, the score stays ≤ 30.

Security (0-100)
  100: No vulnerabilities, secrets safe, inputs sanitized
   90: No critical issues, minor hardening possible
   <80: Potential vulnerability → BLOCKING
   <95: Loop continues

Performance (0-100)
  100: Optimal for the use case
   90: Good performance, minor optimizations possible  
   <80: Noticeable performance issue → BLOCKING
   <95: Loop continues
```

**Verdict Logic:**
```
IF all scores ≥ 95:
    Verdict = "SNAP ✅"
ELSE:
    Verdict = "LOOP AGAIN ↩"
    List all scores < 95 with specific file:line issues
    Prioritize: Logic > Security > Coverage > Visual > Quality > Performance
```

---

## The Socket — Capabilities (v3)

The Gauntlet is the glove that holds the stones. In v3 it also exposes a **socket** that
capabilities plug into for the current goal — without adding a 7th stone.

```
        ┌─────────────────────── THE GAUNTLET ───────────────────────┐
        │  🟠SOUL 🔴REALITY 💜POWER 🔵TIME 🔷SPACE 🟡MIND              │
        │                                                            │
        │   ┌──────── SOCKET (MOBILIZE) ────────┐                    │
        │   │ capabilities/manifest.json (catalog)│  ← Architect reads │
        │   │ skills/<id>/SKILL.md   (guidance)   │  → picks SEMANTICALLY│
        │   │ tools/<id>.sh --detect (gate+invoke)│  → detect or BLOCK  │
        │   └──────────────┬─────────────────────┘                    │
        │                  ▼                                          │
        │         .thanos/MOBILIZED.md  → injected into agent context │
        │         .thanos/proof/*       → evidence for POWER / MIND   │
        └────────────────────────────────────────────────────────────┘
```

**Registry contract:**
- The **Architect** chooses skills *semantically* from the catalog (never keyword routing).
- `thanos.sh --mobilize "<ids>"` builds `MOBILIZED.md` and runs each skill's required
  `tools/<id>.sh --detect`.
- A failed `--detect` is a **blocking dependency** written to `SPACE.md` — install-or-skip with the
  user. The harness never silently proceeds with a missing tool.
- When nothing in the catalog fits the goal, the socket stays empty and Thanos runs vanilla.

---

## The Gauntlet Flow (Visual)

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  LOOP N                                                         │
│                                                                 │
│  ┌──────────┐    task     ┌──────────┐    proof    ┌─────────┐ │
│  │          │────────────►│          │────────────►│         │ │
│  │ ARCHITECT│             │ BUILDER  │             │  POWER  │ │
│  │  (Main)  │◄────────────│  (Sub)   │◄────────────│  STONE  │ │
│  │          │  plan next  │          │   exit 0?   │  check  │ │
│  └────┬─────┘             └──────────┘             └─────────┘ │
│       │                                                         │
│       │  all green                                              │
│       ▼                                                         │
│  ┌──────────┐   score                                          │
│  │  CRITIC  │──────────► < 95 anywhere? ──────────► LOOP AGAIN │
│  │  (Cold)  │                                            │      │
│  │  Haiku/  │           all ≥ 95?                        │      │
│  │  Mini    │──────────► SNAP ✅                          │      │
│  └──────────┘                                            │      │
│       ▲                                                  │      │
│       │                  HERMES: learn from failure ◄────┘      │
│       │                  write anti-rule to THANOS.md           │
│       │                  update TIME.md                         │
│       │                  back to ARCHITECT with issues          │
│       └──────────────────────────────────────────────────────── │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Multi-CLI Setup Examples

### Claude Code
```bash
# AGENTS.md or .claude/agents/ directory
# Thanos activates automatically when skill is in .agents/skills/thanos/
claude "THANOS: implement feature X with full test coverage"
```

### Codex CLI
```bash
# SKILL.md is loaded automatically from .agents/skills/ 
codex /goal "implement feature X — done when npm test exits 0 and coverage > 90%"
```

### Gemini CLI
```bash
# Paste THANOS.md content into system prompt or use --system flag
gemini --system "$(cat THANOS.md)" "implement feature X"
```

### Running the Critic Separately
```bash
# Spawn critic as a one-shot invocation with cold context
claude --model claude-haiku-3-5 \
  --system "$(cat GAUNTLET.md | grep -A 50 'Critic Agent Prompt')" \
  "Review the current repository state and score it. Write results to .thanos/MIND.md"
```
