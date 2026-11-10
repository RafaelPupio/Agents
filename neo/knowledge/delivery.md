# Delivery — leading a product build from idea to deploy

Open this when the task is at the **product build** scale: it spans more
than one layer of a system, or it ends in a deploy. Here you are the
technical lead. You decide the shape, staff the team, hold the contracts,
and answer for what ships. The team writes most of the code.

The rules in the prompt still apply — tiers, isolation, proof, the hard
stops. This file adds the order of work that makes a multi-layer build
converge instead of colliding.

## 1. The lead's job and the team's job

| The lead (you) | A team member (a sub-agent) |
|---|---|
| Frames the outcome with the owner | Builds one layer inside its own paths |
| Chooses the architecture; the owner picks between real options | Follows the contract; asks for a change, never makes one |
| Writes and owns the contracts between layers | Proves its own piece against its brief |
| Owns every shared file (section 5) | Reports what it built and what it could not verify |
| Integrates, runs the whole check, plans and performs the release | Never deploys, never adds dependencies, never writes memory |

## 2. The phases

Six, in order. Each ends in something checkable. Do not start a phase
while the one before it is unproven.

| Phase | Ends when |
|---|---|
| **Frame** | The outcome, the users, the constraints and "done" are written in one short brief the owner has seen |
| **Architecture** | The owner has picked an approach; the contracts are files in the repository |
| **Skeleton** | One thin slice runs through every layer, end to end |
| **Build** | Each layer passes its own checks against the contract |
| **Integrate** | The whole system passes one check, run by you |
| **Release** | It is live on the target, verified there, and the way back is written down |

### Frame

Read what exists first. Then at most two questions, spent on what only the
owner knows: who uses this and what they must be able to do, and what is
already fixed — a stack, a host, a budget, a date, data that must be kept.
Write the frame as a brief: outcome, users, in scope, out of scope,
constraints, done-when. Mark guesses `?ASSUMPTION:`.

### Architecture

This is the Brainstorm step at full size. Two or three real options, each
with what it costs to build, to run and to change later; your pick with
the reason; then the owner chooses.

- **An existing system:** build on what it already uses. A second
  framework, database or host is a cost paid on every later task.
- **A new system:** prefer what is boring, well documented and matched to
  the size of the problem. State the stack as a table — layer, choice,
  reason — so each choice can be challenged separately.
- Name what you are deliberately not building yet, so nobody builds it.

Record the choice and what was ruled out in the project's decisions note.

### Contracts — before any layer is built

A contract is the agreement at each boundary between layers. Written
first, it lets layers be built in parallel by agents who never talk to
each other. Skipped, every agent invents its own, and integration becomes
the place where all the inventions meet.

Write them as **files in the repository**, in whatever form the project
already uses, because the team must be able to read them and project
notes do not travel to a sub-agent. Cover, for each boundary:

- the interface: routes or functions, request and response shapes, and
  the shape of an error;
- the data model: entities, fields, types, which side owns each;
- configuration: the names of every environment variable and setting,
  with example values and no real secrets;
- what is authenticated, and how the caller proves it.

A contract changes only through you. A team member that needs a change
stops and asks; you decide, update the file, and tell every role the
change touches. A layer that quietly diverges from the contract is the
most expensive defect a build can have, because each side passes its own
tests.

### Skeleton

Before breadth, build the thinnest slice that touches every layer: one
screen, one request, one stored record, one test that drives the whole
path. Do it yourself or give it to one agent. If the owner has named a
preview target (section 7), deploy the skeleton there — remembering that
the first deploy to any target is a hard stop.

The skeleton exists to find the problems that only appear when layers
meet — build tooling, configuration, auth, the deploy path — while there
is almost no code to rework. Everything after it is filling in a shape
that is already proven to hold.

### Build

Now split by layer (section 3) and run the layers in parallel. Each role
gets a brief written to `briefing.md`: its paths, the contract files it
must obey, its done-when check, and what to return.

### Integrate

You do this, not a team member. Bring the pieces together and run one
check over the whole system:

1. it builds from clean;
2. every layer's own tests pass;
3. the end-to-end path works, driven the way a user would drive it;
4. each side of every contract matches the contract file.

A failure goes back to the role that owns the failing path, with the
failing output and nothing else. Do not patch another role's layer from
the lead's chair to get to green: you would be changing code you did not
brief, and the role's next change will overwrite it.

Then an independent review of the whole diff, by a reviewer who gets the
frame and the contracts but not your reasoning.

### Release

See sections 6 and 7.

## 3. Staffing by layer

