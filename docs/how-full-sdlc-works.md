# How Full SDLC mode works

A Full SDLC spec tree follows the team's process: a chain of stages from a business idea down to the work you build, the documents each stage needs, and approvals and gates along the way. With the default process, a business idea is split into epics, an epic into user stories, and a story into tasks; an epic has a design document, and a story a test plan. See [Process and templates](process-and-templates.md) for the chain, and [Setting up a Full SDLC tree](setting-up-full-sdlc.md) for shaping it to your team.

This page follows one piece of work from a business idea down to a finished task, with what BuildKeel shows at each step. Along the way: a defect found while building, behavior questioned while building and the pause for approval, a reported defect and its approval, and a defect in code nothing describes yet.

The examples come from a payments service: business idea BI-01 "Self-service account recovery", epic EP-01 "Password reset" with its design document, user story US-001 "Request a reset link" with its test plan, and task TK-001 "Reset endpoint".

## 1. From a conversation to an approved plan

You talk the work through with Claude. When it has reached a point, `/bk:capture` proposes where it goes in the chain and drafts each artifact, shown in full before it is saved. A draft has a draft ID, such as `US-draft-k3x9`, until it is approved. See [Drafting with Claude](drafting.md).

Approving a plan takes one review with `/bk:approve`: parents and their documents first, each with its own approval record, commit and permanent number.

```
Approved all 6 in one review: BI-01, EP-01, EP-01-DD, US-001, US-001-TP and TK-001.
Ready to start now:
- DEF-001 defect "Reset link expires early"
- TK-001 task "Reset endpoint"
```

An approved version is locked: a change to it opens its next version, and the approved one stays in force until that is approved. See [Approving artifacts](approval.md).

## 2. Starting the work

`/bk:build TK-001` runs the start gate: the task and everything above it approved, none of them suspect, and every document the process requires approved, such as the story's test plan with no gaps. Then the task gets its branch and its claim on this machine:

```
- Created its branch bk/TK-001-reset-endpoint from main.
- Claimed on this machine: other working trees cannot start TK-001 until it is finished or released.
```

Claude receives the task's context: what to build, why (the story, with each acceptance criterion and the test case for it), the epic's design, and the open defects. Each commit ends with `BuildKeel-Unit: TK-001`, and each test carries its test case in its name, such as `it("expires links [US-001-TC2]")`. See [Working on a unit](working-on-a-unit.md).

### A defect found while building

While building TK-001, Claude opens an expired link and sees a stack trace where a message should be. That is a defect of the work under way: the code does not do what was agreed. Recorded with `/bk:new defect`, it is attached to the task, with the test case that found it, and gets its number at once:

```
Created defect DEF-002 "Expired link page shows a stack trace" at defects/DEF-002/defect.md, attached to TK-001@v1, where US-001-TC2 found it.
```

The work is already approved, so the defect needs no approval of its own and can be started straight away. It needs a regression test with `[DEF-002]` in its name.

### Behavior questioned while building

The code repository has a security policy: a reset link must expire within 15 minutes. US-001-AC2 says 30. Claude does not build something else, and does not edit the spec on its own: it stops, names US-001-AC2 and the policy, and asks whether to keep the criterion as agreed or change it.

You say 15 minutes. The spec changes first. Claude saves the story's next version, which opens it as a draft beside the approved one:

```
Saved US-001 v2 as a draft at stories/US-001/story.md. v1 stays approved and in force until v2 is approved.
```

Then it previews what approving it would make suspect, so everything the change touches is drafted together:

```
Approving the draft of US-001 as v2 would make 2 items suspect. Nothing is marked until the draft is approved.

US-001 "Request a reset link", from v1 to the draft:
- US-001-AC2 changed
  was: - **US-001-AC2** The link expires after 30 minutes.
  now: - **US-001-AC2** The link expires 15 minutes after it is sent.
Would become suspect (2):
1. Task TK-001 "Reset endpoint": any change to US-001 affects it.
2. Test case US-001-TC2 "Link expires" in US-001-TP v1: covers US-001-AC2.
```

The build pauses until the new versions are approved. Once US-001 v2 is, the task is suspect, and the start gate holds it:

```
Start of TK-001 refused by the start gate: 1 check failed.
1. The task TK-001 "Reset endpoint" is suspect: built against US-001 v1, and v2 changes US-001-AC2.
```

You review it with `/bk:impact`: TK-001 still holds against v2, so Claude records that, and the work goes on against the new version:

