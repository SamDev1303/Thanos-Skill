# ⚡ Thanos Skill

> *"I am inevitable."*

**Thanos Skill** is a universal autonomous agent skill for any AI CLI. Drop one file in your project. Give it a goal. It snaps through the work — planning, executing, rechecking, and looping — until the goal is done.

Works with **Claude Code · Codex CLI · Gemini CLI · OpenCode · any AI agent**.

---

## The Six Infinity Files

Thanos tracks everything through six named files — one per Infinity Stone. Nothing clashes with other skills because every file is prefixed `THANOS_`.

| File | Stone | Purpose |
|---|---|---|
| `THANOS_GAUNTLET.md` | 🟡 Mind Stone | Your hard rules. Agent never breaks these. |
| `THANOS_SOUL.md` | 🟠 Soul Stone | The goal and stop condition. |
| `THANOS_TIME.md` | 🟢 Time Stone | The checkpoint plan. |
| `THANOS_REALITY.md` | 🔴 Reality Stone | Live append-only progress log. |
| `THANOS_SPACE.md` | 🔵 Space Stone | Codebase map for fast fresh context. |
| `THANOS_POWER.md` | 🟣 Power Stone | Sub-model advice, decisions, blockers. |

After any `/clear` or reset, the agent reads all six and resumes. Nothing is ever lost.

---

## Quickstart

**1. Write your rules first:**
```markdown
# THANOS_GAUNTLET.md
- Never touch payments/
- Use branch thanos/snap
- Tests must pass before any commit
```

**2. Start:**
```
"Read THANOS.md. My goal is: [your goal]. Read THANOS_GAUNTLET.md first."
```

**3. Resume after /clear:**
```
"Read THANOS.md. Read all six Infinity Files. Resume."
```

---

## The Infinity Loop

```
Phase 1 — Assemble the Stones (read all six files)
Phase 2 — Read the Universe (map the codebase)
Phase 3 — Forge the Plan (checkpoints with proofs)
Phase 4 — The Snap (execute next checkpoint)
Phase 5 — Recheck Reality (did proof pass?)
Phase 6 — Balance (all done → THE SNAP IS COMPLETE ✅)
```

---

## Ralph Loop (maximum quality mode)

```bash
while true; do
  claude "$(cat THANOS.md)
  Read all six Infinity Files. Run the next pass. Update all six files."
  if <proof command exits 0>; then echo "✅ THE SNAP IS COMPLETE"; break; fi
done
```

---

## File structure in your project

```
your-project/
├── THANOS.md              ← the skill (this file)
├── THANOS_GAUNTLET.md     ← your rules (you write this)
├── THANOS_SOUL.md         ← goal + stop condition (auto-created)
├── THANOS_TIME.md         ← checkpoint plan (auto-created)
├── THANOS_REALITY.md      ← progress log (auto-created)
├── THANOS_SPACE.md        ← codebase map (auto-created)
└── THANOS_POWER.md        ← decisions + advice (auto-created)
```

---

Built by [ClaudeKing.org](https://claudeking.org) — AI automation for real businesses.
