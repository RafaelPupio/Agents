# Orchestration — when to split, who does what, and how to trust it

Reference for Neo, steps 4 and 7. Mechanics — how a sub-agent is started,
how a model is chosen — are in the adapter. This file is the judgement.

## 1. Split or solo — the deciding questions

Answer in order. The first "no" means solo, or sequence the pieces.

1. **Is there more than one piece?** Can the work be cut into parts that
   each have their own goal and done-when check?
2. **Are they independent?** Does any piece need another's output to
   start? If B needs A's result, B waits; that is a sequence, not a team.
3. **Do the write sets overlap?** List the files each piece will change.
   Any file on two lists means the pieces are not independent (section 2).
4. **Is each piece real work?** Does doing it cost more than briefing it
   plus verifying the result? A five-minute edit costs more to brief and
   check than to make.
5. **Would the detail swamp the main thread?** Bulk reading or searching
   whose conclusion you need but whose detail you do not is a reason to
   delegate even when nothing runs in parallel.
6. **Does a review need to be blind?** A review that must not see your
   reasoning has to be done by someone else.

Questions 5 and 6 can justify a single delegate on their own. Questions
1–4 must all be yes to justify a team of writers.

| Situation | Decision | Why |
|---|---|---|
| Add the same validation to three independent services, each with its own folder and tests | Split: three writers | Disjoint paths, separate checks, real work each. |
| Rename a type used across forty files | Solo, or one writer | One change; cutting it by folder makes every writer touch the shared definition. |
| Find every call site of the old payment client in a large codebase | One small-model reader | You need the list, not the reading. |
| Fix a bug, then update the docs that describe the behaviour | Sequence | The docs depend on what the fix turns out to be. |
| Investigate why the build is slow, from three suspected causes | Split: three investigators, read-only | Independent hypotheses, no writes, conclusions only. |
| Two small edits, five minutes each | Solo | Briefing and checking cost more than the edits. |
| Review your own implementation | One reviewer | It must not see your reasoning (section 6). |

## 2. The no-shared-files rule

Two writers never touch the same files. Check the write sets for these
hidden overlaps, which are where parallel work collides:

- **Lockfiles and manifests.** Two pieces that each add a dependency both
  write the lockfile. Add dependencies yourself, first, then split.
- **Generated files.** A schema, a client, a snapshot: if both pieces
  regenerate it, they both write it.
- **Registries.** A route table, an index of exports, a dependency
  injection list, a changelog. Each piece "just adds one line" — to the
  same file.
- **Shared fixtures and test helpers.** Two pieces extending the same
  fixture file collide even when their source files do not.
- **Formatting on save.** A writer whose formatter rewrites a shared file
  it only read has written to it.

If an overlap is found: do the shared part yourself before splitting, give
the shared file to one writer and sequence the other after it, or do not
split. Readers may share files freely; the rule is about writes.

**One writer per working copy.** Disjoint files are not enough when
writers run at the same time in one checkout: one writer's half-finished
change breaks the build the other is testing against, and neither can
tell whose failure it is. Where the adapter offers a separate working
copy per sub-agent, give each parallel writer its own and bring the
results together yourself. Where it does not, run the writers one after
another. Readers may share a working copy.

## 3. Inventing a role

Roles are invented for the task, named by what they must produce. A name
that says what comes back keeps the brief honest about the return shape.

| Weak role | Invented role | What it returns |
|---|---|---|
| "Researcher" | Call-site mapper | A table: file, line, call form, arguments passed. |
| "Backend dev" | Refund-limit fixer | A diff to two named files and a before/after test run. |
| "QA" | Settlement-flake reproducer | The command that reproduces it, the failure rate over N runs, the line that varies. |
| "Reviewer" | Brief-defect reviewer | Defects against the brief, each with file, line and why. |

A role is a brief template, not a persona. Once a role has proved useful
twice in a project, write it to that project's `tooling.md`: the name,
what it returns, the brief skeleton, the model tier. One that is useful
across projects becomes a technique note in the library, with the
project's specifics removed.

## 4. Model routing

Cheapest capable model per role. The adapter says how a tier is chosen in
this environment; where it cannot be chosen, every role runs on the
session's model and this table only shapes how much is delegated.

| Tier | Roles | Signals it belongs here |
|---|---|---|
| **Small** | Searching, bulk reading, listing call sites, summarising logs, mechanical checks (does every file have a header?) | The output is a list or a fact; a wrong answer is cheap to spot when you verify it. |
| **Mid** | Implementation against a clear brief, writing tests for specified behaviour, a migration with a known pattern | The brief says what to build and the done-when check is runnable. |
| **Strongest** | Design and choosing between approaches, review, root-causing a bug no one has explained, anything where a subtle mistake is expensive and hard to see | Judgement is the product; a wrong answer looks like a right one. |

Two corrections to apply:

- **Move up a tier** when the small model's result would be hard to check
  — a summary you cannot cheaply verify against the source is not cheap.
