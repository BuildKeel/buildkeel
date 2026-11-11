# Tests and traceability

Every test carries the ID of what it checks, so BuildKeel can show which requirements have no test and which changed lines no test ran. In Full SDLC, a test plan lists the test cases for one artifact, and BuildKeel refuses to approve a story's plan that leaves an acceptance criterion untested.

## Before you start

- The repository is set up with `/bk:init` (see [Your first change](getting-started.md)).
- Your tests can write a JUnit XML report. Most test tools do with an option, such as `vitest --reporter=junit --outputFile=<file>`, `pytest --junitxml=<file>` or `node --test --test-reporter=junit --test-reporter-destination=<file>`.
- In Full SDLC, the work has a test plan. By default a story requires an approved plan before any work under it starts. Draft one with `/bk:new test-plan US-001`. When Claude breaks an epic down into stories, it drafts each story's plan with it. See [Plans, IDs and checks](#plans-ids-and-checks).

## 1. Tag a test with its test case

A test is linked to what it checks by the ID in its name.

1. Write the test, and put the test case's ID in its name, in square brackets, such as `[US-001-TC2]`.
   In a Spec-driven tree, use the scenario's ID instead, such as `[AUTH-R3-S1]` (see [In a Spec-driven tree](#in-a-spec-driven-tree)).
2. For a test that checks several test cases, give it one ID per bracket: `[US-001-TC2] [US-001-TC3]`.
   A bracket holding several IDs, such as `[US-001-TC2+US-001-TC3]` or `[US-001-TC2, US-001-TC3]`, tags nothing, and recording the results names it:

   ```text title="Recording the results"
   Tags that do not parse: test/reset.test.ts > link expires [US-001-TC2+US-001-TC3]: [US-001-TC2+US-001-TC3]. Write one ID per bracket: [US-001-TC2] [US-001-TC3]. Until then, that bracket tags nothing.
   ```

Claude tags each test it writes this way. A test case's number never changes, so the link between a test and its test case stays intact.

### Tests from before BuildKeel

Tests written before BuildKeel carry no test case IDs. Instead of renaming them, a test case of a plan that describes existing code (version 0, see [Start on existing code](onboarding.md)) can be **matched** to the tests that already check it, and the code stays as it is.

1. Ask Claude to match the tests to their test cases. Claude also proposes matches while documenting existing code.
2. Agree each match.
   Each test case's match is kept in its plan's `matches/` folder, such as `stories/US-E001/test-plan/matches/US-E001-TC1.yaml`:

   ```yaml
   testCase: US-E001-TC1
   tests:
     - test/reset.test.ts > emails a reset link
   matchedBy: Jane Doe <jane@example.com>
   matchedAt: 2026-10-03T10:02:11Z
   ```

Each test is named the way a JUnit test report names it: its file or class, then its name. A match is not part of the plan's versions, so it can change, or be dropped, without a new version of the plan. Each change is committed on its own in the spec repo, such as `match: US-E001-TC1`.

- A test case counts as having a test when a test is tagged with its ID or matched to it. A matched test's result counts for it like a tagged test's, in the done gates too (see [Finish](finishing-a-unit.md)).
- **Tagging later.** When work under the story changes a matched test, Claude adds the test case's ID to its name, as for any test it writes. When the unit is finished, the match is dropped, in the same commit as its completion record.
- **Broken matches.** When the latest test report runs other tests of a matched test's file but not the test itself, the test was renamed or removed. Validation and the [status overview](status.md) report the match, naming the test and its test case. Tag the test, match it again, or drop the match.

## 2. Record test results

BuildKeel reads results from a JUnit XML report, never from what Claude says.

1. Run the tests with a JUnit XML reporter.
2. Give the report to BuildKeel. Claude does this after each run it makes. A run you make in a terminal counts too: tell Claude where its report is.

   ```text title="Recording a run"
   TK-001: 0 of 3 test cases pass, 2 fail, 1 without a current passing or failing result.
   Read .buildkeel/report.xml: 2 tests, 2 tagged with a test case. Results are recorded for this working tree only (local results).
   ```

   An example. The full output also lists the TDD evidence (see [TDD evidence](tdd.md)) and each test case of the unit.

