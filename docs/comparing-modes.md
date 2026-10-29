# Choosing a mode

BuildKeel works in one of two modes, chosen when a spec tree is created. This page compares them, to help you choose. For how each mode works, see [The two modes](modes.md).

## Which to choose

**Spec-driven** suits a team that wants living specs of how its system behaves, and a change for each piece of work, with nothing waiting for an approval.

Code links, tests, change impact and defects are all traced, and everything reports rather than blocks. It is the default, and `/bk:init` offers it first.

**Full SDLC** suits a team that needs the full chain from business idea down to code, with each artifact approved and locked.

Gates stop work until it is ready: no coding against an unapproved or outdated requirement, and no "done" without passing tests.

## Side by side

| | Spec-driven | Full SDLC |
|---|---|---|
| **What you plan with** | Capability specs, which say how the system behaves now, and changes to them | Your process's stages: by default business ideas, epics, user stories and tasks |
| **Artifacts** | A fixed set: capability specs, and changes with a proposal, spec changes, a design when needed, and tasks | The stages you set, with the documents each requires, such as a design document for an epic and a test plan for a story |
| **IDs** | Given when an item is first written: `CH-012`, `ACCT`, `ACCT-R2`, `ACCT-R2-S1` | A draft ID such as `US-draft-k3x9` until first approval, then a permanent one: `EP-03`, `US-012`, `US-012-AC2`, `US-012-TC3` |
| **Drafting** | `/bk:capture` drafts a whole change from a conversation; `/bk:new` drafts a change or one file of an open change | `/bk:capture` drafts what your process needs, level by level; `/bk:new` drafts one artifact or breaks a parent down |
| **Approvals** | None | Each artifact is approved, one at a time or a whole plan in one review |
| **Editing** | Every file of an open change can be edited at any time, with no new version | An approved artifact is locked; a change to it becomes a draft of its next version |
| **Gates** | Only the lock gate, which protects finished records | Approve, start, done and lock, each set to block, warn or off |
| **The unit of work** | A change, whose tasks are checkboxes inside it; defects; ad-hoc units | A task, or a story with no tasks; defects; ad-hoc units |
| **Starting work** | `/bk:build CH-012` starts it at once; no gate runs | `/bk:build TK-047` starts it once the start gate passes: everything above it approved and current |
| **Context for Claude** | The change's proposal, spec changes, design and tasks, each capability it touches at the version in force, its open defects and linked code | The task, its story and acceptance criteria, the epic, the business idea, the test cases that apply, open defects and linked code |
| **Building** | `/bk:build` builds one change's tasks in order, on the change's branch | `/bk:build` builds every ready task in turn, each on its own branch, stacked on the one before |
| **Tests** | Each test names the scenario it checks, such as `[ACCT-R2-S1]`; there are no test plans | Test plans at every level; each test case says what it covers, and each test names its test case, such as `[US-012-TC3]` |
| **Gaps** | A scenario with no tagged test is reported, and never stops anything | A test plan that leaves a criterion uncovered cannot be approved, so work under it cannot start |
| **Finishing** | `/bk:done` reviews the code against the change's requirements, scenarios and design, reports the checks, and you choose **Fix first** or **Finish anyway**; then it archives the change, and each capability it touches gets its next version | `/bk:done` runs the done gate: every test case that applies must pass; then it writes the completion record |
| **Change impact** | By requirement ID: previewed on an open change, and decided before or after it is archived; it reports | A new version makes what was built on the old one suspect, and work cannot start on a suspect until someone decides |
| **Defects** | Found while building: attached to the change whose work found it. Reported: linked to the requirement it affects, or standalone. None is approved, and a missing regression test is a reminder | Found while building: attached to the task or story, and started at once. Reported: under the work it affects, a story by default, and approved before work on it starts. A regression test is needed to finish |
| **Existing code** | A capability's version 0, written once a person has confirmed it | Version 0 of each artifact, reviewed and approved, with its sources kept |
| **What your team sets** | Templates, rules for each artifact, ID prefixes | Stages, kinds within a stage, documents, which kinds a reported defect can belong to, templates, rules, ID prefixes and gates |
| **The spec tree's format** | 3: everyone working in it needs BuildKeel 0.5.0 or later | 3, as for Spec-driven |

