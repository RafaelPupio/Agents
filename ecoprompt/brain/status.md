# Status — EcoPrompt

*Present tense only. Supersede, never stack.*

## Now — 2026-09-29

**Shipped. Both branches tested.** Released as `ecoprompt-v1.0`.

Five-part project: `system-prompt.md`, three knowledge files,
`skill/SKILL.md`, `install.sh`, README. Installed user-level at
`~/.claude/skills/ecoprompt/`, so `/ecoprompt` works in every project from
one copy.

**Test evidence.** Diagnose: run against a real session transcript, found
two defects (no handling for an unchosen idea, no `Audience` field). Compose:
run against a real repo task, found one (fixed-size output template gave
small tasks a brief longer than the change). All three fixed.

**Verified.** Install path exercised end to end from the published URL.
Repo copy and installed copy byte-identical.

**Next action:** none. Changes from here are earned by running it and
finding something, not by re-reading the prompt.
