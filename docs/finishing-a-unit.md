# Finishing a unit

When the work on a unit is committed and its tests pass, you finish it with `/bk:done`. Finishing checks the tests and writes a **completion record**: a permanent note in the spec tree of what was built, against which approved versions, and with which test results.

## While you work

### Commits

Every commit Claude makes while a unit is active ends with the unit's line:

```
Add the reset endpoint

BuildKeel-Unit: TK-001
```

If you agreed to stamp your own commits during `/bk:init`, commits you make in a terminal get the same line. A commit without it still counts for the unit when it is on the unit's branch; `/bk:done` asks you about those (see below).

### Tests

A test that checks a test case carries the test case's ID in square brackets in its name:

```js
it("emails a reset link [US-001-TC1]", async () => {
  // ...
});
```

The test cases that apply to a task are its own plan's and its story's (see [Which test cases apply to a task](test-plans.md#which-test-cases-apply-to-a-task)). A test may carry several IDs.

### Test results

Claude runs the tests with a JUnit XML report and gives the report to BuildKeel, which matches each test to its test case by the ID in its name, or by a recorded match for a test written before BuildKeel (see [Existing tests](test-plans.md#existing-tests)). Most test runners can write one:

| Test runner | Command |
|---|---|
| Vitest | `npx vitest run --reporter=default --reporter=junit --outputFile.junit=.buildkeel/junit.xml` |
| Jest | `npx jest --reporters=default --reporters=jest-junit`, with `JEST_JUNIT_OUTPUT_FILE=.buildkeel/junit.xml` |
| pytest | `pytest --junitxml=.buildkeel/junit.xml` |
| Node's test runner | `node --test --test-reporter=spec --test-reporter-destination=stdout --test-reporter=junit --test-reporter-destination=.buildkeel/junit.xml` |
| Go | `gotestsum --junitfile .buildkeel/junit.xml` |
| Maven, Gradle | already written under `target/surefire-reports/` or `build/test-results/` |

Writing the report under `.buildkeel/` keeps it out of git. BuildKeel then shows where each test case stands:

```
TK-001: 1 of 3 test cases passes, 1 fails, 1 without a current passing or failing result.
Read .buildkeel/junit.xml: 2 tests, 2 tagged with a test case. Results are recorded for this working tree only (local results).

Test cases of TK-001 (local results):
- TK-001-TC1 Endpoint validates its input: passed
- US-001-TC1 Link arrives (from US-001-TP): failed: test/reset.test.ts > emails a reset link [US-001-TC1]
- US-001-TC2 Link expires (from US-001-TP): no tagged test, left for the story
```

Each test case is:

- **passed**: every test tagged with it that ran passed;
- **failed**: a test tagged with it failed;
- **not run**: a test in the code carries its tag, or is matched to it, but no report since has run it;
- **stale**: the code, or the test plan, changed after the tests ran. Committing exactly the code that was tested does not make a result stale;
- **no tagged test**: no test carries its ID yet, and none is matched to it.

A result that comes from a matched test alone says so, such as `- US-E001-TC1 Link sent (from US-E001-TP): passed, through its recorded match`. When the unit is finished, the match of a test that now carries its test case's ID is dropped, in the same commit as the completion record:

```
- Dropped the recorded match of US-E001-TC1 to test/reset.test.ts > emails a reset link: the test now carries [US-E001-TC1] in its name.
```

Results are local: they are kept in `.buildkeel/` in your working tree, never committed, and only the completion record shares them.

## Finish with `/bk:done`

```
/bk:done
```

Run it on its own and Claude asks what to finish; press Enter for the active unit. Claude runs the tests again if the code changed since they last ran, then checks the unit without writing anything.

### What must be true

- The working tree has no uncommitted changes, and is on the unit's branch.
- Every test case of the unit's **own** test plan has a tagged test and a current passing result. For a task, that is the task's plan; for a story built without tasks, the story's plan.
- A test case the task takes from its **story's** plan must pass once a test is tagged with it. Until someone writes that test, it is **left for the story**: it does not stop the task, but the story cannot be finished until every one of its test cases passes. So the first task under a story can finish before the whole story works.
- A task needs **at least one** passing test case, its own or its story's. A task with no test plan of its own, none of whose tests is tagged with a story test case, is refused: nothing shows its work is tested. Give it a test plan whose test cases cover the task, or tag a test with the story test case it delivers.

When something is missing, nothing is written, and every reason is listed with what to do:

```
Finish of TK-001 refused by the done gate: 1 check failed.
1. US-001-TC1 "Link arrives" fails: test/reset.test.ts > emails a reset link [US-001-TC1].
   To fix: Fix the code or the test, then run the tests with a JUnit XML report and record it with the BuildKeel test_results tool.
```

A team can set the done gate to `warn` (finish anyway and show what failed) or `off`:

```yaml
process:
  gates:
    done: warn
```

### Commits without a unit line

When the unit's branch has commits without a `BuildKeel-Unit` line, Claude lists them and asks what to do with them. Press Enter to count them all for the unit, or choose the ones to leave out. Commits left out are named in the completion record, and BuildKeel stops counting them for the unit. Commits stamped with another unit stay with that unit. Nothing in git history is changed.

### What finishing will record

Before writing anything, Claude shows what finishing will do and asks you to confirm:

```
TK-001 "Reset endpoint" v1 can be finished. Finishing will:
- write its completion record in the spec tree, built against US-001@v1, EP-01@v1, BI-01@v1
- commit only that file in the spec repo as "done: TK-001 v1", without pushing
- release its claim on this machine and clear the active unit here; the code branch is left as it is

Commits for the unit in this repo: 2.
Stamped with its BuildKeel-Unit line:
- dcc6036 Add the reset endpoint

1 commit on bk/TK-001-reset-endpoint has no BuildKeel-Unit line. It counts for the unit unless the user leaves it out:
- c8a80a6 Fix lint

Files: src/lint.ts, src/reset.ts, test/reset.test.ts
Not merged into main yet; the record is written before the merge and stays valid after a squash.

Test cases of TK-001 (local results):
- TK-001-TC1 Endpoint validates its input: passed
- US-001-TC1 Link arrives (from US-001-TP): passed
- US-001-TC2 Link expires (from US-001-TP): no tagged test, left for the story

Left for the story: US-001-TC2 has no test yet; US-001 cannot be finished until every test case in US-001-TP passes.
```

## The completion record

Finishing writes one file in the unit's directory, `completions/<time>-<who>.yaml`, and commits it on its own in the spec repo as `done: <ID> v<N>`. It is pushed only when `autoPush` is set in `buildkeel.yaml`, like approvals; otherwise push the spec repo when you are ready to share it.

```yaml
unit: TK-001
version: 1
ancestors:
  - US-001@v1
  - EP-01@v1
  - BI-01@v1
documents:
  EP-01-DD: 1
repo: payments-api
branch: bk/TK-001-reset-endpoint
commits:
  - id: c8a80a6f2d5c3e8b9a1f0e7d6c5b4a3928170f6e
    subject: Fix lint
    by: branch
  - id: dcc60364b1e2a7f3c9d8e0b5a4f6c2d1e3b7a9c8
    subject: Add the reset endpoint
    by: trailer
excluded: []
merged: null
files:
  - src/lint.ts
  - src/reset.ts
  - test/reset.test.ts
tests:
  ranAt: c8a80a6f2d5c3e8b9a1f0e7d6c5b4a3928170f6e
  plans:
    - TK-001-TP@v1
    - US-001-TP@v1
  cases:
    TK-001-TC1:
      result: passed
      tests:
        - test/reset.test.ts > rejects a missing email [TK-001-TC1]
    US-001-TC1:
      result: passed
      tests:
        - test/reset.test.ts > emails a reset link [US-001-TC1]
    US-001-TC2:
      result: no test
      note: left for the story
finishedBy: Jane Doe <jane@example.com>
finishedAt: 2026-10-01T14:12:00Z
host: claude-code
```

| Field | What it holds |
|---|---|
| `unit`, `version` | The unit and the approved version that was finished. Bugs and ad-hoc units have no version. |
| `ancestors` | The versions in force above the unit when it was finished: the ones its context showed. |
| `documents` | The version of each document required of the unit or above it, other than test plans, that the work was built against, as it was when the unit was started, such as the epic's design document. A newer version that changes what the work is built on makes the unit suspect. |
| `repo`, `branch` | The code repository and the unit's branch. |
| `commits` | Each commit counted for the unit, with its subject line, and `by: trailer` (its `BuildKeel-Unit` line) or `by: branch` (on the unit's branch without one). |
| `excluded` | Commits on the unit's branch that you left out. |
| `merged` | The commit that brought the work into the default branch, when it was already merged; otherwise empty. |
| `files` | The files those commits changed. |
| `tests` | The commit the results matched, the test plan versions, and each test case's result with the tests that carry its tag. |
| `finishedBy`, `finishedAt`, `host` | Who finished it (their git identity), when, and in which coding agent. |

The record stands on its own: after a squash merge replaces the commit IDs, it still says what was built, against which versions and with which results. Completion records are never edited; the agent is blocked from changing them.

## Afterwards

- The unit's claim is released, and there is no active unit in this working tree. You stay on the unit's branch: push it and open a pull request as usual.
- When another unit under the same parent is ready to start, such as the story's next task, Claude names it and offers to start it. If you agree, its branch is stacked on this unit's branch, so it has this work before it is merged (see [Working on a unit](working-on-a-unit.md#its-branch)). To build every ready unit in turn, use `/bk:build`.
- A unit is finished once per approved version. Starting or finishing it again is refused, naming its completion record:

  ```
  TK-001 cannot be started.
  - TK-001 v1 was finished on 2026-10-01 by Jane Doe <jane@example.com> (tasks/TK-001/completions/20261001T141200Z-jane-doe.yaml).
    To fix: Save a change to TK-001 with save_draft and approve the new version with /bk:approve TK-001; then it can be started and finished again. Or record the follow-up as a bug with /bk:new bug, or as an ad-hoc unit with /bk:adhoc.
  ```

- `/bk:start` lists finished units under **Done**.
- Finishing a standalone bug also suggests where to attach it. See [Bugs and ad-hoc units](bugs-and-adhoc.md#attaching-a-standalone-bug).

## Finishing a story or an epic

A story built through tasks, or an epic, is never started: its work is done in the units under it. Once they are all done, finish it by name:

```
/bk:done US-001
```

- Every unit under it must be finished at its approved version in force: its tasks, any bugs attached to it or to them, and for an epic, its stories. An open one is named, with what to do: start it and finish it, or finish it in the working tree where it is in progress.
- Every test case of its own test plan must pass. A test case with a tagged test in this repository needs a current passing result here, so run the tests after the work is merged. A test case delivered only in another code repository counts as passed when the completion record of the unit that delivered it says it passed.
- An epic needs no test plan of its own; when it has one, its test cases must pass the same way.
- Nothing under it may be suspect: no unit under it, and no test case in its plan or theirs. See [Change impact](change-impact.md).

Its completion record lists the units under it with their records, and each test case with where it passed:

```yaml
children:
  - unit: TK-001
    version: 1
    record: tasks/TK-001/completions/20261001T141200Z-jane-doe.yaml
  - unit: TK-002
    version: 1
    record: tasks/TK-002/completions/20261001T160500Z-sam-lee.yaml
```
- The unit's context keeps listing its code, from git and from its completion record.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-done`, `/bk-start`.
