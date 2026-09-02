# Status

*Present tense only. Supersede, never stack — old blocks go to `log/status-archive.md`.*

## Now — 2026-09-02

Public portfolio of reusable agent definitions, live at
`github.com/RafaelPupio/Agents`. MIT.

**Agent 1 — EcoPrompt: shipped. Diagnose tested, Compose untested.**

Complete: `system-prompt.md`, three knowledge files, `skill/SKILL.md`,
tested `install.sh`, README with three install routes and four named
customisation levers.

**Verified.** Install path exercised end to end from the published URL —
clone, run `install.sh`, five files land with real content and valid skill
frontmatter. Privacy sweep clean on every commit.

**Test evidence.** Diagnose branch run against a real session transcript;
found and fixed two defects (no handling for an unchosen idea, no `Audience`
field). Compose branch has no evidence behind it at all.

**Next action:** test Compose against a real, sloppily-described task. It is
the only remaining item that can still change the product.

**Then:** agent 2. Topic and audience not yet chosen.
