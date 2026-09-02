#!/usr/bin/env bash
# Install EcoPrompt as a Claude Code skill into a target project.
# Usage: ./install.sh [target-project-dir]   (defaults to the current directory)
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

echo "EcoPrompt installed → $DEST"
echo "Start a new Claude Code session in $TARGET, then run /ecoprompt"
