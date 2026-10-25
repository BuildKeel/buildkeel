---
description: "BuildKeel: Finish the active unit, or a story or epic once everything under it is done: check its tests pass, then write its completion record."
argument-hint: "[ID], e.g. TK-001, or US-001 for a story built through tasks; the active unit when left out"
disable-model-invocation: true
---

Finish a BuildKeel unit with the user. Finishing writes a permanent record of what was built, against which approved versions and with which test results, so it is the user's decision: never finish a unit they have not confirmed in this conversation.

The user typed: $ARGUMENTS

If BuildKeel's session report, or `query` with `view: "process"`, says this spec tree is Spec-driven, follow "In a Spec-driven tree" at the end for a change.

## Choose the unit

If the user named a unit above, use it.

If the user typed nothing, ask straight away, before calling any tool: "What do you want to finish?" Offer the choices with your tool for asking a question with choices, if you have one, so the user can pick with the arrow keys and Enter:

1. **The active unit in this working tree** (the default, listed first).
2. **Another unit, or a story or epic whose work is all done: type its ID.** If they pick this, ask for the ID.

A story built through tasks, an epic, or a stage the team added above its stories, is never the active unit: it is finished once every unit under it is done and its own test cases pass, here or in the completion records of units finished in other repos.

## Check it

1. If the code changed since the tests last ran, run them again with a JUnit XML report (BuildKeel's instructions list the reporter for each test runner) and record the report with the BuildKeel `test_results` tool.
2. Call the BuildKeel `finish_work` tool without `apply`, with `id` if the user named a unit. It runs the done gate and writes nothing.
   - **Refused only because tests have no current result** (not run, or run before the code last changed): run the tests with a JUnit XML report, record it with `test_results`, and call `finish_work` without `apply` again. Do this once, without asking.
   - **Refused by the done gate** for anything else: show every failing check with its fix, as it is, and where each test case stands. Offer the fix that comes first: commit uncommitted changes (ending the message with `BuildKeel-Unit: <ID>`), write a test that is missing its tag, fix a failing test, or run the tests again. Do not finish anything else in its place.
   - **Not the active unit, or no active unit:** show the message and its fix.
   - **A story or epic refused because work under it is open:** show every open unit with its fix, and where each test case stands. Offer to start the first open unit with /bk:start.
   - **Ready:** show what finishing will record: the commits, the files, each test case's result, and any test cases left for the story. For a story or epic: the units under it and where each test case passed.
   - **A standalone bug:** the result also says which stories its changes belong to. Ask where to attach it, with your tool for asking a question with choices: **the story it suggests** (the default), then each task it names, then **leave it standalone**. Pass the chosen ID in `attach` when you finish.

## A bug that is not a defect

When the unit is a bug, offer closing it without a fix beside finishing it, with your tool for asking a question with choices, whether or not it is started: **Finish <ID>** (the default when its regression test passes, or when the user has not said it is not a defect) or **Close without a fix**, for a bug that turns out not to be a defect (a duplicate, one that cannot be reproduced, behavior that works as intended, or a test that was wrong; the default when the user says so). To close, ask for the reason with the same tool, then for a duplicate which bug it duplicates, and for an optional note in the user's words. Call `finish_work` with `close` (`reason`, `duplicateOf`, `note`) and without `apply`, show what it says with the bug's title, and ask the user to confirm. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. Only when they confirm, call it again with `apply: true`. Never close a bug the user has not confirmed in this conversation. When the test was wrong, offer to correct the test case as a new version of its test plan.

## Confirm

Ask the user with your tool for asking a question with choices, the default first, showing what the result said. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. The choices:

- If the result lists commits without a BuildKeel-Unit line, ask what to do with them:
  1. **Count them all as <ID> work and finish** (the default).
  2. **Choose which to leave out.** Then ask which ones, allowing several, and finish with those left out.
  3. **Stop, and do not finish yet.**
- Otherwise ask:
  1. **Finish <ID>** (the default).
  2. **Stop, and do not finish yet.**

Only when the user confirms, call `finish_work` again with `apply: true` (and the same `id` if you passed one), with `exclude` listing the IDs of any commits they left out, and with `attach` when they chose where to attach a standalone bug.

## Afterwards

Show the result as it is: the completion record, the commit in the spec repo, and whether it was pushed. Remind the user to push the unit's branch and open a pull request as usual, and to push the spec repo when the record is not pushed. If test cases were left for the story, name them: the story cannot be finished until they pass.

If the result names the next unit ready under the same parent, offer to start it, with your tool for asking a question with choices: **Start <ID>** (the default), or **Not now**. If the user agrees, call `start_work` with its `id` and `stack: true`, so its branch starts from this unit's branch and has this work before it is merged, and carry on as /bk:start does. Otherwise call `query` with `view: "startable"`, show what can be started next, and offer to start it with /bk:start, or to build everything ready with /bk:build.

Do not create or edit spec tree files yourself: `finish_work` writes the record, and completion records are never edited.

## In a Spec-driven tree

A change is finished by archiving it, and need not be the active unit. With none named and none active, `finish_work` lists the open changes: ask which to finish, allowing several, those with every task ticked first. Call `finish_work` without `apply` (with `ids` for several) and follow its result step by step: review the code against the change, report it labeled as your judgment, and ask **Fix first** or **Finish anyway**, fix first being the default when anything is reported missing. Nothing blocks the finish but uncommitted work. Bugs and ad-hoc units finish as above.
