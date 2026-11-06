---
description: "BuildKeel: Start a unit and build it: a task, story, defect or change by its ID, the ready units under a parent, or a small change described in words."
argument-hint: "[an ID, a parent's ID, or what to change in words], e.g. TK-001, US-001, or \"fix the footer link\""
disable-model-invocation: true
---

Start a BuildKeel unit and build it with the user. Every code change belongs to exactly one unit, and the unit's context tells you what to build. Starting checks the unit is ready, switches to its branch and loads its context; the user then chooses how far to go: build everything, each task in a fresh agent or here, the next one only, or set it up and work together.

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
  2. **Show what can be started** (the default when there is no active unit). Call `query` with `view: "startable"` and show its result as it is. Then ask which to build: paused ones first, when it lists any (building one resumes it), then the ready ones with the one you recommend first, and, in Full SDLC, **Everything that is ready** as a choice too. If nothing is ready, say what is in the way and suggest the next step, such as approving with /bk:approve, and stop.
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
- **Paused by someone else, or on another machine:** the result says whose work it was and when it was paused. Ask the user to confirm taking it over, in their words, such as "Take over Priya's work on TK-013, paused two hours ago?" Only once they confirm, call `start_work` again with `takeOver: true`. If they decline, start nothing.
- **Started:** tell the user the branch and anything it warned about, such as a spec tree that is behind its remote. When it resumed a paused unit or change, show its brief first: where things stand, the decisions and dead ends, the open questions, the next step, and any files left uncommitted on another machine; then go on from the next step.

Keep the context in mind for the rest of the work, and call `get_context` again if you lose track of it. Do not create or edit spec tree files yourself.

## Build a single unit

Sum up the context: what to build, the acceptance criteria and the test cases, by ID. Then ask how to go on, with that summary in the same reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. The choices:

1. **Build it** (the default).
2. **Set it up and work together**: build nothing yet; ask the user how to begin.

If the user asks for it to be built in a fresh agent, build it as "Building in fresh agents" says, as a run of one.

To build it, test first: write the tests for its test cases, each test named with its test case ID in square brackets, one ID per bracket; run them with a JUnit XML report and record it with the BuildKeel `test_results` tool, so their failing run is recorded as their red run; commit the tests on their own; then write the code, run the tests again and record the report. A test that cannot fail first, such as one describing existing behavior, needs an exception with its reason, recorded with `test_results`. Commit as you go, each message ending with `BuildKeel-Unit: <ID>`, and change files only with your file editing tools. The run stops to ask, as "When a run stops" says. When the work is committed and its test cases pass, tell the user they can finish it with /bk:done; do not finish it yourself.

## Build what is ready under a parent

Each unit still goes through its own start gate, gets its own branch, commits and completion record, and is tested before it is finished.

Call the BuildKeel `query` tool with `view: "startable"`. Take the units ready to start, at the lowest level: tasks, and stories that have no tasks (with a parent named, only those under it). Leave out defects and ad-hoc units unless the user asks for them.

If nothing is ready, show what is waiting and why, as `query` gave it, suggest the next step (such as approving with /bk:approve), and stop.

Otherwise call `query` with `view: "run"` and the parent's `id`. It gives the order to build the tasks in, each after the tasks it uses, and checks what each uses. If it says the tasks depend on each other in a loop, stop before the run: show it as it is and ask the user how to go on. Build in its order; a story with no tasks comes where its ID puts it.

Show the list in order, and say how the run goes: each unit is started, built, reviewed, tested and finished in turn; each gets its own branch, stacked on the one before so later units build on the earlier ones' code; and the run stops to ask when a gate refuses, something a task uses is missing, a test fails and cannot be fixed, a review finds something serious, or a requirement is unclear. Then ask, with the list and how the run goes in that same reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. The choices, the default first. `query` with `view: "run"` names which of the first two comes first, by the team's default way to build: put that one first, and the other second.

1. **Build them all, each in a fresh agent**: you control the run, as "Building in fresh agents" says. When this session cannot start agents, put building here first instead, and say why, such as that you have no tool for starting agents, or that it is turned off.
2. **Build them all here,** in this conversation. Each is still reviewed by fresh reviewers when this session can start them.
3. **Build the next one only**: the first is built, reviewed, tested and finished (or ticked), in a fresh agent when this session can start agents, then the run stops and names the next.
4. **Set it up and work together**: start it, build nothing, and ask the user how to begin.

