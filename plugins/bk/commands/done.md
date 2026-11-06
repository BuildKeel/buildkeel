---
description: "BuildKeel: Finish the active unit, or a story or epic once everything under it is done: check its tests pass, then write its completion record."
argument-hint: "[ID], e.g. TK-001, or US-001 for a story built through tasks; the active unit when left out"
disable-model-invocation: true
---

Finish a BuildKeel unit with the user. Finishing writes a permanent record of what was built, against which approved versions and with which test results, so it is the user's decision: never finish a unit they have not confirmed in this conversation.

The user typed: $ARGUMENTS

**Before anything else**, call the BuildKeel `query` tool with `view: "process"`, and do not show its result. If it says this repository is not set up for BuildKeel, tell the user so, and that /bk:init sets it up, then stop: ask nothing else. Otherwise go on straight away.

If BuildKeel's session report, or `query` with `view: "process"`, says this spec tree is Spec-driven, follow "In a Spec-driven tree" at the end for a change.

## Choose the unit

If the user named a unit above, use it.

If the user typed nothing, ask straight away: "What do you want to finish?" Offer the choices with your tool for asking a question with choices, if you have one, so the user can pick with the arrow keys and Enter:

1. **The active unit in this working tree** (the default, listed first).
2. **Another unit, or a story or epic whose work is all done: type its ID.** If they pick this, ask for the ID.

A story built through tasks, an epic, or a stage the team added above its stories, is never the active unit: it is finished once every unit under it is done and its own test cases pass, here or in the completion records of units finished in other repos.

## Check it

