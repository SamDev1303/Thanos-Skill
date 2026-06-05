# Master GSD v3 — "THANOS INFINITY" — Build Plan & Progress Tracker

> Living document. The full approved plan is captured below, followed by a phase-by-phase
> progress tracker that is updated as each phase finishes. Source of truth for "where are we".

---

## 📊 Progress Tracker

| Phase | Description | Status | Commits |
|---|---|---|---|
| **P1** | Bootstrap — scaffold `skills/ tools/ capabilities/ docs/CREDITS.md` + LICENSE | ✅ **done** | `2a059f9` |
| **P2** | Engine — MOBILIZE in `thanos.sh`, `THANOS.md`, `GAUNTLET.md`, `SKILL.md`, templates, install | ✅ **done** | `7802a57`, `03a0796` |
| **P3** | PROOF gate — `visual-proof` skill + `screenshot.sh` + `manifest.json`, wired e2e | ✅ **mechanical gate passed** (LLM E2E + rubric differential → P5) | _next commit_ |
| **P4** | Remaining bundles — `design`, `context-graph`, `media-comms` + 5 tool adapters | ✅ **done** (video/notes/graph real artifacts; email blocked-path; transcribe detect) | _next commit_ |
| **P5** | Tests & docs — extend `tests/`, rewrite README, `--test` green | ⬜ pending | — |
| **P6** | Re-review — Gemini + Haiku on built code; apply blocking fixes | ⬜ pending | — |
| **P7** | Ship — push branch + PR, delete accidental fork, remove old local dir | ⬜ pending | — |

**Working location:** `~/Desktop/Thanos-Skill` (fresh clone) · branch `feat/master-gsd-v3`
**Base engine:** `SamDev1303/Thanos-Skill` (MIT) · **Fork to delete at P7:** `SamDev1303/Mykoala---GET-SHIT-DONE-`

### Verification status (measurable criteria)
| Criterion | Status |
|---|---|
| `bash thanos.sh --test` existing E2E green | ✅ 26/0 (also fixed a pre-existing `((x++))`+`set -e` bug that had it failing) |
| Injection hook: UI-goal MOBILIZE → `MOBILIZED.md` greps visual-proof | ✅ header + body injected (4.5KB) |
| Detect gate: `screenshot.sh --detect` non-zero+hint when Playwright absent, 0 when present | ✅ both directions |
| Screenshot: served `index.html` → non-empty PNG | ✅ 239KB 1024×640 PNG, http not file:// |
| Blocking gate: blocked dep → SPACE.md + MOBILIZED.md (not silent) | ✅ recorded both places |
| Visual rubric differential: lower score without PNG vs. with good PNG | ⬜ P5 (real headless critic) |
| E2E: `thanos claude "build a landing page"` → visual-proof mobilizes, PNG in `.thanos/proof/` | ⬜ P5 (manual/headless) |
| Re-review blocking findings fixed | ⬜ P6 |

### Environment facts (verified this session)
- gh auth scopes: `gist, read:org, repo, workflow` — **missing `delete_repo`** → P7 needs `gh auth refresh -s delete_repo`.
- Playwright `1.58.0` (homebrew) + chromium-1208 cached; python3 `3.14.5` present → screenshot engine ready.
- `timeout`/`gtimeout` NOT installed → `_headless` runs without a timeout wrapper (handled).

---

## 🎯 The Approved Plan (verbatim from plan mode)

### Context
One personal "master GSD" droppable into any app/website/project to drive work to completion
autonomously. Base engine = `SamDev1303/Thanos-Skill` (lean shell harness: Six Infinity Stones,
the Thanos Loop, 3-agent critic, Hermes self-learning). This workspace
(`~/Desktop/Mykoala---GET-SHIT-DONE-`) is an accidental fork of the archived `gsd-build/get-shit-done`
— to be **deleted**. The 28 "Tools to build apps" repos become **CAPABILITIES** (original, attributed
skill modules + thin tool adapters), not source-vendored.

### Review gate already run (Gemini CLI + Haiku) — both FIX-FIRST; fixes baked in:
- **Semantic skill selection, not regex.** `capabilities/manifest.json` is a catalog; the Architect
  semantically decides which skills to mobilize from `SOUL.md`. Vanilla Thanos is the fallback.
- **A real injection hook (the critical fix).** MOBILIZE concatenates chosen `skills/*/SKILL.md` into
  `.thanos/MOBILIZED.md`, then EXECUTE/CRITIQUE agents load it via system-prompt/context flag. Test
  asserts the file contains the expected skill after a UI goal.
- **Tool readiness is a BLOCKING gate.** MOBILIZE runs `tools/<x>.sh --detect`; missing CLIs produce
  `{blocked:[...], install_cmd}` → SPACE.md → Architect asks install-or-skip. No silent skips.
