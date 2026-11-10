# Handoff

*Written when a session ends mid-task. Carries intent, not just facts.*

## Open — 2026-11-10

Build and scenario runs are complete. What remains is the owner's:

1. Install for real: `./install.sh claude-code ~`, start a new session,
   call `/neo`. This is the one thing the scenario runs could not cover —
   they loaded the installed files directly because the command-line login
   on the build machine had expired.
2. Push the `neo` branch, merge, tag `neo-v1.0`.

Worth doing next, each earned by a run recorded in `log/decisions.md`:

- A task split across real sub-agents (scenario 3 ran solo).
- Handing Neo a repository to learn from.
- A project that already has its own notes convention.

Verify: `tests/install.test.sh` passes; the README levers each name a file
and heading that exist.
