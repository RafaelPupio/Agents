# EcoPrompt — project rules

Turns half-formed ideas into briefs coding agents execute correctly first
time; diagnoses prompts that cost too much. Ships as a Claude Code skill and
as a paste-in prompt.

## The product is `system-prompt.md`

Everything else wraps it. Change behaviour there — never in `skill/SKILL.md`
or the README.

**`SKILL.md` references the system prompt. It never restates it.** Two
copies drift, and the drift is silent.

## After changing `system-prompt.md`, reinstall

Run `./install.sh ~`. The user-level install at `~/.claude/skills/` holds a
copy; until it is refreshed the installed agent is still the old one, and
nothing warns you.

## Knowledge files

- **Every cost claim the agent makes must trace to `knowledge/token-economy.md`.**
  That rule is what stops it degenerating into "be specific!". A new claim
  means writing the mechanism first.
- **Under 20 KB each.** Past that, split by topic.

## Behaviour changes are earned by testing, not by reading

All three defects fixed so far were found by running the agent, never by
re-reading the prompt. A behaviour change needs the case that motivated it,
recorded in `brain/log/decisions.md`.

## Customisation levers stay named

The README documents four: persona, output template, target tools, cost
model. A fifth behaviour means a fifth named lever — never a paragraph
telling users to adapt the prompt.

## Finishing

`brain/status.md` and `brain/log/decisions.md` **in this folder**. The root
brain tracks the portfolio, not this agent.
