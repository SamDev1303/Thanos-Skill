```
 _____ _   _    _    _   _  ___  ____
|_   _| | | |  / \  | \ | |/ _ \/ ___|
  | | | |_| | / _ \ |  \| | | | \___ \
  | | |  _  |/ ___ \| |\  | |_| |___) |
  |_| |_| |_/_/   \_\_| \_|\___/|____/

  ⚡  INFINITY SKILL — Snap. Loop. Done.
```

<div align="center">

![Thanos Banner](https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=12,20,25,30&height=200&section=header&text=THANOS%20SKILL&fontSize=60&fontColor=fff&animation=fadeIn&fontAlignY=35&desc=Autonomous%20%E2%80%A2%20Self-Healing%20%E2%80%A2%20Inevitable&descAlignY=55&descSize=18)

[![Version](https://img.shields.io/badge/version-2.0.0-blueviolet?style=for-the-badge&logo=github)](#)
[![Works With](https://img.shields.io/badge/works%20with-Claude%20%7C%20Codex%20%7C%20Gemini%20%7C%20OpenCode-orange?style=for-the-badge)](#)
[![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)](#)
[![Loops](https://img.shields.io/badge/loops-until%20done-red?style=for-the-badge&logo=infinity)](#)

> **"You could not live with your own failure. Where did that bring you? Back to me."**
> — The only AI skill that loops until the work is actually finished.

</div>

---

## 🌌 What Is Thanos?

Thanos is a **production-grade autonomous agent skill** for any AI CLI. It combines three battle-tested patterns — **Codex `/goals`**, **GSD (Get Shit Done)**, and the **Ralph Loop** — into a single unified system with a **3-agent critic architecture** that keeps looping until the work is genuinely, provably done.

Inspired by how OpenAI's own team shipped **1 million+ lines of code** across **1,500 PRs** with zero human-written code — using self-improving agentic loops with machine-verifiable stop conditions.

```
╔══════════════════════════════════════════════════════════════════╗
║                    THE THANOS LOOP                               ║
║                                                                  ║
║  OPUS/SONNET ──────► SONNET/SONNET ──────► HAIKU/FLASH-LITE     ║
║  [Architect]          [Builder]             [The Critic]         ║
║  Plans the snap       Executes the work     Finds every flaw     ║
║       │                    │                      │              ║
║       └────────────────────┴──────────────────────┘              ║
║                            │                                     ║
║                     ┌──────▼──────┐                              ║
║                     │ LOOP AGAIN? │                              ║
║                     │  Critic has │                              ║
║                     │  complaints?│                              ║
║                     └──────┬──────┘                              ║
║                   YES ◄────┘────► NO = 💥 SNAP. DONE.           ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## ✨ The Six Infinity Stones

Thanos tracks everything through **six state files** — one per Infinity Stone. Each stone is a living document the agent reads and writes every loop.

```
📁 your-project/
├── THANOS.md              ← The Gauntlet (master skill instructions)
├── SKILL.md               ← Codex-native skill loader
└── .thanos/
    ├── SOUL.md            ← 🟠 Soul Stone   — Active goal + stop condition
    ├── REALITY.md         ← 🔴 Reality Stone — Current file/code state
    ├── POWER.md           ← 💜 Power Stone  — Test/build/lint proof
    ├── TIME.md            ← 🔵 Time Stone   — Loop history + lessons learned
    ├── SPACE.md           ← 🔷 Space Stone  — Task queue + phase tracker
    └── MIND.md            ← 🟡 Mind Stone   — Critic scores + QA verdict
```

| Stone | Colour | What it tracks |
|-------|--------|----------------|
| Soul | 🟠 | The real goal. Verifiable stop condition. Assumptions. |
| Reality | 🔴 | What code/files actually exist right now. |
| Power | 💜 | Exit codes. Test pass %. Build status. Lint count. |
| Time | 🔵 | Every loop's summary. Lessons injected back into skill. |
| Space | 🔷 | Phase queue. What's next. What's blocked. |
| Mind | 🟡 | Critic's score (0–100). Visual proof. Issues list. |

---

## 🧠 The 3-Agent Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   AGENT HIERARCHY                       │
│                                                         │
│  🔮 MAIN AGENT (Opus / Sonnet Max)                     │
│     Role: Architect, Planner, Final Decision            │
│     Does: Sets goal, plans phases, interprets critic    │
│     Never: Writes production code directly              │
│                                                         │
│  ⚙️  SUB AGENT (Sonnet / Sonnet)                       │
│     Role: Builder, Researcher, Executor                 │
│     Does: Writes code, runs commands, edits files       │
│     Reports: Power Stone proof after every action       │
│                                                         │
│  🔪 CRITIC AGENT (Haiku / Flash-Lite / Mini)           │
│     Role: The Hardest Reviewer You've Ever Had          │
│     Does: Visual proof check, code quality, logic bugs  │
│     Rule: Must find ZERO issues before loop can stop    │
│     Never: Writes code. Only judges.                    │
└─────────────────────────────────────────────────────────┘
```

### Why Haiku as Critic?

The critic is intentionally **small, fast, and cheap**. It runs on every loop. It has no context from previous loops — it sees only the current state of the filesystem and must judge it cold. This mirrors the Ralph Loop's core insight: **a model cannot grade its own work from memory**. Fresh eyes every time.

---

## 🔄 The GSD Phase System

GSD prevents **context rot** — the quality decay that happens when a model fills its window with half-finished reasoning. Each phase is scoped, verified, and handed off cleanly.

```
 Phase 0: DISCUSS    ← Deep Q&A session. Don't skip this.
     │
     ▼
 Phase 1: ASSUMPTIONS ← List every assumption. Make them explicit.
     │
     ▼
 Phase 2: PLAN       ← Acceptance criteria written BEFORE code.
     │
     ▼
 Phase 3: EXECUTE    ← Sub agent builds. Main agent watches.
     │
     ▼
 Phase 4: VERIFY     ← Power Stone must go green.
     │
     ▼
 Phase 5: CRITIQUE   ← Critic agent runs. Scores 0-100.
     │
     ▼
 Phase 6: LOOP? ─── Score < 95 ──► Back to Phase 3
              └──── Score ≥ 95 ──► SNAP. Done. ✅
```

---

## ♾️ The Ralph Loop

Named after the self-improving loop pattern used internally at OpenAI. The key rules:

1. **Never grade your own work** — the critic runs in a fresh context
2. **Only machine signals are truth** — exit codes, test pass %, coverage numbers
3. **Every loop leaves a lesson** — TIME.md gets updated with what was learned
4. **The skill improves itself** — bad patterns get written back as anti-rules
5. **Humans are always confused once** — the DISCUSS phase runs deep Q&A until the goal is crystal clear before any code is written

```
 RALPH LOOP (per iteration)
 ┌─────────────────────────────────────────────────────┐
 │  1. READ   → Soul + Reality + Power + Time stones   │
 │  2. PLAN   → What is the single next action?        │
 │  3. ACT    → Sub agent executes it                  │
 │  4. PROOF  → Run verifier command. Capture exit.    │
 │  5. CRITIC → Haiku/Flash-Lite reviews cold          │
 │  6. LEARN  → Append lesson to TIME.md               │
 │  7. DECIDE → Continue / Pause / Done                │
 │                                                     │
 │  CONTEXT WIPE between iterations (Ralph Rule #1)    │
 └─────────────────────────────────────────────────────┘
```

---

## 🧬 Hermes Mode — Self-Healing & Self-Learning

Hermes is the self-improvement layer. When enabled, Thanos doesn't just fix bugs — it writes the anti-pattern back into its own skill file so it never makes the same mistake twice.

```
 HERMES CYCLE
 ┌──────────────────────────────────────────────────────────┐
 │  After every failed critic check:                        │
 │                                                          │
 │  1. DIAGNOSE  → What category of error was it?          │
 │     (logic / style / performance / security / visual)   │
 │                                                          │
 │  2. PATTERN   → Has this error appeared before?         │
 │     Check TIME.md for recurring failures                │
 │                                                          │
 │  3. VACCINATE → Write anti-rule into THANOS.md          │
 │     "NEVER do X because it caused Y in loop N"          │
 │                                                          │
 │  4. VERIFY    → Confirm the rule was absorbed           │
 │     Main agent reads back and acknowledges              │
 │                                                          │
 │  5. REPEAT    → Quality ceiling rises every loop        │
 └──────────────────────────────────────────────────────────┘
```

**Visual Proof Requirement (Hermes Rule):** The critic cannot pass code changes without visual proof. For UI changes: screenshot diff. For logic changes: before/after test output. For performance: benchmark comparison. Text alone is never enough.

---

## 🚀 Quick Start

### Install

```bash
# Option 1: Clone into your project
git clone https://github.com/SamDev1303/Thanos-Skill .agents/skills/thanos

# Option 2: Clone to global user skills (works for all projects)
git clone https://github.com/SamDev1303/Thanos-Skill ~/.agents/skills/thanos

# Option 3: Just copy THANOS.md into any AGENTS.md or claude.md
cp THANOS.md your-project/AGENTS.md
```

### Initialize a Project

```bash
# Create the six stone files
mkdir -p .thanos
cp templates/THANOS_SOUL.md .thanos/SOUL.md
cp templates/THANOS_REALITY.md .thanos/REALITY.md
cp templates/THANOS_POWER.md .thanos/POWER.md
cp templates/THANOS_TIME.md .thanos/TIME.md
cp templates/THANOS_SPACE.md .thanos/SPACE.md
cp templates/THANOS_MIND.md .thanos/MIND.md
```

### Usage with Claude Code

```bash
# Start a goal
claude "THANOS: Build a REST API with full test coverage"

# The skill handles the rest. Watch it loop.
```

### Usage with Codex CLI

```bash
# Goals command (native Codex loop)
codex /goal "Build and pass all tests for the auth module"

# Or invoke the skill directly
codex "Use THANOS skill to refactor the entire database layer"
```

### Usage with Gemini CLI

```bash
gemini "Following THANOS.md instructions, implement and verify the payment flow"
```

---

## 📊 Loop Progress Visualization

Every loop, the agent updates MIND.md with a progress table:

```
 LOOP #4 CRITIC REPORT
 ┌─────────────────────────────────────────┐
 │ Category        │ Score │ Issues Found  │
 ├─────────────────────────────────────────┤
 │ Logic           │ 95/100│ 0             │
 │ Code Quality    │ 88/100│ 2 warnings    │
 │ Test Coverage   │ 91/100│ 1 uncovered   │
 │ Visual/UI Proof │ 100%  │ ✅ Verified   │
 │ Security        │ 97/100│ 0             │
 │ Performance     │ 89/100│ 1 slow query  │
 ├─────────────────────────────────────────┤
 │ OVERALL         │ 93/100│ LOOP AGAIN ↩  │
 └─────────────────────────────────────────┘

 Threshold to SNAP: 95/100 on all categories
```

---

## 🗺️ Vision

Thanos is built on one belief: **AI agents should finish what they start**.

Most agentic systems stop when the code compiles. Thanos stops when:
- ✅ All tests pass (exit 0)
- ✅ The critic has nothing left to say
- ✅ Visual proof exists
- ✅ The lesson is written back
- ✅ The goal's explicit stop condition is met

The roadmap:
- [ ] MCP server integration for real-time stone updates
- [ ] Web dashboard for loop visualisation
- [ ] Automatic PR creation when snap condition met
- [ ] Multi-repo orchestration (Thanos commands multiple codebases)
- [ ] Fine-tuned critic model trained on accumulated TIME.md lessons

---

## 🤝 Compatible Agents

| Agent | Status | Notes |
|-------|--------|-------|
| Claude Code | ✅ Native | Best experience. AGENTS.md auto-loaded. |
| Codex CLI | ✅ Native | Use SKILL.md. `/goal` integrates perfectly. |
| Gemini CLI | ✅ Works | Paste THANOS.md into context. |
| OpenCode | ✅ Works | Drop in AGENTS.md. |
| Aider | 🔶 Partial | Manual stone file management. |
| Continue.dev | 🔶 Partial | Works via custom instructions. |

---

## 📄 License

MIT — Use it, fork it, improve it. Just keep looping until it's done.

---

<div align="center">

![Footer](https://capsule-render.vercel.app/api?type=waving&color=gradient&customColorList=12,20,25,30&height=100&section=footer)

**Built by [ClaudeKing.org](https://claudeking.org) · Sydney, AU**

*"Perfectly balanced, as all things should be."*

</div>