Each test case of the active unit is shown as passed, failed, not run, stale (the code or the plan changed since the run) or with no tagged test. Results are recorded for your working tree only. How they count when the unit is finished is on [Finish](finishing-a-unit.md).

## 3. See the coverage and the gaps

Ask Claude which requirements have a test, and which behavior has none.

1. Ask Claude for a story's coverage, such as "show the coverage of US-001".

   ```text title="Coverage of US-001"
   Coverage of US-001 "Request a reset link" by its test plan US-001-TP (approved v1), checked against US-001 v1:
   - US-001-AC1 (A reset link is emailed within one minute.) covered by US-001-TC1, TK-001-TC2 (task TK-001)
   - US-001-AC2 (The link expires after 30 minutes.) covered by US-001-TC2
   - US-001-AC3 (A link works only once.) covered by US-001-TC2, US-001-TC3

   Every criterion is covered by US-001-TP.
   ```

2. Ask Claude which behavior has no test, for an artifact and everything under it, or for the whole spec tree.

   ```text title="Untested behavior"
   1 of 2 test cases under US-E001 "Password reset" has a test, tagged with its ID or matched to it.

   No test yet (1):
   - US-E001-TC2 Link lasts an hour (US-E001-TP, covers US-E001-AC2)

   Tests in the latest report (.buildkeel/report.xml) that match no test case (1), anywhere in the tree:
   - test/invoice.test.ts > totals an invoice
   ```

3. Run `/bk:status` to see every coverage gap in the tree.
4. Ask Claude to validate the spec tree, to see every problem with the `covers:` lines across all plans.

In the untested-behavior list, the first part is behavior to cover. The second is tests that check something no requirement states yet: match them, or describe what they check in a new criterion. Once code from before BuildKeel is documented, the status overview counts the onboarded test cases that have a test in its Existing code section.