When `query` with `view: "run"` says some tasks can be built at the same time, and this session can start agents, add a choice after the first: **Build the independent ones at the same time**, naming the batches it gives, each task in a fresh agent in its own worktree, as "Parallel runs" says. If you expect two of them to change the same file, say so, and that a conflict stops the run for the user to decide, with resolving it here as one choice: never present it as a reason the run would fail.

Any other answer, such as a change to the list, is taken in, and the list is shown again.

For each unit, in order:

1. **Start it.** Call `start_work` with its `id` and `run: true`; from the second unit on, also pass `stack: true`, so its branch starts from the branch of the unit just finished. If the start is refused, or there are uncommitted changes, stop the run: show the result as it is and ask the user how to go on.
2. **Build it.** Call `query` with `view: "run"` and the parent's `id` again: if it says the unit cannot start because something it uses is missing, stop the run, name what is missing, and ask the user how to go on. In fresh agents, build it as "Building in fresh agents" says, then go on to step 3. Here, work from the context `start_work` returned: the unit, its requirements, its design, and its test cases. Write the tests for its test cases first, each test named with its test case ID in square brackets, one ID per bracket: run them and record the report with `test_results`, so their failing run is recorded as their red run, and commit them on their own; then write the code. A test that cannot fail first needs an exception with its reason, recorded with `test_results`. Commit as you go, each message ending with `BuildKeel-Unit: <ID>`, and change files only with your file editing tools. When a task needs a test case its own test plan does not have, the plan the user agreed changes: show the test case you would add, with its `covers` line and why it is needed, and ask before saving it. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Once the user agrees, add it with `{{new}}` for its number and save the whole plan with `save_draft` and the plan's `id`: unless the result says the plan waits for approval, it is recorded at once as its next version, and the run goes on.
3. **Test it.** Run the tests with a JUnit XML report and record it with the BuildKeel `test_results` tool. When a test fails, fix the code or the test and run them again.
4. **Review it,** as "Reviews after each task" says.
5. **Finish it.** Call `finish_work` without `apply`. If it says the tests have no current result, run them again and record them, once. If it says the revert check has not run yet, run it, once: call `manage` with `action: "revert-check"`, run the unit's tagged tests in the worktree it prepares, from that directory, with a JUnit XML report written there (it links the dependencies the main checkout has installed: never install, update or remove a package through a link, and install in the worktree only where it says to), and record it with `test_results` and `purpose: "revert-check"`; likewise run mutation testing when it says so, and record its report with `purpose: "mutation"`. Then call `finish_work` without `apply` again. The task's review after it was built counts as its final review when it covers its latest commit, so a task the run reviewed needs no other. If it is refused for any other reason, or lists commits without a `BuildKeel-Unit` line, stop the run and show it. Otherwise call `finish_work` with `apply: true`, with `notes` holding the unit's working notes, as "Working notes at checkpoints" says: the user's choice to build covers finishing each unit that passes its done gate.
6. Say in a line what was finished: the unit, its commits, its test cases passing, and its completion record. Then go on to the next unit.

At the end, show a table of the run: each unit, its branch, its commits, how it was built (a fresh agent or here), and its completion record, or where the run stopped and why. The last branch holds the whole run: say that one pull request from it reviews all of it, or that each branch can have its own pull request, each based on the previous one and merged in order. If the completion records are not pushed, remind the user to push the spec repo.

## Building in fresh agents

This session can start agents when you have a tool for starting agents and it is not turned off. You control the run: you start each agent yourself, take its status, have its task reviewed, and finish each unit (Full SDLC) or tick each task (Spec-driven). The agents never finish, tick or approve anything.

Call `query` with `view: "settings"` once, before the first agent: its part "To start BuildKeel's agents here" names the agent to start for each role, with the model and effort to pass on this host. Start each agent exactly so. The user installs or turns on nothing: BuildKeel ships its agents.

For each task:

1. **Its view.** Call `get_context` with `role: "implementer"` and the unit's `id`; in a change, also its `task` number. It holds the task's context, what the tasks before it built, and the working notes and rulings.
2. **Start the implementer** with that view as it is: it holds every ruling saved so far. Give it nothing else: not the whole plan and not this conversation. If the agent fails to start, stop the run, say so with the reason, and offer to go on here (the default).
3. **Take its status.** It ends with one of these:
   - **finished:** go on to the review.
   - **finished with concerns:** show the concerns in a line each. A concern about what was agreed stops the run, as "Behavior that looks wrong" says; otherwise go on to the review, and name them again at the end of the run.
   - **has a question:** answer it as "Rulings" says, then continue the agent with the answer, or, if you cannot continue it, start the task's implementer again with its view and the ruling.
   - **blocked:** stop the run, show the reason, and ask the user how to go on.
