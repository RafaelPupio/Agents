# Agents — repo rules

A public portfolio of reusable agent definitions. Each agent is a
self-contained folder that someone can clone into their own project.

## Structure — one folder per agent

```
<agent-name>/
├── README.md          purpose · install (both packagings) · customisation
├── system-prompt.md   canonical instructions, single source of truth
├── knowledge/         reference files the agent reasons from
└── skill/SKILL.md     Claude Code packaging; points at references, no copy
```

Never duplicate instruction text across `system-prompt.md` and `SKILL.md`.
`SKILL.md` references the system prompt; it does not restate it. Two copies
drift, and the drift is silent.

## Non-negotiables

**Public repo — nothing personal, ever.** No home paths, no machine names,
no other project names, no client work, no keys. This includes `brain/`.
Check before every commit.

**Generalised content only.** Knowledge files carry principles, not one
repo's layout. If a sentence only makes sense on the author's machine, it is
a bug.

**Portable Markdown.** No platform-specific syntax in `system-prompt.md` or
`knowledge/`. It must paste cleanly into any agent platform.

**Knowledge files stay under 20 KB.** Past that, split by topic. Large files
get read whole or not at all, and "not at all" is what happens.

## Adding an agent

1. Create the folder with the four-part structure above.
2. Write `system-prompt.md` first — it is the product. Everything else wraps it.
3. Give the README explicit **customisation levers**: named sections a user
   edits, not "adapt the prompt to your needs".
4. Add a row to the table in the root `README.md`.
5. Record the decision in `brain/log/decisions.md`.

## Finishing a task

Done means `brain/status.md` and `brain/log/decisions.md` reflect what
changed. A task that changed this repo but not the brain is unfinished.
