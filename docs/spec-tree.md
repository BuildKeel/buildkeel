# The spec tree

The spec tree is where BuildKeel keeps your plan: business ideas, epics, stories, tasks, test plans, bugs and ad-hoc work, with every approved version and every completion record. It is a directory of markdown and YAML files, versioned in git like your code.

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
  bugs/BUG-001/bug.md            one directory per bug
  adhoc/AH-001/adhoc.md          one directory per ad-hoc unit
```

Each artifact has its own directory, named by its ID, holding its working file. As the artifact moves through its life, BuildKeel adds records next to it:

| Directory | Holds |
|---|---|
| `versions/` | A frozen copy of each approved version, such as `v1.md`, and `v0.md` for version 0 |
| `approvals/` | One approval record per approved version, such as `v1.yaml`, and `v1-pending.yaml` for an approval made while its number could not be assigned (see [Approving artifacts](approval.md)) |
| `sources/` | For version 0: each source it was drafted from, kept as it was read, and frozen with it (see [Version 0](approval.md#version-0-code-from-before-buildkeel)) |
| `completions/` | One record each time the work is finished |
| `repins/` | One record each time someone confirms the artifact, or in a test plan one of its test cases, is still valid after what it was built against changed |
| `test-plan/` | The artifact's test plan, `plan.md`, with its own `versions/` and `approvals/` |
| `design/` | The artifact's design document, `design.md`, with its own `versions/` and `approvals/` |
| `<document>/` | A document of your team's own, such as `threat-model/threat-model.md`; see [Process and templates](process-and-templates.md#your-own-documents) |

Records are written once and never edited, so two branches that add records merge without conflicts. Edit only working files, and always through BuildKeel.

Version 0, which describes code as it was before BuildKeel, is drafted in `onboard.md` beside the working file, so it can be drafted while the next version is drafted too. Approving it writes `versions/v0.md` and `approvals/v0.yaml`, and removes `onboard.md`.

The hierarchy is not in the directory structure. Each artifact names its parent in its own file, so moving a story to another epic never moves files. Use `/bk:status` to see the tree as a hierarchy.

### IDs

Every artifact type has a prefix and its own number sequence: `BI-01`, `EP-01`, `US-001`, `TK-001`, `BUG-001`, `AH-001`. While an artifact is a draft it has a temporary ID that starts with its type's prefix, such as `US-draft-k3x9` for a user story, and its directory carries that name. It receives its permanent number when it is first approved, and BuildKeel renames the directory and updates every reference to it.

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
- Business ideas and ad-hoc units have no parent. A bug may have one (the work it was found in) or stand alone. Every other artifact must have one.
- Which fields and sections each type needs is set by its template.

## buildkeel.yaml

The file at the root of the spec tree. Its presence is what makes a directory a spec tree.

```yaml
format: 1
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
| `repos` | The code repositories that use this tree. Each has a `name`, and optionally its `remote` and a `baseline` commit: commits up to the baseline predate BuildKeel and are never reported as untracked work. |
| `templates` | An organization template source, with a fixed `version`. |
| `process` | Your process: stages, ID prefixes, the letter of onboarded numbers (`onboarded.letter`, `E` by default) and gate settings. Leave it out to use the default process. |
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

## Format versions

`format` in `buildkeel.yaml` tells BuildKeel which version of the file layout the tree uses.

- **An older format:** BuildKeel reads the tree but does not change it, and asks you to run `/bk:migrate`. Migration upgrades the tree in one commit you can review, and never alters approved versions.
- **A newer format** than your BuildKeel supports: BuildKeel reads the tree but does not change it, and asks you to update the plugin.

BuildKeel never rewrites files to a new format without being asked.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-status`, `/bk-migrate`.
