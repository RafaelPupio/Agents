# Agents

Agents I build, in the open. Each one is a self-contained folder you can
drop into your own project — plain Markdown, no framework, no lock-in.

## The agents

| Agent | What it does |
|---|---|
| [**prompt-economist**](prompt-economist/) | Turns half-formed ideas into briefs coding agents get right first time. Diagnoses prompts that cost too much and rewrites them. |

## How these are built

Every agent in this repo follows the same shape:

```
<agent-name>/
├── README.md          what it does, how to install, how to customise
├── system-prompt.md   the canonical instructions
├── knowledge/         reference files the agent reasons from
└── skill/SKILL.md     Claude Code packaging
```

Three deliberate constraints:

**Portable.** Plain Markdown, no platform-specific syntax. The same files
work as a Claude Code skill, a Claude Project, a Custom GPT, or anything
else that accepts instructions and documents.

**Two packagings.** A skill you copy into `.claude/skills/`, and a prompt you
paste into a hosted project. Same content, one source of truth.

**Generalised.** Knowledge files describe principles, never one machine's
paths or one person's directory layout. An agent that hard-codes a repo's
structure does not survive contact with the next repo.

## Using one

Each agent's README has its own install steps. The short version:

```bash
git clone https://github.com/RafaelPupio/Agents
```

Then follow `<agent-name>/README.md`.

## Licence

MIT. Use them, fork them, change them.
