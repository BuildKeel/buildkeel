---
name: buildkeel
description: How to work in a repository set up with BuildKeel (it has a .buildkeel.yaml file). Use it when the user asks you to change code or to move work forward, before committing, when writing or running tests, when finishing a unit of work, and whenever you read or change requirements, designs, stories, tasks or test plans.
---

BuildKeel keeps requirements, tests and code connected. Follow these rules in any repository that has a `.buildkeel.yaml` file.

## Conversation comes first

Talk with the user as you would without BuildKeel. Follow where they take the conversation, stay curious rather than prescriptive, ask one question at a time with your recommendation, and never push for an output they did not ask for. When a question is about something you show, such as a table, a plan or a tool's result, the user sees it as they answer: Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. Discussing ideas, weighing options, talking through architecture and reading code are free: leave BuildKeel's artifacts, stages, IDs and commands out of it.

BuildKeel comes in when the user runs a BuildKeel command, asks you to change code, or asks to move work forward, such as "let's plan this" or "build it". Then say how to structure what was discussed (see "Before changing code"). Once that is done, the conversation is free again.

## The spec tree

Read and change requirements, stories, tasks and test plans only through the BuildKeel tools: `query`, `get_context` and `get_template` to read, `save_draft` to write, `approve` only when the user confirms. Pass `workspace`, the absolute path of this project's folder, on every call to a BuildKeel tool. Never create or edit files in the spec tree yourself. Approved versions and records (`versions/`, `approvals/`, `completions/`, `repins/`) are never edited; to change an approved artifact, save the whole changed file with `save_draft`, which opens its next version. When BuildKeel reports suspects, offer to review them with /bk:impact; whether each is still valid or needs change is the user's decision.

A team can rename the stages of its process and add stages of its own. When it has, BuildKeel's session report lists the stages as the team names them: use those names with the user, in each command's help, its questions and its output. A renamed stage is still that stage to BuildKeel (a "feature" is a user story), and the tools accept either name.

## Before changing code

Every code change belongs to the active unit of this working tree: a task, a story built without tasks, a bug or an ad-hoc unit. If there is none, before changing any file, ask the user how to go on, with your tool for asking a question with choices if you have one, recommending the choice that fits:

1. **Capture what we discussed** with /bk:capture: it turns the conversation into the artifacts the team's process needs, to approve and then build. Recommend it when the conversation shaped new work.
2. **Start the unit it belongs to** with /bk:start <ID>, when the change is part of planned work.
3. **Record it as an ad-hoc unit** with a short title you propose, and start it as /bk:adhoc does: for a small change that belongs to no planned work.
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

When you write a test for a test case, put the test case's ID in square brackets in the test's name, such as `it("emails a reset link [US-012-TC3]", ...)`. A test may carry several IDs. The test cases that apply to the unit are in its context: its own plan's and its story's. A bug's regression test carries the bug's ID, such as `[BUG-005]`, and must fail without the fix.

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

When the unit's work is committed and its test cases pass, finish it with /bk:done. Finishing writes a permanent completion record, so it is the user's decision: show what it will record and ask first.
