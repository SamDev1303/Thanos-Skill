#!/usr/bin/env bash
# transcribe.sh — Thanos media-comms adapter (Whisper). Audio/video → text transcript.
#   --detect                              0 ready · non-zero blocked (+ hint on stderr)
#   <audio-file> [out.txt] [model]        transcribe (model default: base)
set -euo pipefail
_err(){ echo "transcribe: $*" >&2; }
_info(){ echo "transcribe: $*" >&2; }

# Resolve a whisper invocation: the `whisper` CLI, or the python module.
whisper_cmd() {
  if command -v whisper &>/dev/null; then echo "whisper"; return 0; fi
  if python3 -c "import whisper" 2>/dev/null; then echo "python3 -m whisper"; return 0; fi
  return 1
}

detect() {
  if ! whisper_cmd >/dev/null; then
    _err "Whisper not found. Install: pipx install openai-whisper  (or: pip install -U openai-whisper). Needs ffmpeg too."
    return 1
  fi
  command -v ffmpeg &>/dev/null || { _err "ffmpeg not found (Whisper needs it). Install: brew install ffmpeg"; return 1; }
  _info "ready — $(whisper_cmd) + ffmpeg"
  return 0
}

main() {
  local first="${1:-}"
  [[ "$first" == "--detect" ]] && { detect; exit $?; }
  if [[ -z "$first" ]]; then echo "Usage: transcribe.sh <audio-file> [out.txt] [model] | --detect" >&2; exit 1; fi
  if ! detect >/dev/null 2>&1; then detect || true; _err "blocked"; exit 1; fi

  local audio="$first"
  [[ -f "$audio" ]] || { _err "audio file not found: $audio"; exit 1; }
  local out="${2:-.thanos/proof/transcript-$(date +%s).txt}"
  local model="${3:-base}"
  mkdir -p "$(dirname "$out")"

  local tmpd; tmpd=$(mktemp -d)
  trap 'rm -rf "$tmpd"' EXIT   # clean up even on an unexpected set -e exit (matches graph.sh)
  _info "transcribing $audio (model=$model) — first run downloads the model, be patient"
  local wc; wc=$(whisper_cmd)
  if ! $wc "$audio" --model "$model" --output_format txt --output_dir "$tmpd" >/dev/null 2>&1; then
    _err "whisper failed"; rm -rf "$tmpd"; exit 1
  fi
  local produced; produced=$(ls "$tmpd"/*.txt 2>/dev/null | head -1 || true)
  [[ -n "$produced" && -s "$produced" ]] || { _err "no transcript produced"; rm -rf "$tmpd"; exit 1; }
  mv "$produced" "$out"; rm -rf "$tmpd"
  _info "ok — $(wc -c < "$out" | tr -d ' ') bytes"
  echo "$out"
}
main "$@"