How the coverage view reads at each level is in [The coverage view](#the-coverage-view).

## 4. Give BuildKeel a coverage report

A test case can pass while part of the code the unit added never runs: a branch no test reaches, or an error path nobody tried. Changed-line coverage lists, at finishing, each line the unit added or changed that no test ran, line by line, not as a percentage of the whole project. It is on by default, and only reports: no mode makes it block a finish. BuildKeel never measures coverage itself. Your test run writes the report.

1. Have your test run write an lcov or Cobertura XML report. Most test tools do with an option. For example:

   | Tool | Command | Report |
   |---|---|---|
   | Vitest | `npx vitest run --coverage --coverage.reporter=lcov` | `coverage/lcov.info` |
   | Jest | `npx jest --coverage --coverageReporters=lcov` | `coverage/lcov.info` |
   | pytest, with pytest-cov | `pytest --cov --cov-report=xml` | `coverage.xml` (Cobertura) |
   | .NET, with coverlet | `dotnet test --collect:"XPlat Code Coverage"` | `TestResults/<run>/coverage.cobertura.xml` |

2. Tell Claude the command your project uses, or put it in your test script, so every run writes the report.
3. Add the report's folder to `.gitignore`. It is not part of the unit's code.
4. Commit your work. Uncommitted edits are not included.
5. Run the whole suite with coverage before finishing. Claude gives the coverage report to BuildKeel with that run's test report:

   ```text title="Recording a run with coverage"
   Coverage from coverage/lcov.info (lcov) is recorded with this run, for the check of changed lines at finishing.
   ```

BuildKeel reads two formats: **lcov**, such as `coverage/lcov.info`, and **Cobertura XML**, such as `coverage.xml` or `coverage.cobertura.xml`. The format is recognized from the file's content, not its name. A path with no file, or a file in neither format, is named, and the run is still recorded without its coverage.

Finishing uses the latest run of the unit that came with a coverage report. A report from a run of only some tests shows the lines the other tests cover as never run. Which lines count and what finishing shows are in [Changed-line coverage](#changed-line-coverage).

## Plans, IDs and checks

### Test plans at every level

Each business idea, epic, story and task can have one test plan. A test plan is a document attached to its artifact, like a design document (see [Process: stages, kinds and documents](process-and-templates.md)). It lives in the artifact's `test-plan/` folder as `plan.md`, has its own versions and approvals, and its ID is the artifact's ID followed by `-TP`: the plan of `US-001` is `US-001-TP`. By default a story requires an approved plan before any work under it starts. Your process can require plans at other stages too, or none.

| Plan of | Called | Its test cases cover | Every one must be covered |
|---|---|---|---|
| Business idea | end-to-end test plan | epics under the idea, or the idea's goals (`BI-01-G2`) | no |
| Epic | integration test plan | stories under the epic (`US-001`), or their criteria | no |
| Story | test plan | the story's acceptance criteria (`US-001-AC2`) | yes: every criterion |
| Task | test plan | the task itself (`TK-001`), or its story's criteria | no |

Its story's plan already applies to a task (see [Which test cases apply to a task](#which-test-cases-apply-to-a-task)). A task needs a plan of its own whenever its tests will not each be one of the story's test cases: a building block such as a token store or a data model, a migration, or a refactor. Its test cases then cover the task itself, such as `covers: [TK-001]`. A task can only be finished with at least one passing test case, of its own or of its story (see [Finish](finishing-a-unit.md)).

Defects and ad-hoc units have no test plan.

### A task's own plan is recorded

A task's own plan is not approved. Each time it is saved, once it passes its checks and its task is approved, it becomes its next version at once: frozen, with a record of its hash and who saved it, and committed as `record: TK-001-TP v2`. So while Claude builds a task, it can add a test case the plan did not foresee, numbered and checked like any other, and carry on. A save that changes nothing records nothing, and one that fails its checks stays a draft until a save passes. A plan drafted with its task, as `/bk:capture` does, is recorded when the task is approved.

Starting the task never waits for its plan. Finishing it still needs every test case of its plan passing, and its completion record names the version the tests ran against, such as `TK-001-TP@v2`. `/bk:status` shows the plan as `recorded v2`. The plans of stories, epics and business ideas are approved as before, and a story's plan still has to cover every criterion.

To have task plans approved like the others, set it in `buildkeel.yaml` (see [Process: stages, kinds and documents](process-and-templates.md)):

```yaml
process:
  taskPlans: approve
```

### Approving a plan

A plan is approved like any other artifact, with `/bk:approve US-001-TP`, and has its own versions. It can be approved once its story is approved, and it is approved against the story's current version. When the story moves to version 2, update the plan against version 2 and approve it again.

### A sample plan

A story:

```markdown
---
id: US-001
title: Request a reset link
parent: EP-01@v1
---

## Summary

A customer asks for a reset link and receives it by email.

## Story

As a customer who forgot my password, I want a reset link by email, so that I can get back into my account.

## Acceptance criteria

- **US-001-AC1** A reset link is emailed within one minute.
- **US-001-AC2** The link expires after 30 minutes.
- **US-001-AC3** A link works only once.
```

Its test plan, written against version 1 of the story:

```markdown
---
parent: US-001@v1
---

## Approach

Integration tests against the reset endpoint, with a fake mail server.

## Test cases

### US-001-TC1 Reset link arrives
covers: [US-001-AC1]

1. Request a reset for a known address.
2. The email arrives within one minute.

### US-001-TC2 Expired or used link is refused
covers: [US-001-AC2, US-001-AC3]

1. Open a reset link 31 minutes after it was sent: it is refused.
2. Use a fresh link, then open it again: it is refused.

### US-001-TC3 Second use from another browser is refused
covers: [US-001-AC3]

1. Open a fresh link in one browser and set a new password.
2. Open the same link in another browser: it is refused.
```

### Test case IDs

A test case's ID is the artifact's ID, `TC` and a number: `US-001-TC2` is the second test case in the plan of `US-001`. Acceptance criteria (`US-001-AC2`) and goals (`BI-01-G2`) are numbered the same way.

You never pick the numbers. When Claude adds an entry, it writes `{{new}}` as its number, and BuildKeel numbers it when the draft is saved, after the highest number the artifact has ever used:

```text title="Saving a draft"
Saved US-001-TP v2 as a draft at stories/US-001/test-plan/plan.md. v1 stays approved and in force until v2 is approved.
New entries numbered: US-001-TC4.
```

A number is never reused. If `US-001-TC2` is removed in version 2 of the plan, no later test case becomes `US-001-TC2`, and a draft that tries it cannot be approved:

```text title="A reused number"
US-001-TC2 was removed in v2 and cannot be used again for a different entry.
  To fix: Write the new entry as US-001-TC{{new}}, and BuildKeel gives it the next number when it is saved.
```

Bringing back a removed entry unchanged, under its own ID, is fine.

If you edit a spec file yourself, ask Claude to show the artifact. It ends with the next number for each kind of entry, such as `Next entry numbers: US-001-TC5`. Use that number, or write `{{new}}` and save through Claude.

### What is checked, and gaps

Every `covers:` line is checked against the version the plan is written against. A story's plan written against `US-001@v1` may only name criteria that exist in version 1 of the story, even after version 2 adds more:

```text title="A criterion that is not there"
stories/US-001/test-plan/plan.md: US-001-TC1 covers US-001-AC9, which is not a criterion of US-001 v1.
```

A story's plan must also cover every criterion. A criterion that no test case covers is a **gap**, and a plan with a gap cannot be approved:

```text title="/bk:approve US-001-TP"
Approval of US-001-TP refused by the approve gate: 1 check failed.
1. US-001-AC3 is not covered by any test case in US-001-TP: "A link works only once."
   To fix: Add a test case to US-001-TP with "covers: [US-001-AC3]", then save the plan again.
```

A criterion added by a later version of the story is a gap too, as soon as that version is approved. The plan's test cases can only name it once the plan is written against the new version, so until a new version of the plan covers it, no work under the story can start:

```text title="A gap from a new version"
1. US-001-AC4 is not covered by any test case in US-001-TP v1: "A used link is refused."
   To fix: US-001-AC4 was added in US-001 v2. Save US-001-TP with parent US-001@v2 and a test case that covers it, then approve the new version.
```

Plans of business ideas, epics and tasks have no gaps: their `covers:` lines are checked, but nothing has to be covered. A business idea's goals are usually measured after release rather than tested, so a goal with no test case is shown, never refused.

### The coverage view

For a story, each criterion is listed with the test cases that cover it, as in [step 3](#3-see-the-coverage-and-the-gaps). Test cases from the plans of the story's tasks are shown too, marked with their task. Only the story's own plan counts for its gaps.

For an epic, the coverage view lists each story under it with the integration test cases that cover it. For a business idea, it lists each goal and epic.

### Which test cases apply to a task

The test cases that apply to a task are its own plan's plus every test case in its story's plan. With three test cases in the story's plan and two in the task's, five apply to the task:

```text title="Test cases of TK-001"
5 test cases apply to TK-001 "Reset endpoint": its own and its story's.

From TK-001-TP (draft):
- TK-001-TC1 Endpoint exists (covers TK-001)
- TK-001-TC2 Endpoint sends the email (covers US-001-AC1)

From US-001-TP (approved v1):
- US-001-TC1 Reset link arrives (covers US-001-AC1)
- US-001-TC2 Expired or used link is refused (covers US-001-AC2, US-001-AC3)
- US-001-TC3 Second use from another browser is refused (covers US-001-AC3)
```

## Changed-line coverage

This is a different check from the coverage of requirements by test cases. It asks whether each changed line ran, not whether each requirement has a test.

### Which lines count

- **The unit's own changes:** every line added or changed from the commit before the unit's first code commit to the latest commit. Uncommitted edits are not included, so commit before finishing.
- **Code files only:** test files are left out, found the same way as for red runs (see [How BuildKeel tells](tdd.md#how-buildkeel-tells)). So are the spec tree, when it is in the code repository, BuildKeel's own `.buildkeel/` folder, and the read-only copy of the glossary, practices and ADRs.
- **Lines the report instruments:** a blank line, a comment or a closing brace is not code the report counts, so it is never listed.
- **A line counts as run** when any test ran it, even once. Lines are checked, not branches: a one-line `if` whose condition a test ran counts as run, even when the branch it guards never was.

A unit whose commits change only test files has no changed lines to check.

### How paths are matched

File paths in the report are matched to the repository's files. An absolute path is read relative to the repository root, and so is a relative one. A Cobertura file name is read relative to the report's first `<source>`. If your tests run from a subfolder, such as one package of a monorepo, and the report gives paths relative to that subfolder, they do not match. Run the tests from the repository root, or have the tool write absolute paths.

### What finishing shows

Under "TDD and the checks on tests", finishing shows one of these:

- **Lines no test ran**, by file, as ranges, such as `src/reset.ts: lines 4, 12-15` (see [Read the evidence](tdd.md#4-read-the-evidence) for an example).
- **Changed files the report does not cover at all**, listed apart, as "Not in the report at all". Usually the tests never loaded the file, or the report's paths do not match, as above.
- **Every changed line ran:** "every changed line the report instruments ran in a test".
- **No report:** "no run recorded a coverage report, so the changed lines were not checked for coverage". This is not a failure. It says the lines were not checked.

Each line no test ran has two possible answers:

- **tie it to a test case,** by writing a test or extending one, tagged with the test case it belongs to;
- **raise it as behavior no spec describes,** when the line does something no requirement asks for, so you can decide whether the spec should say it.

Neither is required: the lines are reported, and the unit can be finished with them listed. The list is kept in the completion record, under `testFirst`, and in the run summary in the unit's `runs/` folder.

Beside the coverage, finishing shows the TDD evidence, the revert check and the test-file diff, and [mutation testing](tdd.md#mutation-testing), which asks whether the tests would notice if the changed code were wrong.

### Turning it off

`checks.coverage: off` in `buildkeel.yaml` turns it off, in either mode (see [Feature switches](settings.md)):

```yaml
process:
  checks:
    coverage: off  # on | off
```

Each unit's record notes whether it was on when the unit started, and finishing follows that. A unit started with it off says so in a line, and its changed lines are not checked.

## In a Spec-driven tree

A Spec-driven tree has no test plans (see [Choose a mode](modes.md)). The scenarios of its capability specs are what tests check (see [Spec-driven mode in depth](how-spec-driven-works.md)). Claude puts the scenario's ID in the name of each test it writes for one:

```js
it("refuses a link opened 31 minutes after it was sent [AUTH-R3-S1]", async () => {
  // ...
});
```

Test results are read from a JUnit XML report, as above, and shown for the active change's scenarios: those of the requirements it adds or modifies first, then the others of the capabilities it changes.

```text title="Recording a run"
CH-002: 1 of 4 scenarios passes, 1 fails, 2 without a current passing or failing result.
Read .buildkeel/results.xml: 2 tests, 2 tagged with a scenario. Results are recorded for this working tree only (local results).

TDD:
- AUTH-R3-S1: passed with no red run on record. If a reason applies (characterization, refactor, no behavior), state it with exceptions; otherwise finishing reports it.

Scenarios of CH-002 (local results):
- AUTH-R2-S1 Registered address: no tagged test
- AUTH-R3-S1 Expired link: passed
Other scenarios of AUTH, which CH-002 leaves as they are:
- AUTH-R1-S1 Correct password: failed: test/reset.test.ts > correct password [AUTH-R1-S1]
- AUTH-R1-S2 Wrong password: no tagged test
```

- A result is **stale** when the code changed since the tests ran, or when the scenario's requirement changed: its text or its scenarios, in the change you are working on or in a newer capability version. A new name for the requirement, and changes to other requirements, leave it current.
- A scenario with no tagged test is a **gap**. Gaps are reported in the status overview and when a change is finished, and never stop anything.
- A tag that looks like a scenario ID but names none, such as a typo or a scenario of a removed requirement, is reported.

Changed-line coverage works the same way for a change.

**More:** [TDD evidence](tdd.md), [Finish](finishing-a-unit.md), [When a requirement changes](change-impact.md), [Status and usage](status.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-new`, `/bk-approve`.
