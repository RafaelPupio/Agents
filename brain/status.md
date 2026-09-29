# Status

*Present tense only. Supersede, never stack — old blocks go to `log/status-archive.md`.*

## Now — 2026-09-29

Public portfolio of reusable agent definitions, live at
`github.com/RafaelPupio/Agents`. MIT. Two entries, both complete for what
they are.

**Agent 1 — EcoPrompt: shipped, both branches tested.**
Five-part folder: `system-prompt.md`, three knowledge files, `skill/SKILL.md`,
`install.sh`, README. Installed user-level at `~/.claude/skills/ecoprompt/`,
so `/ecoprompt` works in every project from one copy.

**Agent 2 — LeaseReviewer: showcase, by design.** README only. The build
sits beside real contracts and stays private. `CLAUDE.md` now recognises
showcase entries, so this is a documented shape rather than a violation.

**Test evidence — both branches now have some.**
Diagnose: run against a real session transcript. Found two defects, both
fixed (no handling for an unchosen idea, no `Audience` field).
Compose: run against a real repo task (the `CLAUDE.md` showcase gap). Found
one defect, fixed — the output template was fixed-size regardless of task
size, so small tasks got a brief longer than the change it described, which
the prompt forbids but gave no way to avoid. Short form added.

**Verified.** Install path exercised end to end from the published URL.
Repo audited against its own `CLAUDE.md`: structure, size caps, no
duplicated instruction text, privacy sweep clean.

**Next action:** none required. The project is complete as scoped. Agent 3
when there is a real problem worth one — not before.

**Outstanding, outside this repo and manual only:** pin `Agents` on the
GitHub profile (no API exists for pinning), set profile location.
