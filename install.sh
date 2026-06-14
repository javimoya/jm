#!/usr/bin/env bash
#
# ALTERNATIVE install (without the plugin system).
# Copies the jm commands into ~/.claude/commands/jm/ (so they're invoked as /jm:ideate,
# /jm:discover, ... — same as the plugin) and the shared library into ~/.claude/jm-shared/.
#
# Prefer the plugin install (see the README) if you can — it auto-updates. This manual copy
# does not; re-run after `git pull`.
#
# Safe to re-run: an existing manual install is backed up to *.bak.<timestamp> first.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CMD_SRC="$SCRIPT_DIR/commands"
SHARED_SRC="$SCRIPT_DIR/jm-shared"

CMD_DEST="$HOME/.claude/commands/jm"
SHARED_DEST="$HOME/.claude/jm-shared"

if [ ! -d "$CMD_SRC" ] || [ ! -d "$SHARED_SRC" ]; then
  echo "error: run this from the repo root (commands/ and jm-shared/ not found)." >&2
  exit 1
fi

stamp="$(date +%Y%m%d-%H%M%S)"
echo "Installing jm (manual / non-plugin method)"

# A backup path that doesn't already exist — avoids collisions when install.sh runs more than once
# in the same second (the stamp has 1-second resolution; a colliding `mv` would nest the install
# inside its own backup or abort mid-run under `set -e`).
backup_path() {
  local candidate="$1.bak.$stamp" n=1
  while [ -e "$candidate" ]; do
    candidate="$1.bak.$stamp.$n"
    n=$((n + 1))
  done
  printf '%s' "$candidate"
}

if [ -e "$CMD_DEST" ]; then
  bak="$(backup_path "$CMD_DEST")"
  mv "$CMD_DEST" "$bak"
  echo "  • backed up existing commands/jm -> $(basename "$bak")"
fi
mkdir -p "$CMD_DEST"
cp -R "$CMD_SRC"/. "$CMD_DEST"/

if [ -e "$SHARED_DEST" ]; then
  bak="$(backup_path "$SHARED_DEST")"
  mv "$SHARED_DEST" "$bak"
  echo "  • backed up existing jm-shared -> $(basename "$bak")"
fi
mkdir -p "$SHARED_DEST"
cp -R "$SHARED_SRC"/. "$SHARED_DEST"/

# The commands reference ${CLAUDE_PLUGIN_ROOT}/jm-shared/ — a variable that only exists for
# installed plugins. Rewrite it to the absolute path this manual install uses.
# Portable in-place edit: write to a temp file and move it back (avoids `sed -i`, whose syntax
# differs between BSD/macOS and GNU/Linux).
find "$CMD_DEST" -name '*.md' -print0 | while IFS= read -r -d '' f; do
  tmp="$f.tmp.$$"
  sed "s#\${CLAUDE_PLUGIN_ROOT}/jm-shared/#$SHARED_DEST/#g" "$f" > "$tmp"
  mv "$tmp" "$f"
done

echo "Done. Commands installed under the 'jm' namespace:"
echo "  /jm:ideate   /jm:discover   /jm:build   /jm:audit   /jm:orient   /jm:wrap"
