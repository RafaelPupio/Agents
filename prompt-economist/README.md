# Prompt Economist

An agent that turns half-formed ideas into briefs coding agents get right
first time — and diagnoses prompts that cost too much.

It does not write your code. It writes the instruction that gets your code
written well, cheaply, by Claude Code, Codex, or whatever you use.

## Why

You have an idea. You type a vague paragraph into a coding agent. It opens
the wrong files, asks three clarifying questions, and re-derives context you
already had — tens of thousands of tokens before any useful work starts.

The fix is not a better model. It is a better brief.

## What it does

**Compose** — describe the idea, get a ready-to-paste brief: goal, scope,
non-goals, constraints, acceptance test, and what you already ruled out.

**Diagnose** — paste a prompt or transcript that cost too much, get the bill
itemised by cause, plus a compressed rewrite.

Both branch again on the target tool, because the right brief for Claude
Code is close to the *opposite* of the right brief for plain chat. Agentic
tools need to be told where to stop; plain chat needs to be told where it is.

---

## Install — Option A: Claude Code skill (recommended)

From the root of the project you want to use it in:

```bash
git clone https://github.com/RafaelPupio/Agents /tmp/agents
mkdir -p .claude/skills/prompt-economist/references
cp /tmp/agents/prompt-economist/skill/SKILL.md .claude/skills/prompt-economist/
cp /tmp/agents/prompt-economist/system-prompt.md /tmp/agents/prompt-economist/knowledge/*.md \
   .claude/skills/prompt-economist/references/
```

Then in Claude Code:

```
/prompt-economist
```

## Install — Option B: Claude Project / Custom GPT

1. Create a new Project (Claude) or Custom GPT (ChatGPT).
2. Open `system-prompt.md`, copy everything **below the `---`**, and paste it
   into the custom instructions field.
3. Upload all three files from `knowledge/` as project knowledge.
4. Start a chat. It opens with its two paths and one question.

## Install — Option C: any other agent platform

The content is plain Markdown with no platform-specific syntax. Paste
`system-prompt.md` as instructions, attach `knowledge/*.md` as retrieval
documents. That is the whole integration.

---

## Customising it

Four levers, in order of how often you will want them. Each is a named
thing you edit, not a prompt you rewrite.

### 1. Persona — `system-prompt.md`, "Persona" section

Ships as a blunt technical editor: curt, no flattery, cuts words. Deliberate
— a polite agent pads, and padding is the thing being optimised away.

To soften it, replace that section. Keep "never pad" whatever else you
change, or the output inflates.

```
## Persona — supportive coach
- Lead with what is strong in the user's description, then cut.
- Explain why each cut saves tokens, so the user learns the pattern.
- Never pad. Brevity is still the product.
```

### 2. Output shape — `system-prompt.md`, "Output" sections

The brief's headings are just a template. Add a field your team needs —
`**Rollback.**`, `**Owner.**`, `**Ticket.**` — by adding a line to the fenced
block. Remove `**Already ruled out.**` only if you enjoy re-litigating
decisions.

### 3. Branches — `system-prompt.md`, "Branch 2"

Ships with three targets: Claude Code, Codex, plain chat. To add one
(Cursor, Aider, an internal tool), add a row to the table there and a
section to `knowledge/tool-profiles.md`. Answer two questions in that
section: **what does it already know**, and **what will it invent if you do
not tell it**. That is the whole profile.

### 4. Cost model — `knowledge/token-economy.md`

The mechanisms the agent cites. If your setup has a cost the file does not
cover — a large retrieval index, an expensive MCP server, a CI loop the
agent triggers — add it under "Where the tokens actually go" with a lever
attached. The agent's rule is that every cost claim traces to this file, so
it will not cite what you have not written.

### Adding your own conventions

Drop an extra file in `knowledge/` describing your team's patterns, then
reference it from `system-prompt.md`. Keep it to principles, not paths —
briefs that hard-code one repo's layout do not survive contact with the next
repo.

---

## Design notes

**Ask at most two questions, then draft.** An agent about token economy that
interrogates you has failed at its own subject. Thin input produces a draft
with `?ASSUMPTION:` markers — correcting a concrete draft is cheaper than
answering abstract questions.

**Non-goals are load-bearing.** Most waste is an agent doing work nobody
asked for. One line of non-goals is the cheapest scope control available.

**"Already ruled out" survives compaction.** Long sessions drop early
context. Without it, the agent rediscovers and re-proposes what you rejected
on turn five.

## Licence

MIT. See [LICENSE](../LICENSE).
