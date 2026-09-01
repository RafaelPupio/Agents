# Tool Profiles — what each target already knows

Reference for Prompt Economist. The same idea needs a different brief
depending on what runs it. Choosing wrong is one of the largest sources of
waste, in both directions: pasting files into a tool that can read them, and
asking repo questions of a tool that has no repo.

## Claude Code

**Has:** your filesystem, your shell, your git history. Reads `CLAUDE.md`
automatically. Can run tests, search, edit many files, and delegate breadth
to subagents. Asks permission before destructive or outward-facing actions.

**Give it:**
- Intent and constraints, not procedure
- File paths as anchors — `src/auth/session.ts`, not "the session logic"
- An acceptance test it can actually run
- Non-goals, since it has the reach to wander

**Never give it:**
- Pasted file contents. It reads them. Pasting doubles the cost.
- Restated `CLAUDE.md` rules. Already in context every turn.
- Step-by-step procedure for something it can figure out. You pay for the
  extra prompt and usually get a worse result.

**Shape:** short brief, heavy on paths and boundaries.

## Codex

**Has:** your repo, and reads `AGENTS.md` the way Claude Code reads
`CLAUDE.md`. Agentic: edits files and runs commands, under its own approval
and sandbox model.

**Give it:** the same brief you would give Claude Code, plus explicit
flagging of anything that will hit an approval boundary — network access,
installs, writes outside the working tree. An agent halted on an unexpected
approval prompt is a stalled session.

**Never give it:** assumptions about tooling it must discover for itself.
Name the test command rather than implying one.

**Shape:** as Claude Code, plus approval-sensitive steps called out.

**Note:** keeping `AGENTS.md` as a symlink to `CLAUDE.md` means both tools
read identical rules, and a brief written for one runs on the other.

## Plain chat (Claude.ai, ChatGPT, and similar)

**Has:** nothing about your project. No filesystem, no repo, no memory of
your conventions beyond what you paste.

**Give it:**
- The minimum self-contained code needed to answer the question
- The signatures and types it depends on
- A precisely scoped question

**Never give it:**
- Repo-wide questions. It cannot answer "where is auth handled?" and will
  guess plausibly and wrongly.
- Your entire file when twenty lines carry the question.

**Best for:** design discussion, algorithm choice, reviewing a snippet,
naming, writing a self-contained function, explaining an error.

**Worst for:** anything requiring knowledge of how your codebase fits
together.

**Shape:** context-heavy, scope-narrow — the exact inverse of an agentic brief.

## The inversion, stated plainly

| | Agentic tools | Plain chat |
|---|---|---|
| Scarce resource | Your *attention to scope* | *Context* about your code |
| So the brief is | Boundaries, paths, acceptance | Pasted code, narrow question |
| Failure mode | Wanders, does unasked work | Confidently invents your codebase |

Agentic tools need to be told where to **stop**.
Plain chat needs to be told where it **is**.
