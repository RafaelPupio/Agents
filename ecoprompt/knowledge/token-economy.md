# Token Economy — what actually costs money in an agentic session

Reference for EcoPrompt. Every cost claim the agent makes should
trace back to a mechanism on this page.

## The one fact that explains most of the bill

**Every request re-sends the entire conversation.** Agents are stateless
between turns: turn 40 ships turns 1–39 along with it. So the total tokens
burned across a session grow *roughly quadratically* with the number of
turns, not linearly.

Two consequences that drive nearly every recommendation here:

1. **Turn count is the dominant lever.** Ten short clarifying exchanges cost
   far more than one well-formed brief, even though each message looks small.
2. **Everything that enters context keeps billing.** A file read on turn 3 is
   re-sent on turns 4 through 40. There is no un-reading.

Prompt caching softens this — a repeated prefix is billed at a large
discount — but it does not remove it, and *changing something early in the
context invalidates the cache from that point onward*. Editing an
instruction file mid-session is more expensive than it looks.

## Where the tokens actually go

### 1. Instruction files, re-sent every turn
`CLAUDE.md`, `AGENTS.md`, system prompts. A 10 KB instruction file in a
60-turn session is roughly 150k tokens of pure re-send.
**Lever:** hard-cap instruction files at ~3 KB. Reference material lives in
`docs/` and gets opened on demand, never auto-loaded.

### 2. Whole-file reads
The most common self-inflicted wound. "Read `src/api/handlers.ts`" on a
2,000-line file puts all 2,000 lines in context permanently.
**Lever:** ask for ranges (`sed -n '120,180p'`) or a grep. When you need
breadth — "where is auth handled?" — delegate to a subagent, which reads
widely and returns a conclusion instead of the file dumps.

### 3. Unfiltered tool output
`npm test` verbose output, full `git log`, a directory listing that includes
`node_modules`. All permanent context.
**Lever:** filter at the source. `--reporter=dot`, `git log --oneline -10`,
`grep -c`. Ask for the answer, not the log.

### 4. Aimless exploration
"Have a look around and see how the auth flow works" makes the agent open a
dozen files to find the three that matter. You pay for all twelve, forever.
**Lever:** name the entry point. "Start at `src/auth/session.ts`" converts an
open search into a targeted read.

### 5. Re-verification
Re-running a suite that passed and no code has changed since. Re-reading a
file immediately after editing it. Restating a conclusion already reached.
**Lever:** verify once, after a change. Not before, not twice.

### 6. Round-trips for independent work
Four separate messages to read four unrelated files costs four full context
re-sends.
**Lever:** batch independent operations into one turn.

### 7. Rediscovering rejected approaches
You ruled out websockets on turn 5. On turn 30, past the context horizon or
after a compaction, the agent proposes websockets.
**Lever:** put rejected approaches in the brief, with the reason. One line
each buys silence for the whole session.

## The levers, ranked by payoff

1. **Name the files.** The single largest win available in most prompts.
2. **State non-goals.** Cheapest possible control on scope creep.
3. **Give an acceptance test.** Bounds an otherwise open-ended session.
4. **Record what is ruled out.** Prevents re-derivation after compaction.
5. **Batch independent requests.** Directly cuts the turn multiplier.
6. **Delegate breadth to subagents.** Buys conclusions instead of dumps.
7. **Keep instruction files small.** Multiplied by every turn, forever.
8. **Hand off before the context dies.** See `context-budget-rules.md`.

## What is *not* worth optimising

Be honest about this — false economy wastes more than it saves.

- **Terse phrasing.** Dropping articles and politeness saves a handful of
  tokens and costs clarity. Not a lever.
- **Short variable names in pasted code.** Irrelevant at this scale.
- **Avoiding a clarifying question when you genuinely do not know.** One
  question costs one turn. A wrong assumption costs a rewrite.
- **Micro-managing the agent's method.** Prescribing every step usually
  produces a longer prompt and a worse result than stating the goal and the
  constraints.

The economy is in *what enters context and how many times*, not in
word choice.
