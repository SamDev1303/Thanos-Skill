---
name: visual-proof
purpose: Capture real screenshots of rendered UI so visual work has objective proof, not prose.
triggers: build a landing page, redesign the dashboard, style the homepage, the button looks wrong, make the UI premium, match this screenshot
requires: screenshot
---

# 🖼️ Visual Proof

> A description of a UI is not proof a UI works. A screenshot is. When the goal touches anything
> visual, the loop does not snap until a real rendered image exists in `.thanos/proof/` **and** the
> critic can justify, from that image, why the design achieves the goal.

This is original best-practice guidance. The mechanics live in `tools/screenshot.sh` (an adapter to
a browser-automation CLI the user installs separately). This skill tells you *how to get proof that
means something*.

## When this applies

Any change that alters what a human sees: pages, components, layouts, themes, spacing, typography,
color, icons, responsive behavior, empty/loading/error states. If in doubt, capture.

## Capture correctly (so the proof is real)

1. **Serve, never `file://`.** Open the page over `http://` from a real server. `file://` breaks
   relative asset paths, `fetch`, module imports, service workers, and CORS — you end up
   screenshotting a broken page and calling it proof. `tools/screenshot.sh` spins an ephemeral
   static server for local files precisely for this reason.
2. **Wait for the page to settle, not just load.** Fonts, images, web components, and client-side
   rendering land *after* the initial load event. Capturing too early yields FOUT, layout shift, or
   blank regions. Wait for network/DOM idle and give late assets a brief settle window.
3. **Capture the full page**, not just the viewport — long pages hide their worst problems below the
   fold (broken footers, overflowing sections).
4. **Prove responsiveness when it matters.** A layout that works at 1280px can collapse at 375px.
   For responsive goals, capture at least a desktop and a mobile width and compare both.
5. **Capture every meaningful state.** Default, hover/focus where relevant, empty, loading, and
   error. "It looks great" with only the happy-path populated state is not proof.
6. **Name artifacts meaningfully** (`landing-desktop.png`, `dashboard-empty-375.png`) and keep them in
   `.thanos/proof/` so they become evidence for the POWER and MIND stones.

## What to actually judge in the image (drives the MIND Visual score)

A PNG existing proves the page *rendered*. The Visual score (see `GAUNTLET.md`) measures how well you
can justify the *result*. Look for and articulate, citing what is visible:

- **Hierarchy** — does the eye land on the most important thing first? Is there one clear focal point?
- **Spacing rhythm** — consistent, intentional whitespace; related things grouped, unrelated things
  separated. Cramped or uneven spacing reads as unfinished.
- **Alignment & grid** — edges line up; nothing floats arbitrarily.
- **Contrast & legibility** — text passes contrast against its background; nothing is unreadable.
- **Type scale** — a small number of deliberate sizes/weights, not a dozen ad-hoc ones.
- **Balance** — the composition isn't lopsided; negative space is used, not feared.
- **Consistency** — buttons, radii, shadows, and color usage repeat predictably.

Name weaknesses too, and judge whether each is blocking. "Looks fine" is never a justification.

## The blocking rule

If `tools/screenshot.sh --detect` fails, **say so and stop** — the capability is unavailable. Surface
the install hint and ask the user to install-or-skip. Never claim a screenshot exists when it does
not, and never raise the Visual score just because a file is present.

## Typical flow

```bash
# 1. Confirm the tool is ready (MOBILIZE already detect-gated it, but verify before relying on it).
bash tools/screenshot.sh --detect

# 2. Capture a served local build (ephemeral server + settle + full page).
bash tools/screenshot.sh ./index.html .thanos/proof/landing-desktop.png 1280 800
bash tools/screenshot.sh ./index.html .thanos/proof/landing-mobile.png   375 812

# 3. Reference the artifacts in MIND.md and justify the Visual score from what they show.
```
