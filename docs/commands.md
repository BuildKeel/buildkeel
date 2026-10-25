# Commands

BuildKeel has 13 commands. They are the same in both modes, and each adapts to the mode of your spec tree: see [The two modes](modes.md).

| Command | What it does | In Antigravity |
|---|---|---|
| [/bk:init](#bkinit) | Sets up BuildKeel in this repository, with a new spec tree or an existing one. | `/bk-init` |
| [/bk:capture](#bkcapture) | Turns what you discussed into a plan: a plain summary, then the artifacts or the change, agreed one by one or all at once. | `/bk-capture` |
| [/bk:new](#bknew) | Drafts an artifact or a change, breaks a parent down into drafts of its children, or records a bug. | `/bk-new` |
| [/bk:approve](#bkapprove) | Approves a draft or a new version after checking it, or a set of drafts in one review. | `/bk-approve` |
| [/bk:start](#bkstart) | Starts work on a unit: checks it is ready, switches to its branch and loads its context. | `/bk-start` |
| [/bk:build](#bkbuild) | Builds what is ready, unit by unit or task by task, after one confirmation. | `/bk-build` |
| [/bk:adhoc](#bkadhoc) | Records a small change as an ad-hoc unit and starts it. | `/bk-adhoc` |
| [/bk:done](#bkdone) | Finishes a unit: checks its tests, then writes its completion record, or archives a change. | `/bk-done` |
| [/bk:status](#bkstatus) | Shows the overview: the tree, work in progress, claims, gaps and what can be started next. | `/bk-status` |
| [/bk:impact](#bkimpact) | Reviews what a change to an approved artifact or a capability spec affects, one suspect at a time. | `/bk-impact` |
| [/bk:onboard](#bkonboard) | Documents code from before BuildKeel, area by area, or moves a Spec-driven tree to Full SDLC. | `/bk-onboard` |
| [/bk:stats](#bkstats) | Shows your own BuildKeel usage over a period, kept on this machine only. | `/bk-stats` |
| [/bk:migrate](#bkmigrate) | Upgrades a spec tree in an older format, in one commit, without touching approved versions. | `/bk-migrate` |

When a command asks you something, the default is listed first: press Enter to take it.

Only you start a command, by typing it. Claude may run `/bk:status` and `/bk:stats` on its own, since they only read; it never starts any other command, even if you ask it to in words, such as "capture it": it asks you to type the command instead. In Claude Code this is enforced; Antigravity has no way to enforce it, so there Claude is told to follow it.

## /bk:init

**What it does.** Sets up BuildKeel in this repository, with a new spec tree or an existing one. It asks one question at a time and lists every file and setting it will add before anything is written.

**What you can type.** The path of an existing spec tree, such as `/bk:init ../payments-specs`. Typed on its own, it asks where the spec tree lives: **In this repository**, **An existing spec tree** or **A new spec repository**, with Claude's recommendation first. For a new spec tree, it then asks for the mode: **Spec-driven** (the default) or **Full SDLC**. Then it asks whether to stamp your own commits.

**In Spec-driven.** There is no process to choose. Setup ends by asking whether to be guided: **Guide me through my first change** (the default) or **Jump right in**.

**In Full SDLC.** It shows the default process as a table, gates included, and asks whether to use it as it is or how your team works, in your own words. Once you have seen the table, the choices are **Set up with this process** (the default), **Change something**, or **Stop, and set up nothing**.

An existing spec tree keeps its own mode and process, and setup names the mode:

```text title="Example output"
The spec tree follows Spec-driven: capability specs say how the system behaves, and each piece of work is a change to them, with no approvals or gates.
```

**More:** [Getting started](getting-started.md#set-up-a-repository), [Setting the mode](modes.md#setting-the-mode).

## /bk:capture

**What it does.** Turns the conversation into a plan. Claude first sums up what it heard in plain words, with the pitfalls raised, then proposes what to draft, then asks the pace: **Step by step** (the default), each artifact shown and agreed before the next, or **All at once**. Nothing is saved until you agree, and Claude invents nothing: each gap is yours to decide.

**What you can type.** Which part of the conversation to capture, such as `/bk:capture the text message reset`. Typed on its own, it captures the whole conversation. After the summary, it asks: **Create the artifacts** (the default), **Change something**, or **Keep talking**.

**In Spec-driven.** Claude reads the capability specs the work touches and proposes one change, as a table of the capabilities it adds or modifies, saying whether it needs a design. The choices are **Looks right** (the default), **Change the plan** and **Keep talking**. Step by step saves the proposal first, which creates the change, then each other file in turn; all at once saves the whole change together. Nothing is approved.

**In Full SDLC.** Claude proposes the artifacts your process needs as a table, level by level, and where the work fits in your tree. The choices are **Looks right** (the default), **Place it somewhere else**, **Change the plan** and **Keep talking**. Step by step goes epic, design document, each story with its test plan, then tasks as one batch. Every artifact stays a draft until it is approved.

**More:** [Drafting with Claude](drafting.md#from-a-conversation), [Drafting in a Spec-driven tree](drafting.md#in-a-spec-driven-tree).

## /bk:new

**What it does.** Drafts one artifact, breaks a parent down into drafts of its children, or records a bug. After each save, Claude tells you what the draft still lacks.

**What you can type.** The type, the parent and what to draft, such as `/bk:new story EP-01`, `/bk:new stories from EP-01` or `/bk:new bug TK-001`. Typed on its own, it asks what to draft, with examples: **Suggest what to draft next** (the default) or **Type what to draft**.

**In Spec-driven.** What you draft is a change, or one file of an open change: `/bk:new change for reset by text message`, `/bk:new spec change for CH-012`. A bug is attached to the change whose work found it, such as `/bk:new bug CH-012`, or stands alone.

**In Full SDLC.** Types are `idea`, `epic`, `story`, `task`, `test-plan`, `design` and `bug`, or your team's own names for its stages and documents. Every draft goes through approval, except a bug, which gets its permanent ID at once.

```text title="Example output"
Created draft EP-01-DD (design document) at epics/EP-01/design/design.md. It is saved; 2 things stand in the way of approval, listed below.
```

**More:** [Drafting with Claude](drafting.md#draft-one-artifact), [Changes](changes.md), [Recording a bug](bugs-and-adhoc.md#recording-a-bug).

## /bk:approve

**What it does.** Checks a draft or a new version, shows what approval will do, and approves it once you confirm. Several drafts, such as a captured plan, can be approved in one review.

**What you can type.** One or more IDs, such as `/bk:approve US-draft-k3x9`, or `/bk:approve US-draft-k3x9@v0 US-draft-k3x9` for a version 0 and its change. Typed on its own, it asks what to approve: **The drafts from this conversation, in one review** (the default, offered only when drafts were saved in this conversation), **Show what is ready to approve** (the default otherwise), or **Type an artifact ID**.

**In Spec-driven.** A Spec-driven tree has no approvals. `/bk:approve` writes nothing, and says so.

**In Full SDLC.** Each artifact goes through the approve gate, gets its permanent number, and is approved with its own record and commit.

```text title="Example output"
Ready to approve user story US-draft-k3x9 "Reset link expires" as v1. Approving will:
- give it its permanent number: the next user story number, US-002 unless someone else approves one first; its directory becomes stories/US-002/
- rewrite references to US-draft-k3x9 in: stories/US-002/test-plan/plan.md
- record it against its parent EP-01@v1
- freeze v1 and record the approval by Jane Doe <jane@example.com>
- commit only those files in the spec repo as "approve: US-002 v1", without pushing
```

**More:** [Approving artifacts](approval.md), [Approving in a Spec-driven tree](approval.md#in-a-spec-driven-tree).

## /bk:start

**What it does.** Starts work on a unit: checks it is ready, switches to its branch, claims it on this machine, makes it the active unit, and loads its context for Claude.

**What you can type.** A unit ID, such as `/bk:start TK-001` or `/bk:start CH-012`. Typed on its own, it asks what to start: **Show what can be started** (the default) or **Type a unit ID**.

**In Spec-driven.** The units are changes, bugs and ad-hoc units. No gate runs: a unit starts unless another working tree on this machine holds it. A change's branch comes from its ID and title, such as `bk/CH-002-reset-links-expire`.

**In Full SDLC.** The units are tasks, stories built without tasks, bugs and ad-hoc units. The start gate checks that the unit, everything above it and the documents your process requires are approved, and that none of them is suspect.

```text title="Example output"
Ready to start (2):
- BUG-001 bug "Reset link expires early"
- TK-001 task "Reset endpoint"

Not ready yet (1):
- TK-002 task "Reset email": The test plan US-001-TP is not approved.
```

**More:** [Working on a unit](working-on-a-unit.md#start-a-unit), [Working in a Spec-driven tree](working-on-a-unit.md#in-a-spec-driven-tree).

## /bk:build

**What it does.** Builds what is ready, one piece after another, after you confirm once. The run stops and asks you when a test keeps failing or a requirement is unclear.

**What you can type.** A parent ID, such as `/bk:build US-001` to build its tasks, or `/bk:build EP-01`. Typed on its own, it asks what to build: **Everything that is ready** (the default) or **Only what is under one story or epic**. Before the run, it shows the list and asks: **Build them** (the default), **Change the list**, or **Stop**.

**In Spec-driven.** A run builds one change's unticked tasks, in order, on the change's branch, ticking each once its verification passes. With no change named or active, it asks: **Show what can be started** (the default) or **Type a change ID**. It does not finish the change: it offers `/bk:done`.

**In Full SDLC.** Each ready unit is started, built, tested and finished in turn, with its own branch, stacked on the one before, and its own completion record.

**More:** [Build everything that is ready](working-on-a-unit.md#build-everything-that-is-ready), [Building a change's tasks](working-on-a-unit.md#building-a-changes-tasks).

## /bk:adhoc

**What it does.** Records a small change that belongs to no planned work as an ad-hoc unit, and starts it. It needs no approval: it gets its permanent ID at once, and its commits carry it.

**What you can type.** The change, such as `/bk:adhoc "Fix the footer link"`. Typed on its own, it asks what the change is: **The change we were just discussing** (the default, offered only when the conversation names one) or **Type a short description**.

The same in both modes.

```text title="Example output"
Created ad-hoc unit AH-002 "Fix the footer link" at adhoc/AH-002/adhoc.md.
- Committed alone as "new: AH-002" (5e2b7c1) in the spec repo.
- Not pushed: push the spec repo to share it.

Start it with /bk:start AH-002.
```

**More:** [Bugs and ad-hoc units](bugs-and-adhoc.md#recording-one-directly).

## /bk:done

**What it does.** Finishes a unit with you. It checks the unit without writing anything, shows what finishing will record, and writes the record only once you confirm.

**What you can type.** An ID, such as `/bk:done TK-001`, `/bk:done US-001` for a story built through tasks, or `/bk:done CH-002`. Typed on its own, it asks what to finish: **The active unit in this working tree** (the default) or **Another unit, or a story or epic whose work is all done**. Then it asks: **Finish TK-001** (the default) or **Stop, and do not finish yet**.

**In Spec-driven.** Finishing a change archives it: its spec changes are merged, and each capability it touches gets its next version. Claude reviews the code against the change first, and you choose **Fix first** or **Finish anyway**. Nothing blocks the finish but uncommitted work. A change need not be the active unit.

**In Full SDLC.** The done gate checks the unit's tests and its branch. A story or an epic is finished once every unit under it is done and its own test cases pass.

```text title="Example output"
TK-001 "Reset endpoint" v1 can be finished. Finishing will:
- write its completion record in the spec tree, built against US-001@v1, EP-01@v1, BI-01@v1
- commit only that file in the spec repo as "done: TK-001 v1", without pushing
- release its claim on this machine and clear the active unit here; the code branch is left as it is
```

**More:** [Finish with /bk:done](finishing-a-unit.md#finish-with-bkdone), [Finishing a change](finishing-a-unit.md#finishing-a-change).

## /bk:status

**What it does.** Shows where everything stands: the tree with each artifact's state, the work in progress, claims, what is missing, what is not shared yet, and what can be started next. It changes nothing.

**What you can type.** Nothing: `/bk:status` takes no arguments and asks nothing first.

**In Spec-driven.** The overview is about changes and capability specs: open changes with their progress, capability specs at their version in force, and scenarios with no tagged test. When a change is active, it offers to review it: **Review CH-002 now** (the default) or **Not now**. The review writes nothing.

**In Full SDLC.** The overview shows the tree of stages, coverage gaps, documents still needed, suspects and approvals not pushed.

```text title="Example output"
BuildKeel status: Payments, spec tree /home/ana/payments-specs (format 1)
In short: TK-001 is in progress here; 3 units are ready to start; 1 gap in coverage or required documents; 1 approval not pushed; 1 commit with no unit.

Active unit here: TK-001 task "Reset endpoint" on branch bk/TK-001-reset-endpoint.
Spec repo: up to date at the last check (2026-10-01T09:00:00Z). Not pushed yet: 1 approval; push the spec repo to share it.
```

**More:** [The status overview](status.md), [The overview in a Spec-driven tree](status.md#in-a-spec-driven-tree).

## /bk:impact

**What it does.** Shows what a change makes suspect: work and tests built against an older version of something that has changed since. Claude goes through each suspect with you and records only what you decide: still valid, or needs change.

**What you can type.** An ID, such as `/bk:impact US-001` to preview what approving its new version would affect, or `/bk:impact US-001-TC2` to review one suspect. Typed on its own, it asks what to review: **Every suspect** (the default) or **Type an ID**.

**In Spec-driven.** Suspects are tests tagged with a scenario, and archived changes, built against a requirement a later capability version modified or removed. `/bk:impact CH-002` previews what archiving an open change would make suspect. Needs change adds a task to revisit it. Suspects never block anything.

**In Full SDLC.** A suspect is a task, story, epic, bug or test case. Needs change opens its next version as a draft, and a suspect stops work from starting until it is decided.

```text title="Example output"
2 items are suspect: built against an older version of something that has changed since in what they rely on.

US-001 "Request a reset link", from v1 to v2:
- US-001-AC2 changed
  was: - **US-001-AC2** The link expires after 30 minutes.
  now: - **US-001-AC2** The link expires after 15 minutes.
- US-001-AC3 added
  now: - **US-001-AC3** A used link cannot be used again.
Suspect (2):
1. Task TK-001 "Reset endpoint": any change to US-001 affects it.
   Finished (tasks/TK-001/completions/20261001T120000Z-sam.yaml): 1 commit in payments-api: a1b2c3d Add the reset endpoint.
   Files: src/reset/endpoint.ts, test/reset.test.ts.
2. Test case US-001-TC2 "Link expires" in US-001-TP v1: covers US-001-AC2.
```

**More:** [Reviewing suspects](change-impact.md#reviewing-suspects), [Change impact in a Spec-driven tree](change-impact.md#in-a-spec-driven-tree).

## /bk:onboard

**What it does.** Documents code that existed before BuildKeel, one area at a time. Claude maps the code into areas and drafts each one from the code and what you bring; you correct, complete and confirm it. You can stop after any area and carry on later.

**What you can type.** An area to onboard, such as `/bk:onboard Billing`. Typed on its own, it shows where onboarding stands and asks what to do. With no map yet: **Map the code** (the default), **Fill in what onboarding left empty** (only when something was), or **Stop**. With a map: **Continue with an area**, **Adjust the map**, **Fill in what onboarding left empty** or **Stop**.

**In Spec-driven.** Each area is documented as capability specs, version 0, each saved once you confirm it. Here you can also ask to move the tree to Full SDLC, once no change is open. The move is one way.

**In Full SDLC.** Each area is drafted as version 0 of every stage from the business idea down to the story, and its drafts are approved in one review. Then Claude matches the existing tests to the new test cases.

```text title="Example output"
Onboarding: 1 of 3 areas onboarded, from the map in onboarding/map.yaml.

| Area | Paths | Where it stands |
|---|---|---|
| Password reset | src/reset/ | onboarded: 2 of 2 files described |
| Billing | src/billing/ | not started: its one file is not described |
| Accounts | src/accounts/ | partly done: 1 of 2 files described |

Next area: Billing.
```

**More:** [Documenting existing code](onboarding.md#area-by-area), [Onboarding in a Spec-driven tree](onboarding.md#in-a-spec-driven-tree), [Moving to Full SDLC](onboarding.md#moving-a-spec-driven-tree-to-full-sdlc).

## /bk:stats

**What it does.** Shows your own use of BuildKeel in this spec tree over a period, from a record kept on your machine. Nothing is sent anywhere.

**What you can type.** A number of days, such as `/bk:stats 7`, or `off`, `on`, `delete` or `export` to change the record. Typed on its own, it asks for the period: **The last 30 days** (the default), **The last 7 days**, **All of it**, or **Change the record**.

**In Spec-driven.** It counts changes and what finishing them reported, in place of gate figures.

**In Full SDLC.** It counts units finished, the time to done, what the gates caught and the suspects decided.

```text title="Example output"
In the last 30 days (since 2026-09-02): 4 units finished, the gates stopped work 4 times and caught 3 coverage gaps, and 3 suspects were decided.
Recorded on this machine only, for Payments; nothing is sent anywhere.

Units finished: 4 (task 3, ad-hoc unit 1).
Recorded as ad-hoc units: 1 of 4 (25%).
Time from start to done: 1 h 3 min typically (the median), 2 h 30 min at the longest.
```

**More:** [Your usage](usage-stats.md#see-it), [Usage in a Spec-driven tree](usage-stats.md#in-a-spec-driven-tree).

## /bk:migrate

**What it does.** Upgrades a spec tree in an older format to the one this version of BuildKeel uses, in one commit you can review. Approved versions and records are left exactly as they are.

**What you can type.** Nothing: `/bk:migrate` takes no arguments. It shows what migrating changes, then asks: **Migrate** (the default) or **Not now**.

The same in both modes.

```text title="Example output"
The spec tree is already in format 1, the one this version of BuildKeel uses; there is nothing to migrate.
```

**More:** [Migrating a spec tree](migration.md#migrate-it).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-init`, `/bk-capture`, `/bk-new`, `/bk-approve`, `/bk-start`, `/bk-build`, `/bk-adhoc`, `/bk-done`, `/bk-status`, `/bk-impact`, `/bk-onboard`, `/bk-stats`, `/bk-migrate`.
