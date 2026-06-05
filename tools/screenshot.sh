#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║  screenshot.sh — Thanos visual-proof adapter                             ║
# ║  Detect + invoke a browser-automation CLI (Playwright) to capture a REAL ║
# ║  rendered screenshot. NOT thin: for local files it spins an ephemeral    ║
# ║  static server (never file://), waits for the DOM to settle, captures    ║
# ║  the full page, and tears the server down.                               ║
# ╚══════════════════════════════════════════════════════════════════════════╝
#
# EXIT-CODE CONTRACT (see tools/README.md):
#   screenshot.sh --detect      0 = ready · non-zero = blocked (+ install hint on stderr)
#   screenshot.sh <target> ...  0 = PNG written (path on stdout) · non-zero = failure
#
# USAGE:
#   screenshot.sh --detect
#   screenshot.sh <url|local-file|local-dir> [out.png] [width] [height]
#
set -euo pipefail

# ─── helpers (logs to stderr so stdout stays the artifact path) ───────────────
_err()  { echo "screenshot: $*" >&2; }
_info() { echo "screenshot: $*" >&2; }

# ─── locate the Playwright CLI (global, or a local node_modules install) ──────
find_playwright() {
  if command -v playwright &>/dev/null; then echo "playwright"; return 0; fi
  if [[ -x "./node_modules/.bin/playwright" ]]; then echo "./node_modules/.bin/playwright"; return 0; fi
  return 1
}

# ─── DETECT: blocking readiness gate ──────────────────────────────────────────
detect() {
  local missing=0
  if ! find_playwright >/dev/null; then
    _err "Playwright not found. Install: npm i -D playwright && npx playwright install chromium  (or: brew install playwright && playwright install chromium)"
    missing=1
  fi
  if ! command -v python3 &>/dev/null; then
    _err "python3 not found (needed to serve local files over http — never file://). Install Python 3."
    missing=1
  fi
  if [[ "$missing" -eq 0 ]]; then
    _info "ready — $(find_playwright) + python3 $(python3 --version 2>&1 | awk '{print $2}')"
    return 0
  fi
  return 1
}

# ─── ephemeral static server (so local pages load over http, not file://) ─────
SERVER_PID=""
cleanup() { [[ -n "${SERVER_PID:-}" ]] && kill "$SERVER_PID" 2>/dev/null || true; }
trap cleanup EXIT INT TERM

wait_for_port() {
  local port="$1" _
  for _ in $(seq 1 60); do
    if python3 - "$port" <<'PYEOF'
import socket, sys
s = socket.socket(); s.settimeout(0.25)
sys.exit(0 if s.connect_ex(("127.0.0.1", int(sys.argv[1]))) == 0 else 1)
PYEOF
    then return 0; fi
    sleep 0.2
  done
  return 1
}

PORT=""
start_server() {
  local dir="$1"
  # Pick a high random port and start a quiet, localhost-only static server.
  PORT=$(( (RANDOM % 20000) + 20000 ))
  python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$dir" >/dev/null 2>&1 &
  SERVER_PID=$!
  if ! wait_for_port "$PORT"; then
    _err "ephemeral server failed to come up on port $PORT"
    return 1
  fi
  _info "serving '$dir' at http://127.0.0.1:$PORT/"
}

# ─── main ─────────────────────────────────────────────────────────────────────
main() {
  local first="${1:-}"
  if [[ "$first" == "--detect" ]]; then
    detect
    exit $?
  fi
  if [[ -z "$first" || "$first" == "-h" || "$first" == "--help" ]]; then
    echo "Usage: screenshot.sh <url|local-file|local-dir> [out.png] [width] [height]" >&2
    echo "       screenshot.sh --detect" >&2
    exit 1
  fi

  # Hard gate before doing any work — never pretend a screenshot happened.
  if ! detect >/dev/null 2>&1; then
    detect || true   # re-run to emit the hint to stderr
    _err "blocked — cannot capture without the engine above."
    exit 1
  fi

  local target="$first"
  local out="${2:-.thanos/proof/screenshot-$(date +%s).png}"
  local W="${3:-1280}"
  local H="${4:-800}"
  local settle="${THANOS_SHOT_SETTLE_MS:-1200}"

  mkdir -p "$(dirname "$out")"

  local url
  if [[ "$target" =~ ^https?:// ]]; then
    url="$target"
  elif [[ -d "$target" ]]; then
    start_server "$(cd "$target" && pwd)"
    url="http://127.0.0.1:${PORT}/"
  elif [[ -f "$target" ]]; then
    start_server "$(cd "$(dirname "$target")" && pwd)"
    url="http://127.0.0.1:${PORT}/$(basename "$target")"
  else
    _err "target not found (not a URL, file, or directory): $target"
    exit 1
  fi

  local pw; pw="$(find_playwright)"
  _info "capturing $url → $out (${W}x${H}, settle ${settle}ms, full-page)"
  if ! "$pw" screenshot \
        --full-page \
        --viewport-size "${W},${H}" \
        --wait-for-timeout "$settle" \
        "$url" "$out" >/dev/null 2>&1; then
    _err "playwright capture failed for $url"
    exit 1
  fi

  if [[ ! -s "$out" ]]; then
    _err "capture produced no (or empty) PNG: $out"
    exit 1
  fi

  _info "ok — $(wc -c < "$out" | tr -d ' ') bytes"
  echo "$out"   # stdout = the artifact path (the contract)
}

main "$@"
