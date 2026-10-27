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
   - **A story or epic refused because work under it is open:** show every open unit with its fix, and where each test case stands. Offer to start the first open unit with /bk:build.
   - **Ready:** show what finishing will record: the commits, the files, each test case's result, and any test cases left for the story. For a story or epic: the units under it and where each test case passed.
   - **A standalone bug:** the result also says which stories its changes belong to. Ask where to attach it, with your tool for asking a question with choices: **the story it suggests** (the default), then each task it names, then **leave it standalone**. Pass the chosen ID in `attach` when you finish.

## A bug that is not a defect

When the unit is a bug, offer closing it without a fix beside finishing it, with your tool for asking a question with choices, whether or not it is started: **Finish <ID>** (the default when its regression test passes, or when the user has not said it is not a defect) or **Close without a fix**, for a bug that turns out not to be a defect (a duplicate, one that cannot be reproduced, behavior that works as intended, or a test that was wrong; the default when the user says so). To close, ask for the reason with the same tool, then for a duplicate which bug it duplicates, and for an optional note in the user's words. Call `finish_work` with `close` (`reason`, `duplicateOf`, `note`) and without `apply`, show what it says with the bug's title, and ask the user to confirm. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Only when they confirm, call it again with `apply: true`. Never close a bug the user has not confirmed in this conversation. When the test was wrong, offer to correct the test case as a new version of its test plan.

## Confirm

Ask the user, the default first, with what the result said in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. The choices:

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

If the result names the next unit ready under the same parent, offer to start it, with your tool for asking a question with choices: **Start <ID>** (the default), or **Not now**. If the user agrees, call `start_work` with its `id` and `stack: true`, so its branch starts from this unit's branch and has this work before it is merged, and carry on as /bk:build does. Otherwise call `query` with `view: "startable"`, show what can be started next, and offer to build it with /bk:build.

Do not create or edit spec tree files yourself: `finish_work` writes the record, and completion records are never edited.

## In a Spec-driven tree

A change is finished by archiving it, and need not be the active unit. With none named and none active, `finish_work` lists the open changes: ask which to finish, allowing several, those with every task ticked first. Call `finish_work` without `apply` (with `ids` for several) and follow its result step by step:

1. **Unticked tasks first.** When it lists unticked tasks, check each against the code and the test results before showing anything else. Say in a line each which now pass their verification, and offer to tick them. Tick those the user agrees to with `save_draft`, `type: "tasks"`, the change's `id` and `tick`, then preview again.
2. **Review and show.** Review the code against the change, and report it labeled as your judgment. In the same reply, show what finishing will write, as the result gives it: the capability specs after the merge, with the requirements the change adds or modifies in full and the others by name.
3. **Ask.** End that reply with the choice, in plain text: **Fix first** or **Finish anyway**, fix first being the default when anything is reported missing. When your review finds a gap where the code is right and the spec is not, also offer **Reword the spec, then finish**. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Nothing blocks the finish but uncommitted work.
   - **Fix first:** help fix it.
   - **Reword the spec:** show the requirement's new text in full, with why, and save it only once the user agrees, with `save_draft`, `type: "spec-change"`, the change's `id`, its `capability` and `requirement`.
   - After any commit or change, call `finish_work` without `apply` again, and ask on the new preview, never on the old one.
4. **Finish.** Call `finish_work` with `apply: true` as the result says. When the change was finished anyway with tasks or gaps left open, the result lists them: offer a follow-up change holding them. If the user agrees, draft it as /bk:capture drafts a change, from its proposal, through the review; if not, they stay recorded with the archived change.

Bugs and ad-hoc units finish as above.
