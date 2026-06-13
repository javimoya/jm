#!/usr/bin/env bash
#
# Removes the manual (non-plugin) install done by install.sh.
# Backups (named *.bak.*) are left untouched.
#
set -euo pipefail

CMD_DEST="$HOME/.claude/commands/jm"
SHARED_DEST="$HOME/.claude/jm-shared"

echo "Removing jm manual install"
removed=0
if [ -e "$CMD_DEST" ]; then
  rm -rf "$CMD_DEST"
  echo "  • removed ~/.claude/commands/jm"
  removed=1
fi
if [ -e "$SHARED_DEST" ]; then
  rm -rf "$SHARED_DEST"
  echo "  • removed ~/.claude/jm-shared"
  removed=1
fi
if [ "$removed" -eq 0 ]; then
  echo "  (nothing to remove)"
fi
echo "Done. Any *.bak.* backups were left in place."
