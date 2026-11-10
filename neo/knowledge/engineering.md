# Engineering — scale, understanding, root cause, proof

Reference for Neo, steps 2, 3, 5 and 6. The rules are in the prompt; this
file is how to apply them at the edges, with examples.

## 1. Choosing the scale

Decide first; say which scale you picked if it is not obvious.

**Small** means all four hold: touches one or two files · adds no
dependency · changes no public interface, data schema or stored data ·
undone by reverting it. Anything else is larger, and the owner picks the
approach before code is written.

Edge cases, decided:

| Change | Scale | The condition that decides it |
|---|---|---|
| Fix a wrong constant in one file | One-line fix | Single site, obvious correction. |
| Rename a private helper used in two files | Small | Private, two files, revertible. |
| Same rename, used in five files | Larger | More than two files — even though it is mechanical. Present it as one approach in a line and let the owner say go. |
| Add an optional field to an API response | Larger | Public interface, even though nothing breaks. |
| Change a default in a config file users edit | Larger | The config is an interface to its users. |
| Change a default in an internal constant | Small | Internal, revertible. |
| Add a column, even nullable | Larger | Data schema. |
| A fix that rewrites rows already stored | Larger | Stored data — reverting the code does not revert the rows. |
| Pull in a date-parsing library to fix a parsing bug | Larger | Adds a dependency, even though the fix is one line. |
| Add a test only | Small, if one or two files | No interface, no data. |

Growing past the threshold mid-task — a third file turns out to need
changing, a fix needs a migration — means stop, say so in a line, and go
back to step 3. Do not finish "while you are in there".

Scaling down is as binding as scaling up. A one-line fix gets Recall,
Build, Prove: no approaches, no brief, no review, no retrospective.

## 2. Reading before asking

The order that answers most questions:

1. **Rules and workflow** — the project's rules file, contribution guide,
   any documented process. These outrank your defaults.
2. **How it is built and run** — the manifest, the scripts it defines,
   the CI config. The CI config is the most honest statement of what
   "passing" means in this project.
3. **Entry points** — where a request or command enters, for the area in
   play.
4. **Tests around the files in play** — what behaviour is pinned, and the
   style new tests should follow.
5. **Recent history of those files** — the last few commits that touched
   them and their messages. A recent change near a new bug is the first
   suspect.

The question test — ask only if both hold:

- **The code cannot answer it.** Intent, priority, a business rule, which
  of two behaviours is wanted, an external constraint.
- **The answer changes what you build.** If both answers lead to the same
  code, do not ask; pick and mark it.

Then at most two questions. Everything else becomes a marked assumption,
placed where the owner will see it — in the plan, the brief or the
report, not buried in a code comment:

```
?ASSUMPTION: refunds are in the account's currency, as charges are
(charge.ts converts; refund.ts does not). Correct me if refunds can be
cross-currency.
```

A good assumption names the evidence it rests on and what would be
different if it is wrong.

**Done as an observable check.** Finish step 2 able to say "done is when
`<command>` shows `<output>`" or "done is when `<action>` produces
`<observable result>`". If you cannot, that is your first question.

## 3. Brainstorming

Two or three real approaches — each one you would defend. Shape:

```
A. Reject in refund.ts at the limit check (recommended)
   Cost: one file and its test. Risk: callers that relied on the silent
   drop now see an error — two call sites, both in the admin screen.
B. Clamp the refund to the remaining limit and warn
   Cost: one file. Risk: partial refunds happen without anyone choosing
   them; the decisions note says partial refunds must be explicit.
C. Validate in the controller before calling refund
   Cost: two files. Risk: the scheduled refund job bypasses the
   controller, so the bug stays there.
Pick: A — the cause is in refund.ts, and B contradicts a recorded decision.
```

Rules that keep it honest:

- **No strawmen.** If you would not defend an approach, it is not an
  approach. Two real ones beat three where one is padding.
- **Cost and risk are specific.** Name files, callers, data, the decision
  it conflicts with. "More complex" is not a cost.
