# Test plans and coverage

A test plan lists the test cases for one artifact, and every test case says what it checks. BuildKeel uses that to show which requirements have no test, and refuses to approve a story's plan that leaves an acceptance criterion untested.

## Plans at every level

Each business idea, epic, story and task can have one test plan. A test plan is a document attached to its artifact, like a design document (see [Process and templates](process-and-templates.md#documents-attached-to-a-stage)): it lives in the artifact's `test-plan/` folder as `plan.md`, has its own versions and approvals, and its ID is the artifact's ID followed by `-TP`: the plan of `US-001` is `US-001-TP`. By default a story requires an approved plan before any work under it starts; your process can require plans at other stages too, or none.

| Plan of | Called | Its test cases cover | Every one must be covered |
|---|---|---|---|
| Business idea | end-to-end test plan | epics under the idea, or the idea's goals (`BI-01-G2`) | no |
| Epic | integration test plan | stories under the epic (`US-001`), or their criteria | no |
| Story | test plan | the story's acceptance criteria (`US-001-AC2`) | yes: every criterion |
| Task | test plan | the task itself (`TK-001`), or its story's criteria | no |

Its story's plan already applies to a task (see [Which test cases apply to a task](#which-test-cases-apply-to-a-task)). A task needs a plan of its own whenever its tests will not each be one of the story's test cases: a building block such as a token store or a data model, a migration, or a refactor. Its test cases then cover the task itself, such as `covers: [TK-001]`. A task can only be finished with at least one passing test case, of its own or of its story (see [Finishing a unit](finishing-a-unit.md)).

### A task's own plan is recorded

A task's own plan is not approved. Each time it is saved, once it passes its checks and its task is approved, it becomes its next version at once: frozen, with a record of its hash and who saved it, and committed as `record: TK-001-TP v2`. So while Claude builds a task, it can add a test case the plan did not foresee, numbered and checked like any other, and carry on. A save that changes nothing records nothing, and one that fails its checks stays a draft until a save passes. A plan drafted with its task, as `/bk:capture` does, is recorded when the task is approved.

Starting the task never waits for its plan. Finishing it still needs every test case of its plan passing, and its completion record names the version the tests ran against, such as `TK-001-TP@v2`. `/bk:status` shows the plan as `recorded v2`. The plans of stories, epics and business ideas are approved as before, and a story's plan still has to cover every criterion.

To have task plans approved like the others, set it in `buildkeel.yaml` (see [Process and templates](process-and-templates.md#task-plans)):

```yaml
process:
  taskPlans: approve
```

Bugs and ad-hoc units have no test plan.

Draft a plan with `/bk:new test-plan US-001`. When Claude breaks an epic down into stories, it drafts each story's plan with it.

## A sample plan

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

## Test case IDs

A test case's ID is the artifact's ID, `TC` and a number: `US-001-TC2` is the second test case in the plan of `US-001`. Acceptance criteria (`US-001-AC2`) and goals (`BI-01-G2`) are numbered the same way.

You never pick the numbers. When Claude adds an entry, it writes `{{new}}` as its number, and BuildKeel numbers it when the draft is saved, after the highest number the artifact has ever used:

```
Saved US-001-TP v2 as a draft at stories/US-001/test-plan/plan.md. v1 stays approved and in force until v2 is approved.
New entries numbered: US-001-TC4.
```

A number is never reused. If `US-001-TC2` is removed in version 2 of the plan, no later test case becomes `US-001-TC2`, and a draft that tries it cannot be approved:

```
US-001-TC2 was removed in v2 and cannot be used again for a different entry.
  To fix: Write the new entry as US-001-TC{{new}}, and BuildKeel gives it the next number when it is saved.
```

Bringing back a removed entry unchanged, under its own ID, is fine.

If you edit a spec file yourself, ask Claude to show the artifact: it ends with the next number for each kind of entry, such as `Next entry numbers: US-001-TC5`, and you can use that number or write `{{new}}` and save through Claude.

Tests in your code carry the test case's ID in their name, such as `[US-001-TC2]`, so a number that never changes keeps that link intact.

## What is checked

Every `covers:` line is checked against the version the plan is written against. A story's plan written against `US-001@v1` may only name criteria that exist in version 1 of the story, even after version 2 adds more:

```
stories/US-001/test-plan/plan.md: US-001-TC1 covers US-001-AC9, which is not a criterion of US-001 v1.
```

A story's plan must also cover every criterion. A criterion that no test case covers is a **gap**, and a plan with a gap cannot be approved:

```
Approval of US-001-TP refused by the approve gate: 1 check failed.
1. US-001-AC3 is not covered by any test case in US-001-TP: "A link works only once."
   To fix: Add a test case to US-001-TP with "covers: [US-001-AC3]", then save the plan again.
```

A criterion added by a later version of the story is a gap too, as soon as that version is approved. The plan's test cases can only name it once the plan is written against the new version, so until a new version of the plan covers it, no work under the story can start:

```
1. US-001-AC4 is not covered by any test case in US-001-TP v1: "A used link is refused."
   To fix: US-001-AC4 was added in US-001 v2. Save US-001-TP with parent US-001@v2 and a test case that covers it, then approve the new version.
```

Plans of business ideas, epics and tasks have no gaps: their `covers:` lines are checked, but nothing has to be covered. A business idea's goals are usually measured after release rather than tested, so a goal with no test case is shown, never refused.

Ask Claude to validate the spec tree to see every such problem across all plans.

## Seeing coverage

Ask Claude for a story's coverage, such as "show the coverage of US-001". Each criterion is listed with the test cases that cover it:

```
Coverage of US-001 "Request a reset link" by its test plan US-001-TP (approved v1), checked against US-001 v1:
- US-001-AC1 (A reset link is emailed within one minute.) covered by US-001-TC1, TK-001-TC2 (task TK-001)
- US-001-AC2 (The link expires after 30 minutes.) covered by US-001-TC2
- US-001-AC3 (A link works only once.) covered by US-001-TC2, US-001-TC3

Every criterion is covered by US-001-TP.
```

Test cases from the plans of the story's tasks are shown too, marked with their task. Only the story's own plan counts for its gaps.

For an epic, the coverage view lists each story under it with the integration test cases that cover it. For a business idea, it lists each goal and epic.

## Which test cases apply to a task

The test cases that apply to a task are its own plan's plus every test case in its story's plan. With three test cases in the story's plan and two in the task's, five apply to the task:

```
5 test cases apply to TK-001 "Reset endpoint": its own and its story's.

From TK-001-TP (draft):
- TK-001-TC1 Endpoint exists (covers TK-001)
- TK-001-TC2 Endpoint sends the email (covers US-001-AC1)

From US-001-TP (approved v1):
- US-001-TC1 Reset link arrives (covers US-001-AC1)
- US-001-TC2 Expired or used link is refused (covers US-001-AC2, US-001-AC3)
- US-001-TC3 Second use from another browser is refused (covers US-001-AC3)
```

## Existing tests

Tests written before BuildKeel carry no test case IDs. Instead of renaming them, a test case of a plan that describes existing code ([version 0](approval.md#version-0-code-from-before-buildkeel)) can be **matched** to the tests that already check it, and the code stays as it is. Ask Claude to match them, or Claude proposes matches while documenting existing code. Each test case's match is kept in its plan's `matches/` folder, such as `stories/US-E001/test-plan/matches/US-E001-TC1.yaml`:

```yaml
testCase: US-E001-TC1
tests:
  - test/reset.test.ts > emails a reset link
matchedBy: Jane Doe <jane@example.com>
matchedAt: 2026-10-03T10:02:11Z
```

Each test is named the way a JUnit test report names it: its file or class, then its name. A match is not part of the plan's versions, so it can change, or be dropped, without a new version of the plan; each change is committed on its own in the spec repo, such as `match: US-E001-TC1`.

- A test case counts as having a test when a test is tagged with its ID or matched to it, and a matched test's result counts for it like a tagged test's, in the done gates too (see [Finishing a unit](finishing-a-unit.md#test-results)).
- **Tagging later.** When work under the story changes a matched test, Claude adds the test case's ID to its name, as for any test it writes. When the unit is finished, the match is dropped, in the same commit as its completion record.
- **Broken matches.** When the latest test report runs other tests of a matched test's file but not the test itself, the test was renamed or removed: validation and the [status overview](status.md) report the match, naming the test and its test case. Tag the test, match it again, or drop the match.

### Untested behavior

Ask Claude which behavior has no test, for an artifact and everything under it or for the whole spec tree. Claude lists the test cases with no test tagged with them or matched to them, and the tests in the latest report that check no test case:

```
1 of 2 test cases under US-E001 "Password reset" has a test, tagged with its ID or matched to it.

No test yet (1):
- US-E001-TC2 Link lasts an hour (US-E001-TP, covers US-E001-AC2)

Tests in the latest report (.buildkeel/report.xml) that match no test case (1), anywhere in the tree:
- test/invoice.test.ts > totals an invoice
```

The first are behavior to cover; the second, tests that check something no requirement states yet, to match, or to describe in a new criterion. Once code from before BuildKeel is documented, the status overview counts the onboarded test cases that have a test in its Existing code section.

## Approving a plan

A plan is approved like any other artifact, with `/bk:approve US-001-TP`, and has its own versions. It can be approved once its story is approved, and it is approved against the story's current version. When the story moves to version 2, update the plan against version 2 and approve it again.

## In a Spec-driven tree

A Spec-driven tree has no test plans (see [The two modes](modes.md)). The scenarios of its [capability specs](capability-specs.md) are what tests check: Claude puts the scenario's ID in the name of each test it writes for one.

```js
it("refuses a link opened 31 minutes after it was sent [AUTH-R3-S1]", async () => {
  // ...
});
```

Test results are read from a JUnit XML report, as above, and shown for the active change's scenarios: those of the requirements it adds or modifies first, then the others of the capabilities it changes.

```
CH-002: 1 of 4 scenarios passes, 1 fails, 2 without a current passing or failing result.
Read .buildkeel/results.xml: 2 tests, 2 tagged with a scenario. Results are recorded for this working tree only (local results).

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

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-new`, `/bk-approve`.
