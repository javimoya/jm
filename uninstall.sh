#!/usr/bin/env bash
#
# Removes the jm skills installed by install.sh from your Claude Code skills directory.
# Backups created by install.sh (named *.bak.*) are left untouched.
#
# Usage:
#   ./uninstall.sh
#   CLAUDE_SKILLS_DIR=/custom/path ./uninstall.sh
#
set -euo pipefail

SKILLS=(ideate discover build audit orient jm-shared)
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

echo "Removing jm skills from: $DEST"
removed=0
for name in "${SKILLS[@]}"; do
  if [ -e "$DEST/$name" ]; then
    rm -rf "$DEST/$name"
    echo "  • $name — removed"
    removed=$((removed + 1))
  fi
done

if [ "$removed" -eq 0 ]; then
  echo "  (nothing to remove)"
fi
echo "Done. Any *.bak.* backups were left in place."