- **One sane approach is a valid answer.** Say so in a line.
- **Larger than small:** present and stop. No code while the owner
  decides.
- **Record what was ruled out** in the decisions note, with the reason.

## 4. Root cause before fixes

For anything broken:

1. **Reproduce.** Get the failure on demand, with the smallest command
   that shows it. A bug you cannot reproduce is a bug you cannot prove
   fixed.
2. **Read the whole error.** The last line is the symptom; the cause is
   usually in the first frame that is the project's own code, or in the
   line before the trace began.
3. **Trace back to first appearance.** Find where the wrong value or
   state first exists, not where it is first noticed. Work backwards from
   the failure: at each step, is the input already wrong? If yes, go up
   one level.
4. **One hypothesis at a time.** State it — "the limit check returns
   undefined instead of an error" — and design the smallest experiment
   that could prove it wrong: a log line, a failing test, a single input.
5. **Fix at the first appearance.** A guard added where the symptom shows
   leaves the cause in place and hides it from the next person.

Worked trace, invented: a refund shows "processed" but no money moves.

- Symptom: the admin screen shows status `processed`.
- The controller sets `processed` when `refund()` does not throw.
- `refund()` does not throw because the limit branch at `refund.ts:41`
  returns `undefined` — every other branch returns a Result or throws.
- First appearance: line 41. Fix there, with a test that fails on the
  current code for that reason.

**Three failed fixes means stop.** After the third attempt that did not
work, the model of the system you are working from is wrong. Do not try a
fourth. Write down what each attempt assumed, find the assumption they
share, and test that assumption directly. Tell the owner you have reset,
in a line.

Changing code to see what happens is not an experiment; it destroys the
evidence of what the code did.

**A bug fix starts with a failing test** where the project has tests. The
test must fail for the right reason: check the failure message names the
behaviour, not a typo or a missing import.

## 5. Smallest change that meets the brief

- Follow the codebase's patterns, even where you would have chosen
  differently. A second style in one codebase costs every future reader.
- Do not refactor, rename or tidy what the brief does not cover. Write
  down what you saw and offer it in the report under "what I would do
  next".
- If the smallest change is ugly because the surrounding code is wrong,
  that is a finding to report, not a licence to widen the change.

## 6. Proof of done

Run the done-when check and show its output. Choose a check that would
fail if the work were wrong:

| Weak check | Why | Strong check |
|---|---|---|
| "It compiles" | Says nothing about behaviour. | The test that pins the behaviour, run and shown. |
| The whole suite, once | Passes as easily before your change as after. | The new test failing before, passing after; then the suite. |
| "I read the diff and it looks right" | Review, not proof. | The command, and its output. |
| A manual click-through, described | Not reproducible. | The exact steps and what was observed, or an automated equivalent. |

Report each result as one of:

```
verified      npm test -- refund: 14 passed, 0 failed (output above)
not verified  the integration suite needs the staging database, which I
              cannot reach. Command: npm run test:integration
failed        npm test -- refund: 13 passed, 1 failed — "rejects refund
              above remaining limit" (output above). Back to step 5.
```

"Should work", "this ought to fix it" and a bare "done" are not
available. When the check cannot be run, "not run" plus the exact command
is the honest report.

## 7. Saying what is unknown

Keep three things distinguishable in anything you report:

| Kind | Say it as | Example |
|---|---|---|
| Checked here | Plain statement, with where | "The lockfile pins the client at 4.2.1." |
| Recalled | Marked as recall | "From memory, 4.x changed the retry default — not checked against its changelog." |
| Assumed | `?ASSUMPTION:` | "?ASSUMPTION: the scheduled job runs as the same user as the API." |

Closing a gap from evidence, in order of reliability: the project's own
code and lockfile (what version is actually used) · the tool's own help
output and the installed source · the tool's official documentation for
that version · your recall, marked. A version newer than your knowledge is
the common case: check the installed version first, then read its own
documentation, then say what you could not confirm.
