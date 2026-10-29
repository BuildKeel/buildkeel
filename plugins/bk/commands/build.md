---
description: "BuildKeel: Start a unit and build it: a task, story, defect or change by its ID, the ready units under a parent, or a small change described in words."
argument-hint: "[an ID, a parent's ID, or what to change in words], e.g. TK-001, US-001, or \"fix the footer link\""
disable-model-invocation: true
---

Start a BuildKeel unit and build it with the user. Every code change belongs to exactly one unit, and the unit's context tells you what to build. Starting checks the unit is ready, switches to its branch and loads its context; the user then chooses how far to go: build everything, the next one only, or set it up and work together.

The user typed: $ARGUMENTS

**Before anything else**, call the BuildKeel `query` tool with `view: "process"`, and do not show its result. If it says this repository is not set up for BuildKeel, tell the user so, and that /bk:init sets it up, then stop: ask nothing else. Otherwise go on straight away.

If BuildKeel's session report, or `query` with `view: "process"`, says this spec tree is Spec-driven, follow "In a Spec-driven tree" at the end in place of "Build a single unit" and "Build what is ready under a parent".

## What to build

What the user typed decides it:

- **A unit's ID**, such as a task, a story built without tasks, a defect, an ad-hoc unit or a change: start it and build it, as "Start it" and the sections after it say.
- **A parent's ID**, such as a story built through tasks or an epic: build the units ready under it, as "Build what is ready under a parent" says.
- **Words**, such as "fix the footer link": see "Words in place of an ID".
- **Nothing:** ask straight away: "What should I build?" Offer the choices with your tool for asking a question with choices, if you have one:
  1. **The active unit** (the default, listed first), named with its ID and title: offer it only when this working tree has one.
  2. **Show what can be started** (the default when there is no active unit). Call `query` with `view: "startable"` and show its result as it is. Then ask which to build, the ready ones offered with the one you recommend first, and, in Full SDLC, **Everything that is ready** as a choice too. If nothing is ready, say what is in the way and suggest the next step, such as approving with /bk:approve, and stop.
  3. **Type an ID or describe the change.** If they pick this, ask for it.

### Words in place of an ID

Call `query` with `view: "startable"`, and in a Spec-driven tree also with `view: "changes"`. Compare the words with the titles of the units that can start and of the open changes, ignoring case and counting the words they share. Then ask, with your tool for asking a question with choices:

- **When a title matches:** **Build <ID> "<title>"** for the best match (the default), then any other close match, then **Record a new ad-hoc unit "<title>"**, with the title you propose from the words. Record no ad-hoc unit unless the user picks it.
- **When nothing matches:** **Record the ad-hoc unit "<title>" and build it** (the default), with the title you propose, or **Type another description**.

The title says what changes in a few words, such as "Fix the footer link". If the change is a defect in work that was planned and tested, suggest recording it with /bk:new defect instead, and go on as the user prefers.

### Recording an ad-hoc unit

An ad-hoc unit needs no approval: it gets its permanent ID straight away, its commits carry that ID, and it is finished with /bk:done like any other unit. Call the BuildKeel `save_draft` tool with `type: "adhoc"` and this content, with the title and a sentence or two saying what changes and why:

```
---
id: {{id}}
title: <title>
---

## Description

<what changes and why>
```

It gives the unit its ID and commits it in the spec repo. If the number counter cannot be reached, the ID ends in letters and digits instead of a number; it is still permanent. Then start it with the new ID.

## Start it

If the unit is already the active unit in this working tree, it is not started again: call `get_context` for it and go on from there. Otherwise call the BuildKeel `start_work` tool with the unit's `id`.

