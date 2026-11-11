# The spec tree and its artifacts

The spec tree is where BuildKeel keeps your plan, with every version and every record of the work. This page explains how it is laid out, how its IDs work, what its settings and pointer file hold, and, for a Spec-driven tree, what capability specs and changes contain.

## Where the plan lives

The spec tree is a directory of markdown and YAML files, versioned in git like your code. In Full SDLC it holds business ideas, epics, stories, tasks, test plans, defects and ad-hoc work. In Spec-driven mode it holds capability specs and changes. Both keep every approved or written version and every completion record.

A spec tree can be:

- **its own repository**, serving several code repositories, or
- **a folder inside a single code repository**, such as `specs/`.

Both work the same way, with the same files and IDs. You can start with a folder and move it to its own repository later by moving the folder and updating the pointer file.

### Layout

A Full SDLC tree:

```
<spec root>/
  buildkeel.yaml                 settings for the whole tree
  templates/                     your own templates (optional)
  ideas/BI-01/idea.md            one directory per business idea
  epics/EP-01/epic.md            one directory per epic
  epics/EP-01/design/design.md   the epic's design document
  stories/US-001/story.md        one directory per user story
  stories/US-001/test-plan/plan.md   the story's test plan
  stories/US-E001/story.md       a story first approved as version 0, describing code from before BuildKeel
  tasks/TK-001/task.md           one directory per task
  defects/DEF-001/defect.md      one directory per defect
  adhoc/AH-001/adhoc.md          one directory per ad-hoc unit
  glossary/<term>/               each version of a glossary entry, one file each
  practices/<ID>/                each version of a practice your team agreed
  adrs/ADR-0001-<title>/         one directory per architecture decision record
  threads/TH-001/                one file per pause while exploring, before any work was planned
  code-notes/CN-001/             each version of a note on the code
```

A Spec-driven tree holds capability specs and changes instead of stages:

```
<spec root>/
  buildkeel.yaml                 settings, with mode: spec-driven
  templates/                     your own templates (optional)
  capabilities/AUTH/versions/    each version of a capability spec, with its record
  changes/CH-012-<short name>/   one directory per change, named by its ID and title
  defects/DEF-001/defect.md      one directory per defect
  adhoc/AH-001/adhoc.md          one directory per ad-hoc unit
  glossary/<term>/               each version of a glossary entry, one file each
  practices/<ID>/                each version of a practice your team agreed
  adrs/ADR-0001-<title>/         one directory per architecture decision record
  threads/TH-001/                one file per pause while exploring, before any work was planned
  code-notes/CN-001/             each version of a note on the code
```

Both modes keep the glossary, the practices, the ADRs, the threads and the notes on the code at the top of the tree. See [Choose a mode](modes.md).

The hierarchy is not in the directory structure. Each artifact names its parent in its own file, so moving a story to another epic never moves files. Use `/bk:status` to see the tree as a hierarchy.

### Records beside each artifact

Each artifact has its own directory, named by its ID, holding its working file. As the artifact moves through its life, BuildKeel adds records next to it:

