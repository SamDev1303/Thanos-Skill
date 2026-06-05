#!/usr/bin/env bash
# email.sh — Thanos media-comms adapter (react-email). Render email templates → HTML.
#   --detect                       0 ready · non-zero blocked (+ hint on stderr)
#   export <email-dir> [out-dir]   render templates to static HTML
# NOTE: sending email is outward-facing — this adapter only RENDERS. Confirm before sending.
set -euo pipefail
_err(){ echo "email: $*" >&2; }
_info(){ echo "email: $*" >&2; }

react_email() {
  if command -v react-email &>/dev/null; then echo "react-email"; return 0; fi
  if [[ -x "./node_modules/.bin/react-email" ]]; then echo "./node_modules/.bin/react-email"; return 0; fi
  return 1
}

detect() {
  if ! react_email >/dev/null; then
    _err "react-email not found. Install: npm i -D react-email @react-email/components"
    return 1
  fi
  _info "ready — $(react_email)"
  return 0
}

main() {
  local cmd="${1:-}"
  [[ "$cmd" == "--detect" ]] && { detect; exit $?; }
  if ! detect >/dev/null 2>&1; then detect || true; _err "blocked"; exit 1; fi

  case "$cmd" in
    export)
      local dir="${2:-emails}" outdir="${3:-.thanos/proof/email}"
      [[ -d "$dir" ]] || { _err "email template dir not found: $dir"; exit 1; }
      mkdir -p "$outdir"
      local re; re=$(react_email)
      _info "rendering $dir → $outdir"
      "$re" export --dir "$dir" --outDir "$outdir" >/dev/null 2>&1 \
        || { _err "react-email export failed"; exit 1; }
      local n; n=$(find "$outdir" -name '*.html' | wc -l | tr -d ' ')
      [[ "$n" -gt 0 ]] || { _err "no HTML produced"; exit 1; }
      _info "ok — $n html file(s)"
      echo "$outdir"
      ;;
    *)
      echo "Usage: email.sh --detect | export <email-dir> [out-dir]" >&2
      exit 1 ;;
  esac
}
main "$@"
