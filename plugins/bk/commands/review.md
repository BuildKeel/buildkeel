---
description: "BuildKeel: Review the work on a unit or change with fresh reviewers: spec compliance by ID, code quality, and tests that try to break it. The active unit by default."
argument-hint: "[an ID, or a range of commits], e.g. TK-001, CH-012 or main..HEAD; the active unit when left out"
disable-model-invocation: true
---

Review work with the user, by fresh reviewers who did not write it and do not see this conversation. A review changes no code: it finds, and the user decides what to do about each finding.

The user typed: $ARGUMENTS

**Before anything else**, call the BuildKeel `query` tool with `view: "process"`, and do not show its result. If it says this repository is not set up for BuildKeel, tell the user so, and that /bk:init sets it up, then stop: ask nothing else. Otherwise go on straight away.

## What to review

What the user typed decides it:

- **Nothing:** the active unit in this working tree, or in a Spec-driven tree the active change. With neither, ask straight away what to review, offering the units and changes with work on them, from `query` with `view: "status"`.
- **A unit's or change's ID**, such as TK-001 or CH-012: that unit or change, its own commits only.
- **A range of commits**, such as `main..HEAD`: those commits. A range belongs to no unit, so its review is shown and never recorded, and there is no spec to judge it against: only the quality reviewer and the break-it agent run.

## Review it

Say in a line what is reviewed: the unit or change, or the range, and how many commits. Then review it with `kind: "on-demand"`.

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

For a range, skip recording: show each reviewer's report as it is, and stop there.

## Show it

Show each reviewer's report in a few lines: the verdicts by ID, the findings by severity with their files and lines, the failing tests, the proposed additions, and the quality reviewer's verdict. Then say what you checked against the code for each High and Medium finding, and ask the user how to answer them, one at a time, with your recommendation first: fix it now, park it as a defect, or reject it with its evidence. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool.

Do not create or edit spec tree files yourself: the BuildKeel tools write every record.
