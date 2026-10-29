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

### Reminders to finish

BuildKeel reminds you to run `/bk:done` when the work looks done. Neither reminder blocks anything.

**When the work is done.** In a Spec-driven tree, ticking a change's last task tells Claude to say so:

```
Every task of CH-002 "Reset links expire" is done: tell the user they can run /bk:done to finish it.
```

In Full SDLC, recording the test results says the same once every test case that applies to the unit passes and its work is committed.

**Before you share unfinished work.** When Claude is about to run `git push`, `gh pr create` or `gh pr merge` while a unit is active, BuildKeel tells it, and the command goes ahead:

```
BuildKeel: CH-002 "Reset links expire" is not finished: tell the user to run /bk:done before merging. The command goes ahead.
```

In Claude Code a hook adds this before the command runs. Antigravity cannot add a note before a command, so there Claude is told to give the reminder itself. A push you make in a terminal gets no reminder.

## Finish with `/bk:done`

```
/bk:done
```

Run it on its own and Claude asks what to finish; press Enter for the active unit. Claude runs the tests again if the code changed since they last ran, then checks the unit without writing anything. For a defect, Claude also offers to close it without a fix, such as a duplicate or a change in behavior; see [Closing a defect without a fix](defects-and-adhoc.md#closing-a-defect-without-a-fix).

### What must be true

- The working tree has no uncommitted changes, and is on the unit's branch.
- The unit is not suspect: built against a version of something above it that has changed since. Decide it first with `/bk:impact` (see [Change impact](change-impact.md)).
- Every test case of the unit's **own** test plan has a tagged test and a current passing result. For a task, that is the task's plan, at the version recorded last; for a story built without tasks, the story's plan.
- A test case the task takes from its **story's** plan must pass once a test is tagged with it. Until someone writes that test, it is **left for the story**: it does not stop the task, but the story cannot be finished until every one of its test cases passes. So the first task under a story can finish before the whole story works.
- A story built without tasks has no open defect under it: each is finished, or closed without a fix. A task is not held up by its own defects; the story above it is.
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

Before writing anything, Claude shows what finishing will do, in its reply, and asks you in plain text to confirm:

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
| `unit`, `version` | The unit and the approved version that was finished. Ad-hoc units, defects found while building and every defect in a Spec-driven tree have no version. |
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
    To fix: Save a change to TK-001 with save_draft and approve the new version with /bk:approve TK-001; then it can be started and finished again. Or record the follow-up as a defect with /bk:new defect, or as an ad-hoc unit with /bk:build and a description of the change.
  ```

- `/bk:build`, asked to show what can be started, lists finished units under **Done**.
- In a Spec-driven tree, finishing a standalone defect offers to link it to a requirement its fix's files implement. See [Defects and ad-hoc units](defects-and-adhoc.md#in-a-spec-driven-tree).

## Finishing a story or an epic

A story built through tasks, or an epic, is never started: its work is done in the units under it. Once they are all done, finish it by name:

```
/bk:done US-001
```

- Every unit under it must be finished at its approved version in force: its tasks, any defects attached to it or to them, and for an epic, its stories. A defect closed without a fix counts as done (see [Defects and ad-hoc units](defects-and-adhoc.md#closing-a-defect-without-a-fix)). An open one is named, with what to do: start it and finish it, or finish it in the working tree where it is in progress.
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

## Finishing a change

In a Spec-driven tree (see [The two modes](modes.md)), `/bk:done` finishes a [change](changes.md) by **archiving** it: its spec changes are merged into the capability specs, each capability it touches gets its next version naming the change, and the change's files are frozen as its record. Defects and ad-hoc units finish as described above, except that a missing regression test is a reminder, not a refusal.

A change does not have to be the active unit to be finished. Run `/bk:done CH-002`, or run `/bk:done` on its own with no active unit and pick from the open changes; those with every task ticked come first, and you can pick several.

### What finishing reports

Before anything is written, BuildKeel gathers, for Claude and for you:

- the **unticked tasks**, each with how it is verified;
- each capability spec as it will be after the merge: what the change adds or modifies in full, the rest one line each;
- the design's Design and Decisions sections;
- the code linked to the change: its commits (stamped `BuildKeel-Unit: CH-002`, or on its branch) and the files they changed;
- where each scenario's tests stand, and the **gaps**: scenarios with no tagged test (see [Test plans](test-plans.md));
- the consistency check: the proposal and spec changes disagreeing, tasks or the design naming a requirement the change removes, test tags naming no scenario, each with its file and line, ticked tasks whose requirement changed after the tick;
- the template check, including the capability specs after the merge;
- the suspects archiving would raise (see [Change impact](change-impact.md));
- **overlaps**: requirements this change modifies or removes that another change archived since its spec change was written.

Nothing here stops the finish. The only things that do are uncommitted changes in the working tree, which the record would leave out, and for the active change, being off its branch.

### Unticked tasks first

A task can be done without being ticked. Before showing you anything else, Claude checks each unticked task against the code and the test results, tells you in a line each which now pass their verification, and offers to tick them. Once they are ticked, finishing is previewed again.

### The review, and your choice

Claude then reviews the code against the change's requirements, scenarios and design, and reports which scenarios the code implements, which it does not, and anything at odds with the design. The report is headed as Claude's judgment, not a check: it is kept in the completion record as Claude wrote it, never as a pass or a fail.

In the same reply, Claude shows what finishing will write: the capability specs after the merge, with the requirements the change adds or modifies in full and the others by name. Then it asks, in plain text at the end of the reply, whether to **Fix first** or **Finish anyway**. Fix first is the default when the review or the checks report something missing, such as a scenario not implemented, a gap or a failing test; otherwise finishing is the default. Finishing anyway is recorded, with what was reported.

When the review finds a gap where the code is right and the spec is not, such as a requirement for a flag the code never needed, Claude also offers **Reword the spec, then finish**. It shows the requirement's new text and why, saves it once you agree, and previews again.

Whenever anything is committed or changed after the preview, such as a fix to a docstring, Claude previews again and asks you on the new preview. A preview that no longer matches the change or its code cannot be applied.

### Work left open

When you finish anyway with tasks unticked or gaps reported, the result lists them, and Claude offers a **follow-up change** to hold them. If you agree, it is drafted and reviewed like any change, starting with its proposal. Either way the change is archived as it is, and its completion record keeps the tasks left unticked (`openTasks`) and what was reported.

### Overlaps

A spec change records the capability version it was written against (`base`). When another change has given the capability a newer version since, changes to different requirements merge on their own. When both changed the same requirement, Claude shows you both texts:

```
- AUTH-R2: written against AUTH v1; CH-002 changed it in v2.
```

You choose which text to keep, or how to combine them, and Claude passes your choice when the change is archived. The spec change is rewritten with that text and the version it was merged onto, so the frozen change says exactly what was merged.

### Several changes

Several changes finish oldest first, each with its own review, versions and commit. Each is merged onto the versions the ones before it wrote: when `CH-012` and `CH-015` both modify `AUTH`, `CH-012` makes `AUTH` version 4, and `CH-015` is checked against version 4 and makes version 5.

### What archiving writes

```
Archived CH-002 "Reset links expire".
- Wrote AUTH v2 (capabilities/AUTH/versions/v2.md), naming CH-002.
- Froze the change: changes/CH-002-reset-links-expire/archive.yaml, and its completion record changes/CH-002-reset-links-expire/completions/20261014T101500Z-jane-doe.yaml (1 commit, 2 files).
- Recorded the tasks left unticked: 1.2, 2.1.
- Committed as "archive: CH-002" (4c1d2e9) in the spec repo.
- Released its claim; there is no active unit in this working tree now.
- The branch bk/CH-002-reset-links-expire is unchanged: push it and open a pull request as usual.
```

Everything is committed once, as `archive: CH-002`, and pushed only when `autoPush` is set:

```
<spec root>/
  capabilities/AUTH/versions/v2.md      AUTH after the merge
  capabilities/AUTH/versions/v2.yaml    its record: the change, the hash, who, when
  changes/CH-002-reset-links-expire/archive.yaml           the hash of every file of the change
  changes/CH-002-reset-links-expire/completions/...yaml    the completion record
```

The archive record freezes the change. Its files, and the capability versions, are never edited: the agent is blocked from changing them, and validation reports one changed, added or removed outside BuildKeel.

```yaml
change: CH-002
versions:
  AUTH: 2
files:
  changes/CH-002-reset-links-expire/design.md: sha256:7d1b0c4e9f2a8e3d5c6b7a8f9e0d1c2b3a4f5e6d7c8b9a0f1e2d3c4b5a6f7e8d
  changes/CH-002-reset-links-expire/proposal.md: sha256:2b4c6d8e0f1a3b5c7d9e1f3a5b7c9d1e3f5a7b9c1d3e5f7a9b1c3d5e7f9a1b3c
  changes/CH-002-reset-links-expire/specs/AUTH.md: sha256:9e8d7c6b5a4f3e2d1c0b9a8f7e6d5c4b3a2f1e0d9c8b7a6f5e4d3c2b1a0f9e8d
  changes/CH-002-reset-links-expire/tasks.md: sha256:1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b
archivedBy: Jane Doe <jane@example.com>
archivedAt: 2026-10-14T10:15:00Z
```

A change's completion record has the fields above, for the change's commits, files and the scenarios' results, and these besides:

| Field | What it holds |
|---|---|
| `versions` | The capability versions its archiving wrote, such as `AUTH: 2`. Code linked to the change is thereby linked to them: `query` on `AUTH` version 2 lists its commits and files. |
| `requirements` | The requirements it added or modified. Its code depends on them: a later change to one makes the change suspect. |
| `review` | Claude's review, as reported to you. |
| `findings` | What the consistency and template checks reported. |
| `finishedAnyway` | `true` when you finished it although something was reported missing. |
| `openTasks` | The tasks left unticked when it was archived, each with its number and text. |

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-done`, `/bk-build`.
