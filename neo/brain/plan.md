# Neo Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship Neo v1.0 — a senior-developer agent, called by name, with a two-store memory, installable into Claude Code, Codex and Hermes from one source.

**Architecture:** One portable prompt (`system-prompt.md`, no size cap), five knowledge files, one adapter per harness, and a shell installer that copies them into the harness's skill location and seeds the library at `$NEO_HOME/`. Nothing is written into any global instruction file.

**Tech Stack:** Markdown; POSIX-leaning Bash (`set -euo pipefail`, no dependencies beyond coreutils and `diff`); a Bash test script.

**Spec:** `neo/brain/design.md`

## Global Constraints

- Public repo: no home paths other than `~`, no machine names, no other project names, no keys, in any file.
- `system-prompt.md` and `knowledge/*.md` name no harness and no harness tool. Harness words appear only in `adapters/`, `skill/`, `install.sh`, `README.md`.
- `neo/CLAUDE.md` ≤ 3072 bytes. Each `knowledge/*.md` ≤ 20480 bytes; split by topic past that. `system-prompt.md` has no cap.
- `skill/SKILL.md` references the prompt; it never restates it.
- Library root: `$NEO_HOME`, default `~/.neo`. Installed skill: `<SKILL_DIR>/neo/` holding `SKILL.md` and `references/`. Project notes: `.neo/` in the project root.
- Commits stay local on branch `neo`. Nothing is pushed or tagged without the owner's say.

## Review Focus

1. `$NEO_HOME` already holds a library with the owner's notes → no existing file is modified; only missing skeleton files are added.
2. Reinstall after the prompt changed → the installed prompt and knowledge are refreshed, and a knowledge file deleted from the source is gone from the install.
3. A path containing a space (`$NEO_HOME` or the target) → install succeeds.
4. Target directory does not exist → exit 1, nothing created.
5. A project install into a git repo → `.neo/` is not added to that repo's ignore file by the installer; Neo does that itself, on first use, and says so.

Each is pinned by a test in Task 4.

---

### Task 1: Harness facts and adapters

**Files:**
- Create: `neo/adapters/claude-code.md`, `neo/adapters/codex.md`, `neo/adapters/hermes.md`, `neo/adapters/generic.md`

**Interfaces:**
- Produces, per harness, five facts later tasks rely on: `SKILL_DIR` (skill location relative to a home or project root), `INVOKE` (what the user types to call Neo), how to delegate to a sub-agent, how to choose a cheaper model for one, whether writes outside the project are sandboxed.

- [ ] **Step 1:** Look up each harness's current documentation for the five facts. Do not write them from memory. Record the source URL and the date checked at the foot of each adapter.
- [ ] **Step 2:** Write each adapter as one table — capability (`delegate`, `parallel delegates`, `cheaper model`, `find a skill`, `install a skill`, `how Neo is called`, `library write access`, `native memory: what it is and how to turn it off`) → how it is done in this harness — plus a "not available here" line for any capability the harness lacks and what Neo does instead.
- [ ] **Step 3:** `generic.md`: no tools. Neo works solo; asks the user to paste the library index in at the start and to save the notes it prints at the end.
- [ ] **Step 4:** Verify: `grep -c '^|' neo/adapters/*.md` shows a table in each; every adapter has a "Checked:" line with a URL and date.
- [ ] **Step 5:** Commit `neo: harness adapters`.

### Task 2: The prompt

**Files:**
- Create: `neo/system-prompt.md`

**Interfaces:**
- Produces: section headings other files link to — `Role`, `Persona`, `Opening`, `Precedence`, `The loop`, `Autonomy`, `Memory`, `Team`, `What you never do`. Knowledge file names it points to: `briefing.md`, `orchestration.md`, `engineering.md`, `tooling.md`, `memory.md`.