1. If the code changed since the tests last ran, run them again with a JUnit XML report (BuildKeel's instructions list the reporter for each test runner) and record the report with the BuildKeel `test_results` tool.
2. Draft the unit's working notes since the last checkpoint, and check them, as "Working notes" below says, steps 1 and 2; and draft what its context adds to them: departures from the plan (spec changes made while building included), known limitations, follow-ups with their IDs, and notes for the next person who touches the code, each from this conversation or the records, never invented.
3. Call the BuildKeel `finish_work` tool without `apply`, with `id` if the user named a unit, `notes` with the notes the checker supports, and `context` with what it adds (`departures`, `limitations`, `followUps`, `forNext`). It runs the done gate and writes nothing.
   - **A check on the tests not run yet:** when the result says the revert check, or mutation testing, has not run yet, run it first, once, without asking, then call `finish_work` without `apply` again. For the revert check: call `manage` with `action: "revert-check"`, run the unit's tagged tests in the worktree it prepares, from that directory, with a JUnit XML report written there (it links the dependencies the main checkout has installed: never install, update or remove a package through a link, and install in the worktree only where it says to), and record it with `test_results` and `purpose: "revert-check"`; when the tests cannot run there, remove the worktree with `remove: true` and say why. For mutation testing: run the command the result names, and record its report with `test_results` and `purpose: "mutation"`.
   - **Refused only because tests have no current result** (not run, or run before the code last changed): run the tests with a JUnit XML report, record it with `test_results`, and call `finish_work` without `apply` again. Do this once, without asking.
   - **Refused by the done gate** for anything else: show every failing check with its fix, as it is, and where each test case stands. Offer the fix that comes first: commit uncommitted changes (ending the message with `BuildKeel-Unit: <ID>`), write a test that is missing its tag, fix a failing test, or run the tests again. Do not finish anything else in its place.
   - **Not the active unit, or no active unit:** show the message and its fix.
   - **A story or epic refused because work under it is open:** show every open unit with its fix, and where each test case stands. Offer to start the first open unit with /bk:build.
   - **The final review not run yet:** when the result says the unit has no final review, review it now, before showing anything else, as "The final review" says, then call `finish_work` without `apply` again. It always runs, whatever the settings say of reviews after each task.
   - **Ready:** show what finishing will record: the commits, the files, each test case's result, the findings and how each was answered, the context part (decisions, those replaced, departures, dead ends, limitations, follow-ups and notes for the next person), and any test cases left for the story. For a story or epic: the units under it and where each test case passed.
   - **A standalone defect,** in a Spec-driven tree: the result names the requirements the files it changed implement. Ask which requirement to link it to, with your tool for asking a question with choices: **the requirement it suggests** (the default), then each other one it names, then **leave it standalone**. Pass the chosen requirement in `link` when you finish.

## The final review

Review the whole unit, or the whole change, with `kind: "final"`, as follows. In a Spec-driven tree, the reviewers judge the change's code against its requirements, scenarios and design.

A review is done by three fresh agents: the spec reviewer, the quality reviewer and the break-it agent. None of them is the agent that wrote the code, and none sees this conversation.

1. **The packages.** Call `review` with `action: "input"`, the `id` (and in a change, the `task` when one task is reviewed), and the `kind` of this review: `kind: "after-task"` in a run, `kind: "final"` at finishing, `kind: "on-demand"` when the user asks. It says which reviewers to start, and only those: each reviewer that is switched on, and at finishing only the commits since the last review, with one spec-compliance review of the whole change when its tasks were reviewed in a run. It writes each one's package, the diff and the reviewer's view, to a folder, and prepares the break-it agent's worktree when break-it runs. When it says nothing is to be reviewed, review nothing, and say so in a line, with why.
2. **The reviewers.** Call `query` with `view: "settings"`, if you have not in this conversation: it names the agent to start for each role, with the model and effort to pass on this host. Start the reviewers the input names: after a task, the spec reviewer and the quality reviewer; at finishing, the final spec reviewer and the final quality reviewer; and the break-it agent. Give each the folder the input names for it and nothing else, and the break-it agent its worktree too. They can run at the same time.
3. **Record each report as it is,** with `review`, `action: "record"`, the same `id` (and `task`), the `reviewer` (spec, quality or break-it), the `kind` of this review, and the report's lists: its verdicts, findings, proposed additions, what was done well and its verdict, or the break-it agent's failing tests. Never change a finding's severity or wording.
4. **When a reviewer cannot be started,** follow "When agents can't be started": review it here, as each reviewer's instructions would, and record each report with `by: "author"`. Say in a line that it was reviewed by the author, so it does not count as an independent review.
5. **Answer each finding.** Check it against the code first: never accept a finding only because a reviewer made it. Then answer it with `review`, `action: "answer"` and the `finding`'s ID:
   - **fixed,** with the `commit` that fixed it;
   - **parked,** once the user agrees to handle it later: record it as a defect found while building the unit with /bk:new defect (in Spec-driven mode, linked to the change), then answer with `parkedAs` set to its ID;
   - **rejected,** with the `evidence`: the code, a test or the spec that shows it is wrong. Show the user each finding you reject, with its evidence.

   A Low finding may stay open: name it at the end.
6. **The break-it agent's failing tests** count only through their test. For each, ask the user, recommending one: **a defect found while building** (record it as in "parked", with the test as its regression test) or **a question about the spec**, where the agreed behavior is what is wrong. Tests that pass are discarded, never committed.
7. **Proposed additions to the spec** are behavior the spec is silent on. Show them apart, never as a requirement not met: the user decides whether to add each, and an addition goes through the same review as any change to the spec.

**When agents can't be started,** the same everywhere:
1. **Say why, once,** in a line: you have no tool for starting agents here, it is turned off, or the model tier the settings name is not available.
2. **Retry once** when an agent started but failed, before treating agents as unavailable.
3. **Follow the step's switch:** off, nothing happens; ask, the offer says it would run here, without a fresh reader; auto, or a step with no switch (an implementer or a reviewer), do it here and say so in a line.
4. **Label what you did here** as done here, not by an independent agent: in what you show, and in the record (`by: "author"` for a review), and present a question or proposal as your own reading.
5. **Never count it where independence is the point:** a final review done here does not satisfy the review-findings check, so say the work was not independently reviewed.

A High or Medium finding still open is shown with the finish, which reports it: offer **Fix first** as the default. Fix it as the build's fix loop does, then preview again.

## A defect closed without a fix

When the unit is a defect, offer closing it without a fix beside finishing it, with your tool for asking a question with choices, whether or not it is started: **Finish <ID>** (the default when its regression test passes, or when the user has not said it is not one) or **Close without a fix**, for a defect that turns out not to be one (a duplicate, one that cannot be reproduced, behavior that works as intended, a test that was wrong, or a change in behavior: the code does what the spec says, and the spec is what must change; the default when the user says so). To close, ask for the reason with the same tool, then for a duplicate which defect it duplicates, for a change in behavior the change, version or item that takes it over (draft it first if there is none yet, such as a change, or a story's next version, with /bk:new), and for an optional note in the user's words. Call `finish_work` with `close` (`reason`, `duplicateOf`, `takenOverBy`, `note`) and without `apply`, show what it says with the defect's title, and ask the user to confirm. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Only when they confirm, call it again with `apply: true`. Never close a defect the user has not confirmed in this conversation. When the test was wrong, offer to correct the test case as a new version of its test plan.

## Confirm

Ask the user, the default first, with what the result said in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. The choices:

- If the result lists commits without a BuildKeel-Unit line, ask what to do with them:
  1. **Count them all as <ID> work and finish** (the default).
  2. **Choose which to leave out.** Then ask which ones, allowing several, and finish with those left out.
  3. **Stop, and do not finish yet.**
- Otherwise ask:
  1. **Finish <ID>** (the default).
  2. **Stop, and do not finish yet.**

Only when the user confirms, call `finish_work` again with `apply: true` (and the same `id` if you passed one), with `exclude` listing the IDs of any commits they left out, with `link` when they chose a requirement for a standalone defect, and with the same `notes` and `context` as the preview. If it is refused because the preview was not seen or something changed since, call it again without `apply`, show the new result, and ask again.

### Working notes

Finishing is a checkpoint.

**Working notes.** At this checkpoint, draft the working notes since the last checkpoint or pause: what the work learned that the code and the spec do not say. Each is one of these: a decision and why (with `replaces` naming an earlier decision it replaces), a constraint or pitfall, a dead end (what was tried, and why it failed), an open question, or the next step. Rulings are kept already. Give each its source: the user's own words, copied exactly, as `quote`; a `file` and `line`; or a `record`, such as a requirement, a finding or a commit. Never record an inference about a person, such as what they seem to prefer. With nothing new to note, leave notes out.
1. **BuildKeel's check:** call `save_draft` with `type: "working-notes"`, the unit's or change's `id` and the `notes`, without `apply`. It says which pass, and drops the rest with the reason.
2. **The note checker:** give it the notes that passed in one batch, with their sources and nothing else, started in the note checker role as `query` with `view: "settings"` names it. When it cannot be started, follow "When agents can't be started": check each yourself as the checker would, and say the notes were checked here. Keep only the notes it supports, and tell the user each one dropped, with why.
3. **Keep them** as this step says. At a checkpoint, the result lists what was kept: show that list in the same reply, without asking first; the user may ask to correct or drop any of it. A pause shows them first, and keeps them once the user agrees.

## Afterwards

Show the result as it is: the completion record, the commit in the spec repo, and whether it was pushed. Remind the user to push the unit's branch and open a pull request as usual, and to push the spec repo when the record is not pushed. If test cases were left for the story, name them: the story cannot be finished until they pass.

If the result names the next unit ready under the same parent, offer to start it, with your tool for asking a question with choices: **Start <ID>** (the default), or **Not now**. If the user agrees, call `start_work` with its `id` and `stack: true`, so its branch starts from this unit's branch and has this work before it is merged, and carry on as /bk:build does. Otherwise call `query` with `view: "startable"`, show what can be started next, and offer to build it with /bk:build.

Do not create or edit spec tree files yourself: `finish_work` writes the record, and completion records are never edited.

## In a Spec-driven tree

A change is finished by archiving it, and need not be the active unit. With none named and none active, `finish_work` lists the open changes: ask which to finish, allowing several, those with every task ticked first. Call `finish_work` without `apply` (with `ids` for several; for one change, with `notes` and `context` drafted as "Check it" step 2 says) and follow its result step by step:

1. **Checks on the tests.** When the result says the revert check, or mutation testing, has not run yet, run it first, once, without asking, as "Check it" says above, then preview again.
2. **Unticked tasks first.** When it lists unticked tasks, check each against the code and the test results before showing anything else. Say in a line each which now pass their verification, and offer to tick them. Tick those the user agrees to with `save_draft`, `type: "tasks"`, the change's `id` and `tick`, then preview again.
3. **The final review, and show.** Review the change as "The final review" says, if it has no final review yet. Then show each requirement and scenario as met, partly met or not met with its evidence, the findings with how each was answered, and the break-it agent's failing tests. In the same reply, show what finishing will write, as the result gives it: its context part, the capability specs after the merge, with the requirements the change adds or modifies in full and the others by name.
4. **Ask.** End that reply with the choice, in plain text: **Fix first** or **Finish anyway**, fix first being the default when a High or Medium finding is open or anything is reported missing. When your review finds a gap where the code is right and the spec is not, also offer **Reword the spec, then finish**. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Nothing blocks the finish but uncommitted work.
   - **Fix first:** help fix it.
   - **Reword the spec:** show the requirement's new text in full, with why, and save it only once the user agrees, with `save_draft`, `type: "spec-change"`, the change's `id`, its `capability` and `requirement`.
   - After any commit or change, call `finish_work` without `apply` again, and ask on the new preview, never on the old one.
5. **Finish.** Call `finish_work` with `apply: true` as the result says, with `review` holding a line per change that sums up the final review as you showed it, and, when one change is finished, the same `notes` and `context` as its preview, as "Check it" and "Working notes" above say: its context part is shown in the preview and kept with its archive. When the change was finished anyway with tasks or gaps left open, the result lists them: offer a follow-up change holding them. If the user agrees, draft it as /bk:capture drafts a change, from its proposal, through the review; if not, they stay recorded with the archived change.

Defects and ad-hoc units finish as above.
