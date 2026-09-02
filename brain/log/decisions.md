# Decisions

*Index only — one line each. Detail goes in `decisions/<year>-Q<n>.md`.*

- 2026-09-01 — Repo is a multi-agent portfolio, not one project per agent. Folder holds many; brain tracks the portfolio.
- 2026-09-01 — Public, MIT. Purpose is showcasing evolution, so knowledge files are generalised and carry nothing personal.
- 2026-09-01 — Ship two packagings (Claude Code skill + paste-in prompt) from one source. `SKILL.md` references `system-prompt.md` rather than copying it, to prevent silent drift.
- 2026-09-01 — Agent 1 is ecoprompt. Chosen over a computer-control agent, which was blocked: computer-use caps terminals and IDEs at click-tier, so it cannot answer Claude Code's keyboard-driven permission prompts.
- 2026-09-01 — Persona is deliberately blunt. A padding agent cannot credibly teach concision.
- 2026-09-01 — Question budget spends on the consumer before the target tool. Testing showed the tool is inferable from context and the audience is not; a wrong audience invalidates the whole brief.
- 2026-09-01 — Agent refuses to draft when the user is still choosing between ideas. A confident brief for an unchosen idea reads as progress and gets built on, which is the costliest possible failure.
- 2026-09-01 — Local skill install is gitignored. Shipping a generated copy alongside its source is the drift the repo rules exist to prevent.
- 2026-09-02 — Agent 1 renamed Prompt Economist → EcoPrompt. Folder, skill name, slash command and all prose follow; no alias kept, since nothing external depends on the old name yet.
