---
description: "BuildKeel: Resume paused work: a unit, a change or a thread, by its ID, or pick from what is paused, the most recent first."
argument-hint: "[nothing, or an ID], e.g. TK-013 or TH-004"
disable-model-invocation: true
---

Resume paused work with the user: a unit or change, where it was left, or a thread, the exploration it holds.

The user typed: $ARGUMENTS

**Before anything else**, call the BuildKeel `query` tool with `view: "process"`, and do not show its result. If it says this repository is not set up for BuildKeel, tell the user so, and that /bk:init sets it up, then stop: ask nothing else. Otherwise go on straight away.

## What to resume

- **Nothing:** call `query` with `view: "paused"` and show the list as it is: each one with who paused it, when, and its next step, the most recent first. Ask which to resume, the most recent as the default. With nothing paused, say so.
- **An ID:** resume that one.

If the spec tree is behind its remote, say so and offer to pull it first (the default), so that work paused on another machine is here.

## A unit or change

Call `start_work` with its `id`.

- **Paused by someone else, or on another machine:** the result says whose work it was and when it was paused. Ask the user to confirm, in their words, such as "Take over Priya's work on TK-013, paused two hours ago?" Only once they confirm, call `start_work` again with `takeOver: true`: the work moves to them, and the handover is recorded. If they decline, change nothing.
- **Uncommitted changes:** handle them as /bk:build does.
- **Started:** show the brief it returns first: where things stand, the decisions and dead ends, the open questions, the next step, and any files left uncommitted on another machine. Then go on as /bk:build goes on with a unit or change it has started: ask how to build what is left.

## A thread

Call `query` with `view: "threads"` and its `id`. Show its brief: the idea, the approaches, the decisions and dead ends, the open questions, and the next thing to discuss, with whose thread it is when someone else kept it. Then let the conversation go where the user takes it: a thread has no stages and no approval. Pausing again adds to it, and capturing it with /bk:capture closes it.

Do not create or edit spec tree files yourself: the BuildKeel tools write every record.