4. **Check its work** before the review: its commits carry the unit's line (and in a change, the task's), and its test runs are recorded. Call `test_results` with no report: if the task's tests have no current passing result, run them and record the report yourself, once.

A run in fresh agents goes from records, not from memory: the ticks, completion records, test runs, rulings and commits. When a run is stopped or the conversation is compacted, /bk:build on the same parent or change goes on from the first unit not finished or task not ticked.

## Parallel runs

Only in Full SDLC, only in fresh agents, and only for the batches `query` with `view: "run"` gives. Batch by batch:

1. **A worktree for each task.** Call `manage` with `action: "worktree"`, the task's `id`, and `from` set to the run's branch `bk/run-<parent ID>` once it exists, otherwise leave `from` out. It adds the task's own worktree and starts the task there, on its own branch. If it cannot, stop the run and show why.
2. **Its agents, at the same time.** Start each task's implementer as "Building in fresh agents" says, all of the batch at once, each with its view from `get_context` called with `workspace` set to its worktree. Tell each agent its folder: it works only there, and passes it as `workspace` to every BuildKeel tool.
3. **Each on its own branch.** As each reports, review it as "Reviews after each task" says, with its reviewer view from its worktree, and finish it with `finish_work`, `workspace` set to its worktree, as step 5 of the run says. Then remove its worktree with `manage`, `action: "worktree"`, its `id` and `remove: true`.
4. **Together.** Once the batch is finished, call `manage` with `action: "merge"`, the parent's `id`, and `ids` with the batch's tasks in task order. Show in a line each what it reports: a file two tasks changed, or a file outside a task's Files. Then call it with `apply: true` once per task: each merges one branch onto `bk/run-<parent ID>`. After each, run the tests and record the report with `test_results`. A conflict, or a failing test you cannot fix, stops the run, to ask the user how to go on. When the user says to resolve a conflict here, call `manage` with `action: "merge"`, the same `id` and `ids`, `apply: true` and `resolve: true`: the merge is left open. Edit only the files it names, keeping what each task meant, and commit nothing yourself; then call it with `apply: true` again, which commits the merge once nothing is left in conflict, and run the tests.

Then go on with the next batch, from the run's branch. At the end, `bk/run-<parent ID>` holds the whole run: one pull request from it reviews it all.

## Rulings

