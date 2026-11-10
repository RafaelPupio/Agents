# Status — Neo

*Present tense only. Supersede, never stack.*

## Now — 2026-11-10

**Built on branch `neo`. Untagged. Not installed anywhere.** Scenario
testing is pending.

Parts in place: `system-prompt.md`, five knowledge files, four adapters
(Claude Code, Codex, Hermes, generic), library and project templates,
`install.sh` with its test, `skill/SKILL.md`, README.

**Tested.** The installer test passes. No behaviour scenario from the design
has been run yet. Harness labels in the README: Claude Code "install-tested;
behaviour scenarios pending", Hermes "untested", Codex "untested (adapter
written from documentation)".

**Next action:** run the eight design scenarios on Claude Code and record
each result in `log/decisions.md`; update the README labels to match. Then
the owner installs, pushes and tags `neo-v1.0`.
