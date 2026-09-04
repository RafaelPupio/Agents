#!/usr/bin/env bash
# Install EcoPrompt as a Claude Code skill.
#   ./install.sh ~                  every project on this machine (recommended)
#   ./install.sh /path/to/project   that project only
#   ./install.sh                    the current directory
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-$PWD}"

if [ ! -d "$TARGET" ]; then
  echo "error: target directory does not exist: $TARGET" >&2
  exit 1
fi

DEST="$TARGET/.claude/skills/ecoprompt"
mkdir -p "$DEST/references"
cp "$SRC/skill/SKILL.md" "$DEST/"
cp "$SRC/system-prompt.md" "$SRC"/knowledge/*.md "$DEST/references/"

if [ "$TARGET" = "$HOME" ]; then
  echo "EcoPrompt installed for every project → $DEST"
  echo "Start a new Claude Code session anywhere, then run /ecoprompt"
else
  echo "EcoPrompt installed → $DEST"
  echo "Start a new Claude Code session in $TARGET, then run /ecoprompt"
fi
