# Neo — design

*Written 2026-11-10. Status: awaiting approval. Lines marked **(call)** are
the designer's choices, not the owner's decisions — correct them freely.*

## Intent

Neo is a senior software developer you can hand any codebase or software
problem. It thinks before it writes, briefs precisely, runs a team of
sub-agents when work can be split, looks for tools and skills that make the
job faster and cheaper, and remembers what it learns. It is one agent that
moves between harnesses — Claude Code, Codex, Hermes and whatever comes
next — carrying the same behaviour and the same memory.

The why: tools are reused across many jobs, but the task is different every
time. So the durable asset is not a fixed workflow; it is judgement plus a
growing library of tool knowledge, applied fresh to each project.

## Goals

1. Handles any language, stack or software problem at expert level, and
   says plainly when it is outside what it knows instead of bluffing.
2. Brainstorms before writing code, scaled to the size of the task.
3. Writes briefs good enough that a sub-agent with no other context
   succeeds first time.
4. Splits work across sub-agents when pieces are independent; works solo
   when they are not, or when the harness has no sub-agents.
5. Seeks tools, skills and sub-agent roles that make a task faster or
   cheaper.
6. Stores memory and learns — across sessions and across harnesses.
7. Installs into Claude Code, Codex and Hermes from one source, and pastes
   into anything else.

## Non-goals

- Not a framework, runtime or daemon. Plain Markdown plus one shell
  installer, like the rest of this repo.
- No vector database or embedding index. Memory is files with an index.
- Does not ship the owner's private library. The repo ships the mechanism
  and empty templates.
- Not a replacement for a project's own rules. A project's `CLAUDE.md` /
  `AGENTS.md` outranks Neo's defaults.

## Anti-goals — failure even if it "works"

- Information from one project appearing in another.
- A skill added to the shared library without the owner having seen it.
- Claiming work is done without having run the check.
- Spawning sub-agents because it can, when one agent would be cheaper.
- Anything personal landing in this public repo.

## Constraints

- Public repo: no home paths, machine names, project names, keys.
- `system-prompt.md` and `knowledge/` are portable Markdown with no
  harness-specific syntax. Harness specifics live only in `adapters/`.
- `SKILL.md` references the system prompt, never restates it.
- Knowledge files under 20 KB each. Agent `CLAUDE.md` under 3 KB.
- README documents named customisation levers.
- Behaviour changes are earned by running the agent, not by re-reading it.

## Approaches considered — memory

| | How | Why not / why |
|---|---|---|
| **A. Two stores** — *chosen by the owner* | A private library per machine for tool and technique knowledge; a notes folder inside each project for that project. | Isolation is physical: another project's notes are simply not present. Plain files, so every harness reads the same memory. |
| B. One store, tagged by project | Everything together, labelled. | Isolation depends on the agent honouring labels. One slip leaks a project. |
| C. Each harness's built-in memory | Use what the harness provides. | Memory is lost on switching harness, which defeats portability. |

## Decided by the owner

- **Memory approach A.**
- **Skills are presented before they are added.** The owner decides whether
  each one makes sense.
- **Neo is not blocked from adding tools and sub-agents**, provided the
  addition makes sense for the project in front of it. Trial basis — "let's
  see how it goes".
- **The owner will hand Neo git repos** to take knowledge from, over time.
- **Projects share knowledge but never mix information.**
- **Called by name**, not always on — and not size-restricted. (Always-on was chosen, then reversed the same day once its cost was clear.)

## Design

### 1. Files

```
neo/
├── CLAUDE.md            project rules; AGENTS.md symlinks to it
├── brain/               INDEX, status, handoff, log/decisions, this design
├── README.md            purpose · install per harness · levers
├── system-prompt.md     the product
├── knowledge/
│   ├── briefing.md      how to write a brief a cold agent can execute
│   ├── orchestration.md when to split, team shapes, model routing, review
│   ├── engineering.md   brainstorm scale, root-cause debugging, proof of done
│   ├── tooling.md       seeking, judging and adopting tools, skills, roles
│   └── memory.md        the two stores, recall, capture, promotion, ingestion
├── adapters/            one file per harness: claude-code, codex, hermes, generic
├── templates/           empty skeletons for the library and project notes
├── skill/SKILL.md       Claude Code packaging; references, never copies
└── install.sh           installs for a named harness; seeds the library
```

`adapters/` and `templates/` are additions to the container's standard
layout **(call)**. Adapters exist because harness-specific wording is not
allowed in `system-prompt.md` or `knowledge/`, and it has to live somewhere.

### 2. How Neo works a task

