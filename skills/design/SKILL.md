---
name: design
purpose: Make UI work look intentional and premium — taste, hierarchy, and craft, not AI slop.
triggers: make it look good, redesign this, polish the UI, improve the styling, it looks generic, premium design, match this aesthetic
requires: screenshot
---

# 🎨 Design

> Functional ≠ finished. Most generated UI is *technically correct and visually generic* — even
> spacing, default shadows, one-of-everything, no point of view. This skill is about pushing past
> that into something that looks deliberately made. Pair it with `visual-proof`: design without a
> screenshot to judge is just hoping.

Original best-practice guidance. No upstream design-repo IP is reproduced here — see
`docs/CREDITS.md` for inspiration.

## Start by looking, not coding

If there's a reference (screenshot, site, brand), study it first: what's the type scale, the spacing
unit, the color story, the radius/shadow language, the density? Name the rules before you write CSS.
If there's no reference, **pick a point of view** (editorial, brutalist, soft-SaaS, technical-dense)
and commit to it — a clear wrong-for-some direction beats mushy default-for-everyone.

## The craft checklist (what separates premium from generic)

1. **Spacing system, not random px.** Choose one base unit (4 or 8px) and use multiples. Consistent
   rhythm is the single biggest "this looks designed" signal.
2. **A real type scale.** 2–3 weights, a deliberate size ramp (e.g. 12/14/16/20/28/40). Set
   line-height and max line-length (~60–75 chars) for body text. Tighten heading letter-spacing.
3. **Restrained color.** One dominant + one accent + a neutral ramp. Don't color everything. Ensure
   text contrast passes WCAG AA.
4. **One focal point per view.** Establish hierarchy: the most important action is unmistakably the
   most prominent. Everything else recedes.
5. **Depth with intent.** Shadows/borders should be consistent and subtle; avoid the default heavy
   drop shadow on everything. Prefer a coherent elevation system.
6. **Alignment & grid.** Edges line up. Optical alignment for icons and mixed content.
7. **States are part of the design.** Hover, focus-visible, disabled, empty, loading, error. An app
   with only the happy path looks like a prototype.
8. **Motion is seasoning.** Small, fast, purposeful transitions (150–250ms). Never animate everything.

## Anti-AI-slop tells (catch these before snapping)

- Everything centered with identical 16px gaps and one generic card style.
- Purple-to-blue gradient hero + emoji bullet list as the entire "design".
- A dozen ad-hoc font sizes and four competing accent colors.
- Perfectly symmetric, zero personality, no negative space used intentionally.
- Components that don't share a radius/shadow/spacing language.

If you see these in the screenshot, the design isn't done — iterate.

## Prove it

Capture the result with `tools/screenshot.sh` at desktop **and** mobile widths, then critique the
actual image against the checklist above (this is exactly what the redefined MIND Visual rubric in
`GAUNTLET.md` rewards — specific, evidence-based judgment, not "looks fine").
