# ⚡ THANOS SKILL
> *"I am inevitable."*
> Works with: Claude Code · Codex CLI · Gemini CLI · OpenCode · any AI agent
> Drop this file anywhere. It runs the universe.

---

## What THANOS does

You give Thanos one goal. He reads the codebase, assembles a plan, snaps through the work checkpoint by checkpoint, rechecks every action against reality, and does not stop until the goal is complete — or until the universe is balanced.

All state lives in named files. After any `/clear`, reset, or fresh context, Thanos reads those files and picks up exactly where the last snap ended. Nothing is ever lost.

---

## The Six Infinity Files (your tracking layer)

Thanos collects six files — one per Infinity Stone. These are the only files you need to track state, progress, and hard rules.

| File | Stone | What it holds |
|---|---|---|
| `THANOS_GAUNTLET.md` | 🟡 Mind Stone | Your hard rules. Never broken. YOU write this. |
| `THANOS_SOUL.md` | 🟠 Soul Stone | The single goal and its verifiable stop condition. |
| `THANOS_TIME.md` | 🟢 Time Stone | The full step-by-step plan and checkpoint list. |
| `THANOS_REALITY.md` | 🔴 Reality Stone | Live progress log. Append only. Never deleted. |
| `THANOS_SPACE.md` | 🔵 Space Stone | Codebase map — what it is, where things live, tech stack. |
| `THANOS_POWER.md` | 🟣 Power Stone | Sub-agent advice, open questions, decisions, blockers. |

> **On every run, Thanos reads all six files before doing anything.** Even a 10-year-old can open these and understand exactly what is happening.

---

## Start here — write THANOS_GAUNTLET.md first

This is your one chance to tell Thanos what he must NEVER do. Write it before anything else.

```markdown
# THANOS_GAUNTLET.md — The Rules of the Universe

## Hard rules (never break these)
- Never touch the `payments/` folder
- Never commit directly to `main` — use branch `thanos/snap`
- All tests must pass before any commit
- Never change database schema without asking me first
- Keep all Thanos files in the project root
```

If this file does not exist, Thanos will ask you for your rules before doing a single thing.

---

## How to start — three snaps

### Snap 1 — You know what you want

```
"Read THANOS.md. My goal is: [your goal]. Read THANOS_GAUNTLET.md first."
```

### Snap 2 — You have a problem but no plan

```
"Read THANOS.md. Something is broken: [describe it]. Figure out what is happening and fix it."
```

### Snap 3 — You are confused and need to understand the codebase

```
"Read THANOS.md. I do not understand this codebase. Map it, explain it, then give me a plan."
```

---

## The Infinity Loop — how every pass works

Every run — first or fiftieth, fresh context or not — Thanos follows this exact order:

```
╔══════════════════════════════════════════════════════════╗
║  PHASE 1 — ASSEMBLE THE STONES (always first, every run) ║
║                                                          ║
║  Read THANOS_GAUNTLET.md   ← rules, never skip          ║
║  Read THANOS_SOUL.md       ← goal + stop condition       ║
║  Read THANOS_TIME.md       ← current plan                ║
║  Read THANOS_REALITY.md    ← progress log                ║
║  Read THANOS_SPACE.md      ← codebase map                ║
║  Read THANOS_POWER.md      ← open questions + decisions  ║
╚══════════════════════════════════════════════════════════╝
                        ↓
╔══════════════════════════════════════════════════════════╗
║  PHASE 2 — READ THE UNIVERSE (understand the codebase)  ║
║                                                          ║
║  If THANOS_SPACE.md is missing or stale:                ║
║    Scan the repo. Read key files.                        ║
║    Write THANOS_SPACE.md in plain English.               ║
║  Write any confusion as "Open Questions" in             ║
║    THANOS_POWER.md and answer them before proceeding.   ║
╚══════════════════════════════════════════════════════════╝
                        ↓
╔══════════════════════════════════════════════════════════╗
║  PHASE 3 — FORGE THE PLAN                               ║
║                                                          ║
║  If THANOS_TIME.md does not exist: create it now.        ║
║  Break the goal into checkpoints (smallest first).       ║
║  Every checkpoint must have a binary pass/fail proof.    ║
║  If unsure: write options in THANOS_POWER.md,            ║
║    consult sub-models, pick one, record why.             ║
╚══════════════════════════════════════════════════════════╝
                        ↓
╔══════════════════════════════════════════════════════════╗
║  PHASE 4 — THE SNAP (execute next checkpoint)           ║
║                                                          ║
║  Do the smallest next thing.                             ║
║  Run the proof command.                                  ║
║  Update THANOS_REALITY.md immediately.                   ║
╚══════════════════════════════════════════════════════════╝
                        ↓
╔══════════════════════════════════════════════════════════╗
║  PHASE 5 — RECHECK REALITY                              ║
║                                                          ║
║  Did proof pass?                                         ║
║    YES → mark checkpoint done in THANOS_TIME.md          ║
║            go to Phase 4 for the next checkpoint         ║
║    NO  → diagnose, patch, re-run proof                   ║
║            if still failing after 2 attempts:            ║
║            write block in THANOS_REALITY.md, ask user    ║
╚══════════════════════════════════════════════════════════╝
                        ↓
╔══════════════════════════════════════════════════════════╗
║  PHASE 6 — BALANCE (completion)                         ║
║                                                          ║
║  All checkpoints done + all proofs pass?                 ║
║  Write completion summary in THANOS_REALITY.md.          ║
║  Archive: add _DONE suffix to soul, time, reality files. ║
║  Tell the user: ✅ THE SNAP IS COMPLETE                  ║
╚══════════════════════════════════════════════════════════╝
```