- **Refused by the start gate:** show every failing check with its fix, as it is. Offer the fix that comes first, such as approving the story or its test plan. Do not start anything else in its place without asking.
- **Uncommitted changes:** show the files it lists. If it says some of them set BuildKeel up (such as `.buildkeel.yaml` or the spec tree's `buildkeel.yaml`), offer first **Commit them as setting BuildKeel up** (the default): commit only those files, with a message such as "Set up BuildKeel" and no `BuildKeel-Unit` line, then deal with any other files as below, and call `start_work` again. Every other change must belong to one unit, so ask the user what to do with them, offering these choices:
  1. **Commit them to the active unit** (the default, when there is one). Show what will be committed, commit it with the message ending in `BuildKeel-Unit: <active unit ID>`, then call `start_work` again. When there is no active unit, ask which unit the changes belong to instead.
  2. **Set them aside.** List the files again and ask for an explicit yes. Then run `git stash push --include-untracked -m "BuildKeel: set aside before starting <ID>"`, tell the user they can bring the changes back with `git stash pop`, and call `start_work` again.
  3. **Leave them, and do not start.**

  Never discard changes any other way.
- **Started:** tell the user the branch and anything it warned about, such as a spec tree that is behind its remote.

Keep the context in mind for the rest of the work, and call `get_context` again if you lose track of it. Do not create or edit spec tree files yourself.

## Build a single unit

Sum up the context: what to build, the acceptance criteria and the test cases, by ID. Then ask how to go on, with that summary in the same reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. The choices:

1. **Build it** (the default).
2. **Set it up and work together**: build nothing yet; ask the user how to begin.

To build it: write the code and the tests for its test cases, each test named with its test case ID in square brackets, one ID per bracket. Commit as you go, each message ending with `BuildKeel-Unit: <ID>`, and change files only with your file editing tools. Run the tests with a JUnit XML report and record it with the BuildKeel `test_results` tool. The run stops to ask, as "When a run stops" says. When the work is committed and its test cases pass, tell the user they can finish it with /bk:done; do not finish it yourself.

## Build what is ready under a parent

Each unit still goes through its own start gate, gets its own branch, commits and completion record, and is tested before it is finished.

Call the BuildKeel `query` tool with `view: "startable"`. Take the units ready to start, at the lowest level: tasks, and stories that have no tasks (with a parent named, only those under it). Leave out defects and ad-hoc units unless the user asks for them. Order them by parent, then by ID, so that a story's tasks are built in order.

If nothing is ready, show what is waiting and why, as `query` gave it, suggest the next step (such as approving with /bk:approve), and stop.

Otherwise show the list in order, and say how the run goes: each unit is started, built, tested and finished in turn; each gets its own branch, stacked on the one before so later units build on the earlier ones' code; and the run stops to ask when a gate refuses, a test fails and cannot be fixed, or a requirement is unclear. Then ask, with the list and how the run goes in that same reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. The choices:

1. **Build them all** (the default).
2. **Build the next one only**: the first unit is started, built, tested and finished, then the run stops and names the next.
3. **Set it up and work together**: start the first unit, build nothing, and ask the user how to begin.

Any other answer, such as a change to the list, is taken in, and the list is shown again.

For each unit, in order:

1. **Start it.** Call `start_work` with its `id` and `run: true`; from the second unit on, also pass `stack: true`, so its branch starts from the branch of the unit just finished. If the start is refused, or there are uncommitted changes, stop the run: show the result as it is and ask the user how to go on.
2. **Build it.** Work from the context `start_work` returned: the unit, its requirements, its design, and its test cases. Write the code and the tests for its test cases, each test named with its test case ID in square brackets, one ID per bracket. Commit as you go, each message ending with `BuildKeel-Unit: <ID>`, and change files only with your file editing tools. When a task needs a test case its own test plan does not have, the plan the user agreed changes: show the test case you would add, with its `covers` line and why it is needed, and ask before saving it. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Once the user agrees, add it with `{{new}}` for its number and save the whole plan with `save_draft` and the plan's `id`: unless the result says the plan waits for approval, it is recorded at once as its next version, and the run goes on.
3. **Test it.** Run the tests with a JUnit XML report and record it with the BuildKeel `test_results` tool. When a test fails, fix the code or the test and run them again.
4. **Finish it.** Call `finish_work` without `apply`. If it says the tests have no current result, run them again and record them, once. If it is refused for any other reason, or lists commits without a `BuildKeel-Unit` line, stop the run and show it. Otherwise call `finish_work` with `apply: true`: the user's choice to build covers finishing each unit that passes its done gate.
5. Say in a line what was finished: the unit, its commits, its test cases passing, and its completion record. Then go on to the next unit.

At the end, show a table of the run: each unit, its branch, its commits, and its completion record, or where the run stopped and why. The last branch holds the whole run: say that one pull request from it reviews all of it, or that each branch can have its own pull request, each based on the previous one and merged in order. If the completion records are not pushed, remind the user to push the spec repo.

## When a run stops

A run stops and asks the user:

- when a gate refuses: show the result as it is;
- when a test fails and still fails after a real attempt to fix it: name the failing test case and what you tried, and ask how to go on;
- when a requirement is unclear (two readings, a missing case, a conflict with the code): ask one question, with your recommendation. Never guess a requirement;
- when agreed behavior looks wrong, as "Behavior that looks wrong" says.

Do not create or edit spec tree files yourself: the BuildKeel tools write every record.

## Behavior that looks wrong

When what was agreed looks wrong while you build (a requirement, an acceptance criterion or a test case), stop and ask, whether or not the build started with this command: name it by ID, and say why it looks wrong. Offer **Keep it as agreed** and **Change it**, your recommendation first. Never build something else, and never edit the spec, without the answer.

- **Kept:** build it as agreed, and do not raise it again in this build.
- **Changed:** change the spec first. Save the whole changed story (or task) with `save_draft`, which opens its next version, and show it as any draft. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Then call the BuildKeel `impact` tool with its `id`: the preview names what the new version would make suspect, such as tasks and test plans. Draft the next version of each that must change too, and offer the set for approval with /bk:approve. Build nothing more on the unit until the set is approved; when the start gate is set to warn and the user says to carry on, go on, saying that you build against versions not yet approved. Once the set is approved, the unit is suspect: with the user's agreement, record that it now builds against the new versions with `resolve_suspect` (`decision: "still-valid"`), and go on against them.
- **In code nothing describes yet** (`query` with `view: "describes"` finds no artifact): draft its version 0 first, describing the code as it is, as /bk:new does, then the change on top of it.

## In a Spec-driven tree

The units are open changes, defects and ad-hoc units, and no gate runs. Defects and ad-hoc units are built as "Build a single unit" says. A change is built task by task, in order, on the change's branch:

1. **The change.** Start it as "Start it" says, unless it is already active: `start_work` starts it, or says which working tree on this machine already holds it. If nothing can be started, suggest drafting a change with /bk:capture.
2. **Choose how to build.** Sum up the change in a few lines, with its title: what the proposal changes, and the requirements it adds, modifies or removes by ID. Show its unticked tasks in order, each with how it is verified, and say how the run goes: each task is built, tested and ticked in turn, and the run stops to ask when a test fails and cannot be fixed, a requirement is unclear, or what was agreed would change. Then ask, with the list in that same reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. The choices:
   1. **Build them all** (the default).
   2. **Build the next one only**: build and tick the first unticked task, then stop and name the next.
   3. **Set it up and work together**: build nothing; ask the user how to begin.

   When every task is ticked already, say so instead, and that the user can run /bk:done to finish the change.
3. **Each task in turn.** Write the code and its tests, each test named with the scenario ID it checks in square brackets, one ID per bracket, such as `[AUTH-R3-S1]`. Commit as you go, each message ending with `BuildKeel-Unit: <change ID>`, and add `BuildKeel-Task: <task number>` on the next line when a commit does exactly that one task. Run the tests with a JUnit XML report and record it with `test_results`. Once the task's stated verification passes, tick it with `save_draft`, `type: "tasks"`, the change's `id` and `tick` set to its number, such as `["2.3"]`, and say so in a line, with the progress the result gives. Never ask before ticking. A failing test you cannot fix, or an unclear requirement, stops the run, as "When a run stops" says.
   - **Behavior that looks wrong** stops the run too: name the requirement or scenario and why, and ask **Keep it as agreed** or **Change it**, your recommendation first. Kept: build it as agreed. Changed: a requirement of this change's own spec change is edited in place, as the next point says, with the follow-on edits to the proposal, design and tasks. A requirement as an archived change left it is changed through this change, with a spec change modifying it (the default), or through a separate change drafted with /bk:capture, as the user prefers. In code nothing describes yet, document it first as version 0 of a capability spec, then change it.
   - **A change to what was agreed** stops the run too: a requirement or scenario to add, change or drop, a task's wording, or a task to add or remove. Say which file, what changes and why, show the change in full, and ask. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Before adding a requirement to a change with more than half its tasks ticked, ask once first whether it belongs in this change or a new one, and draft nothing until the user answers. Save it only once the user agrees, then go on: one requirement with `save_draft`, `type: "spec-change"`, the change's `id`, its `capability` and `requirement` (`id` and `content` to replace it, `section` and `content` to add one, `id` and `drop` to take one out); a task list's wording as the whole file. Never change the spec on your own initiative, not even to make your own check pass.
4. **At the end**, show each task with its commits and whether it is ticked, or where the run stopped and why. When the last tick's result says every task is done, pass on that the user can run /bk:done to finish the change. Do not finish the change yourself: /bk:done reviews the code against the change's requirements before it is archived.
