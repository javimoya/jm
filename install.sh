#!/usr/bin/env bash
#
# ALTERNATIVE install (without the plugin system).
# Copies the jm skills into your Claude Code skills directory.
#
# Prefer the plugin install if you can (see the README) — it namespaces the commands as
# /jm:ideate and can't collide with your other skills. With THIS method the skills land as
# personal skills and the commands are the BARE verbs: /ideate /discover /build /audit /orient
# (the jm-shared library is internal and not invoked directly).
#
# Safe to re-run: any existing skill of the same name is backed up first.
#
# Usage:
#   ./install.sh
#   CLAUDE_SKILLS_DIR=/custom/path ./install.sh
#
set -euo pipefail

SKILLS=(ideate discover build audit orient jm-shared)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/skills"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

if [ ! -d "$SRC" ]; then
  echo "error: can't find the skills/ folder next to this script ($SRC)." >&2
  exit 1
fi

echo "Installing jm skills (manual / non-plugin method)"
echo "  from: $SRC"
echo "  to:   $DEST"
echo

mkdir -p "$DEST"

stamp="$(date +%Y%m%d-%H%M%S)"
for name in "${SKILLS[@]}"; do
  target="$DEST/$name"
  if [ -e "$target" ]; then
    mv "$target" "$target.bak.$stamp"
    echo "  • $name — existing version backed up to $(basename "$target.bak.$stamp")"
  else
    echo "  • $name — installed"
  fi
  cp -R "$SRC/$name" "$target"
done

echo
echo "Done. With this manual method the commands are the bare verbs:"
echo "  /ideate   /discover   /build   /audit   /orient"
echo "(the README uses the plugin form /jm:build — here, drop the 'jm:' prefix.)"
