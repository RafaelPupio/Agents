# Status — Neo

*Present tense only. Supersede, never stack.*

## Now — 2026-11-10

**Built on branch `neo`. Untagged. Not installed anywhere (scenario runs used a scratch sandbox).**

Parts in place: `system-prompt.md`, five knowledge files, four adapters
(Claude Code, Codex, Hermes, generic), library and project templates,
`install.sh` with its test, `skill/SKILL.md`, README.

**Tested.**
- Installer: its test suite passes (15 cases), including refusing a
  foreign `neo` skill folder and recording the library path in the
  installed adapter.
- Behaviour: the seven design scenarios were run against two sample
  projects sharing one scratch library. All seven pass; two carry a noted
  weakness (see `log/decisions.md`). The final review added two prompt
  changes aimed at those weaknesses (scenarios 3 and 4); their re-run is
  pending.
- How they were run matters: each run was a fresh agent on a mid-tier
  model, told to read the installed `SKILL.md` and follow it. That tests
  the prompt and knowledge files as installed. It does **not** test calling
  Neo by name through a harness, real sub-agent delegation, or a session
  free of the machine's other instructions.

**Not tested.** Calling `/neo` in a live Claude Code session. Delegating to
sub-agents. Hermes beyond files landing in place. Codex at all (not
installed where this was built). Repo ingestion. The existing-convention
path. A harness that sandboxes library writes.

**Next action:** the owner installs for real and calls Neo once in a live
session, which closes the first gap; then push and tag `neo-v1.0`.
