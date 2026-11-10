SKILL_DIR: .hermes/skills
INVOKE: /neo

# Adapter: Hermes Agent

`SKILL_DIR` at user level is `~/.hermes/skills/` (the source of truth; a profile uses `~/.hermes/profiles/<name>/` instead). Project level is `<project>/.hermes/skills/` or `<project>/.agents/skills/`, found from the nearest ancestor holding `.git`, and it loads only after `hermes skills trust` is run in that repo. Neo installs to `<SKILL_DIR>/neo/`. Whether a flat folder (no category subfolder) is accepted at user level is inferred from the docs, not tested.

| Capability | How it is done here |
|---|---|
| how Neo is called | Type `/neo` in the CLI or any messaging platform. Up to five skills can be chained in one message. Unconfirmed: Hermes has no confirmed setting that limits a skill to invoke-by-name only, so "called by name" here rests on the skill description saying to use it only when the user calls Neo. |
| delegate | The `delegate_task` tool with `goal` and a self-contained `context` (the child starts with a fresh conversation; only its final summary returns). Children inherit the parent's toolsets; they cannot use `clarify`, `memory`, `send_message`, or `cronjob`. |
| parallel delegates | `delegate_task` with a `tasks` array, each with its own `goal` and `context`. Default cap 10 concurrent (`delegation.max_concurrent_children`); a larger batch errors. Depth is flat unless `max_spawn_depth` is raised. |
| cheaper model | `delegation.model` (and optionally `delegation.provider`) in `~/.hermes/config.yaml`; the key exists in the local default config. It is global to all children: there is no per-task model argument. Empty means children inherit the parent's. Neo cannot choose per call, so it asks the user to set it once. |
| find a skill | `hermes skills search <query>`, `hermes skills browse`, `hermes skills inspect <id>`, `hermes skills list`. |
| install a skill | `hermes skills install <id>` (security-scanned), or copy the folder into `SKILL_DIR`. Extra read-only roots via `skills.external_dirs` in `config.yaml`. |
| library write access | Not sandboxed by default: the default `local` terminal backend runs on the host, with a denylist of protected paths (credentials, Hermes secrets) that does not include `~/.neo`. If `HERMES_WRITE_SAFE_ROOT` is set (the Docker image sets it), `write_file` and `patch` outside it are hard-blocked and `~/.neo` must be inside it. The `docker` backend isolates writes to the container. |
| native memory: what it is and how to turn it off | Two curated files, `MEMORY.md` (~2,200 chars) and `USER.md` (~1,375), in `~/.hermes/memories/`, loaded every session; both on by default. Off: set `memory.memory_enabled: false` and `memory.user_profile_enabled: false` in `config.yaml` (both, or the tool stays). External providers are separate (`hermes memory status`). Past sessions are also searchable in `~/.hermes/state.db`. |

Not available here: a per-task cheaper model (see above). Neo delegates with the configured model and tells the user the saving needs `delegation.model`.

Checked: https://hermes-agent.nousresearch.com/docs/user-guide/features/skills , /features/delegation , /features/memory , /security (2026-11-10); local `hermes --help`, `hermes skills --help` and the default `config.yaml` (v0.22.7) confirm the commands and the `delegation`, `memory`, `skills` keys.
