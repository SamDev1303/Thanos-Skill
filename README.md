```
┌──────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  ████████╗██╗  ██╗ █████╗ ███╗   ██╗ ██████╗ ███████╗         │
│     ██╔══╝██║  ██║██╔══██╗████╗  ██║██╔═══██╗██╔════╝         │
│     ██║   ███████║███████║██╔██╗ ██║██║   ██║███████╗         │
│     ██║   ██╔══██║██╔══██║██║╚██╗██║██║   ██║╚════██║         │
│     ██║   ██║  ██║██║  ██║██║ ╚████║╚██████╔╝███████║         │
│     ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝         │
│                                                                          │
│  T H E   I N F I N I T Y   A G E N T   H A R N E S S                    │
│                                                                          │
│  🟠 SOUL  🔴 REALITY  💜 POWER  🔵 TIME  🔷 SPACE  🟡 MIND               │
│                                                                          │
│  Autonomous. Self-healing. Ruthlessly correct.                           │
│  Works with: Claude • Codex • Gemini • Aider • any CLI agent          │
└──────────────────────────────────────────────────────────────────────────┘
```

[![CI](https://github.com/SamDev1303/Thanos-Skill/actions/workflows/test.yml/badge.svg)](https://github.com/SamDev1303/Thanos-Skill/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Works with Claude](https://img.shields.io/badge/Claude-Opus%20%7C%20Sonnet-8B5CF6)](https://claude.ai)
[![Works with Codex](https://img.shields.io/badge/OpenAI-Codex%20CLI-10A37F)](https://github.com/openai/codex)
[![Works with Gemini](https://img.shields.io/badge/Gemini-2.5%20Pro-4285F4)](https://gemini.google.com)

---

> **"I am inevitable."**
> 
> Thanos is an autonomous agent harness that loops relentlessly until your goal is achieved with machine-verifiable proof. It combines four battle-tested patterns — `/goals`, GSD phases, the Ralph Loop, and Hermes self-healing — into a single CLI you can drop into any project.

---

## ⚡ One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/SamDev1303/Thanos-Skill/main/install.sh | bash
```

Or with npm:

```bash
npx thanos-skill
```

---

## 🚀 Quick Start

```bash
# Open ANY project folder and run:
cd your-project
thanos

# Thanos will:
# 1. Scan EVERY file in your project
# 2. Ask you the REAL goal (not the surface ask)
# 3. Launch your installed CLI (Claude / Codex / Gemini)
# 4. Loop until machine-verifiable proof of completion
# 5. Self-heal and learn from every failure
```

### Specific CLIs

```bash
thanos claude                        # Claude Code
thanos codex "fix the auth module"   # Codex with inline goal
thanos gemini                        # Gemini CLI
thanos aider                         # Aider
```

---

## 🌌 The Six Infinity Stones

Thanos tracks all state in six persistent Markdown files inside `.thanos/`. These survive crashes, context resets, and restarts.

```
.thanos/
├── SOUL.md     🟠  Active goal + stop condition + assumptions
├── REALITY.md  🔴  Every file in your project, read into agent context
├── POWER.md    💜  Test/build/lint exit codes + pass rates
├── TIME.md     🔵  Loop history + Hermes lessons (grows automatically)
├── SPACE.md    🔷  Phase queue + task backlog + blockers
└── MIND.md     🟡  Critic scores (0–100) + visual proof log
```

| Stone | Role | Written by |
|-------|------|------------|
| 🟠 SOUL | The goal. The stop condition. The truth. | Discuss phase (you + agent) |
| 🔴 REALITY | Full code scan — every file, every line | Auto-scanned at launch |
| 💜 POWER | Machine proof — exit codes, test output | Sub agent after each action |
| 🔵 TIME | Loop history + injected anti-rules | Hermes after each loop |
| 🔷 SPACE | Phase queue, what’s done, what’s next | Main agent during planning |
| 🟡 MIND | Critic scores. The hardest reviewer. | Critic agent (smallest model) |

---

## 🔄 The Thanos Loop

```
┌───────────────────────────────────────────────────────────────────┐
│                    THANOS LOOP                              │
└───────────────────────────────────────────────────────────────────┘

  ┌────────────────────────────────────────────────────────────┐
  │ 1. READ ALL 6 STONES   (SOUL•REALITY•POWER•TIME•SPACE•MIND) │
  └────────────────────────────────────────────────────────────┘
                              │
  ┌────────────────────────────────────────────────────────────┐
  │ 2. DISCUSS  🎯 Deep Q&A session — find the REAL goal         │
  │            One loop is never enough. Keep asking.          │
  └────────────────────────────────────────────────────────────┘
                              │
  ┌────────────────────────────────────────────────────────────┐
  │ 3. PLAN     📝 Write acceptance criteria BEFORE any code     │
  └────────────────────────────────────────────────────────────┘
                              │
  ┌────────────────────────────────────────────────────────────┐
  │ 3.5 MOBILIZE 🧤 Architect SEMANTICALLY sockets capability   │
  │            skills for the goal → .thanos/MOBILIZED.md       │
  │            Missing tools BLOCK (install-or-skip), not skip. │
  └────────────────────────────────────────────────────────────┘
                              │
  ┌────────────────────────────────────────────────────────────┐
  │ 4. EXECUTE  ⚔️ Sub agent builds. ONE action at a time.       │
  └────────────────────────────────────────────────────────────┘
                              │
  ┌────────────────────────────────────────────────────────────┐
  │ 5. VERIFY   💜 Run tests + lint + build → write POWER.md      │
  └────────────────────────────────────────────────────────────┘
                              │
  ┌────────────────────────────────────────────────────────────┐
  │ 6. CRITIQUE 🟡 Critic agent runs COLD. No loop history.       │
  │            Haiku/Flash-Lite/4o-mini. 6 scores. All ≥ 95.  │
  │            Visual proof required for any UI change.        │
  └────────────────────────────────────────────────────────────┘
                              │
  ┌────────────────────────────────────────────────────────────┐
  │ 7. LEARN    🧬 Hermes injects anti-rules into TIME.md        │
  │            Lessons accumulate. Quality only goes up.       │
  └────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────────────────┐
              │  All scores ≥ 95?           │
              └───────────────────────────┘
              YES ↓                 NO ↩
         💥 SNAP ✔            Back to EXECUTE
         Done. It is           with issues list
         inevitable.           from critic
```

---

## 🧐 The Three Agents

### Main Agent — The Architect

The largest, smartest model available. Reads all six stones, interprets critic verdicts, decides loop/snap/pause. **Never writes production code directly.** This is Thanos himself.

| Platform | Recommended Model |
|----------|------------------|
| Claude | `claude-opus-4` or `claude-sonnet-4-5-20251101` |
| OpenAI | `o3` or `o4-mini` |
| Gemini | `gemini-2.5-pro` |

### Sub Agent — The Builder

A capable mid-tier model. Writes code, runs shell commands, edits files, updates the Power Stone after every action. Executes ONE scoped task per cycle.

| Platform | Recommended Model |
|----------|------------------|
| Claude | `claude-sonnet-4-5` |
| OpenAI | `gpt-4.1` |
| Gemini | `gemini-2.5-flash` |

### Critic Agent — The Ruthless Reviewer

The smallest, fastest, cheapest model. Runs **cold** with zero loop history — sees only the current repository state. Its job is to find every flaw. A score below 95 means the loop continues. **This is the most important agent in the system.**

| Platform | Recommended Model |
|----------|------------------|
| Claude | `claude-haiku-3-5` |
| OpenAI | `gpt-4o-mini` |
| Gemini | `gemini-2.0-flash-lite` |

> **Why the cheapest model as critic?** It runs on EVERY loop. Speed and cost matter. And a cheaper model with no context bias gives you the most honest, unforgiving review. You want it to be hard to impress.

---

## 🧬 Hermes — Self-Healing & Self-Learning

Hermes is the self-improvement protocol embedded in Thanos. After every critic check that results in a LOOP AGAIN verdict, Hermes:

1. **Classifies** the failure: logic / style / perf / security / visual
2. **Checks TIME.md** — has this pattern appeared before?
3. **Injects an ANTI-RULE** into THANOS.md in this format:
   ```
   [ANTI-RULE Loop N]: NEVER {action} because {consequence} — detected by critic in loop N
   ```
4. **Pattern matches** — before the next execution cycle, the main agent reads all accumulated anti-rules and avoids repeat mistakes
5. **Escalates** if the same issue appears 3+ consecutive loops: pauses and asks the human for help

The ANTI-RULES section of THANOS.md **grows automatically** as the system runs. Each project builds its own muscle memory.

---

## 📋 GSD Phase Commands

These commands can be used inside any running agent session:

| Command | Action |
|---------|--------|
| `THANOS:discuss` | Force deep Q&A goal clarification |
| `THANOS:plan` | Write phase plan to SPACE.md |
| `THANOS:execute` | Run one sub-agent execution cycle |
| `THANOS:verify` | Run verifier command, update POWER.md |
| `THANOS:critique` | Spawn critic agent, score, write MIND.md |
| `THANOS:learn` | Run Hermes — inject lessons from this loop |
| `THANOS:snap` | Force-evaluate snap condition |
| `THANOS:status` | Print all six stone summaries |
| `THANOS:reset` | Clear all stones, start fresh |
| `THANOS:pause` | Write pause state, exit cleanly |
| `THANOS:resume` | Read pause state, continue from last checkpoint |

---

## 🧤 Capabilities — the Gauntlet Socket (v3)

Thanos stays the **engine**. Drop-in **capabilities** socket into the Gauntlet for whatever you're
building — **no 7th Infinity Stone**, the canon stays intact.

- **`skills/<id>/SKILL.md`** — original, license-safe best-practice guidance (no upstream IP).
- **`tools/<id>.sh`** — thin adapters that **`--detect`** then invoke a CLI you install **separately**
  (zero license entanglement). Artifacts land in `.thanos/proof/`.
- **`capabilities/manifest.json`** — the **catalog** the Architect reads to choose skills
  **semantically** (judgment, not keyword routing). Nothing fits → vanilla Thanos.

During **MOBILIZE**, the chosen skills are concatenated into `.thanos/MOBILIZED.md` and injected into
the agent's context (the injection hook). Each skill's required tools are **detect-gated** — a missing
tool is a **blocking** dependency written to `SPACE.md` (install-or-skip), never a silent skip.

| Skill | Purpose | Tool(s) | Engine |
|-------|---------|---------|--------|
| `visual-proof` | Real screenshots so UI work has objective proof | `screenshot` | Playwright + python http |
| `design` | Anti-AI-slop craft: hierarchy, spacing, taste | `screenshot` | Playwright + python http |
| `context-graph` | Cheaper/richer REALITY via a code structure map | `graph` | python3 + git |
| `media-comms` | Transcripts, video, email, durable notes | `transcribe` `video` `email` `notes` | Whisper · ffmpeg · react-email · markdown |

```bash
thanos --capabilities              # list installed skills + catalog
thanos --detect screenshot         # detect-gate a tool (exit 0 = ready, non-zero = blocked + hint)
thanos --mobilize "visual-proof"   # socket skills for the goal → .thanos/MOBILIZED.md
```

> Capabilities are **inspired by** the "Tools to build apps" projects — original guidance only, never
> vendored source. See [`docs/CREDITS.md`](docs/CREDITS.md). GPL / non-standard-licensed projects are
> adapter-invoke only. Thanos stays MIT.

---

## 💥 CLI Reference

```bash
thanos                              # auto-detect CLI, run discuss, mobilize, launch
thanos claude                       # Claude Code
thanos claude "build a landing page"# Claude with inline goal (skips discuss)
thanos codex                        # OpenAI Codex CLI
thanos codex "fix the auth module" 
thanos gemini                       # Gemini CLI
thanos aider                        # Aider
thanos --discuss                    # Run Q&A goal clarification only
thanos --mobilize "ids"             # Socket capability skills for the goal
thanos --detect <tool>              # Detect-gate a tool adapter (0 = ready)
thanos --capabilities               # List installed capabilities + catalog
thanos --status                     # Print all six stones
thanos --reset                      # Wipe .thanos/ and start fresh
thanos --resume                     # Resume from last checkpoint
thanos --test                       # Run E2E test suite
thanos --version                    # v3.0.0
thanos --help                       # Full usage
```

---

## 📊 Critic Scoring Rubric

All six scores must reach **≥ 95** before Thanos snaps. This is not negotiable.

| Category | Weight | What the critic checks |
|----------|--------|------------------------|
| Logic Correctness | 20% | Does it actually do what was asked? |
| Code Quality | 20% | DRY, patterns, no anti-patterns, readability |
| Test Coverage | 20% | Edge cases covered, tests are meaningful |
| Visual/UI Proof | 20% | Real screenshot required — and the score measures *justification*, not mere existence (see below) |
| Security | 10% | OWASP Top 10, no secrets, no injection |
| Performance | 10% | No N+1, no blocking I/O, no memory leaks |

**v3 — the Visual rubric is redefined.** A screenshot is the *evidence*, not the score. A bare PNG
caps at **≤ 30** ("proof exists, unjudged"); reaching **≥ 95** requires the critic to justify, from the
actual image, *why* the design works (hierarchy, spacing, contrast, alignment). You may **not** raise
the score just because a PNG exists. (`tools/screenshot.sh` produces the proof; `GAUNTLET.md` holds the
full rubric.)

The critic runs **cold** — no previous loop context. It reads only the current repository state. This is the Ralph Loop’s most important rule: **never let the agent grade its own work from memory.**

---

## 🔮 The Four Inspirations

### `/goals` (OpenAI Codex)

Codex’s `/goal` command attaches a persistent objective to the session. It injects `goals/continuation.md` at the end of every turn to decide whether to loop again, and enforces a token budget via `goals/budget_limit.md`. Thanos extends this with six-stone state, multi-model orchestration, and Hermes self-learning.

### GSD — Get Shit Done

GSD solves context rot by breaking work into scoped phases with their own specs, assumption lists, and acceptance criteria. The flow is always: Discuss → Assumptions → Plan → Execute → Verify → Critique. Thanos uses GSD as the backbone of every loop.

### The Ralph Loop

The Ralph Loop wipes conversation context between iterations so the AI cannot grade its own work from memory. Instead it uses the filesystem, git, and objective machine signals (test exit codes, coverage %, build output) as the only truth. **The critic agent in Thanos IS the Ralph Loop — it runs cold every single time.**

### Hermes (Self-Learning Agent)

Hermes is an agent architecture built for self-improvement. It finds bad patterns, writes them as anti-rules, and reads them back before the next execution cycle. Thanos’ TIME stone and the ANTI-RULES section of THANOS.md implement the Hermes protocol. Quality only ever goes up.

---

## 💾 What Gets Installed

```
~/.local/bin/thanos                    ← global CLI command
~/.agents/skills/thanos/THANOS.md      ← Codex skill loader path
~/.claude/skills/thanos/THANOS.md      ← Claude Code skill path  
~/.codex/skills/thanos/THANOS.md       ← Codex instructions path
```

---

## 📁 Repository Structure

```
Thanos-Skill/
├── thanos.sh          ← Main CLI harness (this is what you run)
├── THANOS.md          ← Agent skill file (embedded into agent context)
├── GAUNTLET.md        ← Deep architecture + the socket + redefined Visual rubric
├── SKILL.md           ← Agent loader frontmatter
├── install.sh         ← One-line global install (stages the socket too)
├── package.json       ← npx thanos-skill support
├── skills/            ← v3 capability guidance (visual-proof, design, context-graph, media-comms)
├── tools/             ← v3 tool adapters (--detect + invoke) + registry.json
├── capabilities/      ← manifest.json — the catalog the Architect reads
├── templates/         ← Stone file templates
├── tests/             ← E2E test suite (+ opt-in rubric_differential.sh)
└── docs/              ← Architecture diagrams + CREDITS.md
```

---

## 🏁 The Snap Condition

Thanos snaps when ALL seven boxes are checked:

- `[ ]` SOUL.md stop condition verified: every criterion met
- `[ ]` POWER.md: all verifier commands exit 0
- `[ ]` MIND.md: critic score ≥ 95 on ALL six categories
- `[ ]` MIND.md: visual proof exists for any UI changes
- `[ ]` TIME.md: this loop’s lesson written
- `[ ]` SPACE.md: task queue empty
- `[ ]` REALITY.md: file state matches what was planned

**Only when all seven boxes are checked: 💥 SNAP. It is done. It is inevitable.**

---

## 🔭 The Vision

Today’s AI coding tools are reactive. You ask, they answer. You find the bug, they fix it. You notice the security hole, they patch it.

**Thanos is proactive.** It reads every file in your project before you say a word. It asks the real question, not the surface question. It loops until the machine says it’s done — not until the human *thinks* it looks done.

The long-term vision:

- **Any folder, any language, any agent** — `thanos` works everywhere
- **Self-improving skill files** — ANTI-RULES accumulate across projects, shared as community knowledge
- **Multi-repo orchestration** — Thanos coordinates across services, not just files
- **Visual regression built in** — screenshot diffing as a first-class MIND stone metric
- **Cost dashboard** — track tokens spent per loop, per stone, per project
- **One command to rule them all:**

```bash
curl -fsSL https://raw.githubusercontent.com/SamDev1303/Thanos-Skill/main/install.sh | bash
# then:
thanos
```

---

## 🤝 Contributing

Pull requests welcome. The only requirement: your PR must pass `thanos --test` before you submit it. The critic is ruthless. Impress it.

---

## 📄 License

MIT — use it, fork it, make it yours.

---

<div align="center">

**"You could not live with your own failure. Where did that bring you? Back to me."**

*— Thanos, on every loop that leads back to the EXECUTE phase*

</div>