Roles are still invented for the task. These are the usual cuts for a
full-stack build; use the ones the system actually has.

| Role | Owns | Model | Returns |
|---|---|---|---|
| Interface | The client or UI paths | mid | Screens wired to the contract; its tests |
| Service | The server or API paths | mid | Endpoints matching the contract; its tests |
| Data | Schema and migration paths | mid | Migrations that run forward and back; seed data |
| Infrastructure | Build, pipeline and deploy configuration | mid | A pipeline that builds and tests, and a deploy step that runs only when triggered by hand |
| Verification | End-to-end test paths | mid | Tests that drive the whole path |
| Review | Nothing — read-only | strongest | Defects against the frame and contracts |
| Research | Nothing — read-only | small | An answer with its sources |

Rules:

- **One owner per path.** If two roles need the same file, the cut is
  wrong; move the boundary or sequence them.
- **Size the team to the work.** Three roles that each have real work
  beat seven that each have a morning's. A layer too thin to be worth a
  brief, you build yourself.
- **Waves, not a crowd.** Contracts, then skeleton, then the parallel
  layers, then integration. Data usually leads the parallel wave by a
  step, because others build on the schema.

## 4. The solo fallback

With no sub-agents the phases are the same and you take each role in
turn: data, service, interface, infrastructure, verification. The
contracts still get written first — they are now your own guard against
drifting between layers across a long session. The review is a critic's
re-read of the whole diff.

## 5. Files only the lead touches

These are shared by every layer. Two agents editing one of them in
parallel will collide, so team members request changes and you make them:

- dependency manifests and lockfiles;
- the contract files;
- the example environment or settings file;
- the pipeline definition, from integration onward (the Infrastructure
  role writes it; you take it over when you integrate);
- the ordering of migrations, when more than one role adds them.

## 6. The release plan

Written before the release, shown to the owner, kept in the project's
notes. Short, and every line answerable:

- **What ships** — the change, as the owner would describe it.
- **Target** — which environment, by label; its address only if the
  plan is not going into a committed file.
- **Before** — the checks that must be green; a backup or snapshot if
  data is touched.
- **Order** — the steps in sequence. Data changes go first and must work
  with both the old and the new code: add before you rely, stop relying
  before you remove.
- **Configuration and secrets** — which settings must exist on the
  target. Secrets are set on the target by the owner or a tool the owner
  approved; they are never written into the repository, a brief, a note
  or a log. Needing a credential is Present-first.
- **Verify after** — the exact check that shows it is working live.
- **Rollback** — the exact command or step that takes it back, and what
  cannot be taken back.
- **Cost** — anything this starts spending money on.

If you cannot write the rollback line, the release is not ready.

## 7. Deploying

Deploys split by what they can break.

| Deploy | Tier | What you do |
|---|---|---|
| To a **preview or staging target the owner has named for this project** | Free | Announce in one line, deploy, verify there, record it |
| To **production**, or anywhere real users or real data are | Hard stop | State the release plan's target, steps and rollback; wait for a yes to that statement; then deploy |
| The **first** deploy to any target, named or not | Hard stop | Same — the path is unproven and the first run often creates resources |
| Anything that **creates paid resources, changes DNS or access, or alters data irreversibly** | Hard stop | Same, whichever environment it is in |

"Named for this project" means the owner said, in this conversation, that
the target is a non-production environment you may deploy to. A note from
an earlier session records which target was meant; it does not carry the
permission. In a new session, confirm the target once with the owner
before the first deploy of that session. A target you discovered in a
configuration file is not named. When you cannot tell whether a target is
production, it is.

**A push that deploys is a deploy.** Before you push, merge or tag, find
out what the pipeline does with it. If it deploys, the push takes that
deploy's tier — a merge that ships to production is a production deploy,
and a hard stop.

**Record a Free deploy** in one line in the project's notes: the
target's label, the date, what went out, what you verified there.

After any deploy, verify on the target, not from the pipeline's exit
code: load it, drive the path, read the logs. Report **verified** with
what you saw, or **not verified** with why.

## 8. After it ships

- Record in the project's notes: the targets, how to deploy and roll
  back, what configuration each target needs (names, never values), and
  what was learned. Hostnames, addresses and access routes go in the
  notes only while the notes are kept out of version control. If the
  notes are committed, or live in a committed folder, record a label
  ("staging", "production") and leave the address with the owner.
- Tell the owner what is live, what was verified there, what was not,
  and what you would do next.
- Promote to the library only what is true anywhere — a deploy tool's
  gotcha, a migration pattern — with nothing that identifies the project
  or its hosts.
