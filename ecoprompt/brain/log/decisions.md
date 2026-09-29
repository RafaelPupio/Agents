# Decisions

*Index only — one line each. Detail goes in `decisions/<year>-Q<n>.md`.*

- 2026-09-01 — Ship two packagings (Claude Code skill + paste-in prompt) from one source. `SKILL.md` references `system-prompt.md` rather than copying it, to prevent silent drift.
- 2026-09-01 — Agent 1 is ecoprompt. Chosen over a computer-control agent, which was blocked: computer-use caps terminals and IDEs at click-tier, so it cannot answer Claude Code's keyboard-driven permission prompts.
- 2026-09-01 — Question budget spends on the consumer before the target tool. Testing showed the tool is inferable from context and the audience is not; a wrong audience invalidates the whole brief.
- 2026-09-01 — Local skill install is gitignored. Shipping a generated copy alongside its source is the drift the repo rules exist to prevent.
- 2026-09-02 — Agent 1 renamed Prompt Economist → EcoPrompt. Folder, skill name, slash command and all prose follow; no alias kept, since nothing external depends on the old name yet.
- 2026-09-02 — Published public at github.com/RafaelPupio/Agents. Install path verified end to end from the real URL before declaring it done; a broken install is the first thing a visitor hits and fails invisibly for the author.
- 2026-09-03 — Recommended install is user-level (`install.sh ~` → `~/.claude/skills/`), not per-project. One copy serves every project, with no per-repo files to gitignore and no drift. Per-project install kept for teams that want it committed.
- 2026-09-29 — Compose gained a short form (Goal, Non-goals, Done when) for tasks smaller than the full template. Found by testing Compose on a real repo task: the brief came out longer than the edit it described, which "what you never do" forbids while the output section offered no way to comply.