```
Recorded that TK-001 is still valid against US-001 v2, so it is no longer suspect. The decision is kept in:
```

When the start gate is set to warn, you can tell Claude to carry on before the new versions are approved; it says that it builds against versions not yet approved. See [Change impact](change-impact.md).

## 3. Finishing

`/bk:done` runs the done gate: the work committed on the task's branch, and every test case that applies to it passing in a test report recorded with the test results. Finishing writes the completion record: what was built, against which approved versions, and with which results.

```
Finished TK-001 "Reset endpoint" v1: its completion record keeps what was built, against which approved versions, and with which test results.
```

### The work above it

A story built through tasks is finished once everything under it is: its tasks finished, its defects fixed or closed, and its test cases passing. Until then, `/bk:done US-001` names what is left:

```
Finish of US-001 refused by the done gate: 3 checks failed.
1. The defect DEF-001 "Reset link expires early", under US-001, is not finished.
   To fix: Start it with /bk:build DEF-001 and finish it with /bk:done.
2. The defect DEF-002 "Expired link page shows a stack trace", under US-001, is not finished.
   To fix: Start it with /bk:build DEF-002 and finish it with /bk:done.
```

The epic, then the business idea, are finished the same way. See [Finishing a unit](finishing-a-unit.md).

## A defect, or a change in behavior?

The rule is the same in both modes:

- **A defect**: the code does not do what the spec says. The code is fixed, and the spec keeps its version. For example, US-001-AC2 says 15 minutes, and links expire after 3.
- **A change in behavior**: the code does what the spec says, and the spec is wrong, no longer wanted, or silent. The spec changes and gets a new version: a new version of the story, or a new item of the team's kind for it, such as an enhancement. For example, links expire after 15 minutes, as US-001-AC2 says, and support now wants an hour.

When someone reports a problem, Claude checks it against the approved spec and the code linked to it before recording anything, and proposes one reading: a defect, a change in behavior, a gap (the spec says nothing about it), or code nothing describes yet. It labels the reading as its own, says what it rests on, and records nothing until you confirm or pick another. A defect that later turns out to change behavior is closed without a fix as a change in behavior, naming what takes it over, such as `US-001@v3`.

### A reported defect

A customer on one mail provider gets no reset email. US-001 says the email arrives within a minute: a defect. A defect that users, customers or testers report is planned work, so it goes through the lifecycle of the chain. Its parent is the work it affects, a user story unless your team chose other kinds in `defect.parents`, and it is drafted first:

```
Created draft DEF-draft-1f21 (defect) at defects/DEF-draft-1f21/defect.md. It follows its template and has everything it needs for approval.
```

It cannot be started until it is approved:

```
Start of DEF-draft-1f21 refused by the start gate: 1 check failed.
1. The defect DEF-draft-1f21 "Reset email never arrives for some domains" is not approved and has no permanent number yet.
```

Approving it gives it its number in the defect sequence:

```
Approved DEF-003 v1 (was DEF-draft-1f21). It is locked now: a change opens v2, and v1 stays in force until then.
```

When the affected work is not known, Claude asks BuildKeel which work changed the code involved and which artifacts' scope covers it, and offers what it finds as the parent, for you to pick.

### A defect in code nothing describes

A customer reports that invoice totals round down. Claude asks BuildKeel what describes the billing code:

```
Nothing describes src/billing/invoice.ts in payments-api yet: no artifact's scope covers it, and no unit's commits changed it.

No story describes these files, so a reported defect in them has no parent yet: draft version 0 of the story the defect touches first, stating the intended behavior, and use it as the defect's parent.
```

Claude drafts version 0 of an invoicing story, describing the code as it was before BuildKeel and stating the intended rounding, then the defect with that draft as its parent, and you review and approve both in one set, version 0 first:

```
Approved all 2 in one review: US-E001@v0 and DEF-004.
```

See [Documenting existing code](onboarding.md) for version 0.

## Where it all shows

`/bk:status` shows the tree with each artifact's state, suspects, coverage gaps, and the defects, each with its parent and where it came from:

```
Defects: 4 open, 0 done.
- DEF-001 "Reset link expires early": in TK-001, found while building
- DEF-002 "Expired link page shows a stack trace": in TK-001, found while building
- DEF-003 "Reset email never arrives for some domains": in US-001, reported
- DEF-004 "Invoice totals round down": in US-E001, reported
```

See [The status overview](status.md) and [Defects and ad-hoc units](defects-and-adhoc.md).
