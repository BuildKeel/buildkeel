# Defects and ad-hoc units

Every code change belongs to a unit of work. Planned work arrives through the process: tasks and stories in Full SDLC, changes in a Spec-driven tree. Two more kinds of unit cover the rest:

- an **ad-hoc unit** records a small change that belongs to no planned work, such as fixing a typo. It is the only unit outside the process, in either mode, and it is never approved;
- a **defect** records code that does not do what was agreed. It comes from one of two places: **found while building** or testing the work under way, or **reported** later by users, customers or testers.

Each is started and built with `/bk:build`, has a branch, and is finished with `/bk:done`, which writes a completion record like any unit's. An ad-hoc unit and a defect found while building get a permanent ID the moment they are created, because their commits are stamped with it straight away. In Full SDLC, a reported defect is planned work: it is drafted and approved before work on it starts, like any artifact in the chain.

For each mode followed from start to finish, with defects along the way, see [How Spec-driven mode works](how-spec-driven-works.md) and [How Full SDLC mode works](how-full-sdlc-works.md).

## Ad-hoc units

### A change with nothing started

When you ask Claude to change code and no unit is active in the working tree, BuildKeel holds the edit and Claude asks you first:

```
BuildKeel: there is no active unit in this working tree, so a change to src/footer.ts would belong to no unit of work. Before changing it, ask the user how to go on, recommending the choice that fits: capture what you discussed, which the user starts by running /bk:capture (you cannot start it), turning it into the artifacts the team's process needs, to approve and then build; start the unit it belongs to with /bk:build <ID>; record it as an ad-hoc unit, with a short title you propose (create it with the BuildKeel save_draft tool, type adhoc, then start it with start_work); or go ahead without a unit, which only the user can choose (then call the BuildKeel manage tool with action untracked). Make the change once one of these is done.
```

Run `/bk:capture` to capture what you discussed, name the unit the change belongs to, accept the ad-hoc unit, or say to go ahead without a unit. Claude asks before changing code, so you usually see the question rather than the hold. Claude makes the change once a unit is active, or once you have chosen to go ahead without one.

Going ahead without a unit lasts in that working tree until a unit is started: edits are no longer held, and each session tells Claude the changes belong to no unit. Commits made meanwhile carry no `BuildKeel-Unit` line, and `/bk:status` lists them under **commits with no unit**. Changes to the spec tree, to BuildKeel's own `.buildkeel/` folder and to files outside the repository are not held.

### Recording one directly

```
/bk:build fix the footer link
```

Describe the change in place of an ID, and Claude compares your words with the titles of the units that can start. When nothing matches, it offers **Record the ad-hoc unit "Fix the footer link" and build it**; when a title matches, it offers that unit first, and records an ad-hoc unit only if you pick it. Claude creates the unit and starts it:

```
Created ad-hoc unit AH-002 "Fix the footer link" at adhoc/AH-002/adhoc.md.
- Committed alone as "new: AH-002" (5e2b7c1) in the spec repo.
- Not pushed: push the spec repo to share it.

Build it with /bk:build AH-002.
```

Its file holds a title and a short description:

```markdown
---
id: AH-002
title: Fix the footer link
---

## Description

The footer links to the old help page.
```

Commit the change with `BuildKeel-Unit: AH-002`, then finish it with `/bk:done`. An ad-hoc unit has no test cases of its own: finishing needs only a clean working tree on its branch. `/bk:status` lists open ad-hoc units under **Ad-hoc work**.

## Defects

### A defect, or a change in behavior?

- **A defect**: the code does not do what the spec says. The code is fixed, and the spec keeps its version.
- **A change in behavior**: the code does what the spec says, and the spec is wrong, no longer wanted, or silent. The spec changes and gets a new version: through a change in a Spec-driven tree; in Full SDLC, through a new version of the story, or a new item of the team's kind for it, such as an enhancement.

When someone reports a problem, `/bk:new defect` and `/bk:capture` check it against the spec in force and the code linked to it before recording anything. Claude proposes one reading, labelled as its own, with what it rests on: a defect, a change in behavior, a gap (the spec says nothing about it), or code nothing describes yet. Nothing is recorded until you confirm it or pick another.

