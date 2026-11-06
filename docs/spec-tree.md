# The spec tree

The spec tree is where BuildKeel keeps your plan: business ideas, epics, stories, tasks, test plans, defects and ad-hoc work, with every approved version and every completion record. It is a directory of markdown and YAML files, versioned in git like your code.

A spec tree can be:

- **its own repository**, serving several code repositories, or
- **a folder inside a single code repository**, such as `specs/`.

Both work the same way, with the same files and IDs. You can start with a folder and move it to its own repository later by moving the folder and updating the pointer file.

## Layout

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

That is a Full SDLC tree. A Spec-driven tree holds capability specs and changes instead of stages:

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

Both modes keep the glossary, the practices, the ADRs, the threads and the notes on the code at the top of the tree. See [Capability specs](capability-specs.md) and [The two modes](modes.md).

Each artifact has its own directory, named by its ID, holding its working file. As the artifact moves through its life, BuildKeel adds records next to it:

| Directory | Holds |
|---|---|
| `versions/` | A frozen copy of each approved version, such as `v1.md`, and `v0.md` for version 0 |
| `approvals/` | One approval record per approved version, such as `v1.yaml`, and `v1-pending.yaml` for an approval made while its number could not be assigned (see [Approving artifacts](approval.md)) |
| `sources/` | For version 0: each source it was drafted from, kept as it was read, and frozen with it (see [Version 0](approval.md#version-0-code-from-before-buildkeel)) |
| `completions/` | One record each time the work is finished |
| `closed.yaml` | For a defect closed without a fix: why, who closed it and when (see [Defects and ad-hoc units](defects-and-adhoc.md#closing-a-defect-without-a-fix)) |
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
| `<document>/` | A document of your team's own, such as `threat-model/threat-model.md`; see [Process and templates](process-and-templates.md#your-own-documents) |

A change in a Spec-driven tree keeps `notes/`, `pauses/`, `runs/`, `reviews/`, `answers/`, `switches/`, `handoffs/` and `as-built/` in its own directory the same way.

Records are written once and never edited, so two branches that add records merge without conflicts. Each one's file name holds the time and a short random suffix, such as `20261101T183000Z-k3q8.md`, or for a version of a glossary entry, a practice or a note on the code, the version and a suffix, such as `v2-k3q8.md`. When two branches each add the same version of an entry, both are kept and validation asks you to settle which one stands. Edit only working files, and always through BuildKeel.

Version 0, which describes code as it was before BuildKeel, is drafted in `onboard.md` beside the working file, so it can be drafted while the next version is drafted too. Approving it writes `versions/v0.md` and `approvals/v0.yaml`, and removes `onboard.md`.

The hierarchy is not in the directory structure. Each artifact names its parent in its own file, so moving a story to another epic never moves files. Use `/bk:status` to see the tree as a hierarchy.

### IDs

Every artifact type has a prefix and its own number sequence: `BI-01`, `EP-01`, `US-001`, `TK-001`, `DEF-001`, `AH-001`. While an artifact is a draft it has a temporary ID that starts with its type's prefix, such as `US-draft-k3x9` for a user story, and its directory carries that name. It receives its permanent number when it is first approved, and BuildKeel renames the directory and updates every reference to it.

An artifact first approved as version 0 is numbered in a second sequence of its type, with a letter before the number: `US-E001`, `EP-E01`. Its ID never changes afterwards, and neither does the ID of an artifact that gets its version 0 later.

A test plan has no number of its own: the test plan of `US-001` is `US-001-TP`.

## Artifact files

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

## buildkeel.yaml

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
| `mode` | How the tree works: `spec-driven` (capability specs and changes) or `full-sdlc` (your process's stages, approvals and gates). Required from format 2 on: BuildKeel does not read a tree in format 2 or later that names none, and says to add `mode: spec-driven` or `mode: full-sdlc`. A format 1 tree names none, and follows Full SDLC. See [The two modes](modes.md). |
| `repos` | The code repositories that use this tree. Each has a `name`, and optionally its `remote` and a `baseline` commit: commits up to the baseline predate BuildKeel and are never reported as untracked work. |
| `templates` | An organization template source, with a fixed `version`. |
| `process` | Your process: stages and the kinds within them, documents, ID prefixes, which kinds a reported defect can belong to (`defect.parents`), task plans, the letter of onboarded numbers (`onboarded.letter`, `E` by default) and gate settings. Leave it out to use the default process. See [Process and templates](process-and-templates.md). |
| `settings.autoPush` | Push each approval as soon as it is committed. Off by default. |
| `settings.idsBranch` | The branch that holds ID counters. Defaults to `buildkeel/ids`. |
| `settings.contextBudget` | The size, in characters, a unit's context view should stay within. Defaults to `10000`. A larger view is noted, never cut. See [Working on a unit](working-on-a-unit.md). |

## The pointer file: .buildkeel.yaml

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

### When repositories are checked out somewhere else

If the spec repository is checked out in a different place on your machine than the pointer says, record its location in `~/.buildkeel/paths.yaml` instead of changing the shared pointer:

```yaml
specs:
  "git@example.com:acme/payments-specs.git": /Users/me/work/payments-specs
```

The key is the `remote` from the pointer file. This file stays on your machine and is never committed.

## Teams on both hosts

One spec tree serves everyone, whichever host each person uses: Claude Code or Antigravity. The tree, its records and the commands are the same in both; only the commands' form differs (`/bk:build` in Claude Code, `/bk-build` in Antigravity). Each person installs BuildKeel for their own host (see [Install in Claude Code](install-claude-code.md) and [Install in Antigravity](install-antigravity.md)), and work paused on one host can be resumed on the other.

A few things differ by host:

- **Commands only you start** are enforced in Claude Code. Antigravity cannot block them, so there Claude is told the rule and follows it.
- **Models and effort:** a tier names a model and an effort for each host. Antigravity has no effort setting for agents, so an effort is ignored there. See [Models and effort for each role](building-with-agents.md#models-and-effort-for-each-role).
- **Completion records** note the host the work was finished on.

## Format versions

`format` in `buildkeel.yaml` tells BuildKeel which version of the file layout the tree uses. Every new tree is written in format 4. BuildKeel 0.5.0 and earlier open a format 4 tree read-only and ask for an update.

- **An older format,** such as a tree made with BuildKeel 0.5.0 or earlier (formats 1 to 3): BuildKeel reads the tree but does not change it, and asks you to run `/bk:migrate`. Migration upgrades the tree in one commit you can review, never alters approved versions, and keeps work in progress going. See [Migrating a spec tree](migration.md).
- **A newer format** than your BuildKeel supports: BuildKeel reads the tree but does not change it, and asks you to update the plugin.

BuildKeel never rewrites files to a new format without being asked.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-status`, `/bk-migrate`.
