#!/usr/bin/env bash
# notes.sh — Thanos media-comms adapter. Append a durable, Obsidian-compatible markdown note.
# Zero external dependency by design (so it is always available). Optionally syncs to an
# Obsidian vault / memos dir via THANOS_NOTES_VAULT.
#   --detect                       0 ready (always, unless vault unwritable)
#   <title> [body...]              write a timestamped note; prints its path
set -euo pipefail
_err(){ echo "notes: $*" >&2; }
_info(){ echo "notes: $*" >&2; }

vault() { echo "${THANOS_NOTES_VAULT:-.thanos/proof/notes}"; }

detect() {
  local v; v="$(vault)"
  if ! mkdir -p "$v" 2>/dev/null; then
    _err "notes vault not writable: $v (set THANOS_NOTES_VAULT to a writable dir)"
    return 1
  fi
  _info "ready — vault: $v"
  return 0
}

slug() { echo "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g' | cut -c1-50; }

main() {
  local first="${1:-}"
  [[ "$first" == "--detect" ]] && { detect; exit $?; }
  if [[ -z "$first" ]]; then echo "Usage: notes.sh <title> [body...] | --detect" >&2; exit 1; fi
  if ! detect >/dev/null 2>&1; then detect || true; _err "blocked"; exit 1; fi

  local title="$first"; shift || true
  local body="$*"
  local v; v="$(vault)"
  local date_h; date_h="$(date -u +"%Y-%m-%d")"
  local ts; ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  local file; file="$v/${date_h}-$(slug "$title").md"

  {
    echo "---"
    echo "title: $title"
    echo "created: $ts"
    echo "source: thanos"
    echo "---"
    echo ""
    echo "# $title"
    echo ""
    [[ -n "$body" ]] && echo "$body" || echo "_(no body)_"
  } > "$file"

  [[ -s "$file" ]] || { _err "failed to write note"; exit 1; }
  _info "ok — wrote note"
  echo "$file"
}
main "$@"