- [ ] **Step 1:** Write `system-prompt.md` from design sections 2–5 and 7, as complete as the job needs. The autonomy table, the fit test and the skill card fields are copied from the design verbatim. Each loop step names the knowledge file that holds its detail. Include the scale rule: a one-line fix runs Recall, Build, Prove only. `Opening`: on being called, Neo recalls memory, states in two lines what it found and what it will do, and starts — no menu.
- [ ] **Step 2:** Verify portability: `grep -iEn 'claude|codex|hermes|subagent_type|AGENTS\.md|CLAUDE\.md' neo/system-prompt.md` returns nothing.
- [ ] **Step 3:** Verify coverage: each of design goals 1–6 and each anti-goal maps to a sentence in the prompt; list the mapping in the commit body.
- [ ] **Step 4:** Commit `neo: system prompt`.

### Task 3: Knowledge files

**Files:**
- Create: `neo/knowledge/briefing.md`, `orchestration.md`, `engineering.md`, `tooling.md`, `memory.md`

**Interfaces:**
- Consumes: the heading and file names from Task 2.
- Produces: in `memory.md`, the exact layouts of both stores (file names as in design section 4), which Task 4's templates must match.

- [ ] **Step 1:** `briefing.md` — the brief template (goal, context the reader lacks, scope as paths, non-goals, constraints, done-when, already ruled out, what to report back), and the cold-reader test: could someone with only this page succeed?
- [ ] **Step 2:** `orchestration.md` — when to split and when not, the no-shared-files rule, inventing a role per task, the model-routing table (search/bulk reading → small; implementation → mid; design/review → strongest), verifying a report before relying on it, independent review, the solo fallback.
- [ ] **Step 3:** `engineering.md` — brainstorm scale and the small-change threshold, reading before asking, root cause before fix, proof of done, saying what is unknown.
- [ ] **Step 4:** `tooling.md` — where to look for tools and skills, the fit test, the skill card, judging a source (licence, activity, what it can touch), the declined register, removal.
- [ ] **Step 5:** `memory.md` — both layouts, recall order, what to capture, the promotion filter with one worked before/after example using invented names, repo ingestion (what to record, what not to copy), the existing-convention rule, the "to promote" queue, size and rotation.
- [ ] **Step 6:** Verify: each file ≤ 20480 bytes; the portability grep from Task 2 Step 2 run over `neo/knowledge/` returns nothing.
- [ ] **Step 7:** Commit `neo: knowledge files`.

### Task 4: Templates and installer

**Files:**
- Create: `neo/templates/library/INDEX.md`, `neo/templates/library/skills.md`, `neo/templates/library/tools/.gitkeep`, `techniques/.gitkeep`, `sources/.gitkeep`
- Create: `neo/templates/project/INDEX.md`, `project.md`, `decisions.md`, `tooling.md`, `journal.md`
- Create: `neo/install.sh` (executable)
- Test: `neo/tests/install.test.sh` (executable)

**Interfaces:**
- Consumes: `SKILL_DIR` per harness from Task 1; layouts from Task 3.
- Produces: `install.sh <claude-code|codex|hermes> [target] [--dry-run]`. `target` defaults to `~`. Environment: `NEO_HOME` (default `~/.neo`). Exit 0 on success, 1 on bad input, 2 on unknown harness.

- [ ] **Step 1: Write the failing tests.** `tests/install.test.sh` runs every case in a fresh `mktemp -d` with `HOME` and `NEO_HOME` pointed inside it, prints `PASS`/`FAIL` per case, and exits non-zero on any failure. Cases:
  - `fresh_install`: `<target>/<SKILL_DIR>/neo/SKILL.md` exists; `references/` holds `system-prompt.md`, `adapter.md` and all five knowledge files; `adapter.md` equals the named harness's adapter.
  - `reinstall_refreshes`: install, change the source prompt and delete one source knowledge file (in a copied source tree), install again → installed prompt matches, deleted file is gone.
  - `library_seeded`: `$NEO_HOME/INDEX.md`, `skills.md`, `tools/`, `techniques/`, `sources/` exist.
  - `library_kept`: `$NEO_HOME/INDEX.md` pre-filled with `mine` → unchanged; missing `skills.md` is created.
  - `dry_run`: `--dry-run` → exit 0, nothing written anywhere, the planned paths printed.
  - `missing_target`: non-existent target → exit 1, nothing created.
  - `unknown_harness`: `install.sh emacs` → exit 2.
  - `path_with_space`: target and `NEO_HOME` each containing a space → `fresh_install` and `library_seeded` assertions hold.
  - `project_install_leaves_ignore`: target is a git repo with a `.gitignore` → `.gitignore` unchanged.
