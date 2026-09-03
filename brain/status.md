# Status

*Present tense only. Supersede, never stack — old blocks go to `log/status-archive.md`.*

## Now — 2026-09-03

Public portfolio of reusable agent definitions, live at
`github.com/RafaelPupio/Agents`. MIT.

**Agent 2 — LeaseReviewer: showcase only.** A Brazilian lease counsel
(review, consult, readjust, notify) plus a scheduled reminder runner. The
full build is private because it sits next to real contracts and needs a
scheduler. This repo carries `lease-reviewer/README.md` (idea, shape,
anonymised example) and a section in the root README. Nothing installable
here, by design.

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

**Discoverability pass done.** Repo has a description, 9 topics and a
homepage. Root README leads with a before/after rather than a description.
`MORDOMO` and `rafaelpupio.com` given topics. Profile website field set.
Repo keeps the name `Agents`; agents inside carry their own product names.

**Next action:** test Compose against a real, sloppily-described task. It is
the only remaining item that can still change the product.

**Outstanding, manual only:** pin `Agents` on the profile (no API exists),
set profile location, optionally delete two boilerplate forks.

**Then:** if LeaseReviewer is ever generalised for publication, it becomes
a full four-part folder here. That is a separate decision, not planned.
