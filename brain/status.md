# Status

*Present tense only. Supersede, never stack — old blocks go to `log/status-archive.md`.*

## Now — 2026-09-01

Repo scaffolded as a public portfolio of reusable agent definitions.

**Agent 1 — ecoprompt: built, Diagnose branch tested, Compose branch
untested.**

Complete: `system-prompt.md`, three knowledge files, `skill/SKILL.md`, agent
README with install for three platforms and four named customisation levers.
Installed locally at `.claude/skills/ecoprompt/` (gitignored — it is a
generated copy, source of truth stays in `ecoprompt/`).

**Test result.** Ran Diagnose against this session's own opening prompt.
Branch works. Found and fixed two defects: no handling for a user who has not
settled on an idea, and no `Audience` field despite audience being the single
most costly omission in the case under test.

**Next action:** test the Compose branch against a real unwritten task. That
is the half of the agent no evidence covers yet.

**Not done:** GitHub repo not created. Both READMEs hard-code
`github.com/RafaelPupio/Agents`, so the repo name must match or they need
editing first.
