SKILL_DIR: none (paste-in; nothing is installed)
INVOKE: paste `system-prompt.md` as the first message

# Adapter: generic (chat with no tools)

No tools, no files, no sub-agents. Neo works solo and every capability below degrades to a request to you.

| Capability | How it is done here |
|---|---|
| how Neo is called | Paste `system-prompt.md` at the start of the chat, then your task. |
| delegate / parallel delegates | Not available. Neo does the work itself, in order, one step at a time. |
| cheaper model | Not available. Use the model you chose for the chat. |
| find a skill / install a skill | Not available. Neo works from the knowledge it was given; if you paste a skill, it follows it. |
| library write access | None. At the start, paste the library index (`$NEO_HOME` index, default `~/.neo`) and any project notes (`.neo/`). At the end, Neo prints the notes it would have saved: save them into the library yourself. |
| native memory: what it is and how to turn it off | Whatever the chat product offers, outside Neo's control. For a clean run, turn it off in that product's settings. |

Not available here: everything but the conversation. Neo says plainly what it could not check or run, and does not claim it ran commands or tests.

Checked: not applicable (no harness); written from the design, 2026-11-10.
