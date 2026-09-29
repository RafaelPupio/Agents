# Agents — container rules

A public portfolio of agent projects. **Each agent folder is its own
project** — its own `CLAUDE.md`, its own `brain/`, its own release tags.
This file governs the container, not the agents. Read the agent's own
`CLAUDE.md` before working inside it.

## Structure

```
<agent-name>/
├── CLAUDE.md          that agent's rules; AGENTS.md symlinks to it
├── brain/             its INDEX, status, handoff, log/decisions
├── README.md          purpose · install · customisation levers
├── system-prompt.md   the product, single source of truth
├── knowledge/         reference files the agent reasons from
├── skill/SKILL.md     Claude Code packaging; references, never copies
└── install.sh         installs the skill
```

**Two kinds of entry.** A **full agent** ships all of the above and installs.
A **showcase** ships `CLAUDE.md`, `brain/` and `README.md` only — the idea,
the shape, an anonymised example — when the real build cannot be published.
State which in the README's opening lines.

## Where things are recorded

Agent work is recorded in **that agent's** `brain/`. The root `brain/` holds
portfolio decisions only: what this repo is, what gets added, how it is
published. `rafael.md` stays at the root and is shared — never duplicated
into an agent.

Never record an agent's work at the root.

## Non-negotiables — every folder

**Public repo — nothing personal, ever.** No home paths, no machine names,
no other project names, no client work, no keys. Check before every commit.

**Generalised content only.** Principles, not one repo's layout.

**Portable Markdown.** No platform-specific syntax in `system-prompt.md` or
`knowledge/`.

## Adding an agent

1. Create the folder with the structure above, including its own
   `CLAUDE.md`, `AGENTS.md` symlink and `brain/`.
2. Write `system-prompt.md` first — it is the product.
3. Give the README named **customisation levers**, never "adapt as needed".
4. Add a row to the root `README.md` index.
5. Record the new agent in the **root** decisions log; everything after that
   goes in its own brain.

## Releases

Each agent versions independently: `<agent>-vX.Y` annotated tags.
