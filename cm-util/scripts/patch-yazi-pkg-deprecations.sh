#!/usr/bin/env bash
# patch-yazi-pkg-deprecations.sh
#
# Idempotently rewrites deprecated yazi Lua API calls in the third-party
# plugins installed by `ya pkg` (under
# cm-util/ctrld-configs/yazi/plugins/<plugin>.yazi/main.lua).
#
# WHY THIS EXISTS
#   The plugins listed in TARGETS still call `ya.mgr_emit(...)`, which yazi
#   deprecated in v25.5.28 (PR #2653) in favor of `ya.emit(...)`. The two
#   functions are equivalent, but the deprecated path fires a yellow
#   "Deprecated API" toast (once per yazi launch, per call site). There is
#   no Lua-level or config-level mechanism to suppress that toast — see
#   the note in dot_config/yazi/init.lua and the discussion in README.md
#   under "Suppressing the 'Deprecated API' toast".
#
# WHEN TO RUN
#   After every `ya pkg upgrade` (or `ya pkg upgrade --discard`), because
#   the upgrade overwrites these plugins from upstream and re-introduces
#   the deprecated calls.
#
# USAGE
#   $0                 patch in place; prints before/after counts
#   $0 --check         report counts only; exit 1 if any deprecated calls
#                      still present (useful for CI / a chezmoi run script)
#   $0 --help          print this message
#
# OWNERSHIP / UPSTREAM PRs
#   The right long-term fix is upstream PRs replacing `ya.mgr_emit` with
#   `ya.emit` in these repos. Once each upstream merges, this script can
#   drop that plugin from TARGETS and eventually be deleted.

set -euo pipefail

# Resolve the chezmoi source dir from this script's location so the script
# is location-independent (works when chezmoi source moves).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGINS_DIR="$SCRIPT_DIR/../ctrld-configs/yazi/plugins"

# Plugins that still call `ya.mgr_emit` after the latest upstream ya pkg.
# Update this list when upstream merges the rename — `bd ready` style:
# drop a plugin once its `ya.mgr_emit` count is zero post-`ya pkg upgrade`.
TARGETS=(
  bookmarks
  glow
  relative-motions
)

usage() {
  sed -nE 's/^# ?//p' "${BASH_SOURCE[0]}" | head -40
}

count_hits() {
  # `grep -c` already prints "0" when there are no matches, but it also
  # exits 1 in that case; pipe through `|| true` so the function returns
  # success without doubling the output.
  grep -c 'ya\.mgr_emit(' "$1" 2>/dev/null || true
}

main() {
  local mode="patch"
  case "${1:-}" in
    --help|-h) usage; exit 0 ;;
    --check)   mode="check" ;;
    "")        ;;
    *)         echo "unknown arg: $1" >&2; usage; exit 2 ;;
  esac

  local total_before=0 total_after=0 missing=0
  local missing_targets=()
  printf '%-25s %10s %10s\n' 'plugin' 'before' 'after'
  printf '%-25s %10s %10s\n' '-------' '------' '-----'

  for name in "${TARGETS[@]}"; do
    local f="$PLUGINS_DIR/$name.yazi/main.lua"
    if [[ ! -f "$f" ]]; then
      missing=$((missing+1))
      missing_targets+=("$name")
      printf '%-25s %10s %10s\n' "$name" '(missing)' '-'
      continue
    fi
    local before after
    before=$(count_hits "$f")
    total_before=$((total_before+before))

    if [[ "$mode" == "patch" && "$before" -gt 0 ]]; then
      # BSD/macOS-compatible sed (no \b — `ya.mgr_emit(` is distinctive
      # enough on its own to avoid false matches).
      sed -i.bak -E 's/ya\.mgr_emit\(/ya.emit(/g' "$f"
      rm "$f.bak"
    fi

    after=$(count_hits "$f")
    total_after=$((total_after+after))
    printf '%-25s %10d %10d\n' "$name" "$before" "$after"
  done

  echo
  printf 'total ya.mgr_emit  before=%d  after=%d\n' "$total_before" "$total_after"

  if [[ $missing -gt 0 ]]; then
    echo
    echo "warning: $missing target plugin(s) missing (not installed?): ${missing_targets[*]}" >&2
  fi

  # exit codes:
  #   --check  : 0 if all clean, 1 if any deprecated calls remain
  #   patch    : 0 if patch successfully drove count to zero or there was
  #              nothing to patch; 1 otherwise (something blocked the sed)
  if [[ "$total_after" -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
