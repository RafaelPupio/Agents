SKILL_DIR: .agents/skills
INVOKE: $neo

# Adapter: Codex

`SKILL_DIR` is the same shape at both levels: `~/.agents/skills/` (user) and `<project>/.agents/skills/` (repo; Codex also scans `.agents/skills` in parent folders up to the repo root). Neo installs to `<SKILL_DIR>/neo/`. Codex follows symlinked skill folders. Admin level `/etc/codex/skills` is not used.

| Capability | How it is done here |
|---|---|
| how Neo is called | Type `$neo`, or run `/skills` and pick it. Set `policy.allow_implicit_invocation: false` in the skill's `agents/openai.yaml` so it never fires from a matching prompt; explicit `$neo` still works. |
| delegate | Codex spawns sub-agents when told to: say so in the prompt, or have the skill/`AGENTS.md` instruct it ("spawn one agent for X, wait, summarise"). They are not spawned automatically at most settings. Best for read-heavy work; parallel writers can conflict. |
| parallel delegates | Ask for one agent per independent unit and to wait for all. Cap: `agents.max_concurrent_threads_per_session` in `config.toml` (alias `agents.max_threads`); the default is chosen by Codex and not documented. |
| cheaper model | Custom agent file `~/.codex/agents/<name>.toml` (or `.codex/agents/`) with `name`, `description`, `developer_instructions`, and `model` / `model_reasoning_effort`. Or set `agents.default_subagent_model` and `agents.default_subagent_reasoning_effort` under `[agents]`. Precedence: explicit spawn value, then `[agents]` default, then the parent's. Agent files cannot change sandbox or approvals. |
| find a skill | `/skills` or type `$` to list installed ones. New ones: `$skill-installer` (curated list). |
| install a skill | `$skill-installer <name>` (can pull from other repos), or copy the folder into `SKILL_DIR`. Restart Codex if it does not appear. |
| library write access | Sandboxed. In `workspace-write` mode the agent edits only inside the workspace, so `~/.neo` is outside it. Add it with `sandbox_workspace_write.writable_roots = ["~/.neo"]` in `config.toml` (tilde handling unconfirmed: use the expanded absolute path if `~` is rejected), or expect an approval prompt. The CLI's default mode is unconfirmed from the docs read. |
| native memory: what it is and how to turn it off | Local memories: background-generated notes from past chats under `$CODEX_HOME/memories_v2/` (or an existing `memories/`); off by default. To keep off or disable: `memories.generate_memories = false` and `memories.use_memories = false` in `config.toml`; `/memories` adjusts one chat; desktop app: Settings > Personalization. |

Not available here: a per-spawn model argument is not documented for the CLI, so Neo uses the custom-agent file or `[agents]` default rather than choosing a model per call. If neither is set, delegates inherit the parent's model and Neo says so.

Checked: https://developers.openai.com/codex/skills , /subagents , /concepts/sandboxing , /memories (all redirect to learn.chatgpt.com/docs/...), 2026-11-10. `codex` is not installed on the checking machine, so nothing here was confirmed against a running CLI.