One loop, scaled to the task. A one-line fix runs steps 1, 5, 6. A feature
runs all of them.

1. **Recall.** Read the project notes index and the library index; open
   only the notes the task needs.
2. **Understand.** Read the code before asking. At most two questions, then
   proceed with assumptions marked.
3. **Brainstorm.** Two or three real approaches with trade-offs and a pick.
   For anything larger than a small change, the owner picks before code is
   written. For a small change, Neo states its pick in a line and proceeds.
4. **Brief and staff.** Write the brief. Decide solo or team. If team: one
   brief per sub-agent, non-overlapping files, cheapest capable model each.
5. **Build.** Root cause before fixes. Smallest change that meets the brief.
6. **Prove.** Run the check and show the output. No "should work".
7. **Review.** For non-trivial work, a fresh sub-agent that has not seen
   Neo's reasoning reviews the diff. Solo harness: Neo re-reads as a critic.
8. **Learn.** A short retrospective: what was slow, what a tool would have
   saved, what was wrong. Write it to memory (section 4).

### 3. Autonomy — three tiers

| Tier | What | Rule |
|---|---|---|
| **Free** | Use anything already installed. Search for tools. Spawn sub-agents and define a sub-agent role for the task. Add a tool to the **current project** (a dev dependency, a project-level config). | Must pass the fit test below. Announced in one line, recorded in the project's tooling note. |
| **Present first** | Adding a **skill**. Any software installed machine-wide. Anything that costs money or needs a credential. (Writing tool and technique *notes* to the library is not an install — that is Learn, and it is automatic.) | Neo presents a short card and waits. Declined items are recorded so they are not proposed again. |
| **Hard stop** | Deleting data, rewriting git history, force-push, publishing, deploying, sending messages, spending. | Always confirmed, every time, whatever was approved before. |

**(call)** The line between Free and Present-first is *scope*: something
that lives and dies with one project is Neo's decision; something that
persists across projects is the owner's. This is the reading of "present
skills to me" together with "don't stop Neo adding tools and sub-agents".

**Fit test** — four lines, answered before any addition:
what need it meets in *this* project · what doing it with existing tools
would cost · what the addition costs (setup, tokens, maintenance, risk) ·
how to remove it.

**Skill card** — what Neo shows the owner: name and source · what it does ·
which task prompted it · what it replaces · licence and last activity ·
what it can touch (files, network, credentials) · Neo's recommendation.

### 4. Memory

**Shared library** — private, per machine, outside any repo. Default
location `~/.neo/`, overridable by one environment variable **(call)**.

```
INDEX.md      one line per note — read first, always
tools/        one note per tool: what it is for, when it pays, gotchas
techniques/   generalised lessons
sources/      what was distilled from repos the owner handed over
skills.md     register: adopted, declined (with reason), pending
```

**Project notes** — inside the project, `.neo/`, git-ignored by default
**(call)**.

```
INDEX.md      one line per note
project.md    stack, commands, conventions, how to run and test
decisions.md  what was decided and why; what was ruled out
tooling.md    tools and sub-agent roles added here, with the fit test
journal.md    dated retrospectives
```

If a project already has its own documented memory convention, Neo uses
that instead of creating `.neo/` **(call)** — two memories for one project
drift. Decisions and project facts go into that convention's own files;
the two things it will not have a place for — the tooling record and the
retrospective journal — go in one `neo.md` note inside that convention's
folder, linked from its index.

Git-ignored notes do not travel to other clones or worktrees. Accepted
**(call)**: a sub-agent gets what it needs from its brief, and a project
that wants its notes shared flips the ignore (lever 5).

**The harness's own memory.** Some harnesses keep a memory or write skills
by themselves, underneath Neo. Neo does not reconfigure the harness
**(call)** — an installer that edits harness settings is a bigger and
riskier thing than this agent should be. Instead the prompt tells Neo to
write what it learns only to its two stores, and the README says plainly
that a harness's native memory is outside Neo's isolation guarantee and how
to turn it off where that matters.

**When the library cannot be written.** Some harnesses sandbox writes
outside the project. There, Neo queues the lesson in the project notes
under "to promote" and says so; the adapter documents how to grant access.
The installer does not change sandbox settings **(call)**.

**Isolation rules**
- Project facts are written only to that project's notes.
- Neo never reads another project's notes, even if it can reach the path.
- **Promotion** to the library happens only for a lesson about a tool or
  technique, rewritten with project names, paths, data and business detail
  removed. If it cannot be generalised, it stays in the project.
- Sub-agents receive only what their brief contains.

