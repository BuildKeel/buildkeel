# Working on a unit

A unit is a piece of work that code changes belong to: a task, a story built without tasks, a bug or an ad-hoc unit. You start one before changing code, and Claude works on it with its requirements and tests in view.

## Start a unit

```
/bk:start TK-001
```

Run `/bk:start` on its own and Claude asks what you want to start. Press Enter on the first choice to see what can be started:

```
Ready to start (2):
- BUG-001 bug "Reset link expires early"
- TK-001 task "Reset endpoint"

Not ready yet (1):
- TK-002 task "Reset email": The test plan US-001-TP is not approved.
```

Starting a unit:

1. checks that it is ready (see below);
2. switches to its branch, `bk/<ID>-<title>`, such as `bk/TK-001-reset-endpoint`;
3. claims it on this machine, so another working tree cannot start it too;
4. makes it the **active unit** of this working tree;
5. loads its context for Claude.

### Its branch

If the unit's branch already exists, Claude switches to it. Otherwise the branch starts from where you are, or from your default branch (such as `main`) when you are on another unit's branch, so the new unit does not carry the other unit's commits. Nothing is fetched or pushed.

The exception is a unit that follows one just finished: the next unit of a build run, or the next unit Claude offers after `/bk:done`. Its branch is **stacked** on the finished unit's branch, so it has that work before it is merged:

```
- Created its branch bk/TK-002-reset-email from bk/TK-001-reset-endpoint. It is stacked on bk/TK-001-reset-endpoint, so it has that unit's work before it is merged; merge the branches in order, or review the run in one pull request from the last branch.
```

Each unit still has its own branch, commits and completion record, and each commit stays linked to the unit it was made for, even on the branches stacked on top. Open one pull request from the last branch to review the whole run, or one per branch, each based on the one before, and merge them in order. A change to an earlier unit after review means rebasing the branches stacked on it, as does merging per-unit pull requests with a squash; one pull request for the run avoids both.

When the spec tree is a folder of your code repository, its approvals live on the branches too. If the unit was approved on another unit's branch and the branch it would switch to does not have those approvals yet, the start is refused, with the approvals that are missing and the branch to merge first, for example through its pull request. Nothing changes until you start again.

## What must be true to start

- The unit is approved and has its permanent number, and so is everything above it: its story, epic and business idea.
- Neither the unit nor anything above it is suspect: built against an older version of something that has changed since. See [Change impact](change-impact.md).
- Every document your process requires of the unit and of everything above it is approved: by default the epic's design document and the story's test plan, which must cover every acceptance criterion. A task's own test plan needs no approval: it is recorded as it is saved (see [Test plans](test-plans.md#a-tasks-own-plan-is-recorded)), unless your process approves task plans. See [Process and templates](process-and-templates.md#documents-attached-to-a-stage).
- No other working tree on this machine is working on it.

A story that has tasks is worked on through its tasks. Epics and business ideas are not started at all. Bugs and ad-hoc units need no approval and no test plan, but are not started while anything above them is suspect.

