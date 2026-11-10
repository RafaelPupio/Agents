# Decisions

*Index only — one line each. Detail goes in `decisions/<year>-Q<n>.md` once this grows.*

- 2026-11-10 — Memory is two stores (a private library per machine, a notes folder per project) rather than one tagged store or the harness's own memory. Isolation is physical, and plain files carry across harnesses; a tag depends on the agent honouring it.
- 2026-11-10 — Autonomy is three tiers split by scope: what lives and dies with one project is Neo's call, what persists across projects is the owner's. Skills are always shown on a card first; destructive or spending actions are always confirmed.
- 2026-11-10 — Neo is called by name, not always on, and its prompt has no size cap. Always-on was chosen first and reversed the same day: a global instruction is re-sent every turn of every session.
- 2026-11-10 — Knowledge taken from repos the owner hands over stays in the private library; nothing from them enters this public repo unless the owner asks separately.
- 2026-11-10 — Neo edits no harness configuration. The prompt keeps writes to its two stores and the adapters document how to switch each harness's native memory off.
- 2026-11-10 — Testing is phased: v1.0 is tested end to end on Claude Code; Codex and Hermes are install-tested where present and labelled untested in the README until run.