| Directory | Holds |
|---|---|
| `versions/` | A frozen copy of each approved version, such as `v1.md`, and `v0.md` for version 0 |
| `approvals/` | One approval record per approved version, such as `v1.yaml`, and `v1-pending.yaml` for an approval made while its number could not be assigned (see [Full SDLC mode in depth](how-full-sdlc-works.md#approval-and-locking)) |
| `sources/` | For version 0: each source it was drafted from, kept as it was read, and frozen with it (see [Full SDLC mode in depth](how-full-sdlc-works.md#version-0)) |
| `completions/` | One record each time the work is finished |
| `closed.yaml` | For a defect closed without a fix: why, who closed it and when (see [Small fixes, defects and spikes](defects-and-adhoc.md)) |
| `repins/` | One record each time someone confirms the artifact, or in a test plan one of its test cases, is still valid after what it was built against changed |
| `notes/` | The working notes of the work on it, one file each time they are saved |
| `pauses/` | Where the work stood at each pause, and who paused it |
| `runs/` | The summary of its test runs, one file each time it is saved |
| `reviews/` | The findings of each review, each finding with an ID such as `TK-013-Fk3q` |
| `answers/` | How each finding was answered, one file per finding |
| `switches/` | The switches in force when the unit started, which its checks apply |
| `handoffs/` | Each Principal handoff that did not clear its finding |
| `as-built/` | What a task finished before Build-ready tasks was on delivered, written later from its commits |
| `test-plan/` | The artifact's test plan, `plan.md`, with its own `versions/` and `approvals/` |
| `design/` | The artifact's design document, `design.md`, with its own `versions/` and `approvals/` |
| `<document>/` | A document of your team's own, such as `threat-model/threat-model.md`; see [Process: stages, kinds and documents](process-and-templates.md) |

A change in a Spec-driven tree keeps `notes/`, `pauses/`, `runs/`, `reviews/`, `answers/`, `switches/`, `handoffs/` and `as-built/` in its own directory the same way.

Records are written once and never edited, so two branches that add records merge without conflicts. Each one's file name holds the time and a short random suffix, such as `20261101T183000Z-k3q8.md`, or for a version of a glossary entry, a practice or a note on the code, the version and a suffix, such as `v2-k3q8.md`. When two branches each add the same version of an entry, both are kept and validation asks you to settle which one stands. Edit only working files, and always through BuildKeel. See [Records and the audit trail](records.md).

Version 0, which describes code as it was before BuildKeel, is drafted in `onboard.md` beside the working file, so it can be drafted while the next version is drafted too. Approving it writes `versions/v0.md` and `approvals/v0.yaml`, and removes `onboard.md`.

### Artifact files

Every artifact is a markdown file that starts with a block of named fields, followed by sections that each start with a `##` heading:

```markdown
---
id: US-001
title: Request a reset link
parent: EP-01@v1
---

## Summary

A customer asks for a reset link and receives it by email.

## Acceptance criteria

- **US-001-AC1** A reset link is emailed within one minute.
- **US-001-AC2** The link expires after 30 minutes.
```

- `id` must match the name of the artifact's directory.
- `parent` names the parent by ID and the version it was written against, such as `EP-01@v1`. Links always use IDs, never file paths. A draft whose parent is also a draft names it by its draft ID alone.
- Business ideas and ad-hoc units have no parent. In Full SDLC a defect has one: the task or story it was found in, or the work a reported defect affects. In a Spec-driven tree a defect found while building names its change, and a reported one names the requirement it affects in `requirement`, or stands alone. Every other artifact must have a parent.
- Which fields and sections each type needs is set by its template.

## IDs and the counter

Every artifact type has a prefix and its own number sequence: `BI-01`, `EP-01`, `US-001`, `TK-001`, `DEF-001`, `AH-001`. While an artifact is a draft it has a temporary ID that starts with its type's prefix, such as `US-draft-k3x9` for a user story, and its directory carries that name. It receives its permanent number when it is first approved, and BuildKeel renames the directory and updates every reference to it.

An artifact first approved as version 0 is numbered in a second sequence of its type, with a letter before the number: `US-E001`, `EP-E01`. Its ID never changes afterwards, and neither does the ID of an artifact that gets its version 0 later.

A test plan has no number of its own: the test plan of `US-001` is `US-001-TP`.

In a Spec-driven tree, changes are numbered `CH-001`, `CH-002`, and capability specs use codes and requirement IDs (see [Capability specs](#capability-specs)).

### The counter

The counters are kept on a branch of the spec repo's remote, `buildkeel/ids` (set `settings.idsBranch` in `buildkeel.yaml` to use another), never on your main branch. BuildKeel fetches the counter, takes the next number and pushes it back. When two people take a number at the same moment, one push is refused and that one takes the next number. A spec repo with no remote keeps the counter on a local branch. Approvals, defects, ad-hoc units, changes, and requirements and scenarios all take their numbers from it.

### Repairing the counter

The counter only moves forward, so it is behind the spec tree only when something was done to its branch: the branch was deleted, or reset to an older commit, or the remote was replaced. Numbering then stops, rather than give out a number the tree already holds: BuildKeel says the counter is behind and asks to repair it. You can also ask Claude to repair it yourself, for example after moving the spec repo to a new remote.

The repair reads every ID in the spec tree: approved artifacts, defects and ad-hoc units, the changes of a Spec-driven tree, open, archived and discarded, and the requirements and scenarios in its capability specs and changes. It shows each counter it would raise and each capability code it would claim, for the change that creates it, and writes nothing until you agree. Then it writes them in one commit to the counter's branch and pushes it. It never lowers a counter or removes a claim. A number given out but never saved, such as a draft lost before its commit, is not in the tree, so the repair cannot see it: the worst that can happen is a gap in the numbers, never the same number twice.

## Settings and the pointer file

### buildkeel.yaml

The file at the root of the spec tree. Its presence is what makes a directory a spec tree.

```yaml
format: 4
mode: full-sdlc
name: Payments
repos:
  - name: payments-api
    remote: git@example.com:acme/payments-api.git
    baseline: 4f2a9c1
settings:
  autoPush: false
```

| Field | Meaning |
|---|---|
| `format` | The version of the spec tree format. Required. |
| `name` | A display name for the tree. |
| `mode` | How the tree works: `spec-driven` (capability specs and changes) or `full-sdlc` (your process's stages, approvals and gates). Required from format 2 on: BuildKeel does not read a tree in format 2 or later that names none, and says to add `mode: spec-driven` or `mode: full-sdlc`. A format 1 tree names none, and follows Full SDLC. See [Choose a mode](modes.md). |
| `repos` | The code repositories that use this tree. Each has a `name`, and optionally its `remote` and a `baseline` commit: commits up to the baseline predate BuildKeel and are never reported as untracked work. |
| `templates` | An organization template source, with a fixed `version`. See [Templates](templates.md). |
| `process` | Your process: stages and the kinds within them, documents, ID prefixes, which kinds a reported defect can belong to (`defect.parents`), task plans, the letter of onboarded numbers (`onboarded.letter`, `E` by default) and gate settings. Leave it out to use the default process. See [Process: stages, kinds and documents](process-and-templates.md). |
| `settings.autoPush` | Push each approval as soon as it is committed. Off by default. |
| `settings.idsBranch` | The branch that holds ID counters. Defaults to `buildkeel/ids`. |
| `settings.contextBudget` | The size, in characters, a unit's context view should stay within. Defaults to `10000`. A larger view is noted, never cut. See [Build](working-on-a-unit.md). |

### The pointer file: .buildkeel.yaml

Each code repository has a `.buildkeel.yaml` at its root saying which spec tree it uses:

```yaml
specs: ../payments-specs
remote: git@example.com:acme/payments-specs.git
repo: payments-api
```

| Field | Meaning |
|---|---|
| `specs` | Path to the spec tree, relative to the code repository's root. Use `./specs` for a folder in the same repository. |
| `remote` | Where the spec repository is hosted, so it can be found on any machine. |
| `repo` | This repository's name in the spec tree's `repos` list. |

BuildKeel finds the pointer from any directory inside the code repository. If the spec tree is not where the pointer says, BuildKeel tells you and how to fix it, and changes nothing.

The pointer file also sets where the read-only copy of the glossary, practices and accepted ADRs is written in that repository (see [Spec-driven mode in depth](how-spec-driven-works.md#settings-left-at-their-defaults)).

### When repositories are checked out somewhere else

If the spec repository is checked out in a different place on your machine than the pointer says, record its location in `~/.buildkeel/paths.yaml` instead of changing the shared pointer:

```yaml
specs:
  "git@example.com:acme/payments-specs.git": /Users/me/work/payments-specs
```

The key is the `remote` from the pointer file. This file stays on your machine and is never committed.

## Teams on both hosts

One spec tree serves everyone, whichever host each person uses: Claude Code or Antigravity. The tree, its records and the commands are the same in both; only the commands' form differs (`/bk:build` in Claude Code, `/bk-build` in Antigravity). Each person installs BuildKeel for their own host (see [Install](install.md)), and work paused on one host can be resumed on the other.

A few things differ by host:

- **Commands only you start** are enforced in Claude Code. Antigravity cannot block them, so there Claude is told the rule and follows it.
- **Models and effort:** a tier names a model and an effort for each host. Antigravity has no effort setting for agents, so an effort is ignored there. See [Models and effort per role](models.md).
- **Completion records** note the host the work was finished on.

## Format versions

`format` in `buildkeel.yaml` tells BuildKeel which version of the file layout the tree uses. Every new tree is written in format 4. An older BuildKeel opens a format 4 tree read-only and asks for an update.

- **An older format** (formats 1 to 3, made by an older BuildKeel): BuildKeel reads the tree but does not change it, and asks you to run `/bk:migrate`. Migration upgrades the tree in one commit you can review, never alters approved versions, and keeps work in progress going. See [Move to Full SDLC, or upgrade a tree](migration.md).
- **A newer format** than your BuildKeel supports: BuildKeel reads the tree but does not change it, and asks you to update the plugin.

BuildKeel never rewrites files to a new format without being asked.

## Capability specs

In a Spec-driven tree, capability specs describe how the system behaves now. Each covers one lasting behavior, such as authentication or notifications: a purpose, then requirements, and for each requirement the scenarios a test can check. Work never edits a capability spec directly. A change proposes how it should change, and finishing the change writes the capability spec's next version.

### Where they live

```
<spec root>/
  capabilities/AUTH/versions/v1.md     the text of version 1
  capabilities/AUTH/versions/v1.yaml   its record: the change that wrote it, its hash, who and when
  capabilities/AUTH/versions/v2.md     version 2, written when a later change was finished
  capabilities/AUTH/versions/v2.yaml
```

Each capability has a directory named by its code. A capability spec has no working file: every version is written once and never edited, and the highest version is the one in force. Two branches that finish changes to different capabilities merge without conflict.

### The format

```markdown
---
id: AUTH
title: Authentication
---

## Purpose

How people prove who they are, and get back in when they cannot.

## Requirements

### AUTH-R1 Sign in with email and password
The system SHALL sign a user in when their email and password match.

#### AUTH-R1-S1 Correct password
- **WHEN** a user signs in with their email and the right password
- **THEN** they are signed in and taken to their dashboard

#### AUTH-R1-S2 Wrong password
- **WHEN** a user signs in with the wrong password
- **THEN** they are told the email or password is wrong, without saying which
```

- **Purpose**: what the capability covers and why it exists, in a sentence or two.
- **Requirements**: one `###` heading per requirement, with its ID and a short name. Under it, the behavior in one or two sentences using SHALL or MUST, at most 500 characters.
- **Scenarios**: one `####` heading per scenario under its requirement, with its ID and a short name, then a WHEN line and a THEN line. Every requirement has at least one.

Capability specs follow the built-in `capability.md` template. To change it, copy it into your spec tree's `templates/` folder, as for any template; the markers `R` and `S` in requirement and scenario IDs are set there. To require a section in every capability spec without changing the template, add a rule. See [Templates](templates.md) and [Process: stages, kinds and documents](process-and-templates.md).

### Requirement and scenario IDs

Every capability has a short code, such as `AUTH`. Its requirements are numbered after it, `AUTH-R1`, `AUTH-R2`, and each requirement's scenarios after the requirement, `AUTH-R1-S1`, `AUTH-R1-S2`. A test tagged with `[AUTH-R1-S2]` is linked to that scenario.

IDs are given when an item is first written, and they never change. A requirement keeps its ID when it is renamed or reworded, so links and test tags stay valid. Spec changes name existing requirements by ID.

- **Numbers come from the tree's counter**, the same counter approvals, defects and ad-hoc units use, so two people adding requirements to `AUTH` at once never get the same number. One save takes every number it needs in a single step. Claude writes a new item as `AUTH-R{{new}}` and BuildKeel puts in the number when it saves.
- **Numbers are never reused**, even when a change is discarded: a requirement its change added is never numbered again.
- **A capability's code** is proposed by Claude from the capability's name, and you can ask for another before it is saved. It never changes after. The code is reserved in the counter, so two changes cannot create the same capability. If another change already holds it, BuildKeel says which one. Discarding the change releases the code, so another change can create the capability; when the counter cannot be reached at the time, the code is released the next time it can. If the counter is ever behind the tree, BuildKeel says so and offers to [repair it](#repairing-the-counter).
- **Offline**, when the counter cannot be reached, a new change, requirement or scenario gets an ID with a random suffix instead of a number, such as `AUTH-Rk3x9`, as defects do. It is as permanent as a number. A new capability cannot be created offline, because its code must be reserved; the rest of the change can still be drafted, and the capability added once the counter can be reached.

The change prefix and the width of its number are set in `buildkeel.yaml`:

```yaml
process:
  change:
    prefix: RFC
    width: 4
```

The next change is then `RFC-0012`, say, and existing changes keep their IDs. The letters in requirement and scenario IDs, `R` and `S`, are set in the capability template, and the spec change template must use the same ones; validation reports it when they differ. `/bk:init` asks about all of this when it creates the tree, with examples, and writes what you choose: see [Numbering](how-spec-driven-works.md#4-numbering). Defect and ad-hoc prefixes are set as in Full SDLC, under `process.defect` and `process.adhoc`. IDs are always a prefix and a number.

### Versions

Finishing a change that alters a capability writes its next version, with a record beside it:

```yaml
capability: AUTH
version: 1
change: CH-001
hash: sha256:7ca92f69fbdfd5be6c4d8c827473e2d8bff6e3b91815fe96e845defca6370d57
archivedBy: Dana Lee <dana@example.com>
archivedAt: 2026-10-10T08:00:00Z
template:
  type: capability
  version: 1
  source: built-in
```

The record names the change that made the version, so you can always find why a requirement reads as it does. A capability documented from existing code with `/bk:onboard` starts at version 0, whose record names who confirmed it and the code it describes instead of a change.

### What BuildKeel checks in a capability spec

Validation checks every capability version against the hash in its record, so a version changed after it was written is reported, along with a missing record. It also checks the version in force and reports, by ID, a requirement with no scenario, a scenario missing its WHEN or THEN line, and requirement text over 500 characters:

```
capabilities/AUTH/versions/v2.md: AUTH-R3 has no scenario.
To fix: Add one under it as "#### AUTH-R3-S1 <name>", with a WHEN line and a THEN line.
```

## Changes

In a Spec-driven tree, each piece of work is a **change**. It says why the work is done, how it changes the behavior described in the capability specs, how it is built when that needs saying, and the tasks to get there. A change stays open and editable until it is finished, and nothing in it is ever approved.

### A change's files

```
<spec root>/changes/CH-012-password-reset-by-text-message/
  proposal.md      why the change is made and what it changes
  specs/AUTH.md    a spec change: how it alters the AUTH capability
  design.md        how it is built, only when that needs recording
  tasks.md         the tasks, as numbered checkboxes
```

A change's folder is named by its ID and a short name made from its title, the way its branch is: `CH-012-password-reset-by-text-message`, and the branch `bk/CH-012-password-reset-by-text-message`. While the change is open, a new title renames the folder; its ID, branch and commits stay as they are. Once the change is archived, its folder is frozen with the rest of it.

BuildKeel names a change with its title wherever it shows one, such as `CH-012 "Password reset by text message"`, and Claude does the same. Commands and commit trailers take the bare ID: `/bk:done CH-012`, `BuildKeel-Unit: CH-012`.

Claude drafts a change from a conversation with `/bk:capture`, or with `/bk:new` (see [Capture a plan](capture.md)). Each file follows its template, which your team can replace or add rules to (see [Templates](templates.md)).

### The proposal

```markdown
---
id: CH-012
title: Password reset by text message
capabilities: [AUTH]
---

## Why

Users who cannot get to their email cannot reset their password.

## What changes

- Users with a verified phone can ask for a six-digit reset code by text message.
- A code expires 10 minutes after it is sent and works once.

## Capabilities

- **AUTH** (modified): password reset by text message.

## Impact

The reset endpoint, and a text message provider.
```

The proposal says why, what changes (marking anything that breaks existing users or callers as **BREAKING**), which capabilities are new or modified, and the impact. Its `capabilities` field lists the same codes. A change that alters no behavior, such as a refactor, says so with `noSpecChanges: true` and has no spec changes. A proposal captured from a conversation can also hold an **Approaches** section (the approaches weighed, the one chosen and why) and **Non-goals**, and a change captured from a thread names it in a `thread` field, such as `thread: TH-004`; the thread is closed with a link to the change (see [Talk it through and explore](exploring.md)).

### Spec changes

A spec change alters one capability, naming each existing requirement by its ID:

```markdown
---
capability: AUTH
base: 1
---

## Added

### AUTH-R3 Reset by text message
The system SHALL text a six-digit reset code to a user's verified phone on request.

#### AUTH-R3-S1 Verified phone
- **WHEN** a user with a verified phone asks for a reset code by text
- **THEN** a six-digit code is texted to that phone

## Modified

### AUTH-R2 Request a reset link
The system SHALL email a password reset link to a registered address on request, unless the user asked for a code by text.

#### AUTH-R2-S1 Registered address
- **WHEN** a user asks for a reset link for a registered email
- **THEN** a reset link is emailed to that address
```

- **Added**: new requirements, each with its scenarios. They get their IDs when the change is saved.
- **Modified**: existing requirements by ID, each with its full new text and every scenario it keeps or gains. A new name under the same ID renames it, so tests tagged with its scenarios stay linked.
- **Removed**: requirements that no longer apply, each with a **Reason** and a **Migration** line saying what users or callers do instead.
- `base` is the version of the capability the spec change was written against. BuildKeel records it when the spec change is first saved, so finishing can tell when another change reached the same capability first.

A spec change for a capability the tree does not have yet creates it: it gives the capability's `title` and a **Purpose** section, and every requirement goes under Added. Claude proposes the capability's code, which you can change before it is saved.

Capability specs are never edited directly. A change's spec changes are merged into them only when the change is finished.

### The design

A change's design uses the built-in design document, with the change as its parent. It is optional: Claude drafts one when the change makes decisions worth recording, such as a new component, data, an interface or a trade-off. A question that can safely wait goes in an **Open questions** section. See [Process: stages, kinds and documents](process-and-templates.md).

### Tasks

```markdown
---
parent: CH-012
---

## 1. Sending a code by text

- [ ] 1.1 Generate a six-digit code and store it with its send time.
  Files: create src/auth/codes.ts; test test/auth/codes.test.ts
  Interfaces: none
  Verify: npm test, where the code store tests pass
- [ ] 1.2 Text the code to the user's verified phone.
  Files: change src/auth/reset.ts; test test/auth/reset.test.ts
  Uses: createCode (from 1.1)
  Delivers: sendResetCode(phone: string): Promise<void>
  Verify: npm test, where [AUTH-R3-S1] passes
```

Tasks are numbered checkboxes in groups, ordered so that each builds on the ones before. Under each, indented lines state its Files, what it Uses (from an earlier task, a file, or a library at its version), what it Delivers, and how it is verified, or `Interfaces: none` for a task that uses and delivers nothing; a ticked task gets a `Built:` line (see [Build](working-on-a-unit.md)). Each group includes the tests and documentation its own work needs.

A task is ticked once its verification passes; a box holding an `x` is ticked. The change's progress is its ticked tasks, such as 1 of 2. A tick, and the summary of the test runs saved with it, stay uncommitted like the change's other files while it is open: finishing the change commits them with its archive. Pausing the change is the exception: it commits the change's files as they stand, with the pause record, so the change can be resumed on another machine (see [Pause, resume and hand over](pausing-and-resuming.md)). Each tick also keeps the working notes since the last one, beside it.

### Editing an open change

Every file of an open change can be changed at any time, by you or by Claude, with no new version and no approval, and several changes can be open at once; [Capture a plan](capture.md) shows how to edit one.

### What BuildKeel checks in a change

Nothing in a change is ever blocked. Each time a file is saved, BuildKeel reports what it lacks against its template, what does not fit the capability it changes (an added requirement that already exists, a modified or removed one that does not, a removal with no reason or migration, a requirement with no scenario), and where the proposal and the spec changes disagree:

```
CH-012: its proposal names AUTH, but it has no spec change for AUTH.
To fix: Add a spec change for AUTH, or remove AUTH from the proposal's capabilities.
```

The status overview and finishing a change report the same, and also references to requirements the change removes, scenarios with no tagged test, test tags naming no scenario, and ticked tasks whose requirement changed after the tick. A stray tag is reported with the file and line it is in, wherever it is, a docstring included:

```
CH-001: tests/scenarios.py:12 names [MDATA-R9-S1], a scenario of a requirement CH-001 removes.
```

### Finishing, defects and discarding

`/bk:done` finishes a change by archiving it: its spec changes are merged into the capability specs, each capability it touches gets its next version, and its files are frozen as its record. Tasks left unticked are checked first, the final review by fresh reviewers runs (see [Reviews and the fix loop](reviews.md)), and you choose to fix first, finish anyway, or reword the spec where the code is right. The review's findings, with how each was answered, stay with the archived change. Finished anyway with work left, it offers a follow-up change to hold it. See [Finish](finishing-a-unit.md).

A defect found while building a change is attached to it, such as `parent: CH-002`, with the scenario whose test found it, and shows in the change's context while it is open. A reported defect names the requirement it affects, such as `AUTH-R3`, and becomes suspect if a later change modifies that requirement while it is open. A fix that changes a requirement is a change in behavior, made through a change. See [Small fixes, defects and spikes](defects-and-adhoc.md).

A change you will not go on with can be discarded: ask Claude to discard it, such as "discard CH-002, it was replaced by CH-016". Claude first shows what goes:

```
Discarding CH-002 "Reset links expire" will:
- remove its 4 files: changes/CH-002-reset-links-expire/design.md, changes/CH-002-reset-links-expire/proposal.md, changes/CH-002-reset-links-expire/specs/AUTH.md, changes/CH-002-reset-links-expire/tasks.md
- write its discard record, changes/CH-002-reset-links-expire/discarded.yaml: its ID, title, who discarded it, when, and the reason
- commit both as "discard: CH-002" in the spec repo

No capability spec changes. The IDs it gave (AUTH-R3, AUTH-R3-S1) are never used again. Commits stamped with CH-002 stay with it, shown as belonging to a discarded change.
```

Nothing is removed until you confirm. Then the change's files are removed and its discard record is written, in one commit:

```yaml
change: CH-002
title: Reset links expire
discardedBy: Jane Doe <jane@example.com>
discardedAt: 2026-10-14T10:15:00Z
reason: replaced by CH-016
ids:
  - AUTH-R3
  - AUTH-R3-S1
```

- Only an open change can be discarded: an archived change is the record of work that was done.
- No capability changes, and the change's numbers, and those of the requirements and scenarios it added, are never given again.
- Discarding the active change releases its claim and clears it. A change another working tree on this machine is working on is discarded there.
- Commits stamped with the discarded change stay with it: the status overview shows them as belonging to a discarded change, with its reason.
- The discard record is never edited; the agent is blocked from changing it.

**More:** [Spec-driven mode in depth](how-spec-driven-works.md), [Full SDLC mode in depth](how-full-sdlc-works.md), [Records and the audit trail](records.md), [Process: stages, kinds and documents](process-and-templates.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-status`.
