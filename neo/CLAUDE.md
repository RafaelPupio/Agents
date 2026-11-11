# Neo — project rules

A senior-developer agent, called by name. Ships as a skill for Claude Code,
Codex and Hermes, and as a paste-in prompt. Full agent: README, adapters,
templates, installer, tests.

## The product is `system-prompt.md`

Everything else wraps it. Change behaviour there, never in `skill/SKILL.md`
or the README. **`SKILL.md` references the prompt; it never restates it.**

`system-prompt.md` and `knowledge/*.md` name no harness and no harness tool.
Harness words live only in `adapters/`, `skill/`, `install.sh`, `tests/`,
`README.md` and this file.

## After changing the prompt or a knowledge file, reinstall

Run `./install.sh <harness> ~`. The installed skill holds a copy; until it is
refreshed the installed Neo is still the old one, and nothing warns you.

## Sizes

- No cap on `system-prompt.md`: it is loaded only when Neo is called.
- Each `knowledge/*.md` under 20 KB; past that, split by topic.
- This file under 3 KB.

## Adapters are verified, not remembered

Skill locations, sub-agent mechanics and memory switches change. Re-check an
adapter against the harness's current documentation before editing it, and
record the date it was checked in the adapter. Never write one from memory.

## Behaviour changes are earned by a test case

Run Neo on the scenario that motivated the change and record the result in
`brain/log/decisions.md`. A harness's README status stays "untested" until it
has been run.

## Public repo

Nothing personal: no home paths, machine names, other project names, keys.
The library `$NEO_HOME` is the owner's and no script ever removes or
overwrites it.

## Finishing

`brain/status.md` and `brain/log/decisions.md` **in this folder**. The root
brain tracks the portfolio, not this agent.
