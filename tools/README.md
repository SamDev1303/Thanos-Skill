# `tools/` — Tool Adapters (detect + invoke)

Each `*.sh` is a **thin adapter** to an upstream CLI the user installs **separately**. Thanos ships
none of their code — it only detects and invokes them, so there is **zero license entanglement**.

## The exit-code contract (every adapter MUST honor)

| Invocation | Behavior | Exit code |
|---|---|---|
| `tool.sh --detect` | Probe whether the underlying CLI is installed/usable. Print a one-line `install_hint` to **stderr** when missing. | `0` ready · non-zero (e.g. `1`) blocked |
| `tool.sh <args...>` | Do the work, write artifacts under `.thanos/proof/`, print the artifact path. | `0` success · non-zero failure |

**Blocking, not silent.** A non-zero `--detect` is surfaced by MOBILIZE into `.thanos/SPACE.md` as a
blocked dependency. The Architect then asks the user *install-or-skip* — Thanos never proceeds as if
a missing tool were present (root-cause rule: no bandages, no silent skips).

## `registry.json` shape

```json
{
  "screenshot": {
    "detect":       "tools/screenshot.sh --detect",
    "install_hint": "npm i -D playwright && npx playwright install chromium",
    "invoke":       "tools/screenshot.sh <url-or-path> <out.png>"
  }
}
```

Tools are added to `registry.json` **per-tool as each bundle lands** — not all 28 upfront. This is
the de-risking sequence: prove one capability (visual-proof) end-to-end before authoring the rest.
