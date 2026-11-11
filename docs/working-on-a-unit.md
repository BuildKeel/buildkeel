# Build

A unit is a piece of work that code changes belong to: a task, a story built without tasks, a defect or an ad-hoc unit, and in a Spec-driven tree a change. You start one with `/bk:build` before changing code, and Claude builds it, in fresh agents or in your conversation, with its requirements and tests in view.

## 1. Start a unit

Start the unit you want to build, or let Claude list what can be started.

1. Run `/bk:build` with the unit's ID.

   ```
   /bk:build TK-001
   ```

   In a Spec-driven tree, name a change the same way, such as `/bk:build CH-002`.
2. Or run `/bk:build` on its own, and choose **The active unit** (the default, when there is one), **Show what can be started**, or **Type an ID or describe the change**.

   ```text title="Show what can be started"
   Ready to start (2):
   - DEF-001 defect "Reset link expires early"
   - TK-001 task "Reset endpoint"

   Not ready yet (1):
   - TK-002 task "Reset email": The test plan US-001-TP is not approved.
   ```

   Units paused with `/bk:pause` are listed first, to resume, and finished units are listed under **Done**.
3. Or describe the work in words, such as `/bk:build fix the footer link`, and pick what Claude offers.
4. If you have uncommitted changes, choose what to do with them: commit them to the active unit, set them aside, or leave them and not start. See [Uncommitted changes](#uncommitted-changes).
5. Read what Claude says it would build.

`/bk:build` starts the unit when it is not started yet. When the unit is already active, it is not started again: Claude goes on from its context. If the start is refused, every reason is listed with what to do; see [What must be true to start](#what-must-be-true-to-start).

### Words in place of an ID

Claude compares your words with the titles of the units that can start and, in a Spec-driven tree, of the open changes. When one matches, Claude offers it by its ID and title, such as **Build CH-001 "Download historical market data"**. When nothing matches, it offers to record an ad-hoc unit with a title made from your words, then starts and builds it (see [Small fixes, defects and spikes](defects-and-adhoc.md)). Nothing is started until you choose.

### What starting does

1. It checks that the unit is ready (see [What must be true to start](#what-must-be-true-to-start)).
2. It switches to the unit's branch, `bk/<ID>-<title>`, such as `bk/TK-001-reset-endpoint`, or `bk/CH-002-reset-links-expire` for a change (see [Its branch](#its-branch)).
3. It claims the unit on this machine, so another working tree cannot start it too.
4. It makes it the **active unit** of this working tree.
5. It loads its context for Claude (see [The context Claude receives](#the-context-claude-receives)).
6. It refreshes the read-only copy of the glossary, practices and ADRs in the code repository, when it has changed, in a commit of its own (see [The playbook](glossary-practices-adrs.md)).

Building a paused unit resumes it with its brief. One paused by someone else, or on another machine, is resumed only once you confirm taking it over (see [Pause, resume and hand over](pausing-and-resuming.md)).

## 2. Choose fresh agents or here

Once the unit is started, Claude shows what it would build and asks, in plain text, how far to go.

1. Read what it would build: a unit's acceptance criteria and test cases, a change's unticked tasks with how each is verified, or the ready units under a parent.
2. Choose one:
   - **Build them all, each in a fresh agent**: the default when the session can start agents. Each task is built by a fresh agent given only its own context, then reviewed by fresh reviewers, with this conversation running the build.
   - **Build them all here**: the default when the team sets `runs.build: here`, or when the session cannot start agents, with the reason. Claude builds, tests and commits everything in turn, in this conversation. A single unit is offered as **Build it**.
   - **Build the next one only**: Claude builds the first, then stops and names the next.
   - **Set it up and work together**: the unit is active on its branch with its context loaded, nothing is built, and Claude asks how you want to begin.
3. For a single task, ask Claude to build it in a fresh agent if you want one.

When a change's tasks are all ticked already, Claude says so and that you can finish it with `/bk:done`. In Full SDLC, when some ready tasks are independent of each other, Claude also offers to build them at the same time (see [Parallel runs](#parallel-runs)).

### Fresh agents

A fresh agent is a separate agent that starts with only one task's context, does the work, and reports back. Your conversation stays in charge of the run: it starts each agent, checks what it did, has the task reviewed, and finishes it (Full SDLC) or ticks it (Spec-driven). An agent never finishes, ticks or approves anything.

A fresh agent sees only what it needs, so a long run does not fill one conversation, and each task is built without the history of the ones before it. BuildKeel ships its agents with the plugin, for Claude Code and for Antigravity: there is nothing to install or turn on.

The default is **Fresh agent per task**, set with `runs.build` in `buildkeel.yaml`: `fresh-agents` or `here`. It only decides which choice comes first: the other is always offered too. See [Feature switches](settings.md).

Each agent runs as one of ten roles, and you can set a model and effort for each; [Models and effort per role](models.md) covers the roles, the tiers and what Antigravity ignores.

### When agents can't be started

Agents may not start: the session has no tool for starting them, it is turned off in your settings, or the model tier a role names is not available. Every feature that starts agents then follows the same rule:

1. **Claude says why, once,** in a line.
2. **It retries once** when an agent started but failed, before treating agents as unavailable.
3. **It follows the feature's switch.** With `off`, nothing happens. With `ask`, the offer says the check would run here, without a fresh reader. With `auto`, and for the implementer and the reviewers, which have no such switch, Claude does the work here and says so in a line.
4. **It labels the result** as done here, not by an independent agent: in what it shows you, and in the record. A question or a proposal is shown as Claude's own reading.
5. **It never counts where independence is the point.** A final review done here does not satisfy the done gate's review-findings check, so the unit is reported as not independently reviewed.

## 3. Follow the run

Claude builds each task test first, has it reviewed, and stops to ask you only when it must.

1. Watch each task: Claude writes the tests for its test cases and records them failing, commits them, writes the code and runs the tests again (see [TDD evidence](tdd.md)).
2. Read the line Claude gives for each agent's status, and each ruling it makes.
3. Answer when the run stops and asks you one question. Claude gives its recommendation with it.
4. When agreed behavior looks wrong, keep it or change it. A changed behavior is agreed first, and the code follows it.
5. Read the summary at the end: each unit with its branch, commits and record, and the last branch, which holds the whole run.

Built here or in agents, each task is reviewed after it is built, by the reviewers that are on, unless reviews after each task are off. Finishing then reviews only what is new since: see [Reviews and the fix loop](reviews.md).

### When the run stops

The run stops and asks you when a start is refused, a test keeps failing after Claude has tried to fix it, a requirement is unclear, agreed behavior looks wrong, or the work needs a change to what you agreed, such as a requirement or a task's wording, which Claude shows you before saving. Claude never guesses a requirement, and never builds something other than what was agreed. When you change the behavior in Full SDLC, its new versions are drafted and approved before the build goes on (see [Full SDLC mode in depth](how-full-sdlc-works.md)). In Spec-driven, a changed requirement goes through the change first, and the code follows it (see [Spec-driven mode in depth](how-spec-driven-works.md)).

### Questions and rulings

When an agent asks a question, Claude first looks for the answer in the spec, then in the unit's notes and the rulings already made, and, once your tree has them, in the glossary and your team's practices.

- **The answer is there**: Claude answers with it, names where it comes from, and says the ruling to you in a line, such as: "US-001-AC2 says the link expires after 30 minutes." Each later agent in the run is given the ruling too.
- **Nothing answers it**: the run stops and Claude asks you one question, with its recommendation. A requirement is never guessed, by Claude or by the agent.

### What an agent is given

Each agent gets the task's own context, the interfaces the tasks before it built, and the rulings made so far in the run. It does not get the whole plan or your conversation. Claude asks BuildKeel for that view, which starts like this:

```text title="An agent's view"
# Active unit: TK-001 v1 "Reset endpoint"
BI-01 v1 › EP-01 v1 › US-001 v1 › TK-001 v1
Commits: end every message with "BuildKeel-Unit: TK-001".
Tests: put the test case ID in the test's name, such as [TK-001-TC1]. Record each run's JUnit XML report with test_results.
Your part: build this task test first, commit with the line above, and end with your status: finished, finished with concerns, has a question, or blocked. Do not finish the unit, tick a task, approve anything or change the spec tree.
```

Then come the task, why it is wanted, its acceptance criteria with their test cases, and its design, as in [The context Claude receives](#the-context-claude-receives). When a task uses something an earlier task delivered, the view says what that task built, from its `Built:` line, and not what was planned (see [The Built line](#the-built-line)). In a change, the agent gets its one task, not the whole task list.

The agent builds test first, commits with the unit's line, records its test runs, and ends with one status:

- **finished**: the run goes on to the review.
- **finished with concerns**: Claude shows each concern. A concern about what was agreed stops the run and asks you.
- **has a question**: see [Questions and rulings](#questions-and-rulings).
- **blocked**: the run stops, says why, and asks you.

Before the review, Claude checks the agent's work: its commits carry the unit's line, and its test runs are recorded. If an agent cannot be started, Claude follows [When agents can't be started](#when-agents-cant-be-started).

### What a task uses, checked as the run reaches it

Before a run starts, and again before each task, Claude asks BuildKeel for the run's plan. It orders the tasks, each after the tasks it uses, and checks everything each one uses against what is there now: an earlier task's `Built:` line, the file it names, and your project's dependencies.

```text title="The run's plan"
Run of CH-002: 2 tasks to build, in this order: 2.2, 2.3.
- 2.2 Email the code: what it uses is there
  - createResetCode (from 2.1): built differently, built as createResetCode(user: User), in place of createResetCode(userId)
- 2.3 Store the code: something it uses is missing
  - ResetCode (from 2.1): missing, its Built line says ResetCode was not built

Next: 2.2, ready to start. Call this view again before each task: it is checked against what the tasks before it built.
```

Something built differently is given to the agent as it was built, and the run goes on. Something missing stops the run before that task, names it, and asks you how to go on. Tasks that use each other in a loop stop the run before it begins.

### In Full SDLC

Each unit is started, built and finished with its own completion record before the run goes on to the next. Each unit's branch is stacked on the one before, so later units build on the earlier ones' code (see [Its branch](#its-branch)).

### In Spec-driven

`/bk:build` builds the change's unticked tasks, in order, on its branch, once you choose **Build them all** or **Build the next one only**. Each test is named with the scenario it checks, such as `[AUTH-R3-S1]`. A commit that does exactly one task names it too, so a ticked task can be traced to its commits:

```
Refuse reset links older than 30 minutes

BuildKeel-Unit: CH-002
BuildKeel-Task: 1.2
```

Each test is written and seen failing before its code. Each task is ticked once its verification passes, and Claude says so in a line, without asking. Ticking writes the task's [Built line](#the-built-line) and saves a summary of the test runs so far in the change's `runs/` folder. A change's tasks are built one after another. Finish the change with `/bk:done` when its tasks are done.

If you ask in words, such as "let's build the rest now", Claude suggests `/bk:build` once. Say "just go ahead" and it builds the tasks anyway, by the same rules; say "not now" and it builds nothing.

### When the work is done

Finish the unit with `/bk:done`: it checks the tests and records what was built. Claude reminds you when the work looks done: when the last task of a change is ticked, or, in Full SDLC, when every test case of the unit passes and its work is committed. It reminds you again before it pushes, opens a pull request or merges while the unit is unfinished; the command still goes ahead. See [Reminders to finish](finishing-a-unit.md#reminders-to-finish).

## 4. Build everything that is ready

Build every ready unit under a parent in one run, and in Full SDLC build independent tasks at the same time.

1. Run `/bk:build` on its own, or name a story or epic, such as `/bk:build US-001`.

   Claude lists the units ready to start at the lowest level, tasks and stories without tasks, or only those under the parent you name.
2. Choose once how to build them: **Build them all, each in a fresh agent**, **Build them all here**, **Build the next one only**, or **Set it up and work together**.
3. In Full SDLC, accept the offer to build independent tasks at the same time, if Claude makes one.
4. Follow the run as in [3. Follow the run](#3-follow-the-run).
5. If a merge conflicts, tell Claude whether to resolve it.
6. Open one pull request from the run's last branch, or from `bk/run-<parent ID>` after a parallel run, to review the whole run.

### Parallel runs

Parallel runs are for Full SDLC only. In a Spec-driven tree, a change's tasks are built one after another.

Tasks are independent when neither uses what the other delivers, directly or through other tasks, and they list no file in common in their Files. The run's plan says which:

```text title="The run's plan"
Can be built at the same time, up to 3 at once, each in its own worktree: TK-001 and TK-002 and TK-003; then TK-004.
```

Each task gets a worktree of its own, a second checkout of your repository under `.buildkeel/worktrees/`, with the task started there on its own branch. Its agent works only there, and BuildKeel checks its edits against that task:

```text title="Starting a task in its worktree"
Added TK-001's worktree at /home/you/payments-api/.buildkeel/worktrees/TK-001, from this checkout's commit (4abbce1), and started TK-001 there on its branch bk/TK-001-reset-endpoint: it is the active unit there, and claimed by that worktree.
```

The most tasks run at the same time is 3 by default. `1` turns parallel runs off, and a change applies from the next run:

```yaml
process:
  runs:
    parallel: 2
```

### Merging a parallel run

Each task is reviewed and finished on its own branch. Once a batch is finished, the branches are merged, in task order, onto one branch for the run, `bk/run-<parent ID>`, one at a time, with the tests run after each merge. First, BuildKeel compares what each task actually changed:

```text title="Before the merge"
Parallel run of US-001: TK-014 on bk/TK-014-health-check, TK-015 on bk/TK-015-version-endpoint, merged in this order onto bk/run-US-001, which starts from HEAD.
- TK-014 changed src/health.ts, src/routes.ts
- TK-015 changed src/routes.ts, src/version.ts
Changed by more than one task: src/routes.ts (TK-014, TK-015). Their branches may conflict, and the tests after each merge matter more.
Outside the task's Files: src/routes.ts (TK-014); src/routes.ts (TK-015).
```

A conflict undoes the merge and stops the run to ask you:

```text title="A conflict"
Merging TK-015's branch bk/TK-015-version-endpoint onto bk/run-US-001 conflicts in src/routes.ts. The merge was undone, and nothing else was merged.
```

If you tell Claude to resolve it, the merge is left open, only the files in conflict can be changed, and the merge is committed once no conflict marker is left. A failing test after a merge stops the run too. At the end, `bk/run-<parent ID>` holds the whole run, and one pull request from it reviews it all.

## 5. Pick a run up again

A run keeps no progress file of its own. Its ticks, completion records, test runs, reviews and commits are what it is picked up from, after the conversation is compacted or on another machine.

1. Run `/bk:build` again on the same parent or change.

   It goes on from the first task not finished or ticked.

## Before a unit starts

### What must be true to start

- The unit is approved and has its permanent number, and so is everything above it: its story, epic and business idea.
- Neither the unit nor anything above it is suspect: built against an older version of something that has changed since. See [When a requirement changes](change-impact.md).
- Every document your process requires of the unit and of everything above it is approved: by default the epic's design document and the story's test plan, which must cover every acceptance criterion. A task's own test plan needs no approval: it is recorded as it is saved (see [Tests and traceability](test-plans.md)), unless your process approves task plans. See [Process: stages, kinds and documents](process-and-templates.md).
- No other working tree on this machine is working on it.

A story that has tasks is worked on through its tasks. Epics and business ideas are not started at all. Ad-hoc units and defects found while building need no approval and no test plan, but are not started while anything above them is suspect. A reported defect goes through the start gate like any unit: approved first.

A version 0, which describes code as it was before BuildKeel, counts as approved for the work under it (see [Start on existing code](onboarding.md)). A unit whose version in force is version 0 describes work already done, so it is not started itself: changing it starts with its version 1.

When something is missing, nothing changes, and every reason is listed with what to do about it:

```text title="/bk:build TK-001"
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

In a Spec-driven tree, no gate runs: a unit starts unless another working tree on this machine holds it.

### Its branch

If the unit's branch already exists, Claude switches to it. Otherwise the branch starts from where you are, or from your default branch (such as `main`) when you are on another unit's branch, so the new unit does not carry the other unit's commits. Nothing is fetched or pushed.

The exception is a unit that follows one just finished: the next unit of a build run, or the next unit Claude offers after `/bk:done`. Its branch is **stacked** on the finished unit's branch, so it has that work before it is merged:

```text title="A stacked branch"
- Created its branch bk/TK-002-reset-email from bk/TK-001-reset-endpoint. It is stacked on bk/TK-001-reset-endpoint, so it has that unit's work before it is merged; merge the branches in order, or review the run in one pull request from the last branch.
```

Each unit still has its own branch, commits and completion record, and each commit stays linked to the unit it was made for, even on the branches stacked on top. Open one pull request from the last branch to review the whole run, or one per branch, each based on the one before, and merge them in order. A change to an earlier unit after review means rebasing the branches stacked on it, as does merging per-unit pull requests with a squash; one pull request for the run avoids both.

When the spec tree is a folder of your code repository, its approvals live on the branches too. If the unit was approved on another unit's branch and the branch it would switch to does not have those approvals yet, the start is refused, with the approvals that are missing and the branch to merge first, for example through its pull request. Nothing changes until you start again.

### Uncommitted changes

The active unit does not change while you have uncommitted changes, so that every change belongs to exactly one unit. Claude lists the changed files and asks what to do:

- **commit them to the active unit**, with its `BuildKeel-Unit:` line;
- **set them aside** with `git stash`, after you confirm; bring them back with `git stash pop`;
- or leave them and not start.

Your changes are never deleted.

Files that set BuildKeel up are not anyone's work: the `.buildkeel.yaml` pointer, the spec tree's `buildkeel.yaml` and `templates/`, and a `.gitignore` whose only change is BuildKeel's `.buildkeel/` line. When they are uncommitted, as after `/bk:init`, Claude offers to commit them on their own, as setting BuildKeel up, with no `BuildKeel-Unit` line.

### Several units at once

Each git working tree has one active unit. To work on two units at the same time, for example with two agents, give each its own working tree:

```
git worktree add ../payments-api-tk002
```

Each working tree has its own active unit and branch, and commits made in each are stamped with its own unit. A unit claimed in one working tree cannot be started in another on the same machine; removing a working tree releases its claims.

## Build-ready tasks

Every task states four things, so that whoever builds it, Claude or a fresh agent, needs nothing else:

- **Files**: the files it creates, changes and tests, found from the code.
- **Uses**: what it takes from earlier tasks, the existing code or a library, each with where it comes from, in brackets at the end: `(from 1.2)` or `(from TK-011)` for an earlier task, `(from src/auth/tokens.ts)` for a file, `(from twilio 4.23.0)` for a library at the version the project depends on.
- **Delivers**: what it gives later tasks, such as a function's signature, a field or a route.
- **Verify**: the command that checks it, and what must pass, naming the acceptance criteria or scenarios it covers.

A task that uses and delivers nothing writes `Interfaces: none` in place of Uses and Delivers. In Full SDLC these are sections of the task, required by the built-in task template; a team's own task template must keep them, or validation reports it. In a Spec-driven tree they are lines under each checkbox in `tasks.md`:

```markdown
- [ ] 1.1 Add the issue time to reset tokens.
  Files: change src/auth/tokens.ts; test test/auth/tokens.test.ts
  Uses: ResetToken (from src/auth/tokens.ts)
  Delivers: issuedAt on ResetToken
  Verify: npx vitest run test/auth/tokens.test.ts passes for a new and an old token
```

A new or changed task that leaves one out is not saved:

```text title="Saving a task without Verify"
Nothing was saved.
- Task 2.1 does not state Verify. Every task states Files, Uses, Delivers and Verify; Interfaces: none may stand for Uses and Delivers when it uses and delivers nothing.
  To fix: Write each under its checkbox, indented, such as:
- [ ] 2.1 Refuse reset links older than 30 minutes.
  Files: change src/auth/reset.ts; test test/auth/reset.test.ts
  Uses: issuedAt on ResetToken (from 1.1)
  Delivers: isExpired(token: ResetToken, now: Date): boolean
  Verify: npx vitest run test/auth/reset.test.ts, where [AUTH-R3-S1] passes
```

Tasks written before BuildKeel asked for these lines keep working: they are listed for filling in, and never refused for it.

These lines are **Build-ready tasks**, a switch that is on by default. With `planning.build-ready-tasks: off` in `buildkeel.yaml`, tasks are saved without them, no Built line is written, and parallel runs and the readiness check's "shared interface" sign have nothing to work from. See [Feature switches](settings.md).

### Backfilling Build-ready tasks

When Build-ready tasks is turned on in a tree that already has tasks, the tasks from before get their lines:

- **Open tasks**, not built yet or ticked in an open change, get their Files, Uses, Delivers and Verify lines as an ordinary edit, shown and agreed like any other.
- **Finished tasks** are frozen, so they are never edited. Each gets an **as-built record** instead: a new file holding the files and tests its commits changed and what it delivered, labeled as written later.

`/bk:status` says how many finished tasks have neither. Ask Claude to backfill them: it shows each record, says what each task delivered, read from its commits, and writes them in one commit once you agree. Onboarding does the same for the finished tasks it documents, from their linked commits, once their area is approved.

### The Plan check

When tasks are saved, and again in the approval preview in Full SDLC, BuildKeel checks them against each other and against the code: a use that no earlier task delivers, that the named file does not define, or from a library the project does not depend on, or at another version; a use with no source; a file that does not exist and that no task creates; an acceptance criterion or scenario no task's Verify names; a vague line; and tasks that depend on each other in a loop. Each is reported, and none stops a save or an approval:

```text title="The Plan check"
Worth fixing (nothing is blocked):
- Task 1.2: it uses expiresAt from 1.1, which does not deliver it.
  To fix: Add expiresAt to what 1.1 delivers, or name where it really comes from.
- Task 2.1: "Verify: as needed" is vague: say exactly what is done, or how.
- The scenario AUTH-R2-S1 "Registered address" is named in no task's Verify.
  To fix: Name it in the Verify of the task that delivers it, or add a task for it.
```

The Plan check is a switch, on by default; `planning.plan-check: off` turns it off. See [Feature switches](settings.md).

### The Built line

What a task delivers is a plan: whoever builds it may change a signature when the code needs it. When the task is done, BuildKeel checks what it delivers against its last commit and the files its commits changed, and writes a **Built** line:

- **as planned**, naming the commit: everything it delivers is defined there;
- **changed**: what was built in place of the plan, with the reason Claude gives;
- **missing**: something it was to deliver is not there, named;
- **nothing delivered, as planned**, for a task with `Interfaces: none`.

BuildKeel finds definitions by their patterns in 13 languages: TypeScript, JavaScript, Python, Go, Java, Kotlin, C#, Rust, Ruby, PHP, Swift, Scala and Dart. In C and C++ it says "name found" or "name not found" rather than "missing", and in any other language it looks for the name only, the same way. A route or a command, such as `POST /reset`, is looked for by its text. A test file never counts as where something is defined.

In a Spec-driven tree, ticking a task writes its Built line under it in `tasks.md`:

```text title="Ticking a task"
Ticked 1.1 in CH-002 "Reset links expire": 1 of 3 tasks done. BuildKeel leaves the tick uncommitted, as it does the change's files while it is open: finishing the change commits them with its archive.
- 1.1: Built: as planned, checked against 2be0bb9
```

In Full SDLC, `/bk:done` keeps the line in the completion record, and the task's view and context show it beneath what it planned to deliver. Later tasks and reviewers read what was built, not only what was planned.

## What Claude is given

### The context Claude receives

When a unit starts, Claude receives its context: a compact view built from the approved versions of the unit and everything above it. For a task:

```text title="The context of TK-001"
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

## Open defects
- DEF-001 "Reset link expires early" in TK-001

## Linked code: none yet
```

- The unit and its parent appear in full, in their tracked sections. Everything further up appears as one line: its ID, version, title and approved summary.
- The nearest design document, on the unit or above it, usually its epic's, appears under **How it is built**: its summary and the sections work is built on, such as the design, the decisions, and the architecture, data and interfaces when it has them. Other documents attached to the unit or above it, such as a team's own threat model, appear as one line each under **Background**.
- Defects attached to the unit or its parent that are neither finished nor closed are listed under **Open defects**, with the test case that found each one. A defect's own context asks for a regression test tagged with its ID; in a Spec-driven tree, it also shows the change that found it, or the requirement it affects as its version states it, with the tests tagged with its scenarios (see [Small fixes, defects and spikes](defects-and-adhoc.md)).
- Every artifact shows the version the context was built from. When a newer version of a parent is approved, the context shows it at once, with a note that the unit was approved against the older one.
- An artifact at version 0 is marked as describing the code as it was before BuildKeel, with the paths its scope covers, such as `US-E001 v0 describes the code as it was before BuildKeel, in src/reset/.` under **Why**.
- **Glossary terms used here** lists the glossary entries for the terms the unit and the work above it use, and no others.
- **Heads-up notes on these files** gives up to five notes earlier work left about the files the unit will change: working notes of units whose commits changed them, notes for the next person from their completion records, notes on the code, and closed threads that point at them, the most specific and most recent first, each with its source (see [Notes on the code](heads-up-notes.md)).
- A paused unit's context starts with its brief: where things stood, the decisions and dead ends, and the next step (see [Pause, resume and hand over](pausing-and-resuming.md)).
- **Linked code** lists the unit's commits and the files they changed, in every code repository on this machine. For work finished before BuildKeel, these are the commits made before the baseline that name its tracker key, found when its version 0 was approved.
- When a code repository's remote is on GitHub and GitHub's `gh` tool is installed and signed in, the context also names the pull requests that hold the unit's commits, such as `- payments-api: commits 4be1f20 · files src/reset.ts · pull requests #12 "Add the reset endpoint" (merged)`. For other hosts, or without `gh`, it shows the commits and files only.
- The same approved versions always produce exactly the same context. Nothing is summarized on the fly.

Ask Claude to show the context of any unit at any time, such as "show the context of TK-002".

A context view should stay within **10,000 characters**, about 2,500 tokens. A larger one is never cut; it ends with a note saying how large it is, so you can shorten or split the unit. A team can change the budget in `buildkeel.yaml`:

```yaml
settings:
  contextBudget: 15000
```

### A change's context

In a Spec-driven tree, a change's context holds its proposal, every spec change in full, its design and its tasks with their ticks, then each capability it touches at its version in force: the requirements the change touches in full, and the others in a line each. It ends with its open defects and the code linked to it:

```text title="The context of CH-002"
# Active unit: CH-002 "Reset links expire" (change)
Progress: 1 of 3 tasks done.
Commits: end every message with "BuildKeel-Unit: CH-002", and add "BuildKeel-Task: <number>" when the commit does exactly one task.
Tests: put the scenario ID in each test's name, such as [AUTH-R1-S1], one ID per bracket: [AUTH-R1-S1] [AUTH-R2-S1]. Record each run's JUnit XML report with test_results.
Tasks: work through the unticked ones in order, and tick each once its verification passes, with save_draft, type tasks, id CH-002 and tick (its number); say so in a line. Finish with /bk:done.
Keep the change consistent: when you edit one of its files, check the others and propose the follow-on edits, each through the review. Read one file with query (view changes, id CH-002, file); change one requirement with save_draft, type spec-change, its capability and requirement.

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

## Open defects: none

## Linked code: none yet
```

### Staying in scope

While a unit is active, BuildKeel tells Claude when an edit falls outside the areas the unit relates to: the paths in its `scope` field and its story's, and the folders changed by its own commits and by the other work under its story, from their commits and completion records. Claude then checks with you whether the change belongs to the unit:

```text title="An edit outside the unit's areas"
BuildKeel: src/billing/invoice.ts is outside the areas TK-001 relates to so far (src/reset/): its scope and its story's, and what its own work and the other work on its story changed. If the change belongs to TK-001, carry on and tell the user it widens what TK-001 touches. If it belongs to other work, stop and ask the user which unit it belongs to.
```

- Each file is mentioned once, the first time it is changed.
- Tests are never outside the scope, wherever the project keeps them.
- While no area is known, as for the first task under a new story when neither names a scope, nothing is said. The areas grow as the work is committed.
- A story that describes code from before BuildKeel names the paths it covers, so the first task under it is warned about work elsewhere before it has any code of its own.
- In Antigravity, the note reaches the agent right before its next step.

### Sessions

At the start of every session, when a session is resumed, and after Claude Code compacts the conversation, BuildKeel tells Claude only:

- that BuildKeel is set up here, and that the conversation stays free: talk as you would without BuildKeel, and its artifacts, IDs and commands come in only when you run a BuildKeel command or Claude is about to change a file;
- how to discuss: as a thinking partner, laying out options, trade-offs and pitfalls before asking, in prose, with sources for anything it looks up, recommending only what the evidence supports, and never pushing toward a plan. When you say the discussion has reached a point, Claude asks once whether there is more to explore or you are ready for `/bk:capture`, which only you start;
- how to treat the spec tree: show anything in full before saving it to the tree, and never add a requirement on its own; check a problem you report against the spec and its code before recording it, and propose whether it is a defect or a change in behavior; and stop and ask when agreed behavior looks wrong while building;
- the active unit and its branch, followed by its context again, or that no unit is active;
- your team's names for its stages, when your process renames or adds stages;
- to hold the conversation to precise words, against the team's glossary and the code (see [The playbook](glossary-practices-adrs.md));
- what is paused, offered once, and a previous conversation left unsaved, offered once for recovery as a thread (see [Pause, resume and hand over](pausing-and-resuming.md)).

Nothing else is raised at session start, so a question about the code gets a plain answer. Whether the spec tree is behind its remote, what is suspect, and what is not pushed are shown when you start, approve or finish work, and in `/bk:status`.

When you ask Claude to change code and no unit is active, Claude asks how to go on before changing any file: capture what you discussed, by running `/bk:capture` yourself, build the unit the change belongs to with `/bk:build`, record it as an ad-hoc unit, or go ahead without a unit if you say so. If Claude goes to change code anyway, BuildKeel holds the edit until one of these is done (see [Small fixes, defects and spikes](defects-and-adhoc.md)).

BuildKeel checks the edits Claude makes with its file editing tools, and Claude is told to change files only with them. A change made another way, such as through a shell command, escapes these checks; if it is committed without a unit, `/bk:status` lists it under commits with no unit.

Antigravity tells BuildKeel about each step of the agent rather than about sessions, so BuildKeel follows each conversation itself:

- **A new conversation** starts with the same report and the active unit's context, before the agent's first response.
- **Each new message** in a conversation adds only what changed since the last report, such as a unit that was started or finished. When nothing changed, nothing is added. A conversation reopened later keeps its history, so nothing is loaded again.
- **After Antigravity compacts a conversation**, the report and the context come back. BuildKeel sees the compaction in the conversation's record that Antigravity keeps. If that record cannot be read, each new message is reminded of the active unit instead, and the agent loads its context again when it needs it.

What BuildKeel remembers about each conversation is kept in `.buildkeel/conversations/` in the working tree.

### Freshness

When a session starts, BuildKeel fetches the spec repo's remote in the background; the session never waits for it. If the local spec tree is behind, you are told how far when you start, approve or finish work, and starting a unit warns about it but goes ahead. If the fetch fails, for example with no connection, you are told the check could not run, and work continues with your local copy. `/bk:status` always shows where the spec repo stands.

**More:** [Finish](finishing-a-unit.md), [Reviews and the fix loop](reviews.md), [TDD evidence](tdd.md), [Models and effort per role](models.md), [Feature switches](settings.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-build`.
