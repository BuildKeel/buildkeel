# Process: stages, kinds and documents

BuildKeel works through a process: a chain of stages from a business idea down to the work you build, the kinds of work at each stage, the documents each needs, and how strictly each gate applies. The default process needs no setup; this page shows how to set up your own, and what each part of it means.

## Before you start

You need a Full SDLC spec tree, or one you are about to create with `/bk:init`. A Spec-driven tree has no stages: only its numbering and its lock gate can change (see [ID prefixes](#id-prefixes)). To see the process you have now, run `/bk:settings`: see [Change your configuration](configuration.md#1-see-what-you-have-now).

> **Nothing is written before you agree.** At setup, Claude shows the whole process as a table before anything is written. After setup, BuildKeel never changes the process itself: you change `buildkeel.yaml`, and commit it.

## 1. Set up the process

Setup asks about the process when `/bk:init` creates a Full SDLC spec tree.

1. Run `/bk:init` and choose Full SDLC.
2. Read the default process when Claude shows it as a table.
3. Say whether your team uses it as it is. If it does, setup goes on.
4. If not, describe how your team works, in your own words. Say as much or as little as you like.
5. Answer Claude's questions. It asks about each topic your description leaves out, one at a time, in this order, with the default first: stages, kinds, prefixes, documents, task test plans and gates. It assumes nothing you did not say, and names anything the process cannot express with the closest setting it has.
6. Read the whole process when Claude shows it as a table, then agree, change something, or stop.
7. Settle a template for each stage, kind or document you added, one at a time: **Claude drafts it** (the default), from the closest built-in template, or **I'll provide a file**, which BuildKeel checks against the template format before using it.

What you confirm is written to `buildkeel.yaml`, with the templates, together. Nothing is left for later: each added type needs its template before setup writes anything.

## 2. Change the process later

1. Open `buildkeel.yaml` at the root of the spec tree.
2. Change its `process` section, using the settings below. Everything in it is optional: what you leave out keeps its default.
3. Add a template for each stage, kind or document you add: see [Templates](templates.md#2-add-a-template-for-a-new-stage-kind-or-document).
4. Ask Claude to validate the spec tree. It reports what no longer fits, such as an added stage with no template.
5. Commit the change with the spec tree, so your team gets it.

For example:

```yaml
format: 4
mode: full-sdlc
process:
  chain:
    - type: idea
    - type: epic
    - type: capability
      prefix: CAP
      width: 2
      dir: capabilities
    - type: story
      name: feature
      prefix: FEAT
    - type: task
  gates:
    start: warn
```

It adds a capability stage between epic and story, calls stories "features" and numbers them `FEAT-001`, and lets work start with a warning when a check fails. Business ideas, epics and tasks keep their defaults.

> **What happens to work already done.** Changing the process never changes what is already approved. A changed prefix applies to new IDs only. A stage, kind or required document you remove or add applies to the artifacts already there: when you add a stage, stories approved under an epic stay approved; validation lists them under "Approved under earlier rules", and each is moved under a capability when its next version is approved. Required documents are checked when work starts, so a unit already started is not stopped by one you add.

## The default process

```
Business idea → Epic → User story → Task
```

| Type | What it is | ID prefix | Example |
|---|---|---|---|
| Business idea | The problem worth solving and how success is measured | `BI` | `BI-01` |
| Epic | A body of work that delivers part of an idea | `EP` | `EP-01` |
| User story | One piece of user-facing behavior, with acceptance criteria | `US` | `US-001` |
| Task | Part of a story, built in one code repository (optional) | `TK` | `TK-001` |
| Defect | Code that does not do what was agreed: attached to the task or story where it was found, or, when reported, to the work it affects (a story by default) | `DEF` | `DEF-001` |
| Ad-hoc unit | A small change, recorded so every commit traces to something | `AH` | `AH-001` |

Every artifact in the chain can have a **test plan** and a **design document**: see [Documents a stage requires](#documents-a-stage-requires).

Each artifact's parent is of the stage directly above it: an epic sits under a business idea, a story under an epic, a task under a story. Business idea, epic and user story always exist. Tasks are optional: a team that builds stories directly can leave them out.

## Documents a stage requires

Documents that say how a stage's work is tested or built live with the stage's artifact, not in the chain of stages:

| Document | What it is | Example ID | Required by default |
|---|---|---|---|
| Test plan | The test cases for an artifact, each saying what it covers | `US-001-TP` | for every user story |
| Design document | How an artifact's work is built, and the decisions behind it | `EP-01-DD` | for every epic |

Any stage can have either. A document is named after its artifact and sits in a folder inside the artifact's directory (`test-plan/`, `design/`). It is drafted, approved and versioned like any artifact, with its own frozen copies and approval records; it needs no number of its own, and it takes its artifact's number when the artifact gets one.

Work cannot start on a unit until every document the process requires of it, and of everything above it, is approved, and a required test plan leaves no acceptance criterion uncovered. With the default process, a task starts once its story's test plan and its epic's design document are approved. A unit is built against the documents as they were when it was started: a later version that changes what the work is built on makes the unit suspect (see [When a requirement changes](change-impact.md)).

### Which documents each stage requires

Set `requires` on a stage, naming its documents by type:

```yaml
process:
  chain:
    - type: idea
    - type: epic
      requires: []
    - type: story
      requires: [test-plan, design]
    - type: task
```

This team writes a design document for each story rather than each epic. A stage you leave without `requires` keeps its default: a design document for an epic, a test plan for a story, and nothing for the other stages. `requires: []` requires nothing.

### Your own documents

Add a kind of document under `documents`, and require it where it belongs:

```yaml
process:
  documents:
    - type: threat-model
      name: threat model
      suffix: TM
  chain:
    - type: idea
    - type: epic
    - type: story
      requires: [test-plan, threat-model]
    - type: task
```

- `type`: what BuildKeel calls it, in lowercase letters, digits and hyphens. It is also the name of its template and of its working file (`threat-model.md`).
- `suffix`: 2 to 4 capital letters after the artifact's ID, such as `US-001-TM`. Required, and different from every other document's.
- `dir`: the folder inside the artifact's directory (the type when left out).
- `name`: what your team calls it (the type, with spaces, when left out).

It needs a template of its own, such as `templates/threat-model.md`; validation reports a document type that has none. Draft one with `/bk:new threat model US-001`.

### Renaming a document

```yaml
process:
  documents:
    - type: design
      name: tech spec
```

Commands and output then call it a tech spec, and it is checked and required exactly as the design document. A built-in document keeps its suffix and folder.

### The design document

The built-in design document is quick to fill in and complete in scope. Its starting point holds what most designs need; only the summary, context and design are required, so a small epic's design can be short. Further sections are offered, among them Approaches: the approaches considered, the one chosen and why, and the non-goals and things to avoid, filled from the conversation. Spec-driven mode's proposal offers the same section. Offered sections are added only when the work needs them. The design, the decisions, and the architecture, data and interfaces are tracked: a change to them makes the work built on the design suspect. A change in a Spec-driven tree uses the same design document, with the change as its parent.

```markdown
---
template: design
version: 2
description: How a stage's work is built, and the decisions behind it. Fill in what applies; add an offered section only when the work needs it.
fields:
  parent: { required: true, type: link }
sections:
  Summary: { required: true }
  Context: { required: true }
  Goals and non-goals: {}
  Design: { required: true, tracked: true }
  Decisions: { tracked: true }
  Risks and trade-offs: {}
  Approaches: { offered: "The approaches considered, the one chosen and why, and the non-goals and things to avoid, from the conversation only." }
  Architecture: { tracked: true, offered: "The components, how they connect, and where each one runs." }
  Data: { tracked: true, offered: "What is stored, its shape, and how it changes over time." }
  Interfaces: { tracked: true, offered: "The APIs, events and contracts other code relies on." }
  Security and privacy: { offered: "Who can do what, which data is sensitive, and how it is protected." }
  Performance and scale: { offered: "The expected load, the limits, and how the design meets them." }
  Operations: { offered: "How it is deployed, monitored and supported." }
  Rollout and rollback: { offered: "How it is released, and how it is undone if something goes wrong." }
  Testing approach: { offered: "How the design is tested beyond the test cases in its test plans." }
  Open questions: { offered: "Questions that can safely wait, each with who answers it and by when. A question whose answer would change the specs or tasks is answered first." }
  Notes: { offered: "Background, links, and anything from a source that fits no other section." }
---

## Summary

<!-- Two or three sentences: what is built and how. Approved with the document, and what the agent reads about it when working under it. -->

## Context

<!-- What exists today, and why this work is needed. -->

## Goals and non-goals

<!-- What the design must achieve, and what it deliberately leaves out. -->

## Design

<!-- How it works: the parts, what each does, and how they fit together. -->

## Decisions

<!-- One entry per decision: ### 1. <the choice>, then why, and the alternatives considered. -->

## Risks and trade-offs

<!-- What could go wrong or is given up, and how that is handled. -->
```

## Stages, kinds and prefixes

### Renaming a stage

Give a stage a `name` to call it what your team calls it. BuildKeel then uses that name in its commands and their output: with stories named "feature", you draft one with `/bk:new feature EP-01`, the tree lists `US-001 feature`, and the agent writes "feature" when it talks to you.

A renamed stage keeps what it is. Features are still user stories to BuildKeel: their acceptance criteria are what test plans cover, tasks under them take their test cases, and a change to them makes the work built on them suspect, as for any story. Its artifacts stay in the stage's usual directory (`stories/`).

### Adding a stage

Add a stage of your own between the business idea and the user story, such as a capability stage between epic and story:

- `type`: what BuildKeel calls it, in lowercase letters, digits and hyphens. It is also the name of its template, and of the working file in each artifact's directory (`capability.md`).
- `prefix`: the start of its IDs. Required, since no default exists.
- `width`: the number of digits in its IDs (3 when left out).
- `dir`: the directory its artifacts live in (the type when left out).
- `name`: what your team calls it (the type when left out).

An added stage needs a template, `templates/capability.md` in your spec tree (see [Templates](templates.md#2-add-a-template-for-a-new-stage-kind-or-document)). Setup settles it with you when you add the stage there; when you add one later, add its template too. Validation reports a stage that has none.

The stage is part of the chain like any other. A story's parent is now a capability, and a capability's an epic: approving a story whose parent is still a draft is refused, starting work under a capability that is not approved is refused, and a change to an approved capability makes the stories under it suspect. An added stage is not worked on directly: like an epic, it can have a test plan covering the stories under it and their criteria, and it is finished with `/bk:done CAP-01` once everything under it is done.

Stages go between the business idea and the user story only. Work is done on stories, tasks, defects and ad-hoc units, so nothing is added below a story.

### Kinds within a stage

A stage can hold more than one kind of work. List them under the stage's `kinds`:

```yaml
process:
  chain:
    - type: idea
    - type: epic
    - type: story
      kinds:
        - type: feature
          prefix: FEAT
          requires: [test-plan, design]
        - type: enhancement
          prefix: EN
    - type: task
```

The stage's own fields describe its own kind, here the user story. Each kind in `kinds` takes the same settings as a stage you add: `type`, `prefix` (required), `width`, `dir` (the type when left out), `name` and `requires` (the stage's own when left out).

Each kind is an artifact type of its own: numbered in its own sequence (`US-001`, `FEAT-001`, `EN-001`), drafted from its own template (`templates/feature.md`), with its own required documents. It behaves as its stage does: a feature is approved, tested, built and finished as a user story is, a task can sit under any kind at the story stage and takes its test cases, and a change to a feature makes the work under it suspect. Any kind at the stage above is a valid parent.

When you capture new work, Claude proposes the kind of each new artifact from where the work came from, such as an enhancement for an improvement to an existing screen, and you confirm or change it before anything is drafted. A kind needs a template of its own, like an added stage, and every prefix must differ from every other kind's and unit's.

### ID prefixes

Each type has its own prefix and its own number sequence, so the first epic is `EP-01` and the first story is `US-001`. To change a prefix or the number of digits, set `prefix` and `width` on the stage, or under `defect` and `adhoc`:

```yaml
process:
  defect:
    prefix: DEF
```

- Every type needs its own prefix. Prefixes are 1 to 8 capital letters or digits, starting with a letter.
- A changed prefix applies only to artifacts numbered afterwards. IDs already given never change.
- The sequence carries on: after `US-007`, the next story numbered with the prefix `FEAT` is `FEAT-008`, so no number is used twice for one type.

In a Spec-driven tree, the numbering of changes, defects and ad-hoc units is set the same way, such as `change: { prefix: RFC, width: 4 }` under `process`. Setup asks about it when it creates the tree.

### Defects in the chain

A defect found while building sits under the task or story where it was found, and needs no approval. A defect that users, customers or testers report is planned work: it sits under the work it affects and is approved before work on it starts. By default that is a user story. To allow other kinds, such as features beside user stories, list them under `defect`:

```yaml
process:
  chain:
    - type: idea
    - type: epic
    - type: story
      kinds:
        - type: feature
          prefix: FEAT
    - type: task
  defect:
    parents: [story, feature]
```

Each one names a stage or a kind of your process; validation reports one that is not. See [Small fixes, defects and spikes](defects-and-adhoc.md).

## Gates and task plans

### Gate modes

BuildKeel checks your work at four gates:

| Gate | Checks |
|---|---|
| `approve` | before an artifact is approved: it follows its template, and its parent is approved |
| `start` | before work starts: everything above the unit is approved and not suspect, and the documents the process requires are approved, with a test plan that leaves no gaps |
| `done` | before a unit is finished: its test cases pass |
| `lock` | before the agent edits approved versions and records |

Each gate has a mode:

- `block` (the default): a failing check stops the action, and BuildKeel says what to do about it.
- `warn`: the action goes ahead, and each failing check is shown with what to do about it. For the lock gate, the edit goes ahead and the agent is told afterwards; validation and `/bk:status` report the changed file.
- `off`: the gate is not checked.

```yaml
process:
  gates:
    start: warn
    lock: block
```

A gate's mode is read from `buildkeel.yaml` each time the gate runs, so a change applies from the next action. If the process has a problem, every gate blocks until it is fixed. A Spec-driven tree's only gate is the lock gate. The done gate's TDD and review-findings checks have modes of their own: see [Feature switches](settings.md#every-setting).

A spec tree that is behind its remote is never a reason to stop: BuildKeel always warns about it, whatever the gate's mode, even with the gate off.

### Task plans

A task's own test plan is recorded as it is saved, with no approval: `taskPlans: record`, the default. To approve task plans like every other plan, set:

```yaml
process:
  taskPlans: approve
```

The plans of stories, epics and business ideas are always approved. See [Tests and traceability](test-plans.md).

## What BuildKeel checks

Before an artifact can be approved, BuildKeel checks it against its template and lists every problem it finds:

- a required field that is missing, or a field in the wrong form;
- a required section that is missing or empty, or a section that appears twice;
- an entry without an ID, with another artifact's ID, or with an ID used twice;
- a test case that does not say what it covers;
- an entry that reuses the ID of one removed in an earlier version;
- in a test plan, a test case that covers something the plan may not cover, and, in a story's plan, an acceptance criterion that no test case covers (see [Tests and traceability](test-plans.md)).

What a template holds, and how to change one, is on [Templates](templates.md).

**More:** [Change your configuration](configuration.md), [Templates](templates.md), [Full SDLC mode in depth](how-full-sdlc-works.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-init`.
