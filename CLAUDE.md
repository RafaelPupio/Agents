# Agents — index rules

The public front page of an agent portfolio. **It holds no agent.** Each
agent lives in its own repository, `agent-<name>`, with its own
`CLAUDE.md`, `brain/`, history and tags. This repo holds the index
`README.md`, the licence, and the portfolio's own `brain/`.

Working on an agent means opening that agent's repository, not this one.

## Every agent is its own repo — including future ones

| | |
|---|---|
| Repository | `RafaelPupio/agent-<name>`, private unless the owner says otherwise |
| Folder | `agent-<name>`, beside this repo's folder — never inside it |
| Tags | `vX.Y` in the agent's own repo |
| Index | One section in this `README.md` linking to it |

An agent's layout, inside its repo:

```
CLAUDE.md          its rules; AGENTS.md symlinks to it
brain/             INDEX, status, handoff, log/decisions, rafael.md
README.md          purpose · install · customisation levers
system-prompt.md   the product, single source of truth
knowledge/         reference files the agent reasons from
skill/SKILL.md     Claude Code packaging; references, never copies
install.sh         installs the skill
LICENSE            MIT
```

**Two kinds.** A **full agent** ships all of the above. A **showcase**
ships `CLAUDE.md`, `brain/` and `README.md` only, when the real build
cannot be published. The README's opening lines say which.

## Adding an agent

1. Propose the name, the visibility and the folder, and get a yes —
   never create a repository silently.
2. Create `agent-<name>` beside this folder with the layout above,
   `git init`, then `gh repo create RafaelPupio/agent-<name> --private
   --source=. --remote=origin --push`.
3. Write `system-prompt.md` first — it is the product.
4. Give its README named **customisation levers**, never "adapt as needed".
5. Add its section to this `README.md`, and one line to this repo's
   `brain/log/decisions.md`. Everything after that goes in its own brain.

## Non-negotiables

**This repo is public — nothing personal, ever.** No home paths, machine
names, other project names, client work or keys. Check before every
commit. Agent repos are kept to the same standard so any of them can be
published, except `brain/rafael.md`, which is removed first.

**Generalised content only. Portable Markdown** in every prompt and
knowledge file.

## Where things are recorded

Agent work goes in that agent's repo. This repo's `brain/` records only
portfolio decisions: what is listed, how it is published.
