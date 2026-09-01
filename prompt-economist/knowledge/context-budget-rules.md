# Context Budget Rules — keeping long sessions alive

Reference for Prompt Economist. These are structural habits, applied to a
repository once, that reduce cost on every future session in it. Distinct
from `token-economy.md`, which covers a single prompt.

## 1. Instruction files are multiplied by session length

`CLAUDE.md` / `AGENTS.md` are re-sent every turn. Every byte is paid once
per turn, forever.

- **Cap them at ~3 KB.** This is a hard budget, not an aspiration.
- They hold *this project's rules only* — never reference material, never CLI
  documentation, never an agent catalogue, never architecture notes.
- Everything else lives in `docs/` or a knowledge folder and is opened on
  demand.
- Symlink `AGENTS.md` to `CLAUDE.md` so every tool reads one source and the
  two cannot drift apart.

## 2. Index first, then one note

Keep a small annotated hub note that says what exists and when to read it.
An agent reads the hub, then opens the single note the task needs.

**Never bulk-read** a documentation folder, a knowledge vault, or a spec
appendix. The cost is not the reading — it is that all of it is re-sent on
every subsequent turn.

## 3. Status notes are present tense only

A status note describes what is true *now*. When something changes, the old
block is **superseded, not stacked** — move it to an archive file.

A status note that grows by accretion becomes a changelog, and a changelog
is the most expensive possible thing to re-read at the start of every
session. Cap it and enforce the cap.

## 4. Decision logs are indexes

One line per decision in the log. The reasoning lives in a dated file the
log points to. You want to *see* that a decision exists without paying to
read all of them.

## 5. Split anything oversized

Any note past ~20 KB gets split. Large notes are read whole or not at all,
and "not at all" is what actually happens.

## 6. Hand off before the context dies

At roughly **70% of context used**, stop and write a handoff. Do not push
to 95% — past ~90% there is not enough room left to write a good one, and
you lose the session's understanding entirely.

A handoff must carry **intent**, not just facts:

- The task, in one sentence
- What is done
- The single next action
- Files currently in play
- **What was ruled out, and why**
- How to verify the work

The ruled-out section is the part that cannot be recovered by reading code.
A fresh session can re-derive what the code does; it cannot re-derive what
you already tried and rejected. Omit it and the next session repeats your
dead ends at full price.

## 7. Resuming is cheaper than re-deriving

Reading a good handoff plus a status note costs a few thousand tokens.
Reconstructing the same understanding by exploring the repository costs
tens of thousands — and still misses the intent.

This is the highest-leverage habit on this page: the discipline of writing
the handoff is repaid every single time work crosses a session boundary.
