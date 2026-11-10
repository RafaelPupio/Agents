# Status — Neo

*Present tense only. Supersede, never stack.*

## Now — 2026-11-10

**Built on branch `neo`. Untagged. Installed for Claude Code on the build machine.**

Parts in place: `system-prompt.md`, six knowledge files, four adapters
(Claude Code, Codex, Hermes, generic), library and project templates,
`install.sh` with its test, `skill/SKILL.md`, README.

**Tested.**
- Installer: its test suite passes (15 cases), including refusing a
  foreign `neo` skill folder and recording the library path in the
  installed adapter.
- Behaviour: the seven design scenarios were run against two sample
  projects sharing one scratch library. All seven pass. Two first showed a
  weakness (scenarios 3 and 4); the prompt was changed for each and both
  were re-run on the changed prompt and pass (see `log/decisions.md`).
- How they were run matters: each run was a fresh agent on a mid-tier
  model, told to read the installed `SKILL.md` and follow it. That tests
  the prompt and knowledge files as installed. It does **not** test real
  sub-agent delegation, or a session free of the machine's other
  instructions.
- Live call: `/neo` was called once in a live Claude Code session after a
  user-level install. The skill loaded, Neo read its prompt, ran Recall
  (the project's own notes convention, an empty library at the recorded
  path) and opened as designed. The call carried a question, not a task.

- Product build (added after v1): one scenario, a small full-stack build
  run solo — contracts first, whole-system check, release plan, stop
  before the production deploy. Pass, with one weakness logged.

**Not tested.** A full task run through a live `/neo` call. Delegating to
sub-agents, including a real team by layer. Any actual deploy, to any
target. Hermes beyond files landing in place. Codex at all (not
installed where this was built). Repo ingestion. The existing-convention
path. A harness that sandboxes library writes.

**Next action:** merge the open pull request and tag `neo-v1.0`. The first
real task given to a live Neo is worth recording in `log/decisions.md`.
