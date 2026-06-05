---
name: media-comms
purpose: Produce and handle media/comms artifacts — transcripts, video, email, durable notes.
triggers: transcribe this audio, turn this into a video, send an email, make a render, save this as a note, generate a clip
requires: transcribe, video, email, notes
---

# 🎙️ Media & Comms

> Some goals produce artifacts that aren't code: a transcript of a meeting, a short video render, an
> email, a durable note. This bundle adapters those out to dedicated tools and drops the results in
> `.thanos/proof/` so they become real evidence, not claims.

Original best-practice guidance. The underlying tools (Whisper, ffmpeg, react-email, Obsidian/memos)
are **adapter-invoke only** — the user installs them; Thanos ships none of their code. Note Remotion
and Obsidian have non-standard licenses (see `docs/CREDITS.md`); use them under their own terms.

## The four adapters

| Tool | What it does | Engine |
|---|---|---|
| `transcribe` | audio/video → text transcript | Whisper |
| `video` | images/clips → a rendered video (or a test render) | ffmpeg |
| `email` | render an email template to HTML | react-email |
| `notes` | append a durable, Obsidian-compatible markdown note | (zero-dep markdown) |

Each is detect-gated by MOBILIZE. If one is **blocked** (its CLI isn't installed), you'll see it in
`.thanos/SPACE.md` — surface the install hint and ask install-or-skip. Never claim an artifact you
couldn't actually produce.

## Working rules

1. **Artifacts are proof.** Write transcripts/renders/notes into `.thanos/proof/` and reference them
   in POWER/MIND — same discipline as a screenshot.
2. **Transcription:** prefer a small/local Whisper model for speed unless accuracy demands larger;
   capture the model used. Audio in → `.thanos/proof/<name>.txt`.
3. **Video:** keep renders short and deterministic for proof. For real output, drive ffmpeg from a
   defined image sequence or clip list, not ad-hoc.
4. **Email:** render to static HTML and screenshot it (`visual-proof`) before anyone sends anything.
   Sending is outward-facing — confirm with the user first.
5. **Notes:** write self-contained markdown with a title + timestamp so it's useful months later and
   syncs cleanly into an Obsidian vault or memos.

## Mobilizing a subset

If the goal only needs one adapter (e.g. just transcription), it's fine that the others show as
blocked — resolve only the one you need with the user.
