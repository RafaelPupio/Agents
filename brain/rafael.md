# Conventions

How agents in this repo get written. Applies to every agent added here.

## The product is the system prompt

Everything else wraps it. Write it first, make it good, then package it.
README and skill file are distribution, not substance.

## Personas are functional, not decorative

Pick the persona that makes the agent's *job* work. Prompt Economist is
curt because a polite agent pads, and padding is exactly what it exists to
remove. If a persona choice cannot be justified by the task, it is
decoration — cut it.

## Customisation must be a named thing

"Adapt the prompt to your needs" is not documentation. Every agent README
lists specific levers: this section, this table, this file. A user should
edit a named target, never rewrite prose to get a different behaviour.

## Draft over interrogate

Agents here ask at most two questions, then produce a draft with assumptions
marked. Correcting something concrete is faster and cheaper for the user
than answering abstract questions about what they want.

## Generalised, always

Content describes principles, never one machine's layout. This repo is
public and the agents are meant to run in other people's projects.
