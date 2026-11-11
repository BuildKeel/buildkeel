# Start on existing code

Most teams set BuildKeel up on code that already exists. None of it needs documenting before new work starts, and code from before BuildKeel is never reported as untracked; this page shows the two ways to describe it when you want to, which you can mix.

## Before you start

Set the repository up with `/bk:init` first. See [Your first change](getting-started.md).

- **As work touches it.** When a change touches code that nothing describes yet, the plan for it includes a description of how that code works today, so the change has a "before".
- **All at once, area by area**, with `/bk:onboard`, whenever you choose.

Neither is a setting, and neither is offered unless you run a BuildKeel command or ask for a change. Either way, people lead: Claude proposes and drafts, and you correct, complete and approve. You can also write or correct any of it by hand.

## 1. Document it as work touches it

The plan for a piece of work holds a version 0 of the code it touches, then the work itself.

### In Spec-driven

1. Talk the work through and run `/bk:capture`. See [Capture a plan](capture.md).
2. Read the version 0 of a capability that the change includes, describing how the undocumented code works today.
3. Keep it, correcting what is wrong, or drop it.

Once you keep it, it is saved before the change, the same way as in [area by area](#2-document-it-area-by-area), and the change's spec change is written against version 0.

### In Full SDLC

1. Talk the work through and run `/bk:capture`. See [Capture a plan](capture.md).
2. Read the version 0 the plan holds, describing what the code does today, beside the change as version 1 of the same artifact.
3. Approve them in one review. Version 0 is approved first:

   ```
   /bk:approve US-draft-k3x9@v0 US-draft-k3x9
   ```

   Each gets its own approval record and commit: `approve: US-E001 v0`, then `approve: US-E001 v1`.

A reported defect in code nothing describes is approved the same way: version 0 of the story it touches, then the defect under it, in one review, version 0 first. See [Small fixes, defects and spikes](defects-and-adhoc.md).

## 2. Document it area by area

`/bk:onboard` maps the code into areas and documents them one at a time.

1. Run:

   ```
   /bk:onboard
   ```

   Run on its own, it shows where onboarding stands and offers the next step: continue with an area once there is a map, choosing among every area not onboarded yet, map the code when there is none, or fill in what earlier onboarding left empty.
2. Agree the map. Claude reads the code's layout and proposes its capability areas: what the product does, in its users' words, each with the paths it covers. Merge, split or rename them until the map fits. Nothing is drafted before you agree. The map is kept in the spec tree, in `onboarding/map.yaml`, and each change to it is committed:

   ```text title="/bk:onboard"
   The map now has 3 areas, in onboarding/map.yaml, committed as "onboard: map of 3 areas" (5d1e2f3):

   | Area | Repo | Paths | What it does |
   |---|---|---|---|
   | Password reset | payments-api | src/reset/ | Reset by email |
   | Billing | payments-api | src/billing/ | Invoices and totals |
   | Accounts | payments-api | src/accounts/ | Profiles and settings |
   ```

3. Choose an area. Claude reads its code as it was at the baseline.
4. Say what you have about it: a project in your issue tracker, wiki pages, documents.
5. Agree what the area needs. Claude shows every stage of your process from the business idea down to the story, with the documents each stage requires:
   - What a source or the code describes is drafted as version 0.
   - Tasks and defects come in only when a source has them and they are finished. See [Finished work and old commits](#finished-work-and-old-commits).
   - A document your process requires that no source has, such as an epic's design document or a story's test plan, is drafted as **version 1**, under the normal rules, so new work under the area can start as usual.
6. Answer Claude's questions. Once you agree, Claude drafts everything. For each required section nothing supports, it asks you, one question at a time, and **Leave it empty** is always an answer.
7. Approve the area's drafts in one review, each version 0 before what builds on it.
8. Stop, or run `/bk:onboard` again for the next area. Progress is worked out from the spec tree itself, so it is the same on every machine:

   ```text title="/bk:onboard"
   Onboarding: 1 of 3 areas onboarded, from the map in onboarding/map.yaml.

   | Area | Paths | Where it stands |
   |---|---|---|
   | Password reset | src/reset/ | onboarded: 2 of 2 files described |
   | Billing | src/billing/ | not started: its one file is not described |
   | Accounts | src/accounts/ | partly done: 1 of 2 files described |

   Next area: Billing.
   ```

   Below the table, each area with tickets recorded says how many were read, carried over and left out, and names those left out, such as `- Password reset: 12 read, 9 carried over, 3 left out (3 open). Left out: PAY-31 "Reset by text" (open), …`.

An area is **onboarded** once every code file in it is described, by the paths an approved artifact covers or by the commits of linked work. One that work already touched shows as **partly done**, and onboarding it drafts only what is not described yet.

After approval, Claude runs the tests and matches the existing ones to the new test cases. See [Existing tests](#existing-tests).

### In Spec-driven

Existing code is described by capability specs (see [Spec-driven mode in depth](how-spec-driven-works.md)), and what describes code from before BuildKeel is a capability's **version 0**. It is written once a person has read and confirmed it, never drafted as a file first, and no change writes it.

`/bk:onboard` maps the code into areas as above, each to become one or more capabilities. For the next area, Claude reads its code and what you bring, then shows you each capability spec it drafts: a purpose, then requirements with their scenarios, under a code Claude proposes from its name, which you can change. Only when you confirm one is it saved:

```markdown title="BILL, version 0"
---
id: BILL
title: Billing
area: Billing
---

## Purpose

How customers are charged each month.

## Requirements

### BILL-R1 Monthly invoice
The system SHALL send each customer an invoice on the first day of the month.

#### BILL-R1-S1 First of the month
- **WHEN** the first day of a month begins
- **THEN** every active customer is sent an invoice for the month before
```

Its code is reserved and its requirements and scenarios numbered from the shared counter, like any others. Its record says who confirmed it and when, the code repository's baseline commit, and a hash of each source it was drafted from. It is committed on its own as `onboard: BILL v0`, and never edited: the first change to it makes version 1.

Where onboarding stands lists each area with the capabilities confirmed for it, from the `area` each names:

```text title="/bk:onboard"
Onboarding, from the map in onboarding/map.yaml: each area is documented as capability specs, version 0, confirmed by a person.
- Billing: BILL v0, confirmed by Jane Doe <jane@example.com> on 2026-10-14
- Search: not started (src/search/)
```

## Where existing code ends

The line is `/bk:init`.

- **The baseline.** Each code repository's baseline is the commit it was at when it was set up with BuildKeel. A repository added to the tree later gets its own. It never moves. A repository with no commits when it was set up has no baseline, and so no existing code.
- **Before the baseline** is existing code: documented as version 0, from the code as it was at the baseline commit.
- **After the baseline,** everything goes through BuildKeel. Code written outside it is reported as having no unit (see [Status and usage](status.md)), is never version 0, and is documented through the process when work touches it.
- **`/bk:onboard` runs any time after setup,** as often as you like, one area at a time, with the map and where it stands kept in the spec tree. It mixes freely with documenting as work touches it, and an artifact made in BuildKeel can get its version 0 later (see [Filling in later](#filling-in-later)).
- **Not during a move to Full SDLC.** While a Spec-driven tree is being moved, onboarding says that `/bk:migrate` carries the move on. `/bk:onboard` itself only documents code, and sends you to `/bk:migrate` when you ask it to move the tree. See [Move to Full SDLC, or upgrade a tree](migration.md).

## Version 0

What describes code from before BuildKeel is **version 0** of its artifact; anything made in BuildKeel starts at version 1. Version 0 reads like any artifact of its type, as if BuildKeel had been used from the start. Claude drafts it from the code and from what you bring: your issue tracker or wiki through tools you connected to Claude, files, and what people know.

- **No template holds it.** It is not held to the template or to the documents your process requires, so a section nobody knows can stay empty, but a person reads and approves it like any version. The approval record lists what it leaves empty, for a later version to fill in.
- **It counts as done.** Its code already exists. It counts as approved when work starts under it, and as done when its parent is finished. Changing it starts with its version 1, held to the template, the gates and [change impact](change-impact.md) like any version.
- **When sources disagree** with each other or with the code, Claude asks which is intended. When the code is wrong, version 0 states the intended behavior, and the defect is recorded. When a ticket is out of date, version 0 follows the code. When you do not know, answer **Not sure: leave it open**.

### Approving version 0

Its draft is `onboard.md`, in the artifact's directory beside its working file, so version 0 and a change that builds on it can be drafted side by side. Approving version 0 checks only that its parent is approved, at any version, and that it leaves no question open.

```text title="/bk:approve"
Ready to approve version 0 of user story US-draft-k3x9 "Password reset": it describes the code as it was before BuildKeel, so it is held to no template; a person reads it before it is approved. Approving will:
- give it its permanent number: the next onboarded user story number, US-E001 unless someone else approves one first; its directory becomes stories/US-E001/
- record it against its parent EP-01@v1
- freeze v0 and record the approval by Jane Doe <jane@example.com>, with its source frozen with it: jira-PAY-12.md
- record what it leaves empty, for a later version to fill in: Story
- commit only those files in the spec repo as "approve: US-E001 v0", without pushing
```

Once approved, version 0 is in force like any version, and `onboard.md` is gone: the frozen copy `versions/v0.md` holds it. Its approval record:

```yaml title="Approval record of version 0"
artifact: US-E001
version: 0
hash: sha256:4d1a7b…
approvedBy: Jane Doe <jane@example.com>
approvedAt: 2026-10-03T09:20:41Z
onboarded: true
baseline:
  payments-api: 4f2a9c1
sources:
  jira-PAY-12.md: sha256:a83c02…
empty:
  - Story
parent: EP-01@v1
draftId: US-draft-k3x9
```

### Kept sources

Each source a version 0 is drafted from is kept beside it in `sources/`, one file per source, exactly as it was read: for an issue tracker entry, its description, fields and comments. Attachments, images and history stay behind its link, and only what your tool returned is kept. Code is never copied: the baseline commit in the approval record names it.

```text title="sources/jira-PAY-12.md"
---
source: Jira
key: PAY-12
link: https://acme.atlassian.net/browse/PAY-12
readAt: 2026-10-03T09:14:00Z
readBy: Jane Doe <jane@example.com>
---

Summary: Reset links
Description: Links last an hour.
Comment (Ana): agreed.
```

BuildKeel lists the sources in a Sources section at the end of version 0, with their links. Until version 0 is approved, a source can be read again, replacing the earlier copy, or dropped. Approval freezes them: their hashes go into the approval record, the agent cannot edit them, and validation reports a source that was changed or added afterwards.

### Onboarded numbers

An artifact first approved as version 0 is numbered in its type's onboarded sequence: its prefix, a letter, then the number, such as `US-E001`, `EP-E01` or `DEF-E001`. New work keeps the normal sequence, so the next story approved as version 1 is `US-002`. The letter is `E` unless the process sets another:

```yaml title="buildkeel.yaml"
process:
  onboarded:
    letter: H
```

An ID never changes. Version 0 added later to `US-005` leaves it `US-005`.

### Questions left open

When the person documenting an area does not know which of two disagreeing sources is right, often because someone else wrote the code, they answer **Not sure: leave it open**. Claude offers it after the two answers, and recommends none of them. The question is kept in the version 0 draft's front matter, with both readings and who left it open, and the part it concerns is left out of version 0:

```yaml title="onboard.md, front matter"
openQuestions:
  - id: Q1
    about: Reset link lifetime
    code: Links last 60 minutes (src/reset/token.ts)
    source: Links last 30 minutes
    sources: [PAY-12]
    leftOpenBy: Jane Doe <jane@example.com>
    leftOpenAt: 2026-10-15T09:12:00Z
```

A version 0 with a question left open cannot be approved, nor can what depends on it, such as its test plan; the rest of the area's drafts are approved in the same review. `/bk:onboard` lists the questions left open, and `/bk:status` counts them, so someone who knows can answer later. Claude asks them, records `answer: code` or `answer: source` with who answered and when, and drafts the part it concerns. When the source was right, the defect is recorded, as for any known defect. Answered questions are frozen with version 0.

In a Spec-driven tree, where a capability's version 0 is written once, the question is kept on its area of the map instead, and the requirement it concerns is left out of version 0. Answering it is followed by a change that adds the requirement.

### Known defects

When you tell Claude a drafted behavior is a defect, not what was intended, version 0 is changed to state the intended behavior. Once the area is approved, the defect is recorded against that story as a reported defect, naming the criterion and what the code does instead, and is approved and fixed like any defect. See [Small fixes, defects and spikes](defects-and-adhoc.md).

## Finished work and old commits

Tasks and defects come into an area only when a source has them and they are **finished**, as version 0 with their tracker keys. When one is approved, the commits made before the baseline that name its key are linked to it, so its old code is known. Open work is left out: it is drafted with `/bk:new` when someone takes it up.

With Build-ready tasks on, each finished task the area documents then gets an as-built record from its linked commits: the files and tests they changed and what the task delivered, labeled as written later. Claude shows the records and writes them once you agree. See [Build](working-on-a-unit.md).

Once the area is approved, Claude records every ticket it read for the area on the map, with what became of each: carried over, with the artifact it became, or left out, as open, in progress, or by your choice, with who chose. Nothing read slips through, and you can tell when an old tracker project has nothing left in it:

```yaml title="onboarding/map.yaml"
tickets:
  - key: PAY-14
    link: https://example.atlassian.net/browse/PAY-14
    title: Email template
    outcome: carried
    artifact: TK-E004
  - key: PAY-31
    title: Reset by text
    outcome: left-out
    why: open
```

## Existing tests

Tests written before BuildKeel carry no test case IDs. After an area is approved, Claude runs the tests and matches the existing ones to the new test cases, without changing the code. Then it shows which behavior has no test and which tests test no stated behavior. You can also ask Claude to match them at any time.

Each test case's match is kept in its plan's `matches/` folder, such as `stories/US-E001/test-plan/matches/US-E001-TC1.yaml`:

```yaml title="matches/US-E001-TC1.yaml"
testCase: US-E001-TC1
tests:
  - test/reset.test.ts > emails a reset link
matchedBy: Jane Doe <jane@example.com>
matchedAt: 2026-10-03T10:02:11Z
```

A matched test's result counts for its test case like a tagged test's, in the done gates too. When work under the story changes a matched test, Claude adds the test case's ID to its name. For how matches are kept, broken matches and the untested-behavior report, see [Tests and traceability](test-plans.md).

## Filling in later

Sections left empty are listed when you run `/bk:onboard`, with what each artifact lacks:

```text title="/bk:onboard"
Still as onboarding left them, with required sections empty (1):
- US-E002 story "Invoices" v0: Story, Acceptance criteria
Filling one in drafts its next version, which only completes it: nothing built on it becomes suspect.
```

1. Run `/bk:onboard`.
2. Choose **Fill in what onboarding left empty**.
3. Answer Claude's question for each empty section, one at a time. Anything you still cannot answer can stay empty.

### Version 0 for what BuildKeel already has

An artifact made in BuildKeel can get its version 0 later, describing its code as it was at the baseline. Name it with `@v0`:

```
/bk:approve US-005@v0
```

Its ID stays the same, and the version in force stays in force; version 0 comes before it in the history, and nothing becomes suspect. An artifact has one version 0 at most. When the version in force leaves out behavior that version 0 describes, Claude also drafts the next version with both, the version in force winning where they overlap. That version only completes the one in force (`completes` in its record), so nothing built on it becomes suspect, and the criteria it adds are coverage gaps until the test plan covers them. See [When a requirement changes](change-impact.md).

### In the status overview

Once a version 0 or a map exists, `/bk:status` shows an **Existing code** section: how much of the code is described, how many areas are onboarded, and how many onboarded test cases have a test. Nothing in it needs attention, so it never appears in the line under the title, nor in the session report. See [Status and usage](status.md). `/bk:stats` counts what was documented area by area and what as work touched it.

**More:** [Tests and traceability](test-plans.md), [When a requirement changes](change-impact.md), [Move to Full SDLC, or upgrade a tree](migration.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-onboard`.
