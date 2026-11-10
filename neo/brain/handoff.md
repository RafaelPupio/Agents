# Handoff

*Written when a session ends mid-task. Carries intent, not just facts.*

## Open — 2026-11-10

Build is complete. What remains:

1. Run the scenarios listed under "How it gets tested" in `design.md` on
   Claude Code. Record each result in `log/decisions.md`. Any defect found
   is fixed in `system-prompt.md` or a knowledge file, then reinstalled and
   re-run.
2. Update the README harness labels to what was actually run.
3. The owner installs, pushes and tags `neo-v1.0`.

Verify: the installer test passes; the README levers each name a file and
heading that exist.