When an implementer asks a question, look for the answer first, in this order: the spec (the task's context, its story or change, and the requirements it names), the working notes and rulings in its view, and, when the tree has them, the glossary and the team's practices.

- **The answer is there:** answer with it and name where it comes from, such as "US-004-AC2 says the link expires after 30 minutes". Say the ruling to the user in a line.
- **Nothing answers it:** stop the run and ask the user, as for an unclear requirement: one question, with your recommendation. Never guess a requirement, and never let the agent guess one. The user's answer is the ruling.

Save each ruling at once as a working note on the unit or change, so that each later implementer's view holds it: call `save_draft` with `type: "working-notes"`, `apply: true`, the unit's or change's `id`, and one note with `kind: "ruling"`, the ruling as `text`, and its source: `record` with the ID it comes from (such as `US-004-AC2`), `file` and `line`, or `quote` with the user's answer word for word. If the result says it was dropped, tell the user why in a line, and give the ruling to the implementer anyway.

## Reviews after each task

Each task is reviewed once it is built, whether it was built in a fresh agent or here, unless `query` with `view: "settings"` says reviews after each task are off. Review it as follows, with `kind: "after-task"`, and in a change with its `task` number.

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

**The fix loop.** An open High or Medium finding stops the task until each one is answered. To fix one, give the findings, with their files and lines, to the task's implementer: continue the agent if you can, or start it again with its view and the findings. Then review the fix again, from step 1. A fix and its review are one round. Answer each finding the fix cleared as fixed, with its commit.

**Principal handoff.** When the fix rounds the settings give (2 by default; "Principal handoff" in `query` with `view: "settings"`) leave a finding open:
- **When the settings name a handoff tier,** run one more round: start the implementer as "Principal handoff's round" in the settings says, with its model and effort, the finding, and what each round tried and why its review rejected it. Have the reviewers that are on review that fix, as for any round.
- **When it clears the finding,** answer it as fixed, with its commit, and go on.
- **When it leaves the finding open too, or no handoff tier is set,** stop the run. Record a failed handoff with `review`, `action: "handoff"`, the `finding`, the `task` in a change, the `tier`, `tried` (each round before it: what it tried and why its review rejected it) and `principal` (its own attempt and why it was rejected); with no tier set, record nothing. Then show the whole story: the finding, each fix tried and why it was rejected, and the principal's attempt. Ask how to go on, recommending one: **Fix it together here**, **Park it** (as a defect or follow-up; the task stays not done in this run), or **Reject the finding** with its evidence. While the finding is open, the task is never ticked or finished, whatever the gate modes say: BuildKeel refuses it.

Never go on to the next task while a High or Medium finding on this one is open.

## When a run stops

A run stops and asks the user:

- when a gate refuses: show the result as it is;
- when something a task uses is missing: name it, and say what `query` with `view: "run"` found;
- when an agent fails to start, or reports that it is blocked;
- when merging a parallel run's branches conflicts, or the tests fail after a merge;
- when a High or Medium finding is still open after the fix loop's rounds;
- when a test fails and still fails after a real attempt to fix it: name the failing test case and what you tried, and ask how to go on;
- when a requirement is unclear (two readings, a missing case, a conflict with the code): ask one question, with your recommendation. Never guess a requirement;
- when agreed behavior looks wrong, as "Behavior that looks wrong" says.

A run that stops is a checkpoint: before you ask, keep its working notes, as "Working notes at checkpoints" says, with `save_draft`, `type: "working-notes"`, `apply: true`, `at: "run-stopped"`, and `standing` saying in a sentence where the run stopped and why.

## Working notes at checkpoints

Finishing a unit, ticking a task, and a run that stops are checkpoints, in both modes and whether the work was built in fresh agents or here.

**Working notes.** At this checkpoint, draft the working notes since the last checkpoint or pause: what the work learned that the code and the spec do not say. Each is one of these: a decision and why (with `replaces` naming an earlier decision it replaces), a constraint or pitfall, a dead end (what was tried, and why it failed), an open question, or the next step. Rulings are kept already. Give each its source: the user's own words, copied exactly, as `quote`; a `file` and `line`; or a `record`, such as a requirement, a finding or a commit. Never record an inference about a person, such as what they seem to prefer. With nothing new to note, leave notes out.
1. **BuildKeel's check:** call `save_draft` with `type: "working-notes"`, the unit's or change's `id` and the `notes`, without `apply`. It says which pass, and drops the rest with the reason.
2. **The note checker:** give it the notes that passed in one batch, with their sources and nothing else, started in the note checker role as `query` with `view: "settings"` names it. When it cannot be started, follow "When agents can't be started": check each yourself as the checker would, and say the notes were checked here. Keep only the notes it supports, and tell the user each one dropped, with why.
3. **Keep them** as this step says. At a checkpoint, the result lists what was kept: show that list in the same reply, without asking first; the user may ask to correct or drop any of it. A pause shows them first, and keeps them once the user agrees.

Do not create or edit spec tree files yourself: the BuildKeel tools write every record.

## Behavior that looks wrong

When what was agreed looks wrong while you build (a requirement, an acceptance criterion or a test case), stop and ask, whether or not the build started with this command: name it by ID, and say why it looks wrong. Offer **Keep it as agreed** and **Change it**, your recommendation first. Never build something else, and never edit the spec, without the answer.

- **Kept:** build it as agreed, and do not raise it again in this build.
- **Changed:** change the spec first. Save the whole changed story (or task) with `save_draft`, which opens its next version, and show it as any draft. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Then call the BuildKeel `impact` tool with its `id`: the preview names what the new version would make suspect, such as tasks and test plans. Draft the next version of each that must change too, and offer the set for approval with /bk:approve. Build nothing more on the unit until the set is approved; when the start gate is set to warn and the user says to carry on, go on, saying that you build against versions not yet approved. Once the set is approved, the unit is suspect: with the user's agreement, record that it now builds against the new versions with `resolve_suspect` (`decision: "still-valid"`), and go on against them.
- **In code nothing describes yet** (`query` with `view: "describes"` finds no artifact): draft its version 0 first, describing the code as it is, as /bk:new does, then the change on top of it.

## In a Spec-driven tree

The units are open changes, defects and ad-hoc units, and no gate runs. Defects and ad-hoc units are built as "Build a single unit" says. A change is built task by task, in order, on the change's branch:

1. **The change.** Start it as "Start it" says, unless it is already active: `start_work` starts it, or says which working tree on this machine already holds it. If nothing can be started, suggest drafting a change with /bk:capture.
2. **Choose how to build.** Sum up the change in a few lines, with its title: what the proposal changes, and the requirements it adds, modifies or removes by ID. Call `query` with `view: "run"` and the change's `id`: if it says the tasks depend on each other in a loop, stop before the run, show it as it is, and ask the user how to go on. Show its unticked tasks in order, each with how it is verified, and say how the run goes: each task is built, reviewed, tested and ticked in turn, and the run stops to ask when something a task uses is missing, a test fails and cannot be fixed, a review finds something serious, a requirement is unclear, or what was agreed would change. Then ask, with the list in that same reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool.

   The choices, the default first. `query` with `view: "run"` names which of the first two comes first, by the team's default way to build: put that one first, and the other second.

   1. **Build them all, each in a fresh agent**: you control the run, as "Building in fresh agents" says. When this session cannot start agents, put building here first instead, and say why, such as that you have no tool for starting agents, or that it is turned off.
   2. **Build them all here,** in this conversation. Each is still reviewed by fresh reviewers when this session can start them.
   3. **Build the next one only**: the first is built, reviewed, tested and finished (or ticked), in a fresh agent when this session can start agents, then the run stops and names the next.
   4. **Set it up and work together**: start it, build nothing, and ask the user how to begin.

   When every task is ticked already, say so instead, and that the user can run /bk:done to finish the change.
3. **Each task in turn, test first.** Before each task, call `query` with `view: "run"` and the change's `id` again: if it says the next task cannot start because something it uses is missing, stop, name what is missing, and ask the user how to go on. In fresh agents, build it as "Building in fresh agents" says, have it reviewed as "Reviews after each task" says, then tick it as below. Here, write its tests first, each test named with the scenario ID it checks in square brackets, one ID per bracket, such as `[AUTH-R3-S1]`; run them with a JUnit XML report and record it with `test_results`, so their failing run is recorded as their red run, and commit them on their own. Then write the code, run the tests again and record the report. A test that cannot fail first needs an exception with its reason, recorded with `test_results`. Commit as you go, each message ending with `BuildKeel-Unit: <change ID>`, and add `BuildKeel-Task: <task number>` on the next line when a commit does exactly that one task. Once the task's stated verification passes, have it reviewed as "Reviews after each task" says, then tick it with `save_draft`, `type: "tasks"`, the change's `id`, `tick` set to its number, such as `["2.3"]`, and `notes` with the working notes since the last tick, as "Working notes at checkpoints" says, and say so in a line, with the progress the result gives. Never ask before ticking. A failing test you cannot fix, or an unclear requirement, stops the run, as "When a run stops" says.
   - **Behavior that looks wrong** stops the run too: name the requirement or scenario and why, and ask **Keep it as agreed** or **Change it**, your recommendation first. Kept: build it as agreed. Changed: a requirement of this change's own spec change is edited in place, as the next point says, with the follow-on edits to the proposal, design and tasks. A requirement as an archived change left it is changed through this change, with a spec change modifying it (the default), or through a separate change drafted with /bk:capture, as the user prefers. In code nothing describes yet, document it first as version 0 of a capability spec, then change it.
   - **A change to what was agreed** stops the run too: a requirement or scenario to add, change or drop, a task's wording, or a task to add or remove. Say which file, what changes and why, show the change in full, and ask. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Before adding a requirement to a change with more than half its tasks ticked, ask once first whether it belongs in this change or a new one, and draft nothing until the user answers. Save it only once the user agrees, then go on: one requirement with `save_draft`, `type: "spec-change"`, the change's `id`, its `capability` and `requirement` (`id` and `content` to replace it, `section` and `content` to add one, `id` and `drop` to take one out); a task list's wording as the whole file. Never change the spec on your own initiative, not even to make your own check pass.
4. **At the end**, show each task with its commits and whether it is ticked, or where the run stopped and why. When the last tick's result says every task is done, pass on that the user can run /bk:done to finish the change. Do not finish the change yourself: /bk:done reviews the code against the change's requirements before it is archived.
