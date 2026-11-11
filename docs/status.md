# Status and usage

`/bk:status` shows where everything in the spec tree stands, and `/bk:stats` shows your own use of BuildKeel over a period. This page shows how to use both, then explains what each section of the overview shows and what the usage record holds.

## 1. See the overview

The overview shows the tree with each artifact's state, the work in progress, what is missing, what is not shared yet, and what can be started next. It changes nothing.

1. Open Claude Code or Antigravity in your repository.
2. Run `/bk:status`.

   ```text title="/bk:status"
   BuildKeel status: Payments, spec tree /home/ana/payments-specs (format 4)
   In short: TK-001 is in progress here; 3 units are ready to start; 1 gap in coverage or required documents; 1 approval not pushed; 1 commit with no unit.

   Active unit here: TK-001 task "Reset endpoint" on branch bk/TK-001-reset-endpoint.
   Spec repo: up to date at the last check (2026-10-01T09:00:00Z). Not pushed yet: 1 approval; push the spec repo to share it.

   AH-001 ad-hoc unit "Fix typo in reset email": open
   BI-01 business idea "Self-service account recovery": approved v1
     EP-01 epic "Password reset": approved v1
       EP-01-DD design document: approved v1
       US-001 user story "Request a reset link": approved v1
         TK-001 task "Reset endpoint": approved v1 · in progress here
           DEF-001 defect "Reset link expires early": open
         US-001-TP test plan: approved v1
       US-002 user story "Reset by text message": approved v1 · no test plan

   Claims on this machine (1):
   - TK-001: this working tree, branch bk/TK-001-reset-endpoint, since 2026-10-01T09:05:00Z
   A claim is released when its unit is finished. One whose work has stopped can be released sooner, on request.

   Coverage gaps:
   - US-002 user story "Reset by text message" has no test plan, so no work under it can start.

   Defects: 1 open, 0 done.
   - DEF-001 "Reset link expires early": in TK-001, found while building

   Ad-hoc work: 1 open ad-hoc unit, 0 done.
   - AH-001 "Fix typo in reset email"

   Commits with no unit, after each repo's baseline:
   - payments-api: 1 commit: 3f9c2e1 "Quick fix"

   Ready to start (3):
   - TK-001 task "Reset endpoint": the active unit here
   - AH-001 ad-hoc unit "Fix typo in reset email"
   - DEF-001 defect "Reset link expires early"
   Not ready yet: 1; /bk:build lists them with the reason.

   How this repository is set up (the mode, the process and its gates, the templates): /bk:settings.
   ```

   An example from a Full SDLC tree. Sections with nothing to report are left out. A Spec-driven tree shows changes and capability specs instead: see [In a Spec-driven tree](#in-a-spec-driven-tree).
3. Read the line under the title first: it says what it all comes to.
4. Follow the fix shown under any problem or file changed outside BuildKeel.

## 2. Release a claim

A claim stops other working trees on this machine from starting a unit. It is released when its unit is finished. If the work on a unit has stopped, you can release it sooner.

1. Run `/bk:status` and find the unit under **Claims on this machine**.
2. Ask Claude to release its claim, such as "release the claim on TK-001".

Any working tree can then start the unit, and it is no longer the active unit in the working tree that held it. Its branch and commits stay as they are.

## 3. See your usage

BuildKeel keeps a record of how you use it, on your own machine, so you can see what the process did for you: what you finished, how long it took, and what the checks caught along the way.

1. Run `/bk:stats`.
2. Choose a period: the last 30 days (press Enter), the last 7 days, or all of it. You can also give a number of days: `/bk:stats 90`.

   ```text title="/bk:stats"
   In the last 30 days (since 2026-09-02): 4 units finished, the gates stopped work 4 times and caught 3 coverage gaps, and 3 suspects were decided.
   Recorded on this machine only, for Payments; nothing is sent anywhere.

   Units finished: 4 (task 3, ad-hoc unit 1).
   Recorded as ad-hoc units: 1 of 4 (25%).
   Time from start to done: 1 h 3 min typically (the median), 2 h 30 min at the longest.

   | Gate | Passed | Warned | Blocked |
   |---|---|---|---|
   | approve | 9 | 0 | 1 |
   | start | 4 | 0 | 2 |
   | done | 4 | 0 | 1 |

   Coverage gaps caught by a gate: 3.
   Suspects: 3 raised; 2 kept as still valid, 1 needing change.
   Drafts: 11 created (8 captured from a conversation); 9 approvals.
   Context loaded for a unit 14 times; 2 units started in a build run.
   ```

   An example from a Full SDLC tree. Before anything is recorded, `/bk:stats` says there is nothing to show yet.

What each figure means:

- **Units finished**, by type, and the share recorded as ad-hoc units.
- **Time from start to done**: from starting a unit to finishing it.
- **Gates**: how often each one let work through, warned, or stopped it. A gate that stopped an approval, a start or a finish caught something before it went further.
- **Coverage gaps caught**: acceptance criteria with no test case, found by the approve or start gate.
- **Suspects**: work built against something that changed since, and how each was decided. See [When a requirement changes](change-impact.md).
- **Existing code documented**: once anything has been approved as version 0, how many artifacts, area by area or as work touched the code.

A Spec-driven tree has no gates, so `/bk:stats` shows changes and what finishing them reported instead:

```text title="/bk:stats"
In the last 30 days (since 2026-09-02): 4 changes finished, typically in 1 h 15 min; at finish, 4 findings and 3 untested scenarios were reported, and 1 change was finished anyway; 2 suspects were decided.
Recorded on this machine only, for Accounts; nothing is sent anywhere.

Changes: 6 started, 4 finished, 1 discarded.
Time from start to finish: 1 h 15 min typically (the median), 3 h at the longest.
Reported at finish, over 4 changes: scenario-untested 3, task-names-removed-requirement 1; 3 scenarios with no tagged test; 1 failing scenario.
Finished anyway, with something reported missing: 1 of 4.
Suspects: 2 raised; 1 kept as still valid, 1 needing change.
Defects and ad-hoc units finished: defect 1, ad-hoc unit 1.
Context loaded for a unit 12 times.
Guidance for a first change: turned on 1, turned off 0, completed 1.
```

The findings are those of the consistency and template checks at finish (see [Finish](finishing-a-unit.md)). Claude's review is not counted: it is a judgment, kept only in the change's completion record.

## 4. Turn usage stats off

Recording is on until you turn it off. The setting applies to every spec tree on this machine.

1. Run `/bk:stats` and choose **Change the record**, or run `/bk:stats off`.

Nothing new is recorded, and everything else works as before. What was already recorded stays until you delete it. To start recording again, run `/bk:stats on`.

## 5. Delete or export usage stats

You can delete the record, or write it to a file of your own.

1. To delete it, run `/bk:stats delete`.
2. Confirm when Claude asks.

   This deletes the usage record of every spec tree on this machine. It cannot be undone. Whether recording is on or off stays as it was.
3. To export it instead, run `/bk:stats export`.
4. Give the file to write, such as `~/buildkeel-usage.jsonl`.

   The export holds this spec tree's record: one JSON line per event, with IDs, types, outcomes and times, and no artifact text or code.

## What the overview shows

### In short

One line under the title with what it all comes to: the unit in progress here, how many units are ready to start, and anything that needs attention, such as suspects, gaps in coverage or required documents, records not pushed, commits with no unit, or records changed outside BuildKeel.

### The active unit and the spec repo

- **Active unit here**: the unit this working tree is working on, and its branch; or that you chose to work without a unit here, and since when.
- **Spec tree settings not committed**: the spec tree's `buildkeel.yaml` or templates have changes nobody committed, such as after `/bk:init`. BuildKeel never commits them itself; commit them on their own, so everyone works to the same process and templates.
- **Spec repo**: how the spec tree compared with its remote at the last check, which BuildKeel makes in the background when a session starts, and the approvals and completion records committed but not pushed yet. A unit's branch that has no remote branch of its own is compared with the remote's default branch, such as `origin/main`; only commits that change the spec tree count.

### Warnings

What the spec tree's own setup gives up. Today that is a test plan template that makes the `covers` line optional: a test case without one is never marked suspect when what it tests changes, and counts toward no criterion. See [Tests and traceability](test-plans.md).

### The tree

Every artifact, in its hierarchy, with its state:

| State | Meaning |
|---|---|
| `draft` | Never approved. |
| `approved v2` | Version 2 is approved and in force. |
| `approved v1, v2 in draft` | Version 1 is in force; a change is being drafted. |
| `recorded v2` | A task's own test plan: version 2 is in force, recorded as it was saved, with no approval (see [Tests and traceability](test-plans.md)). |
| `approved v0 (code as it was before BuildKeel, reviewed by Ana Lima on 2026-10-03)` | [Version 0](how-full-sdlc-works.md#version-0) is in force: it describes code that existed before BuildKeel, and counts as done. |
| `v0 in draft` | A version 0 is drafted and waits for approval. |
| `approved, number pending` | Approved while the number counter could not be reached; it gets its number the next time it can. |
| `open`, `done on 2026-10-01` | For ad-hoc units and defects found while building, which are never approved. A reported defect shows its approval state like any artifact. |
| `closed on 2026-10-15 as a duplicate of DEF-001` | A defect closed without a fix, with its reason and any note. It counts as done. See [Small fixes, defects and spikes](defects-and-adhoc.md). |

After the state, the work on it:

- **in progress here**, or **in progress in** another working tree on this machine, while a unit is claimed;
- **done on** a date, once it is finished at its version in force;
- **no** followed by a document's name, such as **no test plan** or **no design document**, for an approved artifact that lacks a document your process requires of it.

### Claims

The units claimed by working trees on this machine, with each one's branch and since when. A claim is released when its unit is finished, or sooner on request: see [Release a claim](#2-release-a-claim).

### Gaps, suspects and pending numbers

- **Coverage gaps**: approved stories that have no test plan, a test plan that is not approved yet, or a test plan that leaves acceptance criteria uncovered, including criteria added by a newer version of the story. No work under such a story can start.
- **Documents still needed**: approved artifacts that lack a document your process requires of them, other than a test plan, or whose document is not approved yet, such as an epic with no design document. No work under such an artifact can start. See [Process: stages, kinds and documents](process-and-templates.md).
- **Suspect**: artifacts and test cases built against an older version of something that has changed since, in what they rely on: a task whose story has a new version, a test case whose criterion changed, a unit whose epic's design document changed since it was started, or an epic linked to another epic that changed. Each line says which versions differ and what changed. A suspect is marked in the tree too, and no work under it can start until someone decides whether it is still valid or needs change; see [When a requirement changes](change-impact.md).
- **Approved under earlier rules**: approved artifacts that do not follow a template or process changed since they were approved, such as a story approved before the team required a "Risks" section, or one approved under an epic before a capability stage was added. They stay approved, and each is checked against the current rules when its next version is approved. Validation lists what each one lacks; see [Templates](templates.md).
- **Numbers pending**: approvals recorded while the number counter could not be reached. They get their numbers the next time it can be; approving one again tries straight away.
- **Defects**: how many defects are open, done and closed without a fix; each open one with its parent and where it came from, found while building or reported, and whether it waits for approval or is in progress; and each closed one with its reason. **Ad-hoc work**: open ad-hoc units, and how many are done. See [Small fixes, defects and spikes](defects-and-adhoc.md).

### Commits with no unit

Commits in each code repository on this machine that carry no `BuildKeel-Unit` line and are not on a unit's branch: work that bypassed a unit. Only commits after the repository's **baseline** count, the commit recorded when BuildKeel was set up, so years of history before it are never reported. A commit that changes only the `.buildkeel.yaml` pointer file and `.gitignore` is setting BuildKeel up, not work, and is left out. If a baseline is not in the repository's history, the overview says so, and every commit counts. Registered repositories that are not on this machine are named as not checked.

### Existing code

Once any code from before BuildKeel is documented, with a version 0 or a map of areas, this section shows how much of the code in this repository something describes:

```text
Existing code (payments-api):
- Described: 38 of 152 files (25%), by the paths artifacts cover and the commits of their work; tests and the spec tree are left out.
- Areas: 2 of 6 areas onboarded, from the map in onboarding/map.yaml; next: Billing.
- Tests: 14 of 20 onboarded test cases (70%) have a test, tagged or matched; 3 tests in the latest report match no test case.
```

The **Areas** line appears once there is a map of areas, and the **Tests** line once a test plan has a version 0 (see [Start on existing code](onboarding.md)). Two more lines appear when there is something to say: **Tickets**, once the tickets onboarding read are recorded on the map, such as `- Tickets: 12 read, 9 carried over, 3 left out (2 open, 1 by choice).`, and **Questions left open**, while a version 0 draft keeps one. A file is described when an approved artifact's `scope` covers it, or when the commits of a unit changed it, including the commits from before BuildKeel found for onboarded work by its tracker key. The files counted are those tracked in git, leaving out tests, the spec tree when it is kept in the repository, and the `.buildkeel.yaml` pointer file and `.gitignore`. Nothing here needs attention, so it is never in the line under the title, and it never appears in the session report. To find what describes particular files, ask Claude, such as "what describes src/reset/token.ts?".

### Changed outside BuildKeel

BuildKeel cannot stop changes made with other tools, so it reports them:

- an approved version whose frozen copy no longer matches the hash in its approval record;
- an approval, completion or other record with uncommitted changes, or changed by a commit after it was written.

```text
Changed outside BuildKeel:
- US-001 v1 was altered after approval: stories/US-001/versions/v1.md no longer matches the hash in stories/US-001/approvals/v1.yaml.
  To fix: Restore stories/US-001/versions/v1.md from git history. To change US-001, save a new version as a draft and approve it.
```

Validation reports the same. See [Records and the audit trail](records.md).

### Work that continues

Seven sections, in both modes:

- **Paused:** units and changes paused with `/bk:pause`, the most recent first, each with who paused it, when, and its next step. See [Pause, resume and hand over](pausing-and-resuming.md).
- **Open threads:** explorations kept as threads, not yet captured or dropped.
- **Missing red runs:** the active unit's test cases whose tests never failed before their code, with no exception stated. See [TDD evidence](tdd.md).
- **Open review findings:** High and Medium findings not yet fixed, parked or rejected, on any unit or change. See [Reviews and the fix loop](reviews.md).
- **Learning loop:** patterns that recur in the records, such as a file three defects changed, each with the records behind it and what Claude proposes for it, saved only with your agreement. See [The Learning loop](learning-loop.md).
- **Spike branches:** the `spike/` branches still around. BuildKeel never merges or deletes them: keep, delete or take from each as you decide, and build what you take through a unit. See [Small fixes, defects and spikes](defects-and-adhoc.md).
- **Finished tasks with no Build-ready lines:** when Build-ready tasks was turned on after tasks were finished, how many have no as-built record yet. See [Build](working-on-a-unit.md).

### Ready to start, and your settings

The units that can be started now, the active unit first. `/bk:build` lists the ones that are not ready yet, each with the reason. The last line names `/bk:settings`, which shows how the repository is set up: the mode, the process and its gates, and the templates. See [Change your configuration](configuration.md).

## In a Spec-driven tree

In a Spec-driven tree, the overview is about changes and capability specs:

```text title="/bk:status"
BuildKeel status: Accounts, Spec-driven spec tree /home/ana/accounts-specs (format 4)
In short: CH-002 is in progress here; 2 open changes; 2 findings in open changes; 4 scenarios with no tagged test; 1 failing; commits with no unit.

Active unit here: CH-002 "Reset links expire" (change) on branch bk/CH-002-reset-links-expire.
Spec repo: up to date at the last check (2026-10-01T09:00:00Z).

Open changes (2):
- CH-002 "Reset links expire": 1 of 3 tasks done; proposal, spec change AUTH, design, tasks · in progress here
  - scenario AUTH-R2-S1 "Registered address" has no tagged test.
- CH-003 "Remember devices": 1 of 2 tasks done; proposal, spec change AUTH, tasks
  - scenario AUTH-R1-S1 "Correct password" has no tagged test.

Capability specs (2):
- AUTH "Authentication" v1, written by CH-001; open changes to it: CH-002, CH-003
- NOTIF "Notifications" v1, written by CH-001

Claims on this machine (1):
- CH-002: this working tree, branch bk/CH-002-reset-links-expire, since 2026-10-14T09:12:40Z

Scenarios: 5, 1 with a tagged test (local results in this working tree).
- No tagged test (4): AUTH-R1-S1, AUTH-R1-S2, AUTH-R2-S1, NOTIF-R1-S1
- Failing (1): AUTH-R3-S1

Defects: 1 open, 0 done.
- DEF-001 "Reset email lands in spam": standalone, reported

Ad-hoc work: 1 open, 0 done.
- AH-001 "Fix typo in sign-in page"

Commits with no unit, after each repo's baseline:
- accounts-api: its baseline 4f2a9c1 is not in its history, so every commit counts.
- accounts-api: 1 commit: e41b7d2 "Initial commit"

Ready to start (4):
- CH-002 "Reset links expire" (change, 1 of 3 tasks done): the active unit here
- CH-003 "Remember devices" (change, 1 of 2 tasks done)
- AH-001 ad-hoc unit "Fix typo in sign-in page"
- DEF-001 defect "Reset email lands in spam"

Offer to review CH-002 now, with fresh reviewers as /bk:review does: they judge its code against its requirements, scenarios and design, and their findings are recorded on the change. It finishes nothing: do not finish it unless the user asks.

How this repository is set up (the mode, the numbering, the templates): /bk:settings.
```

- **Open changes**: each with its progress, its files, whether it is in progress here or in another working tree, and what the consistency check finds in it (see [The spec tree and its artifacts](spec-tree.md#what-buildkeel-checks-in-a-change)). Archived and discarded changes are counted below them.
- **Capability specs**: each at its version in force, the change that wrote it, and the open changes that alter it.
- **Scenarios**: how many have a tagged test, then those with none (the gaps), those whose test fails, and those whose result is stale. Results are this working tree's. None of these ever stops anything.
- **Suspect**: tests, archived changes and open defects linked to a requirement, built against a capability version that a later one changed where they rely on it. See [When a requirement changes](change-impact.md).
- **Defects**: each open one with what it is linked to (its change, the requirement it affects, or standalone) and where it came from, and those closed without a fix, with their reason. **Ad-hoc work**: the open ones.
- **Commits with no unit**, as above, and the **commits of discarded changes**, with the reason each was discarded.
- **Changed outside BuildKeel**: a capability version, or a file of an archived change, edited after it was written.
- **Ready to start**: open changes, defects and ad-hoc units. No gate applies.

When a change is active, Claude offers to review it with fresh reviewers, as `/bk:review` does: the same review as finishing (see [Reviews and the fix loop](reviews.md)), with the findings recorded on the change and nothing finished.

## What usage stats record

One line for each of these, with the IDs, types, outcomes and time, and the coding agent it happened in:

- a draft created, and whether it came from a captured conversation;
- an approval;
- a gate's outcome, with the names of the checks that failed, such as `test-plan-gap`: every time a gate stops something, and a pass or a warning when the work goes ahead;
- a unit started, and whether a build run started it; a unit finished, with how long it took;
- something becoming suspect, and the decision on it;
- a unit's context loaded;
- an ad-hoc unit or a defect recorded;
- an artifact approved as version 0, and an onboarding map written.

In a Spec-driven tree, also:

- a change started, finished or discarded, with how long it took;
- what finishing a change reported: the findings by kind, such as `scenario-untested`, how many scenarios had no tagged test or a failing one, and whether you finished it anyway;
- the guide for a first change turned on, turned off, or completed.

The text of your requirements, designs, tests and code is never recorded, nor a change's review or the reason it was discarded.

The record is kept in `~/.buildkeel/usage/`, one file per spec tree, outside every repository. It is never committed or pushed with your work, never shared with your team, and BuildKeel sends nothing anywhere: each person sees only their own usage, on their own machine.

**More:** [Records and the audit trail](records.md), [The Learning loop](learning-loop.md), [When a requirement changes](change-impact.md), [Feature switches](settings.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-status`, `/bk-stats`.