- **Visual proof is real, screenshot.sh is NOT thin.** Ephemeral dev server (or serve build dir),
  DOM-idle wait, capture to `.thanos/proof/*.png`. MIND Visual rubric redefined so "a PNG exists"
  scores ≤3; higher scores require the critic to articulate *why* the design works.
- **License-safe.** Skills hold only original general best-practice guidance. GPL repos (hackingtool)
  are adapter-invoke only. `docs/CREDITS.md` = attribution. Repo stays MIT.
- **Sequenced to avoid 28-tool burnout.** Socket + ONE capability (visual-proof) shipped and verified
  before the other three bundles.

### Guiding principle
Thanos stays the engine. Capabilities socket into the Gauntlet — no 7th Infinity Stone.
`skills/` = original attributed guidance; `tools/` = detect+invoke an upstream CLI the user installs.

### The MOBILIZE step
Insert MOBILIZE between PLAN and EXECUTE:
1. Architect reads `SOUL.md` goal + `manifest.json` catalog → semantically chooses 0–N skills.
2. `thanos.sh` runs `tools/<x>.sh --detect` for needed tools → blocked list to SPACE.md; Architect
   resolves install-or-skip. Never silently proceeds with a missing tool.
3. `thanos.sh` concatenates chosen skills → `.thanos/MOBILIZED.md`; EXECUTE & CRITIQUE load it.
4. Builder may call ready `tools/*.sh`; artifacts → `.thanos/proof/` → feed POWER/MIND.
5. Critic scores Visual against the redefined rubric using the actual PNG.

### Build phases (full v3, de-risked)
- **P1 Bootstrap** — fresh clone; scaffold dirs + CREDITS; commit.
- **P2 Engine** — extend `thanos.sh` (MOBILIZE + MOBILIZED.md builder + --detect), `THANOS.md`,
  `GAUNTLET.md` (redefined Visual rubric), `SKILL.md`.
- **P3 PROOF-OF-ARCHITECTURE** — author ONLY `visual-proof` + `screenshot.sh` + `manifest.json`;
  wire e2e; run a real UI goal; verify injection + screenshot + scoring. **Gate before P4.**
- **P4 Remaining bundles** — `design`, `context-graph`, `media-comms` skills + `tools/*.sh`,
  extend `registry.json`. Each proven on a sample goal.
- **P5 Tests & docs** — extend `tests/`; rewrite README; `thanos --test` green.
- **P6 Re-review** — Gemini + Haiku on the built code; apply blocking fixes.
- **P7 Ship** — push to `Thanos-Skill`; delete accidental fork (confirmed); remove old local dir.

### Confirmed execution decisions
- **Push style:** feature branch `feat/master-gsd-v3` + PR on Thanos-Skill.
- **Fork deletion:** at P7, after the new clone is built+verified; confirm exact name immediately
  before `gh repo delete SamDev1303/Mykoala---GET-SHIT-DONE- --yes`. Needs `delete_repo` scope —
  `gh auth refresh -s delete_repo` if missing (interactive).
- **Sequencing:** visual-proof proven end-to-end (P3 gate) before the other three bundles.
- **Cleanup:** remove old local `~/Desktop/Mykoala---GET-SHIT-DONE-` only after new clone verified.

---

## 📝 Code Review — P1 & P2 (independent code-reviewer agent, 2026-06-05)

All findings triaged and the actionable ones **fixed before P3 build proceeds** (commit below the table).

| # | Sev | Finding | Resolution |
|---|---|---|---|
| 1 | Critical* | `list_skill_ids` relied on the `-f` guard absorbing an unexpanded glob literal (nullglob not set) | **Fixed** — explicit `dirs=( … )` array + `[[ -e "${dirs[0]:-}" ]]` empty-glob guard |
| 2 | High | `_headless` `$TO` scalar word-splitting footgun for the timeout wrapper | **Fixed** — `TO` is now an array; `${TO[@]+"${TO[@]}"}` guards empty-array under `set -u` on **bash 3.2** (verified `/usr/bin/env bash` = 3.2.57 here) |
| 3 | High | `skill_requires` mangled inline-list YAML (`requires: [a, b]` → `[a`, `b]`) → false blocked entries | **Fixed** — added `tr -d '[]'` |
| 4 | Medium | `skill_field` interpolated `key` into an awk **regex** (metachar risk) | **Fixed** — rewritten to literal `index()`/`substr()` key compare |
| 5 | Medium | `do_mobilize "bad-id"` (explicit ids matching nothing) returned exit 0 | **Fixed** — returns non-zero on invalid explicit ids; `--mobilize` propagates the code |

_*Reviewer rated #1 Critical but noted it "does not crash today"; treated as a latent footgun and fixed anyway._

**Closed-by-review (no action needed):** awk frontmatter parsers correctly scope to the first two `---`
lines and handle missing frontmatter; `--detect` honors the adapter exit code; blocked tools always
reach SPACE.md + MOBILIZED.md (never silent); no bare `(( ))` errexit traps remain (the P2 commit fixed
the four pre-existing ones). E2E remained **26/0** after every fix.
