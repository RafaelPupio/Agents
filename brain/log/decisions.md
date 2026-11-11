# Decisions — portfolio

*Container-level only: what this repo is, what gets added, how it is
published. Agent decisions live in that agent's own `brain/log/`.*

- 2026-09-01 — Repo is a multi-agent portfolio, not one project per agent. Folder holds many; brain tracks the portfolio.
- 2026-09-01 — Public, MIT. Purpose is showcasing evolution, so knowledge files are generalised and carry nothing personal.
- 2026-09-01 — Persona is deliberately blunt. A padding agent cannot credibly teach concision.
- 2026-09-01 — Agent refuses to draft when the user is still choosing between ideas. A confident brief for an unchosen idea reads as progress and gets built on, which is the costliest possible failure.
- 2026-11-10 — Agent 3 is neo, a full agent. The standard layout is extended for it with `adapters/` (one file per harness, since harness wording is barred from the prompt and knowledge files), `templates/` and `tests/`. It is called by name, not always on: always-on was considered and reversed the same day because of its per-turn cost.
- 2026-11-11 — neo shipped as `neo-v1.0` by merging its branch into `main`; it versions independently of the other agents.
- 2026-11-11 — Each agent becomes its own repository, `agent-<name>`, split out with its history; this repo becomes the public index only, holding no agent. Supersedes the 2026-09-01 one-repo decision, at the owner's request. The owner chose private agent repositories, so the index links do not open for visitors until one is made public. The rule covers every future agent (`CLAUDE.md`, "Adding an agent").
- 2026-11-11 — `agent-neo` made public by the owner; the other two agent repositories stay private.
- 2026-11-11 — `agent-ecoprompt` made public by the owner; `agent-lease-reviewer` stays private.
