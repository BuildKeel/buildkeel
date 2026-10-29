# The status overview

`/bk:status` shows where everything stands: the tree with each artifact's state, the work in progress, what is missing, what is not shared yet, and what can be started next. It changes nothing.

```
/bk:status
```

## An example

```
BuildKeel status: Payments, spec tree /home/ana/payments-specs (format 1)
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

Sections with nothing to report are left out.

## What it shows

### In short

One line under the title with what it all comes to: the unit in progress here, how many units are ready to start, and anything that needs attention, such as suspects, gaps in coverage or required documents, records not pushed, commits with no unit, or records changed outside BuildKeel.

### The active unit and the spec repo

- **Active unit here**: the unit this working tree is working on, and its branch; or that you chose to work without a unit here, and since when.
- **Spec tree settings not committed**: the spec tree's `buildkeel.yaml` or templates have changes nobody committed, such as after `/bk:init`. BuildKeel never commits them itself; commit them on their own, so everyone works to the same process and templates.
- **Spec repo**: how the spec tree compared with its remote at the last check, which BuildKeel makes in the background when a session starts, and the approvals and completion records committed but not pushed yet. A unit's branch that has no remote branch of its own is compared with the remote's default branch, such as `origin/main`; only commits that change the spec tree count.

### Warnings

What the spec tree's own setup gives up. Today that is a test plan template that makes the `covers` line optional: a test case without one is never marked suspect when what it tests changes, and counts toward no criterion. See [Process and templates](process-and-templates.md#coverage-declarations).

### The tree

Every artifact, in its hierarchy, with its state:

| State | Meaning |
|---|---|
| `draft` | Never approved. |
| `approved v2` | Version 2 is approved and in force. |
| `approved v1, v2 in draft` | Version 1 is in force; a change is being drafted. |
| `recorded v2` | A task's own test plan: version 2 is in force, recorded as it was saved, with no approval (see [Test plans](test-plans.md#a-tasks-own-plan-is-recorded)). |
| `approved v0 (code as it was before BuildKeel, reviewed by Ana Lima on 2026-10-03)` | [Version 0](approval.md#version-0-code-from-before-buildkeel) is in force: it describes code that existed before BuildKeel, and counts as done. |
| `v0 in draft` | A version 0 is drafted and waits for approval. |
| `approved, number pending` | Approved while the number counter could not be reached; it gets its number the next time it can. |
| `open`, `done on 2026-10-01` | For ad-hoc units and defects found while building, which are never approved. A reported defect shows its approval state like any artifact. |
| `closed on 2026-10-15 as a duplicate of DEF-001` | A defect [closed without a fix](defects-and-adhoc.md#closing-a-defect-without-a-fix), with its reason and any note. It counts as done. |

After the state, the work on it:

- **in progress here**, or **in progress in** another working tree on this machine, while a unit is claimed;
- **done on** a date, once it is finished at its version in force;
- **no** followed by a document's name, such as **no test plan** or **no design document**, for an approved artifact that lacks a document your process requires of it.

### Claims

The units claimed by working trees on this machine, with each one's branch and since when. A claim is released when its unit is finished. If the work on a unit has stopped, ask Claude to release its claim: any working tree can then start it, and it is no longer the active unit in the working tree that held it. Its branch and commits stay as they are.

### Coverage gaps

Approved stories that have no test plan, a test plan that is not approved yet, or a test plan that leaves acceptance criteria uncovered, including criteria added by a newer version of the story. No work under such a story can start.

### Documents still needed

Approved artifacts that lack a document your process requires of them, other than a test plan, or whose document is not approved yet, such as an epic with no design document. No work under such an artifact can start. See [Process and templates](process-and-templates.md#documents-attached-to-a-stage).

### Suspect

Artifacts and test cases built against an older version of something that has changed since, in what they rely on: a task whose story has a new version, a test case whose criterion changed, a unit whose epic's design document changed since it was started, or an epic linked to another epic that changed. Each line says which versions differ and what changed. A suspect is marked in the tree too, and no work under it can start until someone decides whether it is still valid or needs change; see [Change impact](change-impact.md).

### Approved under earlier rules

Approved artifacts that do not follow a template or process changed since they were approved, such as a story approved before the team required a "Risks" section, or one approved under an epic before a capability stage was added. They stay approved, and each is checked against the current rules when its next version is approved. Validation lists what each one lacks; see [Process and templates](process-and-templates.md#changing-a-template).

### Numbers pending

Approvals recorded while the number counter could not be reached. They get their numbers the next time it can be; approving one again tries straight away.

### Defects

How many defects are open, done and closed without a fix; each open one with its parent and where it came from, found while building or reported, and whether it waits for approval or is in progress; and each closed one with its reason. See [Defects and ad-hoc units](defects-and-adhoc.md).

### Ad-hoc work

Open ad-hoc units, and how many are done. See [Defects and ad-hoc units](defects-and-adhoc.md).

### Commits with no unit

Commits in each code repository on this machine that carry no `BuildKeel-Unit` line and are not on a unit's branch: work that bypassed a unit. Only commits after the repository's **baseline** count, the commit recorded when BuildKeel was set up, so years of history before it are never reported. A commit that changes only the `.buildkeel.yaml` pointer file and `.gitignore` is setting BuildKeel up, not work, and is left out. If a baseline is not in the repository's history, the overview says so, and every commit counts. Registered repositories that are not on this machine are named as not checked.

### Existing code

Once any code from before BuildKeel is documented, with a version 0 or a map of areas, this section shows how much of the code in this repository something describes:

```
Existing code (payments-api):
- Described: 38 of 152 files (25%), by the paths artifacts cover and the commits of their work; tests and the spec tree are left out.
- Areas: 2 of 6 areas onboarded, from the map in onboarding/map.yaml; next: Billing.
- Tests: 14 of 20 onboarded test cases (70%) have a test, tagged or matched; 3 tests in the latest report match no test case.
```

The **Areas** line appears once there is a map of areas, and the **Tests** line once a test plan has a version 0 (see [Documenting existing code](onboarding.md)). Two more lines appear when there is something to say: **Tickets**, once the tickets onboarding read are recorded on the map, such as `- Tickets: 12 read, 9 carried over, 3 left out (2 open, 1 by choice).`, and **Questions left open**, while a version 0 draft keeps one (see [Questions left open](onboarding.md#questions-left-open)). A file is described when an approved artifact's `scope` covers it, or when the commits of a unit changed it, including the commits from before BuildKeel found for onboarded work by its tracker key. The files counted are those tracked in git, leaving out tests, the spec tree when it is kept in the repository, and the `.buildkeel.yaml` pointer file and `.gitignore`. Nothing here needs attention, so it is never in the line under the title, and it never appears in the session report. To find what describes particular files, ask Claude, such as "what describes src/reset/token.ts?".

### Changed outside BuildKeel

BuildKeel cannot stop changes made with other tools, so it reports them:

- an approved version whose frozen copy no longer matches the hash in its approval record;
- an approval, completion or other record with uncommitted changes, or changed by a commit after it was written.

For example:

```
Changed outside BuildKeel:
- US-001 v1 was altered after approval: stories/US-001/versions/v1.md no longer matches the hash in stories/US-001/approvals/v1.yaml.
  To fix: Restore stories/US-001/versions/v1.md from git history. To change US-001, save a new version as a draft and approve it.
