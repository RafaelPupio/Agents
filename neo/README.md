# Neo

**Full agent.** A senior software developer you hand any codebase or
software problem. It brainstorms before it builds, writes briefs a cold
sub-agent can execute, splits work across sub-agents only when that is
cheaper, looks for tools that make a job faster, proves work is done by
running the check, and remembers what it learns.

One source, several harnesses: the same behaviour and the same memory in
Claude Code, Codex, Hermes, or pasted into any chat.

## Why

Tools are reused across many jobs; the task is different every time. So the
durable asset is not a fixed workflow. It is judgement, plus a growing
library of what each tool is good for, applied fresh to each project.

## How you use it

Neo is **called by name, not always on.** Nothing is written into any global
instruction file, so sessions where you do not call it are untouched and cost
nothing. Its prompt has no size cap, because it is only loaded when wanted.

Call it once at the start of a session. From then on you simply talk to it:
it stays in charge for the rest of that session.

| Harness | Call it with |
|---|---|
| Claude Code | `/neo` |
| Codex | `$neo` |
| Hermes | `/neo` |
| Anything else | paste `system-prompt.md` as the first message |

Project rules outrank Neo. Order: your direct instruction, then the project's
own `CLAUDE.md` / `AGENTS.md`, then Neo.

---

## Install

```bash
git clone https://github.com/RafaelPupio/Agents
./Agents/neo/install.sh claude-code ~
```

`~` installs for every project on the machine. Pass a project path instead to
install for that project only. `--dry-run` shows what would happen and writes
nothing. Start a **new** session afterwards, then call Neo (table above).

| Harness | Command | Status |
|---|---|---|
| Claude Code | `install.sh claude-code ~` | install-tested; behaviour scenarios pending |
| Hermes | `install.sh hermes ~` | untested |
| Codex | `install.sh codex ~` | untested (adapter written from documentation) |
| Anything else | no install: paste `adapters/generic.md` then `system-prompt.md` | not applicable |

Statuses are updated only after the harness has actually been run.

**What the installer writes.**
- The skill, in `<SKILL_DIR>/neo/`: `SKILL.md` and a `references/` folder
  holding the prompt, the five knowledge files and the one adapter for that
  harness. This folder is replaced on every run.
- The library skeleton, at `$NEO_HOME` (default `~/.neo`): only files that are
  missing. It never overwrites a note you or Neo wrote.
- It edits no harness settings and no file you wrote. Codex additionally gets
  an `agents/openai.yaml` that stops it firing Neo from a matching prompt.

**Uninstall.** Delete the installed skill folder (`<SKILL_DIR>/neo/`, for
example `~/.claude/skills/neo`). The library at `$NEO_HOME` is yours and no
script removes it; delete it by hand if you want it gone.

---

## How it remembers

Two stores, so isolation is physical rather than a label Neo has to honour.

```
$NEO_HOME/  (default ~/.neo — private, per machine, outside any repo)
├── INDEX.md       one line per note; read first
├── tools/         one note per tool: what it is for, when it pays, gotchas
├── techniques/    generalised lessons
├── sources/       what was distilled from repos you handed over
└── skills.md      register: adopted, declined (with reason), pending

<project>/.neo/    (created when there is something worth keeping)
├── INDEX.md       one line per note
├── project.md     stack, commands, conventions, how to run and test
├── decisions.md   what was decided and why; what was ruled out
├── tooling.md     tools and sub-agent roles added here, with the fit test
└── journal.md     dated retrospectives
```

- Project facts are written only to that project's notes. Neo never reads
  another project's notes.
- A lesson reaches the library only about a tool or technique, rewritten with
  project names, paths and business detail removed. If it cannot be
  generalised, it stays in the project.
- Project notes are kept out of version control by default (the repository's
  local exclude list; no tracked file changes). Say so if you want them
  committed and shared.
- A project that already documents its own memory convention keeps that one;
  Neo does not add a second.

