---
description: "BuildKeel: Start work on a task, story, bug or ad-hoc unit: check it is ready, switch to its branch and load its context."
argument-hint: "[unit ID], e.g. TK-001"
disable-model-invocation: true
---

Start work on a BuildKeel unit with the user. Every code change belongs to exactly one unit, and the unit's context tells you what to build.

The user typed: $ARGUMENTS

If BuildKeel's session report, or `query` with `view: "process"`, says this spec tree is Spec-driven, follow "In a Spec-driven tree" at the end as well.

## Choose the unit

If the user named a unit above, use it.

If the user typed nothing, ask straight away, before calling any tool: "What do you want to start?" Offer the choices with your tool for asking a question with choices, if you have one:

1. **Show what can be started** (the default, listed first).
2. **Type a unit ID.** If they pick this, ask for the ID.

If they pick the first choice, call the BuildKeel `query` tool with `view: "startable"` and show its result as it is. Then ask which unit to start, offering the ready ones as choices with the one you recommend first. If nothing is ready, say what is in the way and suggest the next step, such as approving with /bk:approve.

## Start it

Call the BuildKeel `start_work` tool with the unit's `id`.

- **Refused by the start gate:** show every failing check with its fix, as it is. Offer the fix that comes first, such as approving the story or its test plan. Do not start anything else in its place without asking.
- **Uncommitted changes:** show the files it lists. If it says some of them set BuildKeel up (such as `.buildkeel.yaml` or the spec tree's `buildkeel.yaml`), offer first **Commit them as setting BuildKeel up** (the default): commit only those files, with a message such as "Set up BuildKeel" and no `BuildKeel-Unit` line, then deal with any other files as below, and call `start_work` again. Every other change must belong to one unit, so ask the user what to do with them, offering these choices:
  1. **Commit them to the active unit** (the default, when there is one). Show what will be committed, commit it with the message ending in `BuildKeel-Unit: <active unit ID>`, then call `start_work` again. When there is no active unit, ask which unit the changes belong to instead.
  2. **Set them aside.** List the files again and ask for an explicit yes. Then run `git stash push --include-untracked -m "BuildKeel: set aside before starting <ID>"`, tell the user they can bring the changes back with `git stash pop`, and call `start_work` again.
  3. **Leave them, and do not start.**

  Never discard changes any other way.
- **Started:** tell the user the branch and anything it warned about, such as a spec tree that is behind its remote. Then give a short summary of the context it returned: what to build, the acceptance criteria, and the test cases, by ID. Propose how to begin, and ask before writing code.

Keep the context in mind for the rest of the work, and call `get_context` again if you lose track of it. Do not create or edit spec tree files yourself.

## In a Spec-driven tree

The units are open changes, bugs and ad-hoc units, and no gate runs: `start_work` starts the unit, or says which working tree on this machine already holds it. If nothing can be started, suggest drafting a change with /bk:capture. When a change starts, sum up its context in a few lines: what the proposal changes, the requirements it adds, modifies or removes by ID, how many of its tasks are done, and the next unticked task. Propose starting with that task, or running /bk:build for all of them, and ask before writing code.
