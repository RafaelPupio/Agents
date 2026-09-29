# Status — Agents (container)

*Present tense only. Supersede, never stack.*

## Now — 2026-09-29

Public portfolio of agent projects, live at `github.com/RafaelPupio/Agents`.
MIT. One repo, one clone, one front page — **each agent inside is its own
project** with its own `CLAUDE.md`, `brain/` and version line.

| Agent | Kind | Version | State |
|---|---|---|---|
| ecoprompt | full agent | `ecoprompt-v1.0` | shipped, both branches tested |
| lease-reviewer | showcase | `lease-reviewer-v1.0` | complete as a showcase |

For either agent's state, read its own `brain/status.md`. This file tracks
the container only.

**Structure rationale.** Separate repos were considered and rejected:
EcoPrompt is six files and LeaseReviewer is one, neither earns a repo yet,
and splitting would break the published URL and both install commands.
Orphan branches were considered and rejected: they hide agents behind a
branch switcher, which is backwards for a repo whose job is being found.
`git subtree split --prefix=<agent>` promotes any folder to a standalone
repo later with its history intact, so nothing is foreclosed.

**Next action:** none. Agent 3 when there is a real problem worth one.

**Outstanding, outside this repo:** pin `Agents` on the GitHub profile (no
API exists), set profile location.
