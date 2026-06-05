#!/usr/bin/env bash
# video.sh — Thanos media-comms adapter (ffmpeg). Render video artifacts to .thanos/proof/.
#   --detect                         0 ready · non-zero blocked (+ hint on stderr)
#   testcard [out.mp4] [seconds]     deterministic test render (proof/demo)
#   slideshow <img-dir> [out.mp4] [sec-per-image]
set -euo pipefail
_err(){ echo "video: $*" >&2; }
_info(){ echo "video: $*" >&2; }

detect() {
  if ! command -v ffmpeg &>/dev/null; then
    _err "ffmpeg not found. Install: brew install ffmpeg  (or apt-get install ffmpeg)"
    return 1
  fi
  # NOTE: ffmpeg reads stdin by default and will BLOCK on a TTY — always feed it </dev/null
  # (probe) or pass -nostdin (renders below). This is the canonical ffmpeg-in-script fix.
  _info "ready — ffmpeg $(ffmpeg -version </dev/null 2>/dev/null | head -1 | awk '{print $3}')"
  return 0
}

main() {
  local cmd="${1:-}"
  [[ "$cmd" == "--detect" ]] && { detect; exit $?; }
  if ! detect >/dev/null 2>&1; then detect || true; _err "blocked"; exit 1; fi

  local out=""
  case "$cmd" in
    testcard)
      out="${2:-.thanos/proof/video-testcard-$(date +%s).mp4}"
      local secs="${3:-2}"
      mkdir -p "$(dirname "$out")"
      _info "rendering ${secs}s testcard → $out"
      ffmpeg -nostdin -y -f lavfi -i "testsrc=size=640x360:rate=25:duration=${secs}" \
             -f lavfi -i "sine=frequency=440:duration=${secs}" \
             -pix_fmt yuv420p -shortest "$out" >/dev/null 2>&1 \
        || { _err "ffmpeg render failed"; exit 1; }
      ;;
    slideshow)
      local dir="${2:-}"
      out="${3:-.thanos/proof/video-slideshow-$(date +%s).mp4}"
      local per="${4:-2}"
      [[ -d "$dir" ]] || { _err "slideshow needs an image directory: $dir"; exit 1; }
      mkdir -p "$(dirname "$out")"
      _info "building slideshow from $dir → $out (${per}s/image)"
      ffmpeg -nostdin -y -framerate "1/${per}" -pattern_type glob -i "$dir/*.png" \
             -vf "scale=1280:-2:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,format=yuv420p" \
             -r 25 "$out" >/dev/null 2>&1 \
        || { _err "ffmpeg slideshow failed (need .png files in $dir)"; exit 1; }
      ;;
    *)
      echo "Usage: video.sh --detect | testcard [out.mp4] [secs] | slideshow <img-dir> [out.mp4] [sec/img]" >&2
      exit 1 ;;
  esac

  [[ -s "$out" ]] || { _err "no output produced"; exit 1; }
  _info "ok — $(wc -c < "$out" | tr -d ' ') bytes"
  echo "$out"
}
main "$@"
