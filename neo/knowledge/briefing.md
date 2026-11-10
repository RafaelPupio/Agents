# Briefing — writing a brief a cold agent can execute

Reference for Neo, step 4. Every task gets a brief, even one Neo does
itself: the brief is what step 6 proves against. The test of a brief is
that an agent with no other context would succeed first time from it.

## 1. The template

```
Goal:          <one sentence — the outcome, not the activity>
Scope:         <paths it may change>  (read-only: <paths it may read>)
Non-goals:     <what it must not do, even if it looks helpful>
Constraints:   <patterns to follow, versions, rules>
               Sub-agent limits: Free tier only — anything Present-first
               or Hard-stop comes back as a request. No writes to the
               library, the project notes or the environment's memory.
               No adding dependencies: ask, and I add them.
Done when:     <an observable check: a command and the output that counts>
Ruled out:     <approaches already rejected, and why>
```

A sub-agent's brief adds two sections:

```
Context:       <every fact it needs that lives only in your head or notes>
Report back:   <the exact shape of what it returns>
```

What each field is for — and the failure it prevents:

| Field | Prevents |
|---|---|
| Goal, one sentence | A reader optimising the activity ("refactor X") instead of the outcome ("X can be tested without a network"). If it takes two sentences, it is two tasks. |
| Scope as paths | Wandering. "The payments code" invites a tour; `src/payments/refund.ts` does not. Paths are also what keeps two writers apart. |
| Non-goals | The capable reader's typical overreach: tidying, renaming, upgrading, "while I was there". Name the tempting ones. |
| Constraints | A correct solution in the wrong style. Point at an existing file to imitate rather than describing the style. |
| Done when | "Done" meaning "I stopped". Without a check, the reader decides when it is finished. |
| Ruled out | The reader rediscovering your rejected idea and spending its budget on it. This is the field nothing else can recover. |
| Context | Silent dependence on a fact only you have: an environment variable, a flaky test to ignore, a decision from an earlier session. |
| Report back | A narrative you must then mine. A fixed shape is cheap to verify and to compare across sub-agents. |

## 2. A filled-in example

The task: refunds over the card limit are failing silently in the billing
service. Neo has found the cause (step 5 trace) and is handing the fix and
its test to a sub-agent.

```
Goal:        Refunds above the card's remaining limit are rejected with a
             visible error instead of being dropped.
Scope:       src/payments/refund.ts, tests/payments/refund.test.ts
             (read-only: src/payments/errors.ts, src/payments/charge.ts)
Non-goals:   Do not change charge.ts, even though it has the same pattern —
             that is a separate task. No renames. No dependency changes.
Constraints: Raise a RefundRejected error the way charge.ts raises
             ChargeRejected (line 88); reuse the existing error type in
             errors.ts, do not add one. Tests follow refund.test.ts's
             existing table style. Free tier only: anything that would
             install software machine-wide, cost money, delete data or
             touch git history comes back to me as a request. No writes
             to the library, the project notes or the environment's
             memory. No new dependencies — ask.
Done when:   `npm test -- tests/payments/refund.test.ts` passes, and the
             new case "rejects refund above remaining limit" fails on the
             current code and passes after your change.
Ruled out:   Clamping the refund to the limit — the owner decided partial
             refunds must be explicit (decisions note, refund limits).
             Catching the error in the controller — the cause is in
             refund.ts, where the limit check returns early with no error.
Context:     The limit check is at refund.ts:41; it returns `undefined`
             where every other branch returns a Result. The test suite
             needs `PAYMENTS_FAKE=1`, already set in the test script.
             tests/payments/settlement.test.ts is flaky on timing; ignore
             a failure there and say so.
Report back: 1. Files changed, with a one-line reason each.
             2. The test command and its full summary line, run twice:
                before your fix (expect 1 failure) and after (expect 0).
             3. Anything you noticed outside scope, as a list. Not fixed.
             4. Anything you could not do, and why.
```

Note what it does not contain: no history of how the cause was found, no
explanation of the refund feature, no file contents the reader can open
itself. Pasting what the reader can read doubles the cost and dates the
brief.

## 3. The small-change brief

For a change inside the brainstorm threshold, the brief is one line per
field, and only the fields that apply:

```
Goal:      The CSV export header says "Amount (net)" to match the screen.
Scope:     src/reports/export.ts only; no other text changes.
Done when: `npm test -- export` passes and the header test asserts the new text.
```

Non-goals and ruled-out appear only when there is something to say.

## 4. The cold-reader test

Before sending a brief — or starting on one you wrote for yourself — read
it as someone who has only this page. Answer each line; any "no" is an
edit.

- Could they find every file named, from the project root, without
  asking? (Paths are relative to the root, not to where you were.)
- Is there one term used for each thing? A brief that says "refund",
  "reversal" and "credit" for the same thing reads as three things.
- Does the done-when check name a command they can run, and say what
  output counts as passing? "Tests pass" is not a check when only one
  test file matters and another is known to be flaky.
- Is every fact they need either in the brief or in a file the brief
  names? Look for words like "as discussed", "the usual way", "the
  issue": each one points into your head.
- Do the non-goals name the specific temptation, not just "stay in
  scope"?
- Would they know what to do when they hit something you did not
  anticipate? (Usually: stop and report it, under "anything you could not
  do".)
- Is the return shape something you can check in under a minute?

## 5. Before and after

| Weak | Why it fails | Strong |
|---|---|---|
| "Fix the flaky tests in the billing service." | No scope, no check, "flaky" undefined. | "`tests/payments/settlement.test.ts` fails about one run in five on a timing assertion at line 120. Make it deterministic without changing `src/`. Done when 20 consecutive runs pass: `for i in $(seq 20); do npm test -- settlement || break; done`." |
| "Clean up the export module." | An invitation to rewrite. | Name the one defect, or do not brief it. |
| "Use the same approach as before." | Points into a session the reader never saw. | State the approach in one line, or name the file that shows it. |
| "Let me know how it goes." | Unstructured report you must then interpret. | A numbered return shape (section 2). |
| "Be careful with the database." | A worry, not a constraint. | "Read-only against the database. No migrations. No writes outside `tests/fixtures/`." |

## 6. What a brief never contains

- **The library or the project notes wholesale.** A sub-agent receives
  only what its brief contains. Copy the one fact it needs, not the note
  it lives in.
- **Facts from another project.** A brief is written from this project's
  notes and code only.
- **Your reasoning, when the brief is for a reviewer.** A reviewer gets
  the brief and the diff; see `orchestration.md`.
- **Permission beyond the Free tier.** A sub-agent cannot be granted a
  Present-first or Hard-stop action in its brief; those come back as
  requests.

## 7. Briefing yourself

Show the brief to the owner even when working solo: they can correct the
goal before code exists. If the work drifts from it, update it in the
open.
