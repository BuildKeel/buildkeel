# Bugs and ad-hoc units

Every code change belongs to a unit of work. Planned work arrives as tasks and stories, approved first. Two kinds of unit cover the rest, and neither is approved:

- an **ad-hoc unit** records a small change that belongs to no planned work, such as fixing a typo;
- a **bug** records a defect, found while building or testing planned work, or reported later.

Both get a permanent ID the moment they are created, because their commits are stamped with it straight away. Both are started with `/bk:start`, have a branch, and are finished with `/bk:done`, which writes a completion record like any unit's.

## Ad-hoc units

### A change with nothing started

When you ask Claude to change code and no unit is active in the working tree, BuildKeel holds the edit and Claude asks you first:

```
BuildKeel: there is no active unit in this working tree, so a change to src/footer.ts would belong to no unit of work. Before changing it, ask the user how to go on, recommending the choice that fits: capture what you discussed with /bk:capture, which turns it into the artifacts the team's process needs, to approve and then build; start the unit it belongs to with /bk:start <ID>; record it as an ad-hoc unit, with a short title you propose (create it with the BuildKeel save_draft tool, type adhoc, then start it with start_work); or go ahead without a unit, which only the user can choose (then call the BuildKeel manage tool with action untracked). Make the change once one of these is done.
```

Capture what you discussed, name the unit the change belongs to, accept the ad-hoc unit, or say to go ahead without a unit. Claude asks before changing code, so you usually see the question rather than the hold. Claude makes the change once a unit is active, or once you have chosen to go ahead without one.

Going ahead without a unit lasts in that working tree until a unit is started: edits are no longer held, and each session tells Claude the changes belong to no unit. Commits made meanwhile carry no `BuildKeel-Unit` line, and `/bk:status` lists them under **commits with no unit**. Changes to the spec tree, to BuildKeel's own `.buildkeel/` folder and to files outside the repository are not held.

### Recording one directly

```
/bk:adhoc "Fix the footer link"
```

Run it on its own and Claude asks what the change is. Claude creates the unit and starts it:

```
Created ad-hoc unit AH-002 "Fix the footer link" at adhoc/AH-002/adhoc.md.
- Committed alone as "new: AH-002" (5e2b7c1) in the spec repo.
- Not pushed: push the spec repo to share it.

Start it with /bk:start AH-002.
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

## Bugs

### Recording a bug

```
/bk:new bug TK-001
```

Claude asks where the bug was found and, when a test failed, which test case found it, offering the test cases that apply there. A bug is attached to the **task or story** where it was found, or recorded **standalone** when it has no known home yet, such as one a customer reported.

```
Created bug BUG-002 "Reset link lasts 3 minutes" at bugs/BUG-002/bug.md, attached to TK-001@v1, where US-001-TC2 found it.
- Committed alone as "new: BUG-002" (8d41a07) in the spec repo.
- Not pushed: push the spec repo to share it.
- Finishing it needs a regression test with [BUG-002] in its name, passing.

Start it with /bk:start BUG-002.
```

```markdown
---
id: BUG-002
title: Reset link lasts 3 minutes
parent: TK-001@v1
testCase: US-001-TC2
---

## Description

Links expire after 3 minutes instead of 30.
```

To change a bug's file later, such as to add steps to reproduce, ask Claude; it saves the whole file again.

### Fixing it

Start the bug with `/bk:start BUG-002`. Its context gives the bug, the work it was found in, and what to test. Write a **regression test**, a test that fails without the fix and passes with it, with the bug's ID in its name:

```js
it("keeps reset links for 30 minutes [BUG-002]", async () => {
  // ...
});
```

Finishing a bug needs that regression test passing, and the test case that found it passing too. Without one, the finish is refused and names it:

```
Finish of BUG-002 refused by the done gate: 1 check failed.
1. BUG-002 has no regression test: no test is tagged [BUG-002].
   To fix: Write a test that fails without the fix and passes with it, with [BUG-002] in its name, then run the tests with a JUnit XML report and record it with the BuildKeel test_results tool.
```

Once a bug attached to a unit is finished, its regression test counts among that unit's test cases: when the unit is worked on again, at a new version, the test must still pass. The unit's coverage view lists it under **Regression tests of fixed bugs**.

If fixing a bug means a requirement must change, the change is made as a new version of the story or task, approved as usual.

### Open bugs in a unit's context

A unit's context lists the bugs attached to it or to its parent that are not finished yet:

```
## Open bugs
- BUG-002 "Reset link lasts 3 minutes" in TK-001, found by US-001-TC2
```

A story or epic cannot be finished while a bug under it is open.

### Attaching a standalone bug

When a standalone bug is finished, BuildKeel looks at the files its fix changed, finds the other work that changed them and the stories and tasks whose `scope` covers them, and names the story each belongs to. Code documented from before BuildKeel is found by its story's scope, even when no unit's commits ever changed it:

```
BUG-003 is standalone. The files it changed also belong to:
- US-001 "Request a reset link": 1 file (src/reset.ts), through TK-001 "Reset endpoint"
```

A story found by its scope is named the same way: `- US-E001 "Password reset": 1 file (src/reset/token.ts), under its scope src/reset/`.

Claude asks whether to attach the bug there, to one of the tasks named, or to leave it standalone. An attached bug's file names its new parent, committed with its completion record, and its regression test joins that unit's test cases.

## When the spec tree is in your code repository

The file of a bug or ad-hoc unit is committed on the branch that is checked out when it is recorded, often the branch of a unit you just finished, which waits for its pull request. When you start it, its own branch is made from your main branch as usual and brings along the commit that recorded it, which changes nothing but the unit's own file. The same file then sits on both branches, and they merge cleanly in either order.

## IDs

Bugs and ad-hoc units are numbered like everything else, `BUG-002` and `AH-002`, from the same number counter in the spec repo. When the counter cannot be reached, such as with no connection, the unit still gets a permanent ID at once, with four random letters and digits in place of the number:

```
Created ad-hoc unit AH-k3x9 "Fix the footer link" at adhoc/AH-k3x9/adhoc.md.
- The number counter could not be reached (...), so AH-k3x9 has an ID that needs no counter. It is permanent: commits are stamped with it.
```

It is never renumbered: its commits already carry it.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-adhoc`, `/bk-new bug`, `/bk-start`, `/bk-done`.