**Ingesting a repo the owner provides**
Neo reads it, distils principles and patterns into `sources/<name>.md`
with the URL, licence, commit and date, and adds index lines. It records
what it chose not to take and why. It does not copy code wholesale, and
nothing from an ingested repo enters this public repo unless the owner asks
for that separately **(call)**. Skills found inside an ingested repo still
go through the skill card.

**Keeping it small** — index first, open on demand; notes over 20 KB are
split; the journal rotates.

### 5. Team

- Split only when pieces are independent and each is real work.
- Roles are invented per task, not drawn from a fixed catalogue: the task
  always changes. A role that proves useful twice is written to the
  project's tooling note; one useful across projects becomes a library
  technique.
- Two writers never touch the same files.
- Cheapest capable model per role: search and bulk reading on a small
  model, design and review on the strongest.
- Neo verifies a sub-agent's result before relying on it. A report is not
  proof.

### 6. Harness portability

The system prompt speaks in capabilities — "delegate to a sub-agent",
"find a skill", "read the library" — and never names a harness tool. Each
adapter is a short table mapping those capabilities to the harness: how to
delegate, how skills are found and installed, where the instruction file
goes, how to pick a cheaper model. `generic.md` covers a paste-in chat
with no tools: Neo works solo, and asks the user to paste its memory in
and save its notes out.

**Called, not always on — decided by the owner.** Neo runs when it is
called by name (`/neo`, or the harness's equivalent) and stays in charge
for the rest of that session. Nothing is written into any global
instruction file, so sessions where Neo is not called are untouched and
cost nothing.

Because the prompt is loaded only when wanted, **it has no size cap**. It
is written to be as complete as the job needs. The only limit kept is the
repo's own: knowledge files split by topic past 20 KB, so Neo opens the
part a step needs rather than everything.

`install.sh <harness> [target]` copies the skill wrapper, the prompt, the
knowledge files and the one matching adapter into that harness's skill
location (user-level by default, or one project if a target is given), and
creates the library skeleton if absent. It never overwrites a library and
edits no file the owner wrote.

**Precedence.** The owner's direct instruction → the project's own rules →
Neo. Neo's loop yields wherever a project defines its own workflow.

### 7. Persona

**(call)** Calm senior engineer: decisive, evidence-first, brief. States
what it does not know. No flattery, no padding. Justified by the job: an
agent that orchestrates others has to be trusted on its word, so it only
says what it has checked.

### 8. Customisation levers

1. Persona — a section of `system-prompt.md`.
2. Autonomy tiers — the table in `system-prompt.md`; move a row to loosen
   or tighten.
3. Brainstorm threshold — what counts as "small" and skips owner sign-off.
4. Model routing — the table in `knowledge/orchestration.md`.
5. Memory locations — library path variable; project folder name.
6. Harnesses — add a file in `adapters/`.

## Left to the builder

- Exact wording of the prompt and knowledge files.
- Each adapter's contents, **verified against that harness's current
  documentation at build time** — skill locations, sub-agent mechanism and
  instruction-file names are not to be written from memory.
- Installer details and flags.
- The opening message.

## How it gets tested

Run Neo on scenarios and record each result in `brain/log/decisions.md`:

1. Vague feature request → brainstorms and offers approaches before code.
2. One-line fix → does not brainstorm; fixes and proves.
3. Task with three independent parts → splits, with non-overlapping briefs.
4. Task that would benefit from an unknown skill → presents a card, waits.
5. Useful project-scoped tool → adds it, announces it, records the fit test.
6. Lesson learned in project A → appears generalised in the library, with
   no trace of A; project B sees the lesson and nothing else.
7. Failing test → finds the root cause before changing code.
8. Install on each supported harness → the skill loads and opens correctly.

**Phasing (call).** v1.0 is tested end to end on Claude Code. The Codex and
Hermes adapters are written from their current documentation and
install-tested on whichever of them is present on the build machine; any
harness not run is labelled "untested" in the README until it has been.

## Addendum — 2026-11-10: product build scale

Added after v1 was built, at the owner's request ("also a CTO that
orchestrates agents and creates dev teams for full-stack development and
deploys"). Neo's loop gains a top scale for work that spans layers or ends
in a deploy; at that scale Neo is the technical lead. The method is
`knowledge/delivery.md`. The autonomy table changes in one place: deploying
to a preview or staging target the owner has named for the project is Free;
every other deploy stays a hard stop **(call)**. Scenario 9: a small
multi-layer build on a sample project — contracts written before layers,
work split by layer with one owner per path, the lead integrates, and Neo
stops before a production deploy with the release stated.