- [ ] **Step 2:** Run `neo/tests/install.test.sh`. Expected: every case FAIL (no installer).
- [ ] **Step 3:** Implement `install.sh`: parse args → resolve `SKILL_DIR` → validate target → replace `<SKILL_DIR>/neo/` wholesale → seed the library with copy-if-absent → print where it landed and what to type to call Neo.
- [ ] **Step 4:** Run the tests. Expected: all PASS.
- [ ] **Step 5:** Run `shellcheck neo/install.sh neo/tests/install.test.sh` if available; fix findings.
- [ ] **Step 6:** Commit `neo: memory templates and installer`.

### Task 5: Packaging and records

**Files:**
- Create: `neo/skill/SKILL.md`, `neo/README.md`, `neo/CLAUDE.md`, `neo/AGENTS.md` (symlink → `CLAUDE.md`), `neo/brain/INDEX.md`, `status.md`, `handoff.md`, `log/decisions.md`
- Modify: `README.md` (root: add a Neo section above "How these are built"; add `neo-v1.0` to the versions sentence), `brain/INDEX.md` (root: add the Neo brain row), `brain/status.md` (root: add the agent row), `brain/log/decisions.md` (root: one line recording the new agent and the `adapters/` and `templates/` additions to the standard layout)

- [ ] **Step 1:** `SKILL.md` — frontmatter `name: neo`, a description that triggers on software work, and a body that says: read `references/system-prompt.md` and follow it for the rest of the session; open the knowledge file each step names; read `references/adapter.md` for how this harness delegates. No restated rules.
- [ ] **Step 2:** `README.md` — states "full agent" in its opening lines; what Neo is; install per harness with the tested/untested label from the design's phasing; what the installer writes and how to remove it; the two stores with a tree; the native-memory caveat; the six levers, each naming its file and section; how to give Neo a repo to learn from.
- [ ] **Step 3:** `CLAUDE.md` — Neo's project rules: the prompt is the product; reinstall after changing it or a knowledge file; adapters re-verified against docs, never from memory; behaviour changes earned by a recorded test case; finishing means this folder's brain.
- [ ] **Step 4:** Brain files and the four root edits.
- [ ] **Step 5:** Verify: `[ "$(wc -c < neo/CLAUDE.md)" -le 3072 ]`; `[ "$(readlink neo/AGENTS.md)" = CLAUDE.md ]`; every lever in the README names a path that exists.
- [ ] **Step 6:** Hygiene: `grep -rnE '/Users/|/home/[a-z]|@gmail|sk-[A-Za-z0-9]{8}' neo/ README.md brain/` returns nothing.
- [ ] **Step 7:** Commit `neo: packaging, README and records`.

### Task 6: Run it

**Files:**
- Modify: `neo/brain/log/decisions.md`, `neo/brain/status.md`, `neo/README.md` (harness labels)

- [ ] **Step 1:** Install into a scratch `HOME` for each harness whose CLI is present on the build machine; confirm the skill loads when called the way the adapter says. Label any harness not run "untested" in the README.
- [ ] **Step 2:** With the scratch install active, run design scenarios 1–7 in non-interactive sessions against a throwaway sample project. For each, record input, what Neo did, pass or fail.
- [ ] **Step 3:** For any failure, change `system-prompt.md` or the knowledge file at fault, reinstall, re-run the scenario, and record the case that motivated the change.
- [ ] **Step 4:** Scenario 6 check, mechanical: after the run, `grep -rn "<sample project's name and paths>" "$NEO_HOME"` returns nothing.
- [ ] **Step 5:** Update status. Commit `neo: scenario results`.
- [ ] **Step 6:** Stop. Installing into the owner's real home folder, pushing, and tagging `neo-v1.0` are the owner's to trigger.
