# `capabilities/` — The Catalog

`manifest.json` is the **catalog the Architect reads** to decide — *semantically* — which skills to
mobilize for the current goal. It is a map, not a router: it lists each skill's purpose and
example triggers, and the Architect uses judgment (from `.thanos/SOUL.md`) to choose. When nothing
matches, vanilla Thanos runs unchanged — that is the graceful fallback.

## `manifest.json` shape

```json
{
  "version": 1,
  "skills": {
    "visual-proof": {
      "purpose": "Capture real screenshots/renders so UI work has visual proof.",
      "trigger_examples": [
        "build a landing page",
        "redesign the dashboard",
        "the button looks wrong"
      ],
      "skill": "skills/visual-proof/SKILL.md",
      "requires": ["screenshot"]
    }
  }
}
```

- `requires` references tool ids in `../tools/registry.json`. MOBILIZE detect-gates them.
- Entries are added **as each capability bundle is built and verified**, not all at once.
