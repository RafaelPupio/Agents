#!/usr/bin/env bash
# Tests for install.sh. Every case runs in a fresh temp dir; HOME and NEO_HOME
# point inside it, so the real home directory is never touched.
set -uo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILED=0

# fresh sandbox: sets T (root), HOME, NEO_HOME, TARGET
sandbox() {
  T="$(mktemp -d)"
  trap 'rm -rf "$T"' EXIT   # each case runs in its own subshell
  export HOME="$T/home"
  export NEO_HOME="$T/neo-home"
  TARGET="$T/target"
  mkdir -p "$HOME" "$TARGET"
}

run_case() {
  if ( "$1" ); then
    echo "PASS $1"
  else
    echo "FAIL $1"
    FAILED=$((FAILED + 1))
  fi
}

# Each case runs in a subshell and returns non-zero on any failed assertion.
ok() { # ok <description> <command...>
  local desc="$1"; shift
  if ! "$@" >/dev/null 2>&1; then
    echo "    assertion failed: $desc" >&2
    return 1
  fi
}

assert_fresh_install() { # assert_fresh_install <skill-dir-rel> <harness> <src>
  local rel="$1" harness="$2" src="$3" d f
  d="$TARGET/$rel/neo"
  ok "SKILL.md" test -f "$d/SKILL.md" || return 1
  for f in system-prompt.md adapter.md briefing.md orchestration.md engineering.md tooling.md memory.md; do
    ok "references/$f" test -f "$d/references/$f" || return 1
  done
  ok "adapter.md matches adapter" cmp -s "$d/references/adapter.md" "$src/adapters/$harness.md" || return 1
}

assert_library() {
  ok "INDEX.md" test -f "$NEO_HOME/INDEX.md" || return 1
  ok "skills.md" test -f "$NEO_HOME/skills.md" || return 1
  ok "tools/" test -d "$NEO_HOME/tools" || return 1
  ok "techniques/" test -d "$NEO_HOME/techniques" || return 1
  ok "sources/" test -d "$NEO_HOME/sources" || return 1
}

# copy of the source tree, for cases that modify it; sets COPY
copy_src() {
  COPY="$T/src copy/neo"
  mkdir -p "$T/src copy"
  cp -R "$SRC" "$COPY"
}

case_fresh_install() {
  sandbox
  "$SRC/install.sh" claude-code "$TARGET" >/dev/null 2>&1 || { echo "    install failed" >&2; return 1; }
  assert_fresh_install .claude/skills claude-code "$SRC" || return 1
  "$SRC/install.sh" codex "$TARGET" >/dev/null 2>&1 || return 1
  assert_fresh_install .agents/skills codex "$SRC" || return 1
  ok "codex implicit invocation off" grep -q 'allow_implicit_invocation: false' "$TARGET/.agents/skills/neo/agents/openai.yaml" || return 1
  "$SRC/install.sh" hermes "$TARGET" >/dev/null 2>&1 || return 1
  assert_fresh_install .hermes/skills hermes "$SRC" || return 1
}

case_reinstall_refreshes() {
  sandbox; copy_src
  "$COPY/install.sh" claude-code "$TARGET" >/dev/null 2>&1 || return 1
  echo "changed prompt line" >> "$COPY/system-prompt.md"
  rm "$COPY/knowledge/tooling.md"
  "$COPY/install.sh" claude-code "$TARGET" >/dev/null 2>&1 || return 1
  local d="$TARGET/.claude/skills/neo/references"
  ok "prompt refreshed" cmp -s "$d/system-prompt.md" "$COPY/system-prompt.md" || return 1
  ok "deleted knowledge file gone" test ! -e "$d/tooling.md" || return 1
}

case_library_seeded() {
  sandbox
  "$SRC/install.sh" claude-code "$TARGET" >/dev/null 2>&1 || return 1
  assert_library || return 1
}