**Native memory caveat.** Some harnesses keep their own memory, or write
skills by themselves, underneath Neo. That memory is **outside Neo's
isolation guarantee**: Neo writes only to its two stores, but it cannot stop
the harness writing elsewhere. Neo does not edit harness settings. Where it
matters, turn the harness memory off; each adapter in `adapters/` has the
exact switch.

## Giving Neo a repository to learn from

Say it in plain words: "Learn from `<url or path>`." Neo reads it, then
writes `sources/<name>.md` into the library with the URL, licence, commit and
date, the principles it took in its own words, and what it chose not to take
and why. It adds index lines, plus `tools/` or `techniques/` notes that came
out of it. It does not copy code wholesale. Skills found inside the repo are
not adopted by being read: each one goes through the skill card first.

What it learned stays in your private library. Nothing from a handed-over
repo enters a public repository unless you ask for that separately.

## Autonomy

The line between the first two tiers is scope: what lives and dies with one
project is Neo's call; what persists across projects is yours.

| Tier | What | Rule |
|---|---|---|
| **Free** | Use installed tools, search for tools, spawn sub-agents, define a role for the task, add a tool to the current project | Passes the fit test; announced in one line; recorded in the project's tooling note |
| **Present first** | Adding a skill, anything installed machine-wide, anything that costs money or needs a credential | Neo shows a short card and waits; declined items are not proposed again |
| **Hard stop** | Deleting data, rewriting history, force-push, publishing, deploying, sending messages, spending | Confirmed every time, whatever was approved before |

---

## Customising it

Six levers. Each is a named thing you edit.

### 1. Persona: `system-prompt.md`, "Persona" section

Ships as a calm senior engineer: decisive, evidence-first, brief. The reason
is the job: an agent that directs others is trusted on its word, so it says
only what it has checked. Replace the section to change the voice; keep the
rule about marking what is unverified.

### 2. Autonomy tiers: `system-prompt.md`, "Autonomy" section

The three-row table. Move an action between rows to loosen or tighten Neo:
for example, move "adding a skill" to Free if you want to stop seeing cards.

### 3. Brainstorm threshold: `system-prompt.md`, "The loop" (the "Brainstorm threshold" paragraph) and `knowledge/engineering.md`, "1. Choosing the scale"

What counts as a *small* change, which Neo does after stating its pick in a
line instead of waiting for you to choose among approaches. Raise the bar to
be asked less; lower it to be asked more.

### 4. Model routing: `knowledge/orchestration.md`, "4. Model routing" table

Which roles run on a small, mid or strongest model. Move a role between rows
to change how Neo spends on sub-agents.

### 5. Memory locations: `$NEO_HOME` and `.neo/`

Set `NEO_HOME` before running the installer to put the library somewhere
else. The project folder name `.neo/` and the library layout are defined in
`system-prompt.md`, "Memory" section, and `knowledge/memory.md`, "1. The
shared library" and "2. Project notes". Change them there, in both files.

### 6. Harnesses: `adapters/`

Add a file named for the harness. The first two lines are `SKILL_DIR:` and
`INVOKE:`; the installer reads them. Below that, one row per capability:
how Neo is called, how it delegates, how to pick a cheaper model, how skills
are found and installed, whether the library is writable, and how the native
memory is turned off. Verify each row against the harness's current
documentation; do not write it from memory. Then add the name to the case
list in `install.sh`.

---

## Design notes

**Two stores over one tagged store.** A tag is honoured only while the agent
remembers to honour it. A project's notes living in that project's folder
means another project's notes are simply not there.

**Called by name, not always on.** Always-on was chosen first and reversed the
same day: a global instruction is re-sent on every turn of every session, so
a prompt this complete would tax every session that did not need it.

**Skills are shown before they are added.** The shared library is the part
that persists, so a person decides what enters it.

**A report is not proof.** Neo checks a sub-agent's result before relying on
it, and runs the check before saying work is done.

**Behaviour is earned by running it.** Scenario results are recorded in
`brain/log/decisions.md`.

## Licence

MIT. See [LICENSE](../LICENSE).
