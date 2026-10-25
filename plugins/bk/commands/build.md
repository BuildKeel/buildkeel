---
description: "BuildKeel: Build what is ready: start, build, test and finish each ready unit in turn, after one confirmation."
argument-hint: "[parent ID], e.g. US-001 to build its tasks, or EP-01; everything ready when left out"
disable-model-invocation: true
---

Build every unit that is ready, one after another, with the user's one confirmation up front. Each unit still goes through its own start gate, gets its own branch, commits and completion record, and is tested before it is finished.

The user typed: $ARGUMENTS

If BuildKeel's session report, or `query` with `view: "process"`, says this spec tree is Spec-driven, follow "In a Spec-driven tree" at the end instead of the sections before it.

## Choose what to build

If the user named a story, an epic or another parent above, build the ready units under it.

If the user typed nothing, ask straight away, before calling any tool: "What should I build?" Offer the choices with your tool for asking a question with choices, if you have one:

1. **Everything that is ready** (the default, listed first).
2. **Only what is under one story or epic: type its ID.** If they pick this, ask for the ID.

## List it and ask once

Call the BuildKeel `query` tool with `view: "startable"`. Take the units ready to start, at the lowest level: tasks, and stories that have no tasks (with a parent named, only those under it). Leave out bugs and ad-hoc units unless the user asks for them. Order them by parent, then by ID, so that a story's tasks are built in order.

If nothing is ready, show what is waiting and why, as `query` gave it, suggest the next step (such as approving with /bk:approve), and stop.

Otherwise show the list in order, and say how the run goes: each unit is started, built, tested and finished in turn; each gets its own branch, stacked on the one before so later units build on the earlier ones' code; and the run stops to ask when a gate refuses, a test fails and cannot be fixed, or a requirement is unclear. Then ask, with your tool for asking a question with choices, showing the list and how the run goes. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. The choices:

1. **Build them** (the default).
2. **Change the list.** Take in what they say and show the list again.
3. **Stop.**

## Build each unit in turn

For each unit, in order:

1. **Start it.** Call `start_work` with its `id` and `run: true`; from the second unit on, also pass `stack: true`, so its branch starts from the branch of the unit just finished. If the start is refused, or there are uncommitted changes, stop the run: show the result as it is and ask the user how to go on.
2. **Build it.** Work from the context `start_work` returned: the unit, its requirements, its design, and its test cases. Write the code and the tests for its test cases, each test named with its test case ID in square brackets. Commit as you go, each message ending with `BuildKeel-Unit: <ID>`, and change files only with your file editing tools. When a task needs a test case its own test plan does not have, add it, with `{{new}}` for its number and its `covers` line, and save the whole plan with `save_draft` and the plan's `id`: unless the result says the plan waits for approval, it is recorded at once as its next version, and the run goes on.
3. **Test it.** Run the tests with a JUnit XML report and record it with the BuildKeel `test_results` tool. When a test fails, fix the code or the test and run them again. If it still fails after a real attempt, stop the run: name the failing test case and what you tried, and ask the user how to go on.
4. **When a requirement is unclear** (two readings, a missing case, a conflict with the code), stop the run and ask the user one question, with your recommendation. Never guess a requirement.
5. **Finish it.** Call `finish_work` without `apply`. If it says the tests have no current result, run them again and record them, once. If it is refused for any other reason, or lists commits without a `BuildKeel-Unit` line, stop the run and show it. Otherwise call `finish_work` with `apply: true`: the user's confirmation of the run covers finishing each unit that passes its done gate.
6. Say in a line what was finished: the unit, its commits, its test cases passing, and its completion record. Then go on to the next unit.

## At the end

Show a table of the run: each unit, its branch, its commits, and its completion record, or where the run stopped and why. The last branch holds the whole run: say that one pull request from it reviews all of it, or that each branch can have its own pull request, each based on the previous one and merged in order. If the completion records are not pushed, remind the user to push the spec repo.

Do not create or edit spec tree files yourself: the BuildKeel tools write every record.

## In a Spec-driven tree

A run builds one change's tasks, in order, on the change's branch.

1. **The change.** If the user named a change, start it with `start_work` unless it is already active. If they typed nothing and a change is active, build it. Otherwise ask, straight away, which change to build, offering **Show what can be started** (the default) and **Type a change ID**, then start the one they pick.
2. **Ask once.** Call `get_context` for the change. Show its unticked tasks in order, each with how it is verified, and say how the run goes: each task is built, tested and ticked in turn, and the run stops to ask when a test fails and cannot be fixed or a requirement is unclear. Then ask, showing the list. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. The choices: **Build them** (the default), **Change the list**, **Stop**.
3. **Each task in turn.** Write the code and its tests, each test named with the scenario ID it checks in square brackets, such as `[AUTH-R3-S1]`. Commit as you go, each message ending with `BuildKeel-Unit: <change ID>`, and add `BuildKeel-Task: <task number>` on the next line when a commit does exactly that one task. Run the tests with a JUnit XML report and record it with `test_results`. Once the task's stated verification passes, tick it: save the task list with `save_draft`, type `tasks` and the change's `id`, with its box changed to `[x]`. A failing test you cannot fix, or an unclear requirement, stops the run with one question and your recommendation.
4. **At the end**, show each task with its commits and whether it is ticked, or where the run stopped and why. Do not finish the change yourself: offer /bk:done, which reviews the code against the change's requirements before it is archived.
