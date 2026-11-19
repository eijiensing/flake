#!/usr/bin/env bash
# Backend for the Thunar archive plugin.
#
# The plugin calls this as:
#   dtrx-thunar <create|extract-here|extract-to> <folder> <file>...
#
# It is also used directly by the (hidden) dtrx desktop entry as:
#   dtrx-thunar open <file>
#
# Extraction is delegated to dtrx. Creating archives is delegated to
# xarchiver, which provides the "choose a name/location" GUI that dtrx
# does not have.

set -uo pipefail

action="${1:-open}"
shift || true

folder="${1:-}"
if [[ -n "$folder" ]]; then
  shift || true
fi

error_dialog() {
  local title="$1"
  local text="$2"

  if command -v zenity >/dev/null 2>&1; then
    zenity --error --title="$title" --text="$text" 2>/dev/null || true
  else
    printf '%s: %s\n' "$title" "$text" >&2
  fi
}

choose_directory() {
  local title="$1"
  local start="$2"

  zenity --file-selection --directory \
    --title="$title" \
    --filename="${start%/}/" 2>/dev/null
}

extract_archive() {
  local dest="$1"
  local archive="$2"
  local output status

  # dtrx's whole point is to choose a safe layout for the archive: it
  # normally extracts into a new directory named after the archive
  # (appending .1, .2, ... on collisions) instead of flattening files into
  # the current directory. `--flat` would overwrite/clobber too eagerly,
  # so keep the default behaviour.
  output="$(cd "$dest" && dtrx --noninteractive -- "$archive" 2>&1)"
  status=$?

  if (( status != 0 )); then
    error_dialog "Extraction failed" "Could not extract $(basename "$archive").

$output"
    return 1
  fi

  return 0
}

case "$action" in
  create)
    # Let xarchiver ask for the archive name/location, like a normal
    # "Create Archive..." action.
    exec xarchiver --compress "$@"
    ;;

  extract-here)
    [[ -n "$folder" ]] || folder="$PWD"

    for archive in "$@"; do
      extract_archive "$folder" "$archive" || true
    done
    ;;

  extract-to)
    [[ -n "$folder" ]] || folder="$PWD"

    destination="$(choose_directory "Extract archives to..." "$folder")" || exit 0
    [[ -n "$destination" ]] || exit 0

    for archive in "$@"; do
      extract_archive "$destination" "$archive" || true
    done
    ;;

  open)
    archive="$folder"
    [[ -n "$archive" ]] || exit 1

    destination="$(choose_directory "Extract archive to..." "$(dirname "$archive")")" || exit 0
    [[ -n "$destination" ]] || exit 0

    extract_archive "$destination" "$archive" || true
    ;;

  *)
    error_dialog "dtrx" "Unsupported archive action: $action"
    exit 1
    ;;
esac
