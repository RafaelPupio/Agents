# LeaseReviewer — project rules

A lease counsel for Brazilian rental contracts. **Showcase only.** The
working build, its legal knowledge base and the scheduled runner live in a
private repository.

## What may never appear here

The build sits beside signed contracts and tenant data. This folder carries
the idea, the shape, and anonymised examples — nothing else.

- **No real names, addresses, rent values or dates.** Invent them, and say
  in the README that examples are invented.
- **Never the system prompt or the legal knowledge base.** Describing what
  they do is the showcase. Publishing them is not.
- **Never the runner's schedule, credentials or recipient addresses.**

Check before every commit. A leak here is not a bug to fix later — it is
already published.

## It stays a README

A showcase entry, which the root `CLAUDE.md` recognises as a valid shape. Do
not add `system-prompt.md`, `knowledge/`, `skill/` or `install.sh`. If the
agent is ever generalised for publication, that is a separate decision,
recorded in `brain/log/decisions.md` before any file is written.

## Nothing here is legal advice

Keep that line in the README. It is not boilerplate — the agent reasons
about tenancy law, and the disclaimer is load-bearing.

## Finishing

`brain/status.md` and `brain/log/decisions.md` **in this folder**.
