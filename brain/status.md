# Status — Agents (container)

*Present tense only. Supersede, never stack.*

## Now — 2026-11-11

Public portfolio of agent projects, live at `github.com/RafaelPupio/Agents`.
MIT. One repo, one clone, one front page — **each agent inside is its own
project** with its own `CLAUDE.md`, `brain/` and version line.

| Agent | Kind | Version | State |
|---|---|---|---|
| ecoprompt | full agent | `ecoprompt-v1.0` | shipped, both branches tested |
| lease-reviewer | showcase | `lease-reviewer-v1.0` | complete as a showcase |
| neo | full agent | `neo-v1.0` | shipped; Claude Code tested, Codex and Hermes untested |

For any agent's state, read its own `brain/status.md`. This file tracks
the container only.

**Structure rationale.** Separate repos were considered and rejected:
EcoPrompt is six files and LeaseReviewer is one, neither earns a repo yet,
and splitting would break the published URL and both install commands.
Orphan branches were considered and rejected: they hide agents behind a
branch switcher, which is backwards for a repo whose job is being found.
`git subtree split --prefix=<agent>` promotes any folder to a standalone
repo later with its history intact, so nothing is foreclosed.

**Next action:** none at the container level; each agent's own status holds its next step.

**Outstanding, outside this repo:** pin `Agents` on the GitHub profile (no
API exists), set profile location.