```

Validation reports the same.

### Ready to start

The units that can be started now, the active unit first. `/bk:build` lists the ones that are not ready yet, each with the reason.

### Your settings

The last line names `/bk:settings`, which shows how the repository is set up: the mode, the process and its gates, and the templates. See [Process and templates](process-and-templates.md#seeing-and-changing-your-settings).

## In a Spec-driven tree

In a Spec-driven tree (see [The two modes](modes.md)), the overview is about changes and capability specs:

```
BuildKeel status: Accounts, Spec-driven spec tree /home/ana/accounts-specs (format 2)
In short: CH-002 is in progress here; 2 open changes; 2 findings in open changes; 4 scenarios with no tagged test; 1 failing; commits with no unit.

Active unit here: CH-002 "Reset links expire" (change) on branch bk/CH-002-reset-links-expire.
Spec repo: not checked yet in this session.

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

Offer to review CH-002 now: call finish_work without apply (it writes nothing), review the code against its requirements, scenarios and design, and report as your judgment what is implemented, missing or at odds with the design. Do not finish it unless the user asks.

How this repository is set up (the mode, the numbering, the templates): /bk:settings.
```

- **Open changes**: each with its progress, its files, whether it is in progress here or in another working tree, and what the consistency check finds in it (see [What BuildKeel checks](changes.md#what-buildkeel-checks)). Archived and discarded changes are counted below them.
- **Capability specs**: each at its version in force, the change that wrote it, and the open changes that alter it.
- **Scenarios**: how many have a tagged test, then those with none (the gaps), those whose test fails, and those whose result is stale. Results are this working tree's. None of these ever stops anything.
- **Suspect**: tests, archived changes and open defects linked to a requirement, built against a capability version that a later one changed where they rely on it. See [Change impact](change-impact.md).
- **Defects**: each open one with what it is linked to (its change, the requirement it affects, or standalone) and where it came from, and those closed without a fix, with their reason. **Ad-hoc work**: the open ones.
- **Commits with no unit**, as above, and the **commits of discarded changes**, with the reason each was discarded.
- **Changed outside BuildKeel**: a capability version, or a file of an archived change, edited after it was written.
- **Ready to start**: open changes, defects and ad-hoc units. No gate applies.

When a change is active, Claude offers to review it: the same review as finishing (see [Finishing a change](finishing-a-unit.md#finishing-a-change)), reported as Claude's judgment, with nothing written.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-status`, `/bk-build`.