The same in both: commits are linked to their unit automatically, test results are read from JUnit XML reports, defects can be closed without a fix, every finished unit leaves a permanent record, nothing leaves your repositories, and the commands are the same.

## The same piece of work in each mode

**The work:** Verification links should expire after 24 hours.

### In Spec-driven

- `/bk:capture`: drafts the change
- `/bk:build CH-012`: starts it, no gate, and builds its tasks
- `/bk:done`: reviews, then archives

You talk it through with Claude, and `/bk:capture` drafts a change:

```text title="changes/CH-012"
changes/CH-012/proposal.md      why links should expire, and what changes
changes/CH-012/specs/ACCT.md    the spec change to ACCT "Account creation and verification"
changes/CH-012/tasks.md         the tasks, as numbered checkboxes
```

Its spec change modifies a requirement by its ID, keeping its scenarios and adding one:

```markdown title="changes/CH-012/specs/ACCT.md"
## Modified

### ACCT-R2 Email verification
The system SHALL email a verification link to a new account's address, and SHALL refuse a link opened more than 24 hours after it was sent.

#### ACCT-R2-S1 Link opened in time
- **WHEN** a user opens their verification link within 24 hours
- **THEN** their address is verified

#### ACCT-R2-S2 Link used after it expires
- **WHEN** a user opens their verification link more than 24 hours after it was sent
- **THEN** they are told the link has expired, and offered a new one
```

You start it with `/bk:build CH-012`, and Claude builds its tasks, naming each test after its scenario, such as `[ACCT-R2-S2]`. `/bk:done` reviews the code against `ACCT-R2` and its scenarios, and, once you choose to finish, writes the next version of `ACCT` naming `CH-012`. Nothing was approved along the way, and the change is kept as the record of why the behavior changed.

### In Full SDLC

- `/bk:capture`: drafts the new versions
- `/bk:impact US-012`: shows what is suspect
- `/bk:approve`: approves both
- `/bk:build TK-047`: start gate checks
- `/bk:done`: every test case passes

You talk it through with Claude, and `/bk:capture` drafts what your process needs: here, a new version of the story `US-012` "Email verification flow" with a changed criterion, and the test case that checks it in its test plan, `US-012-TP`:

```markdown title="US-012, next version"
## Acceptance criteria

- **US-012-AC1** A new account is emailed a verification link.
- **US-012-AC2** A link opened more than 24 hours after it was sent is refused, with an offer of a new one.
```

```markdown title="US-012-TP"
### US-012-TC3 Expired link is refused
covers: [US-012-AC2]

1. Open a verification link 25 hours after it was sent.
2. The link is refused, and a new one is offered.
```

Before approving, `/bk:impact US-012` shows what the new version puts in question, such as a finished task built against version 1 and the tests of the changed criterion. You approve both with `/bk:approve`, decide on each suspect, and build the task `TK-047` with `/bk:build TK-047`: the start gate checks that the story and its test plan are approved and current. Claude names each test after its test case, such as `[US-012-TC3]`, and `/bk:done` finishes the task only when every test case that applies passes.

## Moving to Full SDLC

A Spec-driven tree moves to Full SDLC with `/bk:migrate`, once no change is open. You set up your process, as for a new Full SDLC tree, and your stages are drafted from the capability specs and archived changes, area by area, for you to review and approve. Scenarios become test cases or acceptance criteria, tests tagged with scenario IDs count for what those scenarios became, code linked to changes stays linked, and open defects keep their IDs under the artifacts they affect. The capability specs and archived changes stay in the tree, read-only, as its history.

A Full SDLC tree cannot become Spec-driven. See [Moving to Full SDLC](modes.md#moving-to-full-sdlc) for the steps.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-init`, `/bk-capture`, `/bk-new`, `/bk-approve`, `/bk-build`, `/bk-done`, `/bk-impact`, `/bk-migrate`.

Once you have chosen, the setup guide for your mode walks you through every question `/bk:init` asks: [Setting up a Spec-driven tree](setting-up-spec-driven.md) or [Setting up a Full SDLC tree](setting-up-full-sdlc.md).