A [version 0](approval.md#version-0-code-from-before-buildkeel), which describes code as it was before BuildKeel, counts as approved for the work under it. A unit whose version in force is version 0 describes work already done, so it is not started itself: changing it starts with its version 1.

When something is missing, nothing changes, and every reason is listed with what to do about it:

```
Start of TK-001 refused by the start gate: 1 check failed.
1. The user story US-001 "Request a reset link", above TK-001, is not approved.
   To fix: Approve US-001 with /bk:approve US-001.
```

A team can set the start gate to `warn` (start anyway and show what failed) or `off`:

```yaml
process:
  gates:
    start: warn
```

## Uncommitted changes

The active unit does not change while you have uncommitted changes, so that every change belongs to exactly one unit. Claude lists the changed files and asks what to do:

- **commit them to the active unit**, with its `BuildKeel-Unit:` line;
- **set them aside** with `git stash`, after you confirm; bring them back with `git stash pop`;
- or leave them and not start.

Your changes are never deleted.

Files that set BuildKeel up are not anyone's work: the `.buildkeel.yaml` pointer, the spec tree's `buildkeel.yaml` and `templates/`, and a `.gitignore` whose only change is BuildKeel's `.buildkeel/` line. When they are uncommitted, as after `/bk:init`, Claude offers to commit them on their own, as setting BuildKeel up, with no `BuildKeel-Unit` line.

## The context

When a unit starts, Claude receives its context: a compact view built from the approved versions of the unit and everything above it. For a task:

```
# Active unit: TK-001 v1 "Reset endpoint"
BI-01 v1 › EP-01 v1 › US-001 v1 › TK-001 v1
Commits: end every message with "BuildKeel-Unit: TK-001".
Tests: put the test case ID in the test's name, such as [US-001-TC1]. Record each run's JUnit XML report with test_results, and finish with /bk:done.

## What to build: TK-001 v1
repo payments-api · scope src/reset/
Add the POST /reset endpoint.

## Why: US-001 v1 "Request a reset link"
As a customer who forgot my password, I want a reset link by email, so that I can get back into my account.

| Criterion | Must hold | Tested by |
|---|---|---|
| US-001-AC1 | A reset link is emailed within one minute. | US-001-TC1 Link arrives |
| US-001-AC2 | The link expires after 30 minutes. | US-001-TC2 Link expires |

## How it is built: EP-01-DD v1, the design document of EP-01
Reset links are signed, single-use tokens sent by email.
### Design
A signed token in an emailed link opens the reset form once.

## Background
- EP-01 v1 "Password reset": Customers reset a forgotten password by email.
- BI-01 v1 "Self-service account recovery": Customers recover their own accounts without calling support.

## Open bugs
- BUG-001 "Reset link expires early" in TK-001

## Linked code: none yet
```

- The unit and its parent appear in full, in their tracked sections. Everything further up appears as one line: its ID, version, title and approved summary.
- The nearest design document, on the unit or above it, usually its epic's, appears under **How it is built**: its summary and the sections work is built on, such as the design, the decisions, and the architecture, data and interfaces when it has them. Other documents attached to the unit or above it, such as a team's own threat model, appear as one line each under **Background**.
- Bugs attached to the unit or its parent that are neither finished nor closed are listed under **Open bugs**, with the test case that found each one. A bug's own context asks for a regression test tagged with its ID (see [Bugs and ad-hoc units](bugs-and-adhoc.md)).
- Every artifact shows the version the context was built from. When a newer version of a parent is approved, the context shows it at once, with a note that the unit was approved against the older one.
- An artifact at version 0 is marked as describing the code as it was before BuildKeel, with the paths its scope covers, such as `US-E001 v0 describes the code as it was before BuildKeel, in src/reset/.` under **Why**.
- **Linked code** lists the unit's commits and the files they changed, in every code repository on this machine. For work finished before BuildKeel, these are the commits made before the baseline that name its tracker key, found when its version 0 was approved.
- The same approved versions always produce exactly the same context. Nothing is summarized on the fly.

Ask Claude to show the context of any unit at any time, such as "show the context of TK-002".

### Size

A context view should stay within **10,000 characters**, about 2,500 tokens. A larger one is never cut; it ends with a note saying how large it is, so you can shorten or split the unit. A team can change the budget in `buildkeel.yaml`:

```yaml
settings:
  contextBudget: 15000
```

## Sessions

At the start of every session, when a session is resumed, and after Claude Code compacts the conversation, BuildKeel tells Claude only:

- that BuildKeel is set up here, and that the conversation stays free: talk as you would without BuildKeel, and its artifacts, IDs and commands come in only when you run a BuildKeel command or Claude is about to change a file;
- how to discuss: as a thinking partner, laying out options, trade-offs and pitfalls before asking, in prose, with sources for anything it looks up, recommending only what the evidence supports, and never pushing toward a plan. When you say the discussion has reached a point, Claude asks once whether there is more to explore or you are ready for `/bk:capture`, which only you start;
- the active unit and its branch, followed by its context again, or that no unit is active;
- your team's names for its stages, when your process renames or adds stages.

Nothing else is raised at session start, so a question about the code gets a plain answer. Whether the spec tree is behind its remote, what is suspect, and what is not pushed are shown when you start, approve or finish work, and in `/bk:status`.

When you ask Claude to change code and no unit is active, Claude asks how to go on before changing any file: capture what you discussed, by running `/bk:capture` yourself, start the unit the change belongs to, record it as an ad-hoc unit, or go ahead without a unit if you say so. If Claude goes to change code anyway, BuildKeel holds the edit until one of these is done (see [Bugs and ad-hoc units](bugs-and-adhoc.md)).

BuildKeel checks the edits Claude makes with its file editing tools, and Claude is told to change files only with them. A change made another way, such as through a shell command, escapes these checks; if it is committed without a unit, `/bk:status` lists it under commits with no unit.

### In Antigravity

Antigravity tells BuildKeel about each step of the agent rather than about sessions, so BuildKeel follows each conversation itself:

- **A new conversation** starts with the same report and the active unit's context, before the agent's first response.
- **Each new message** in a conversation adds only what changed since the last report, such as a unit that was started or finished. When nothing changed, nothing is added. A conversation reopened later keeps its history, so nothing is loaded again.
- **After Antigravity compacts a conversation**, the report and the context come back. BuildKeel sees the compaction in the conversation's record that Antigravity keeps. If that record cannot be read, each new message is reminded of the active unit instead, and the agent loads its context again when it needs it.

What BuildKeel remembers about each conversation is kept in `.buildkeel/conversations/` in the working tree.

### Freshness

When a session starts, BuildKeel fetches the spec repo's remote in the background; the session never waits for it. If the local spec tree is behind, you are told how far when you start, approve or finish work, and starting a unit warns about it but goes ahead. If the fetch fails, for example with no connection, you are told the check could not run, and work continues with your local copy. `/bk:status` always shows where the spec repo stands.

## Staying in scope

While a unit is active, BuildKeel tells Claude when an edit falls outside the areas the unit relates to: the paths in its `scope` field and its story's, and the folders changed by its own commits and by the other work under its story, from their commits and completion records. Claude then checks with you whether the change belongs to the unit:

```
BuildKeel: src/billing/invoice.ts is outside the areas TK-001 relates to so far (src/reset/): its scope and its story's, and what its own work and the other work on its story changed. If the change belongs to TK-001, carry on and tell the user it widens what TK-001 touches. If it belongs to other work, stop and ask the user which unit it belongs to.
```

- Each file is mentioned once, the first time it is changed.
- Tests are never outside the scope, wherever the project keeps them.
- While no area is known, as for the first task under a new story when neither names a scope, nothing is said. The areas grow as the work is committed.
- A story that describes code from before BuildKeel names the paths it covers, so the first task under it is warned about work elsewhere before it has any code of its own.
- In Antigravity, the note reaches the agent just before its next step.

## Pull requests

When a code repository's remote is on GitHub and GitHub's `gh` tool is installed and signed in, a unit's context also names the pull requests that hold its commits:

```
- payments-api: commits 4be1f20 · files src/reset.ts · pull requests #12 "Add the reset endpoint" (merged)
```

For other hosts, or without `gh`, the context shows the commits and files only.

## Several units at once

Each git working tree has one active unit. To work on two units at the same time, for example with two agents, give each its own working tree:

```
git worktree add ../payments-api-tk002
```

Each working tree has its own active unit and branch, and commits made in each are stamped with its own unit. A unit claimed in one working tree cannot be started in another on the same machine; removing a working tree releases its claims.

## Build everything that is ready

```
/bk:build
```

Claude lists the units ready to start, at the lowest level (tasks, and stories without tasks), or only those under a story or epic you name, such as `/bk:build US-001`, and asks you once. Then, for each unit in turn, it starts it, writes the code and the tests for its test cases, runs the tests, and finishes it with its own completion record, before going on to the next. Each unit's branch is stacked on the one before, so later units build on the earlier ones' code.

The run stops and asks you when a start is refused, a test keeps failing after Claude has tried to fix it, or a requirement is unclear: Claude never guesses a requirement. At the end it shows each unit with its branch, commits and record, and the last branch, which holds the whole run.

## In a Spec-driven tree

In a [Spec-driven](modes.md) tree, the units are [changes](changes.md), bugs and ad-hoc units. Starting one works as above, with two differences: no gate runs, so a unit starts unless another working tree on this machine holds it, and a change gets its branch from its ID and title, such as `bk/CH-002-reset-links-expire`.

```
/bk:start CH-002
```

### A change's context

A change's context holds its proposal, every spec change in full, its design and its tasks with their ticks, then each capability it touches at its version in force: the requirements the change touches in full, and the others in a line each. It ends with its open bugs and the code linked to it:

```
# Active unit: CH-002 "Reset links expire" (change)
Progress: 1 of 3 tasks done.
Commits: end every message with "BuildKeel-Unit: CH-002", and add "BuildKeel-Task: <number>" when the commit does exactly one task.
Tests: put the scenario ID in each test's name, such as [AUTH-R1-S1]. Record each run's JUnit XML report with test_results.
Tasks: work through the unticked ones in order, and tick each with save_draft once its verification passes. Finish with /bk:done.
Keep the change consistent: when you edit one of its files, check the others and propose the follow-on edits.

## Proposal
### Why

A reset link that never expires can be used by anyone who finds it later.

### What changes

- Reset links expire 30 minutes after they are sent.
- The reset email says when the link expires.

### Capabilities

- **AUTH** (modified): reset links expire 30 minutes after they are sent, and the reset email says when.

### Impact

The reset endpoint and the reset email template.

## Spec change: AUTH
### Added

#### AUTH-R3 Reset link expires
The system SHALL expire a reset link 30 minutes after it is sent.

##### AUTH-R3-S1 Expired link
- **WHEN** a user opens a reset link 31 minutes after it was sent
- **THEN** they are told the link expired and offered a new one

### Modified

#### AUTH-R2 Request a reset link
The system SHALL email a password reset link to a registered address on request, saying when the link expires.

##### AUTH-R2-S1 Registered address
- **WHEN** a user asks for a reset link for a registered email
- **THEN** a reset link is emailed to that address, with the time it expires

## Design
### Summary

Each reset link carries its issue time, signed, and the endpoint refuses links older than 30 minutes.

### Context

Reset links are random tokens stored with no time.

### Design

The token gains an issue time, signed with the existing reset key. The endpoint checks the signature, then the age.

## Tasks
### 1. Expiry

- [x] 1.1 Add the issue time to reset tokens. Verify: token tests for a new and an old token.
- [ ] 1.2 Refuse links older than 30 minutes. Verify: the "Expired link" scenario test (AUTH-R3-S1).

### 2. Email

- [ ] 2.1 Say when the link expires in the reset email. Verify: the "Registered address" scenario test (AUTH-R2-S1).

## AUTH v1, in force
How people prove who they are, and get back in when they cannot.
- AUTH-R1 Sign in with email and password

### AUTH-R2 Request a reset link
The system SHALL email a password reset link to a registered address on request.

#### AUTH-R2-S1 Registered address
- **WHEN** a user asks for a reset link for a registered email
- **THEN** a reset link is emailed to that address

## Open bugs: none

## Linked code: none yet
```

### Building a change's tasks

`/bk:build` builds the active change's unticked tasks, in order, on its branch, after one confirmation. Each test is named with the scenario it checks, such as `[AUTH-R3-S1]`. A commit that does exactly one task names it too:

```
Refuse reset links older than 30 minutes

BuildKeel-Unit: CH-002
BuildKeel-Task: 1.2
```

so a ticked task can be traced to its commits. Each task is ticked once its verification passes, and the run stops to ask when a test fails and cannot be fixed, or a requirement is unclear. Finish the change with `/bk:done` when its tasks are done.

## When the work is done

Finish the unit with `/bk:done`: it checks the tests and records what was built. See [Finishing a unit](finishing-a-unit.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-start`, `/bk-approve`, `/bk-build`, `/bk-done`.