case_library_kept() {
  sandbox
  mkdir -p "$NEO_HOME"
  printf 'mine\n' > "$NEO_HOME/INDEX.md"
  "$SRC/install.sh" claude-code "$TARGET" >/dev/null 2>&1 || return 1
  ok "INDEX.md untouched" test "$(cat "$NEO_HOME/INDEX.md")" = "mine" || return 1
  ok "missing skills.md created" test -f "$NEO_HOME/skills.md" || return 1
}

case_dry_run() {
  sandbox
  local out rc=0
  out="$("$SRC/install.sh" claude-code "$TARGET" --dry-run 2>&1)" || rc=$?
  ok "exit 0" test "$rc" -eq 0 || return 1
  ok "nothing in target" test -z "$(ls -A "$TARGET")" || return 1
  ok "no library" test ! -e "$NEO_HOME" || return 1
  ok "plan names skill path" grep -qF "$TARGET/.claude/skills/neo" <<<"$out" || return 1
  ok "plan names library path" grep -qF "$NEO_HOME" <<<"$out" || return 1
}

case_missing_target() {
  sandbox
  local rc=0
  "$SRC/install.sh" claude-code "$T/does-not-exist" >/dev/null 2>&1 || rc=$?
  ok "exit 1" test "$rc" -eq 1 || return 1
  ok "target not created" test ! -e "$T/does-not-exist" || return 1
  ok "library not created" test ! -e "$NEO_HOME" || return 1
}

case_unknown_harness() {
  sandbox
  local rc=0 out
  "$SRC/install.sh" emacs "$TARGET" >/dev/null 2>&1 || rc=$?
  ok "emacs exits 2" test "$rc" -eq 2 || return 1
  rc=0
  out="$("$SRC/install.sh" generic "$TARGET" 2>&1)" || rc=$?
  ok "generic exits 2" test "$rc" -eq 2 || return 1
  ok "generic hint" grep -qi "paste" <<<"$out" || return 1
  ok "nothing installed" test -z "$(ls -A "$TARGET")" || return 1
}

case_path_with_space() {
  sandbox
  TARGET="$T/my target"
  export NEO_HOME="$T/my neo home"
  mkdir -p "$TARGET"
  "$SRC/install.sh" claude-code "$TARGET" >/dev/null 2>&1 || return 1
  assert_fresh_install .claude/skills claude-code "$SRC" || return 1
  assert_library || return 1
  ok "project templates" test -f "$NEO_HOME/templates/project/INDEX.md" || return 1
}

case_project_install_leaves_ignore() {
  sandbox
  git init -q "$TARGET" || return 1
  printf 'node_modules/\n' > "$TARGET/.gitignore"
  cp "$TARGET/.gitignore" "$T/ignore.before"
  cp "$TARGET/.git/info/exclude" "$T/exclude.before"
  "$SRC/install.sh" claude-code "$TARGET" >/dev/null 2>&1 || return 1
  ok ".gitignore unchanged" cmp -s "$TARGET/.gitignore" "$T/ignore.before" || return 1
  ok "info/exclude unchanged" cmp -s "$TARGET/.git/info/exclude" "$T/exclude.before" || return 1
  ok "no .neo created in project" test ! -e "$TARGET/.neo" || return 1
}

case_project_templates_available() {
  sandbox
  "$SRC/install.sh" claude-code "$TARGET" >/dev/null 2>&1 || return 1
  local f
  for f in INDEX.md project.md decisions.md tooling.md journal.md; do
    ok "templates/project/$f" test -f "$NEO_HOME/templates/project/$f" || return 1
  done
  ok "journal opens with To promote" grep -q '^## To promote' "$NEO_HOME/templates/project/journal.md" || return 1
  for f in Adopted Declined Pending; do
    ok "skills.md $f" grep -q "^## $f" "$NEO_HOME/skills.md" || return 1
  done
}

for c in fresh_install reinstall_refreshes library_seeded library_kept dry_run \
         missing_target unknown_harness path_with_space \
         project_install_leaves_ignore project_templates_available; do
  run_case "case_$c"
done

if [ "$FAILED" -ne 0 ]; then
  echo "$FAILED case(s) failed"
  exit 1
fi
echo "all cases passed"
