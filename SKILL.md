---
name: thanos
description: Autonomous self-healing agent skill combining GSD phases, Ralph Loop, and 3-agent critic system. Loops with machine-verifiable stop conditions until work is genuinely complete.
---

# Thanos Infinity Skill

See THANOS.md for full instructions.

This skill activates when the user mentions:
- "THANOS:"
- "/goal" or "/goals"
- "GSD:" or "gsd"
- "snap" in an agentic context
- "loop until done" or "keep going until finished"
- "mobilize", "capabilities", or "use a skill for this"
- a build/UI goal that benefits from a capability — e.g. "build a landing page", "redesign the
  dashboard", "transcribe this audio", "make a video", "the design looks off"

When activated, load THANOS.md from the skill directory and follow all instructions there. Read all six Infinity Stone files from `.thanos/` before taking any action.

**v3 — Capabilities socket:** during the MOBILIZE phase, read `capabilities/manifest.json` and
semantically choose which `skills/<id>/SKILL.md` to mobilize for the goal, then run
`bash thanos.sh --mobilize "<ids>"` and Read `.thanos/MOBILIZED.md`. Tool adapters under `tools/`
must pass `--detect` before use; a blocked tool is install-or-skip, never a silent skip.
