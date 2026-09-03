# Agents

Reusable AI agents you drop into your own projects. Plain Markdown — no
framework, no dependencies, no lock-in.

Each agent installs as a **Claude Code skill**, or pastes into a **Claude
Project** or **Custom GPT**, from one source file.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![No dependencies](https://img.shields.io/badge/dependencies-none-brightgreen)

---

## EcoPrompt

**Turns half-formed ideas into briefs coding agents get right first time.**

You know the feeling: you type a vague paragraph into Claude Code, and it
opens the wrong files, asks three clarifying questions, and re-derives
context you already had — thousands of tokens before any useful work starts.

The fix is not a better model. It is a better brief.

### Before

> the thing keeps timing out when the API is slow, i should probably add
> retries but i don't want it hammering the server, and there's tests
> somewhere that'll break

### After

> **Goal.** Transient API timeouts retry automatically with exponential
> backoff instead of failing the caller.
>
> **Scope.** The API client module at `<path?>` and its test file. Fill these
> in — I will not guess paths.
>
> **Non-goals.** No retry framework or new dependency. Do not change the
> client's public signature. Do not touch call sites. Do not retry
> non-idempotent requests.
>
> **Constraints.** Exponential backoff with jitter, capped attempts. Retry on
> timeout and 5xx only — never 4xx. Follow the module's existing error
> handling.
>
> **Done when.** A simulated timeout retries and succeeds; a 400 fails
> immediately; the existing suite passes unchanged.
>
> **Cut.** "There's tests somewhere that'll break" — a worry, not an
> instruction. Replaced with something checkable.

One exchange. The non-goals alone prevent the most expensive failure mode:
an agent tidying four files you never asked about, each one sitting in
context for the rest of the session.

### Install

```bash
git clone https://github.com/RafaelPupio/Agents
./Agents/ecoprompt/install.sh /path/to/your/project
```

Start a new Claude Code session in that project, then:

```
/ecoprompt
```

Not a Claude Code user? Paste `ecoprompt/system-prompt.md` into a Claude
Project or Custom GPT and upload the three files in `ecoprompt/knowledge/`.
[Full instructions →](ecoprompt/)

### What it does

| Mode | You bring | You get |
|---|---|---|
| **Compose** | A rough idea | A brief: goal, scope, non-goals, constraints, acceptance test |
| **Diagnose** | A prompt that cost too much | An itemised bill and a compressed rewrite |

It asks **at most two questions**, then drafts and marks its guesses. An
agent about token economy that interrogates you has failed at its own
subject.

If you have not settled on an idea yet, it refuses to draft — it names your
options and stops. A confident brief for an unchosen idea is the most
expensive thing it could hand you, because it looks like progress.

---

## LeaseReviewer

**A lease counsel for Brazilian rental contracts.** Reviews a contract
clause by clause before you sign, answers questions about it afterwards,
computes the annual IGP-M or IPCA readjustment with the full twelve-month
table, and drafts the tenant notice in Portuguese. A small scheduled runner
emails the landlord two months ahead of every readjustment and renewal.

| Mode | You bring | You get |
|---|---|---|
| **Review** | A contract, draft or signed | Findings by severity, each with the article it rests on, and a "change before signing" list |
| **Consult** | A question about it | An answer that cites the clause and the law |
| **Readjust** | Index, base month, rent | The twelve values, the factor, the new rent |
| **Notify** | A readjustment or renewal | A formal letter to the tenant, as a draft for you to send |

**Private build.** The agent and its legal knowledge base sit next to real
contracts, so they are not published. The showcase page has the design, the
reasoning, and an example review.
[See the showcase →](lease-reviewer/)

---

## How these are built

```
<agent-name>/
├── README.md          purpose · install · customisation levers
├── system-prompt.md   canonical instructions, single source of truth
├── knowledge/         reference files the agent reasons from
├── skill/SKILL.md     Claude Code packaging
└── install.sh         copies the skill into a target project
```

**Portable.** No platform-specific syntax. The same files work as a skill, a
Project, a Custom GPT, or anything else that accepts instructions and
documents.

**One source of truth.** `SKILL.md` references the system prompt rather than
copying it. Two copies drift, and the drift is silent.

**Generalised.** Knowledge files describe principles, never one machine's
paths. An agent that hard-codes a repo's layout does not survive contact
with the next repo.

## Customising

Every agent documents named levers you edit — a specific section, table, or
file — never "adapt the prompt to your needs". For EcoPrompt: persona,
output template, target tools, and the cost model.
[See the levers →](ecoprompt/#customising-it)

## Licence

MIT. Use them, fork them, change them.
