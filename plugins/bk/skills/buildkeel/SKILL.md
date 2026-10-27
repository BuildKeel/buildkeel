---
name: buildkeel
description: How to work in a repository set up with BuildKeel (it has a .buildkeel.yaml file). Use it when the user asks you to change code, before committing, when writing or running tests, when finishing a unit of work, and whenever you read or change requirements, designs, stories, tasks or test plans.
---

BuildKeel keeps requirements, tests and code connected. Follow these rules in any repository that has a `.buildkeel.yaml` file.

## Conversation comes first

Talk with the user as you would without BuildKeel, as a thinking partner, the way BuildKeel's session report describes: explain the options, trade-offs and pitfalls before you ask, ask in prose, recommend only what the evidence supports, and never push toward a plan or a BuildKeel step. Discussing ideas, weighing options, talking through architecture and reading code are free: leave BuildKeel's artifacts, stages, IDs and commands out of it.

BuildKeel comes in when the user runs a BuildKeel command, or when you are about to change a file (see "Before changing code"). Once that is done, the conversation is free again. Start a BuildKeel command only when the user types it, except /bk:status and /bk:stats, which you may run on your own.

## The spec tree

Read and change requirements, stories, tasks and test plans only through the BuildKeel tools: `query`, `get_context` and `get_template` to read, `save_draft` to write, `approve` only when the user confirms. Pass `workspace`, the absolute path of this project's folder, on every call to a BuildKeel tool. Never create or edit files in the spec tree yourself. Approved versions and records (`versions/`, `approvals/`, `completions/`, `repins/`) are never edited; to change an approved artifact, save the whole changed file with `save_draft`, which opens its next version. When BuildKeel reports suspects, offer to review them with /bk:impact; whether each is still valid or needs change is the user's decision.

Nothing goes into the spec tree unseen. Before you save anything to it, show what changes, in full, in your reply, and ask in plain text at its end, never inside your question tool. Agreement saves it; anything else is feedback: discuss it, then list each point with how it was addressed, show the final version, and save only once the user agrees. When work would change a document the user agreed, say which, what and why, and take it through the same review, one edit at a time. Never add, change or remove a requirement, criterion, scenario or task on your own initiative. Report each tick in a line; do not ask about ticks.

A team can rename the stages of its process and add stages of its own. When it has, BuildKeel's session report lists the stages as the team names them: use those names with the user, in each command's help, its questions and its output. A renamed stage is still that stage to BuildKeel (a "feature" is a user story), and the tools accept either name.

## Before changing code

Every code change belongs to the active unit of this working tree: a task, a story built without tasks, a bug or an ad-hoc unit. If there is none, before changing any file, ask the user how to go on, with your tool for asking a question with choices if you have one, recommending the choice that fits:

1. **Capture what we discussed**: the user runs /bk:capture, which turns the conversation into the artifacts the team's process needs, to approve and then build. You cannot start it yourself: if they choose it, ask them to run it, and change nothing until a unit is active. Recommend it when the conversation shaped new work.
2. **Start the unit it belongs to** with /bk:build <ID>, when the change is part of planned work.
3. **Record it as an ad-hoc unit** with a short title you propose, and start it as /bk:build does for a description: for a small change that belongs to no planned work.
4. **Go ahead without a unit.** Only the user can choose this: then call the BuildKeel `manage` tool with `action: "untracked"` first, and tell them the change will belong to no unit.

When the user reports a defect, or a test fails in work that was finished, offer to record a bug with /bk:new bug. Call `get_context` when you need the unit's requirements, design and test cases again.

Change files with your file editing tools, never through the shell (such as `sed -i`, `echo >` or `mv` over a file): BuildKeel checks each edit made with those tools, and an edit made around them escapes its checks.

If BuildKeel says a change is outside the areas the active unit relates to, tell the user: carry on if it belongs to the unit, and otherwise ask which unit it belongs to.

## Commits

End every commit message with the active unit's trailer, after a blank line:

```
Add the reset endpoint

BuildKeel-Unit: TK-047
```

If the message has other trailer lines, such as `Co-Authored-By`, keep them all in that last block with no blank line between them, so git reads them as trailers. Use the active unit's ID, never another unit's. Do not rewrite commits that are already made.

## Tests

When you write a test for a test case, put the test case's ID in square brackets in the test's name, such as `it("emails a reset link [US-012-TC3]", ...)`. A test may carry several IDs, one per bracket: `[US-012-TC3] [US-012-TC4]`; a bracket holding several tags nothing. The test cases that apply to the unit are in its context: its own plan's and its story's. A bug's regression test carries the bug's ID, such as `[BUG-005]`, and must fail without the fix.

A test written before BuildKeel may be matched to a test case instead of tagged; the unit's context lists those matches. When you change such a test, add its test case's ID to its name too; BuildKeel drops the match when the unit is finished.

Run the tests with a JUnit XML reporter, writing the report under `.buildkeel/` (git ignores it), and record each report with the BuildKeel `test_results` tool. For example:

- Vitest: `npx vitest run --reporter=default --reporter=junit --outputFile.junit=.buildkeel/junit.xml`
- Jest: `npx jest --reporters=default --reporters=jest-junit` with `JEST_JUNIT_OUTPUT_FILE=.buildkeel/junit.xml`
- pytest: `pytest --junitxml=.buildkeel/junit.xml`
- Node's test runner: `node --test --test-reporter=spec --test-reporter-destination=stdout --test-reporter=junit --test-reporter-destination=.buildkeel/junit.xml`
- Go: `gotestsum --junitfile .buildkeel/junit.xml`
- Maven and Gradle write JUnit XML already, under `target/surefire-reports/` and `build/test-results/`.

Results are local to this working tree. A result goes stale when the code or the test plan changes, so run the tests again after changing code.

## Finishing

When the unit's work is committed and its test cases pass, finish it with /bk:done. Before you push, open a pull request or merge while a unit is active, tell the user it is not finished and to run /bk:done before merging, then go ahead. Finishing writes a permanent completion record, so it is the user's decision: show what it will record and ask first.
