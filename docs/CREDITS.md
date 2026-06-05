# 🙏 CREDITS — Inspiration & Attribution

Thanos is the **engine**. Its **capabilities** (`skills/` + `tools/`) were *inspired by* the
projects below — the "Tools to build apps" reading list. Thanos does **not** vendor, copy, or
redistribute any of their source code.

## How attribution works here

- **`skills/*/SKILL.md`** contains only **original, general best-practice guidance** written for
  Thanos. It paraphrases widely-known engineering practice (e.g. "wait for DOM-idle before
  screenshotting"), never a specific repo's code, file structure, or proprietary IP.
- **`tools/*.sh`** are **thin adapters** that *detect* and *invoke* a CLI **the user installs
  separately**. Thanos ships none of their binaries or source. The tool runs under **its own
  upstream license**, on the user's machine, exactly as if the user ran it by hand.
- Therefore Thanos itself stays **MIT** with **zero license entanglement**. The projects below are
  credited as **inspiration**, not as bundled dependencies.

> **License accuracy note:** licenses marked `(verify upstream)` were not independently confirmed at
> authoring time — check the source repo before relying on them. Projects with **non-standard or
> restrictive** licenses are flagged explicitly and are **adapter-invoke only** (never distilled
> into a skill).

---

## Capability bundle → sources

### `skills/visual-proof` — screenshot / render proof
| Project | Role | License |
|---|---|---|
| [puppeteer/puppeteer](https://github.com/puppeteer/puppeteer) | headless-Chrome screenshot patterns (inspiration) | Apache-2.0 |
| [microsoft/playwright](https://github.com/microsoft/playwright) | cross-browser capture + DOM-idle waiting (inspiration) | Apache-2.0 |

### `skills/design` — UI/UX taste & critique
| Project | Role | License |
|---|---|---|
| ui-ux-pro-max | design-quality heuristics (inspiration) | (verify upstream) |
| impeccable | polish / detail checklist (inspiration) | (verify upstream) |
| taste-skill | aesthetic-judgment prompts (inspiration) | (verify upstream) |
| awesome-design-md | curated design references (inspiration) | (verify upstream) |
| design-extract | extracting design tokens from references (inspiration) | (verify upstream) |
| open-design | open design-system practice (inspiration) | (verify upstream) |

### `skills/context-graph` — richer/cheaper REALITY stone
| Project | Role | License |
|---|---|---|
| graphify | code-as-graph context modelling (inspiration) | (verify upstream) |
| [vercel-labs/opensrc](https://github.com/vercel-labs) | open-source context extraction (inspiration) | (verify upstream) |
| caveman | minimal/cheap context capture (inspiration) | (verify upstream) |

### `skills/media-comms` — transcription, video, email, notes
| Project | Role | License |
|---|---|---|
| [openai/whisper](https://github.com/openai/whisper) | audio transcription (adapter-invoke) | MIT |
| [remotion-dev/remotion](https://github.com/remotion-dev/remotion) | programmatic video (adapter-invoke) | ⚠️ **Remotion License** — free for individuals & small teams, **not** plain OSS; commercial use may require a license. Adapter-invoke only. |
| [resend/react-email](https://github.com/resend/react-email) | email components (adapter-invoke) | MIT |
| [usememos/memos](https://github.com/usememos/memos) | lightweight notes/memo (adapter-invoke) | MIT |
| Obsidian | knowledge base (adapter-invoke) | ⚠️ **Proprietary app** (free for personal use); only the plugin API is MIT. Adapter-invoke only. |

---

## Explicitly adapter-invoke-only (never distilled)

| Project | License | Why isolated |
|---|---|---|
| [Z4nzu/hackingtool](https://github.com/Z4nzu/hackingtool) | **GPL** | Copyleft. Thanos must not distill GPL'd structure/IP into MIT skills. If ever wired, it is **invoke-only** via an adapter the user installs themselves. |

---

## The base engine

| Project | Role | License |
|---|---|---|
| [SamDev1303/Thanos-Skill](https://github.com/SamDev1303/Thanos-Skill) | the harness this builds on (Six Infinity Stones, the Thanos Loop, 3-agent critic, Hermes self-learning) | MIT |

---

_The full "Tools to build apps" star list (28 repos) is the broader inspiration set. The table above
names the projects actually distilled-from (skills) or adapted-to (tools). If a project you expected
is missing, it influenced the design generally but was not turned into a discrete capability._