- **Move down a tier** when the brief has removed the judgement — an
  implementation whose design, files and test are all specified does not
  need the strongest model.

**State the tier every time you delegate.** Where a model can be chosen,
a role started without one usually runs on the session's model — often
the most expensive — and nothing says so. And count turns, not only
price: a small model that needs three attempts at a multi-step task
costs more than a mid one that needs one.

This table is a customisation lever: an owner tunes it by moving roles
between rows.

## 5. A report is not proof

Sub-agents report success they did not achieve as fluently as success
they did. Before relying on a result:

| The report says | Check |
|---|---|
| "Changed these files" | Read the diff. Compare it to the brief's scope; anything outside scope is a finding. |
| "Tests pass" | Run the done-when command yourself. Compare the summary line to the one reported. |
| "Found N call sites" | Open two or three of them. Search for one more form the reader may have missed. |
| "The cause is X" | Find the line it cites and confirm it does what the report says. |
| "Could not do Y" | Decide whether Y blocks the goal. If it is Present-first or Hard-stop, take it to the owner. |

What you pass to the owner is either verified by you or marked
unverified. "The sub-agent says it works" is not a status.

**Nothing open without a next mover.** Every piece of work that is not
finished names what moves it next: a sub-agent that is running, a review
that has been requested, a question put to the owner, a check you will
run. "Blocked" is allowed only with who unblocks it and how. A piece
with no next mover has stalled, whatever its status says — before you
end a turn, read your task list for one.

**Stopped is not done.** When every piece has come to rest, read the
evidence once more before you report: a "done" with no check output
behind it, a "blocked" that misread its limits, a review that was
requested and never came back. On a team, give that read to an agent
that built none of it.

## 6. Independent review

For non-trivial work, a fresh reviewer gets **the brief and the diff, and
not your reasoning**. A reviewer who has read why you did it inherits the
reasons you might be wrong.

Reviewer brief:

```
Goal:        Find defects in this diff against this brief.
Scope:       Read-only. The diff below; any file in the repository.
Non-goals:   No summary, no praise, no style preferences the project's
             own rules do not state. Do not fix anything.
Done when:   Every claim in the brief has been checked against the diff.
Report back: A list. Each item: file and line · what is wrong · which
             brief line it breaks, or "not in brief" · how sure (checked /
             suspected). An empty list is a valid answer.
<the brief>
<the diff>
```

**Never tell a reviewer what not to flag.** "Ignore X", "X is
intentional", "at most a minor issue" — each is your conclusion handed
to the one reader whose job is to test it. If you expect a false
positive, let it be raised and judge it then.

The sub-agent's own report, if the reviewer gets it, is a list of claims
to check, not evidence. What the reviewer cannot see in the diff it
marks "cannot verify"; you close those yourself.

Then verify each finding before acting on it; a reviewer can be wrong.
Fix what is real, then run step 6 again. Record a rejected finding, with
the reason, in the decisions note if it is likely to be raised again.

**The fix loop has a cap.** A fix that keeps failing review is not
converging, and another round rarely changes that.

| Round | Who fixes | Then |
|---|---|---|
| 1–2 | The agent that wrote it — it has the context | A re-review of the fix only |
| 3 | A fresh agent, one tier up, with the brief, the diff and the open findings | A re-review of the fix only |
| After 3 | Nobody | You decide each open finding: fix it yourself, re-cut the task, or record it as open and tell the owner |

A re-review looks at the fix against the findings it answers, not the
whole diff again. A new finding on code the fix did not touch is
recorded, and does not restart the loop. Working solo, the same cap
applies to your own attempts.

## 7. Sub-agents and the tiers

Sub-agents act inside the Free tier only, and narrower than you; every
brief's Constraints line says so (template in `briefing.md`):

- Anything Present-first or Hard-stop comes back as a request under
  "anything you could not do", and you take it to the owner. A
  sub-agent's judgement never counts as the owner's approval.
- No writes to the library, the project notes or the environment's own
  memory. It reports; you decide what is kept.
- No deploying, to any target. A release is the lead's (`delivery.md`).
- No adding dependencies. It asks; you add them — before splitting, so
  no two writers edit the manifest or lockfile (section 2).
- No agents of its own. A worker that starts its own reviewer pays for a
  review you are about to run anyway, and one you did not brief.
- Being given a task grants nothing. Owning a piece of work is not
  permission to widen its own scope, tools or access to finish it.

## 8. The solo fallback

With no sub-agents, the same judgement applies to sequencing:

- Pieces that would have been parallel are done one at a time, each with
  its own brief and its own check, in the order that lets later pieces
  use earlier results.
- Bulk reading is done in passes, writing the conclusion down as you go
  so the detail can be dropped.
- Review becomes a critic's re-read: the whole diff, top to bottom,
  against the brief, asking what breaks, what was not asked for, and
  what the check you ran does not cover. Do it after step 6, starting
  from the brief rather than from what you remember intending — read
  what the diff does, not what you meant it to do.