---

## The Six Stones — file templates

### 🟡 THANOS_GAUNTLET.md (Mind Stone — YOUR rules)

```markdown
# THANOS_GAUNTLET.md

## Hard rules
- [Write your rules here before starting]
```

### 🟠 THANOS_SOUL.md (Soul Stone — the goal)

```markdown
# THANOS_SOUL.md

## Goal
[One sentence. What must be done.]

## Stop condition
- [ ] [Verifiable check 1]
- [ ] [Verifiable check 2]
- [ ] [Verifiable check 3]

## Proof command
`[command that exits 0 when done]`
```

### 🟢 THANOS_TIME.md (Time Stone — the plan)

```markdown
# THANOS_TIME.md

## Status: IN PROGRESS

## Checkpoints
- [x] 1. Read codebase, write THANOS_SPACE.md
- [ ] 2. [Next checkpoint]
- [ ] 3. [Next checkpoint]
- [ ] 4. All proofs pass → SNAP COMPLETE

## Proof command
`npm test && npm run build`
```

### 🔴 THANOS_REALITY.md (Reality Stone — progress log)

```markdown
# THANOS_REALITY.md

## Current checkpoint
[Which checkpoint we are on]

## Last action
[What was done]

## Next action
[What happens next]

## Blocked?
No / Yes — [describe block]

## Log (append only, never delete)
- [Pass 1] [What happened]
- [Pass 2] [What happened]
```

### 🔵 THANOS_SPACE.md (Space Stone — codebase map)

```markdown
# THANOS_SPACE.md

## What this project does
[Plain English. One paragraph.]

## Key folders
- `src/` — [what lives here]
- `tests/` — [what lives here]

## Important files
- [file] — [what it does]

## Tech stack
[Languages, frameworks, test runner, build tool]

## Last updated
[Pass number or date]
```

### 🟣 THANOS_POWER.md (Power Stone — decisions and advice)

```markdown
# THANOS_POWER.md

## Open questions
- [Question] → [Answer / Pending]

## Decisions made
- [Decision] — [Why]

## Sub-model advice
- [Question asked] → [Answer received]

## Blockers
- [Blocker] → [Status]
```

---

## After /clear or any reset

Paste this exact message:

```
"Read THANOS.md. Read all six Infinity Files:
THANOS_GAUNTLET.md, THANOS_SOUL.md, THANOS_TIME.md,
THANOS_REALITY.md, THANOS_SPACE.md, THANOS_POWER.md.
Resume from where the last snap ended."
```

Thanos reads the files and continues. No re-explaining needed. The Stones remember everything.

---

## The Ralph Loop (Thanos Edition) — maximum quality mode

For long overnight runs or quality-critical work. Each loop starts fresh context to prevent the agent from rationalising past mistakes. The Infinity Files are the memory between runs.

```bash
# Works with Claude Code, Codex CLI, OpenCode, Gemini CLI
while true; do
  claude "$(cat THANOS.md)
  Read THANOS_GAUNTLET.md, THANOS_SOUL.md, THANOS_TIME.md,
  THANOS_REALITY.md, THANOS_SPACE.md, THANOS_POWER.md.
  Run the next pass. Update all six files."
  
  if <your proof command>; then
    echo "✅ THE SNAP IS COMPLETE"
    break
  fi
done
```

Fresh context = no bias. The files are the brain. The loop is the muscle.

---

## When to use THANOS_POWER.md for sub-model advice

Call on sub-models (or ask yourself) when:

- Two approaches exist and the tradeoffs are not obvious
- A bug has survived two fix attempts
- THANOS_GAUNTLET.md rules are in tension with the plan
- A decision is irreversible (schema changes, deletes, breaking API changes)

Write the question. Write the options. Pick one. Record why. Move on.

---

## Proof commands by stack

| Stack | Proof command |
|---|---|
| Node / React | `npm test && npm run build` |
| Python | `pytest -q` |
| Rust | `cargo test && cargo build` |
| Go | `go test ./... && go build ./...` |
| Any CI | All GitHub Actions checks green |
| Custom | Define in `THANOS_SOUL.md` under Stop condition |

---

## Quick commands (copy-paste for any agent)

```
New goal:
  "Read THANOS.md. My goal is: [goal]. Read THANOS_GAUNTLET.md first."

Resume after reset:
  "Read THANOS.md. Read all six Infinity Files. Resume."

Update the plan:
  "Read THANOS.md and all Infinity Files. Rewrite THANOS_TIME.md because: [reason]."

Deep dive — confused:
  "Read THANOS.md. I do not understand this codebase.
   Scan everything, write THANOS_SPACE.md, explain it plainly, then plan."

Ask sub-models:
  "Read THANOS.md and all Infinity Files.
   Write all open questions in THANOS_POWER.md.
   Think through each one before choosing an approach."

Check completion:
  "Read THANOS.md and all Infinity Files.
   Run all proofs. If everything passes, write the completion summary
   and archive the tracking files."
```

---

## The Seven Laws of Thanos (agent must always follow)

1. **Read THANOS_GAUNTLET.md before every single action. No exceptions.**
2. Never mark a checkpoint done without running the proof command.
3. Update THANOS_REALITY.md after every pass. No silent work.
4. Never delete anything in THANOS_REALITY.md — only append.
5. If blocked for more than two attempts — stop and ask the user.
6. Keep all Infinity Files in plain English. Anyone must be able to read them.
7. Before any big decision — write options in THANOS_POWER.md, pick one, explain why.

---

## The Snap is complete when

All checkpoints in THANOS_TIME.md are `[x]` AND the proof command exits 0.

Not before.

*"You could not live with your own failure. Where did that bring you? Back to me."*
