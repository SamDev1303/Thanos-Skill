# `skills/` — Capability Guidance (the distillate)

Each subdirectory is **one capability**, holding a single `SKILL.md` of **original, general
best-practice guidance**. These are *not* a 7th Infinity Stone — they **socket into the Gauntlet**
(see `../GAUNTLET.md`) and are mobilized on demand.

## How a skill is used

1. The **Architect** reads `../capabilities/manifest.json` (a catalog: skill → purpose →
   trigger-examples) and the goal in `.thanos/SOUL.md`, then **semantically** decides which skills
   to mobilize. No keyword routing.
2. `thanos.sh` (the MOBILIZE step) concatenates the chosen `skills/*/SKILL.md` into
   `.thanos/MOBILIZED.md`.
3. The EXECUTE / CRITIQUE agents load `MOBILIZED.md` via their system-prompt / context flag — this
   is the **injection hook**. Without it, skills never reach the model's context.

## `SKILL.md` frontmatter contract

```markdown
---
name: visual-proof
purpose: One-line description of what this capability adds.
triggers: short, comma-separated example goals that should mobilize this skill
requires: comma-separated tool ids from ../tools/registry.json (optional)
---
```

- `requires:` lists tool adapters this skill leans on. MOBILIZE runs each tool's `--detect`; missing
  tools become a **blocking** entry in `.thanos/SPACE.md` (install-or-skip), never a silent skip.

## Authoring rules (license-safe)

- Write **original** guidance only. Paraphrase widely-known practice; never copy a source repo's
  code, structure, or proprietary IP. See `../docs/CREDITS.md`.
- GPL or non-standard-licensed projects are **adapter-invoke only** — never distilled into a skill.
