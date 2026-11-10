SKILL_DIR: .claude/skills
INVOKE: /neo

# Adapter: Claude Code

`SKILL_DIR` is the same shape at both levels: `~/.claude/skills/` (user, all projects) and `<project>/.claude/skills/` (one project). Neo installs to `<SKILL_DIR>/neo/`. A personal skill beats a project skill of the same name.

| Capability | How it is done here |
|---|---|
| how Neo is called | Type `/neo` (the skill's `name`); text after it becomes its arguments. Set `disable-model-invocation: true` in the skill's frontmatter so it only runs when called by name. |
| delegate | The `Agent` tool (named `Task` before v2.1.63). Give it a `subagent_type` and a self-contained prompt; only the sub-agent's summary returns. Built-ins: `general-purpose`, `Explore` (read-only), `Plan`. Custom ones: Markdown with frontmatter in `~/.claude/agents/` or `.claude/agents/`. |
| parallel delegates | Issue several `Agent` calls in one turn; they run concurrently in the background. Default cap 20 (`CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`). |
| cheaper model | Pass `model` on the `Agent` call (aliases `haiku`, `sonnet`, `opus`), or set `model:` in a custom sub-agent's frontmatter. Fallbacks: `CLAUDE_CODE_SUBAGENT_MODEL`, then the main model. |
| find a skill | `/skills` lists installed skills (filterable). Discovery of new ones: `/plugin` menu and its marketplaces. |
| install a skill | Copy the folder (containing `SKILL.md`) into `SKILL_DIR`. Or `/plugin install <plugin>` / `claude plugin install`. |
| library write access | Not sandboxed by default (sandbox is opt-in via `/sandbox`). The Edit/Write tools follow permission rules, so writing `~/.neo` outside the project prompts for approval unless allowed. If the sandbox is on, Bash writes are limited to the working directory and `$TMPDIR` unless the path is added via `sandbox.filesystem.allowWrite`, `permissions.additionalDirectories`, or `--add-dir`. |
| native memory: what it is and how to turn it off | Auto memory: notes Claude writes itself to `~/.claude/projects/<project>/memory/`, first 200 lines or 25 KB loaded each session. Off: `/memory` toggle, `"autoMemoryEnabled": false` in settings (user or project), or env `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`. |

Not available here: nothing from the list is missing. Neo's own library stays separate from native memory; if auto memory is on, Neo does not write to it.

Checked: https://code.claude.com/docs/en/skills , /sub-agents , /memory , /sandboxing , /commands (2026-11-10); CLI v2.1.266 `--help` confirms `plugin install`, `--add-dir`.
