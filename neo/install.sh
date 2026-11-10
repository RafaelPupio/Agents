#!/usr/bin/env bash
# Install Neo as a skill, and seed its private library.
#   ./install.sh claude-code ~          every project on this machine
#   ./install.sh codex /path/to/project that project only
#   ./install.sh hermes --dry-run       show what would happen, write nothing
# Harnesses: claude-code, codex, hermes. Target defaults to ~.
# NEO_HOME is the library (default ~/.neo). Existing library files are never overwritten.
# Exit: 0 ok, 1 bad input, 2 unknown harness.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="${HOME:-}"
if [ -z "${NEO_HOME:-}" ]; then
  if [ -z "$HOME_DIR" ]; then
    echo "error: HOME is not set; set HOME or NEO_HOME" >&2
    exit 1
  fi
  NEO_HOME="$HOME_DIR/.neo"
fi

usage() { echo "usage: install.sh <claude-code|codex|hermes> [target] [--dry-run]" >&2; }

HARNESS="${1:-}"
if [ -z "$HARNESS" ]; then usage; exit 1; fi
shift

TARGET=""
DRY=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY=1 ;;
    -*) echo "error: unknown option: $arg" >&2; usage; exit 1 ;;
    *)
      if [ -n "$TARGET" ]; then echo "error: more than one target given" >&2; usage; exit 1; fi
      TARGET="$arg" ;;
  esac
done
if [ -z "$TARGET" ]; then
  if [ -z "$HOME_DIR" ]; then
    echo "error: HOME is not set; give a target directory" >&2
    exit 1
  fi
  TARGET="$HOME_DIR"
fi

case "$HARNESS" in
  claude-code|codex|hermes) ;;
  generic)
    echo "error: generic is not installable; it is paste-in. Paste adapters/generic.md and system-prompt.md as the first message." >&2
    exit 2 ;;
  *)
    echo "error: unknown harness: $HARNESS (use claude-code, codex or hermes)" >&2
    exit 2 ;;
esac

ADAPTER="$SRC/adapters/$HARNESS.md"
SKILL_REL="$(sed -n '1s/^SKILL_DIR:[[:space:]]*//p' "$ADAPTER")"
INVOKE="$(sed -n '2s/^INVOKE:[[:space:]]*//p' "$ADAPTER")"
if [ -z "$SKILL_REL" ] || [ -z "$INVOKE" ]; then
  echo "error: could not read SKILL_DIR/INVOKE from $ADAPTER" >&2
  exit 1
fi

if [ ! -d "$TARGET" ]; then
  echo "error: target directory does not exist: $TARGET" >&2
  exit 1
fi

DEST="$TARGET/$SKILL_REL/neo"
REFS="$DEST/references"

if [ "$DRY" -eq 1 ]; then
  echo "dry run: nothing will be written"
  echo "skill:   $DEST  (replaced wholesale)"
  echo "library: $NEO_HOME  (missing files only)"
  echo "         $NEO_HOME/templates/project  (missing files only)"
  exit 0
fi

# Skill: build beside the old install, then swap, so a failed copy leaves the old one intact.
NEW="$DEST.new.$$"
trap 'rm -rf "$NEW"' EXIT
mkdir -p "$NEW/references"
cp "$SRC/skill/SKILL.md" "$NEW/"
cp "$SRC/system-prompt.md" "$SRC"/knowledge/*.md "$NEW/references/"
cp "$ADAPTER" "$NEW/references/adapter.md"
if [ "$HARNESS" = "codex" ]; then
  mkdir -p "$NEW/agents"
  printf 'policy:\n  allow_implicit_invocation: false\n' > "$NEW/agents/openai.yaml"
fi
rm -rf "${DEST:?}"
mv "$NEW" "$DEST"

# Library and project skeleton: copy only what is absent; never touch the owner's notes.
seed() { # seed <source dir> <dest dir>
  mkdir -p "$2"
  ( cd "$1" && find . -mindepth 1 | sort ) | while IFS= read -r rel; do
    case "$rel" in */.gitkeep) continue ;; esac
    if [ -d "$1/$rel" ]; then
      mkdir -p "$2/$rel"
    elif [ ! -e "$2/$rel" ]; then
      cp "$1/$rel" "$2/$rel"
    fi
  done
}
seed "$SRC/templates/library" "$NEO_HOME"
seed "$SRC/templates/project" "$NEO_HOME/templates/project"

echo "Neo installed → $DEST"
echo "Library        → $NEO_HOME"
if [ "$TARGET" = "$HOME_DIR" ]; then
  echo "Start a new session anywhere, then call Neo with: $INVOKE"
else
  echo "Start a new session in $TARGET, then call Neo with: $INVOKE"
fi
if [ "$HARNESS" = "hermes" ] && [ "$TARGET" != "$HOME_DIR" ]; then
  echo "Next step: project-level skills load only after you run 'hermes skills trust' in $TARGET"
fi