### Recording a defect found while building

```
/bk:new defect TK-001
```

Claude asks whether the defect was found while building or reported, proposing found while building when a unit is active. A defect found while building is attached to the **task or story** where it was found, with the test case that found it when a test did, offering the test cases that apply there. The work is approved already, so the defect needs no approval of its own and gets its number at once.

```
Created defect DEF-002 "Reset link lasts 3 minutes" at defects/DEF-002/defect.md, attached to TK-001@v1, where US-001-TC2 found it.
- Committed alone as "new: DEF-002" (8d41a07) in the spec repo.
- Not pushed: push the spec repo to share it.
- Finishing it needs a regression test with [DEF-002] in its name, passing.

Build it with /bk:build DEF-002.
```

```markdown
---
id: DEF-002
title: Reset link lasts 3 minutes
source: found
parent: TK-001@v1
testCase: US-001-TC2
---

## Description

Links expire after 3 minutes instead of 30.
```

To change a defect's file later, such as to add steps to reproduce, ask Claude; it saves the whole file again. A defect keeps its source.

### Recording a reported defect

In Full SDLC, a reported defect has the work it affects as its parent: a user story, unless your team allows other kinds in `defect.parents` in `buildkeel.yaml`, such as `[story, feature]`. It is drafted with a draft ID, such as `DEF-draft-p2m7`, reviewed like any draft, and approved with `/bk:approve`, which gives it its number in the defect sequence. `/bk:build` refuses it until it is approved. When the work it affects is not known, Claude finds it first: see [Finding the work a reported defect affects](#finding-the-work-a-reported-defect-affects).

There is no standalone defect in Full SDLC: when nothing describes the code yet, Claude drafts version 0 of the story the defect touches first, stating the intended behavior, and the two are approved in one set, version 0 first. A defect fixed before BuildKeel, recorded as version 0 while documenting existing code, may stand alone.

### Fixing it

Start the defect with `/bk:build DEF-002`. Its context gives the defect, the work it was found in, and what to test. Write a **regression test**, a test that fails without the fix and passes with it, with the defect's ID in its name:

```js
it("keeps reset links for 30 minutes [DEF-002]", async () => {
  // ...
});
```

Finishing a defect needs that regression test passing, and the test case that found it passing too. Without one, the finish is refused and names it:

```
Finish of DEF-002 refused by the done gate: 1 check failed.
1. DEF-002 has no regression test: no test is tagged [DEF-002].
   To fix: Write a test that fails without the fix and passes with it, with [DEF-002] in its name, then run the tests with a JUnit XML report and record it with the BuildKeel test_results tool.
```

Once a defect attached to a unit is finished, its regression test counts among that unit's test cases: when the unit is worked on again, at a new version, the test must still pass. The unit's coverage view lists it under **Regression tests of fixed defects**.

If fixing a defect means a requirement must change, the change is made as a new version of the story or task, approved as usual.

### Closing a defect without a fix

Some defects turn out not to be defects after all: a duplicate of another defect, one nobody can reproduce, behavior that works as intended, or a failure caused by a wrong test. None of these can get a regression test, so instead of finishing one, close it. Run `/bk:done DEF-002`, and Claude offers **Close without a fix** beside finishing it, then asks for the reason, for a duplicate which defect it duplicates, and for a note if you want one. Before anything is written, it shows what closing does:

```
Closing DEF-002 "Login redirect loops" without a fix, as a duplicate of DEF-001, will:
- write its closing record, defects/DEF-002/closed.yaml: the reason, who closed it and when, never edited after
- commit it on its own in the spec repo

A closed defect is not open, counts as done for the work above it, and is never started or reopened: a defect that returns is a new defect.
```

Claude closes a defect only when you confirm it. The closing record is written once and committed alone, as `close: DEF-002 (duplicate of DEF-001)`:

```yaml
defect: DEF-002
reason: duplicate
duplicateOf: DEF-001
note: Same root cause as the redirect loop.
closedBy: Jane Doe <jane@example.com>
closedAt: 2026-10-15T09:12:00Z
```

The reason is one of `duplicate`, `cannot-reproduce`, `works-as-intended`, `wrong-test` or `changes-behavior`, when the code does what the spec says and the spec is what must change; the record then names what takes it over in `takenOverBy`, such as `CH-014` or `US-007@v3`. A closed defect counts as done for its story or epic, drops out of open defects, relies on nothing that can change, and cannot be started. It is never reopened: if the defect comes back, record a new defect, which can name the closed one. When the test was wrong, correct the test case as a new version of its test plan. A defect that is finished, or already closed, cannot be closed.

### Open defects in a unit's context

A unit's context lists the defects attached to it or to its parent that are neither finished nor closed:

```
## Open defects
- DEF-002 "Reset link lasts 3 minutes" in TK-001, found by US-001-TC2
```

A story, whether it is built through tasks or on its own, and an epic above it, cannot be finished while a defect under it is open. A task is not held up by its own defects: the story above it is. A closed defect counts as done. `/bk:status` lists every defect with its parent and where it came from, and each closed one with its reason.

### Finding the work a reported defect affects

Before a reported defect is saved, Claude asks BuildKeel which work the code involved belongs to. BuildKeel finds the units whose commits changed those files and the stories and tasks whose `scope` covers them, and names the story each belongs to, most likely first. Code documented from before BuildKeel is found by its story's scope, even when no unit's commits ever changed it:

```
A reported defect in these files would have as its parent, most likely first:
- US-001 story "Request a reset link": 1 file (src/reset.ts), through TK-001 "Reset endpoint"
```

A story found by its scope is named the same way: `- US-E001 story "Password reset": 1 file (src/reset/token.ts), under its scope src/reset/`.

Claude offers the first as the defect's parent, and you pick before anything is saved. When nothing describes the code yet, BuildKeel says so, and Claude drafts version 0 of the story the defect touches first, as its parent.

## When the spec tree is in your code repository

The file of a defect or ad-hoc unit is committed on the branch that is checked out when it is recorded, often the branch of a unit you just finished, which waits for its pull request. When you start it, its own branch is made from your main branch as usual and brings along the commit that recorded it, which changes nothing but the unit's own file. The same file then sits on both branches, and they merge cleanly in either order.

## In a Spec-driven tree

Defects and ad-hoc units work the same way in a [Spec-driven](modes.md) tree, with these differences:

- Nothing is approved: every defect gets its number when it is created.
- A defect found while building is attached to the [change](changes.md) whose work found it, such as `parent: CH-002`, with the scenario whose test found it as its `testCase`. It needs no proposal, and it shows in that change's context while it is open.
- A reported defect names the requirement it affects, such as `requirement: AUTH-R3`, pinned to the capability version in force (`AUTH-R3@v4`), or stands alone. Its context shows that requirement as its version states it, with its scenarios and the tests tagged with them. While it is open, a later version that modifies or removes the requirement makes it suspect: you decide whether it still applies, and its file is saved naming the new version, or it is closed.
- When a standalone defect is finished, BuildKeel looks at the files its fix changed, finds the requirements that archived changes built in them, and offers to link the defect to one. You may leave it standalone.
- When nothing describes the code of a reported defect, Claude asks whether to **record it standalone** (the default) or **document this code first**, as version 0 of a capability spec.
- Finishing a defect with no test tagged with its ID reports the missing regression test, as a reminder, and the defect is still finished. The work must be committed on its branch.
- A fix that changes a requirement is made through a change, which alters the capability spec when it is finished.
- Closing a defect without a fix works as above, and a closed defect drops out of its change's open defects.

## IDs

Defects and ad-hoc units are numbered like everything else, `DEF-002` and `AH-002`, from the same number counter in the spec repo. A reported defect in Full SDLC is numbered when it is approved, as any draft is. When the counter cannot be reached for one created with its number, such as with no connection, the unit still gets a permanent ID at once, with four random letters and digits in place of the number:

```
Created ad-hoc unit AH-k3x9 "Fix the footer link" at adhoc/AH-k3x9/adhoc.md.
- The number counter could not be reached (...), so AH-k3x9 has an ID that needs no counter. It is permanent: commits are stamped with it.
```

It is never renumbered: its commits already carry it.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-build`, `/bk-new defect`, `/bk-done`.
