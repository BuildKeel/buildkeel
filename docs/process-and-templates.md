# Process and templates

BuildKeel works through a process: a chain of stages from a business idea down to the work you build, the kinds of work at each stage, the documents each needs, and a template for every kind of artifact. The default process needs no setup. When your team needs something different, you can rename stages, add your own, hold several kinds of work at one stage, choose the documents each requires and add your own kinds of document, change ID prefixes, choose how strictly each gate applies, and change templates. Setup asks about each of these, one at a time: see [Setting up a Full SDLC tree](setting-up-full-sdlc.md).

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

Every artifact in the chain can have a **test plan** and a **design document**: see [Documents attached to a stage](#documents-attached-to-a-stage).

Each artifact's parent is of the stage directly above it: an epic sits under a business idea, a story under an epic, a task under a story. Business idea, epic and user story always exist. Tasks are optional: a team that builds stories directly can leave them out.

## Documents attached to a stage

Documents that say how a stage's work is tested or built live with the stage's artifact, not in the chain of stages:

| Document | What it is | Example ID | Required by default |
|---|---|---|---|
| Test plan | The test cases for an artifact, each saying what it covers | `US-001-TP` | for every user story |
| Design document | How an artifact's work is built, and the decisions behind it | `EP-01-DD` | for every epic |

Any stage can have either. A document is named after its artifact and sits in a folder inside the artifact's directory (`test-plan/`, `design/`). It is drafted, approved and versioned like any artifact, with its own frozen copies and approval records; it needs no number of its own, and it takes its artifact's number when the artifact gets one.

Work cannot start on a unit until every document the process requires of it, and of everything above it, is approved, and a required test plan leaves no acceptance criterion uncovered. With the default process, a task starts once its story's test plan and its epic's design document are approved. A unit is built against the documents as they were when it was started: a later version that changes what the work is built on makes the unit suspect (see [Change impact](change-impact.md)).

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

### Setting up the process

When `/bk:init` creates a Full SDLC spec tree, it shows the default process as a table and asks whether your team uses it as it is. If not, you describe how your team works, and Claude asks about each topic your description leaves out, one at a time, then settles a template for each stage, kind or document you added. What you confirm is written to `buildkeel.yaml`, with the templates, together. [Setting up a Full SDLC tree](setting-up-full-sdlc.md) walks through every question, with three complete processes. You can change the process later in `buildkeel.yaml`.

## Seeing and changing your settings

Run `/bk:settings` at any time, or ask Claude "what's our process?", to see how the repository is set up: the mode, where the spec tree lives, the process table with the documents each stage requires and the gates, and each template with where it comes from, the tree's own, your organization's or BuildKeel's built-in one. Claude then offers to show any template in full. It changes nothing. See [/bk:settings](commands.md#bksettings).

BuildKeel does not change the settings after setup. To change one, edit `buildkeel.yaml` or a file in `templates/` in the spec tree, and commit the change with the spec tree so your team gets it. Take care with a tree that already holds artifacts: a changed prefix applies to new IDs only, and a stage, kind or required document you remove or add applies to the artifacts already there. Run validation afterwards; it reports what no longer fits, such as an added stage with no template.

## Changing the process

The process is set in the `process` section of `buildkeel.yaml`. Everything in it is optional: what you leave out keeps its default. For example:

```yaml
format: 3
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

### Renaming a stage

Give a stage a `name` to call it what your team calls it. BuildKeel then uses that name in its commands and their output: with stories named "feature", you draft one with `/bk:new feature EP-01`, the tree lists `US-001 feature`, and the agent writes "feature" when it talks to you. In Antigravity the commands are `/bk-new` and so on.

A renamed stage keeps what it is. Features are still user stories to BuildKeel: their acceptance criteria are what test plans cover, tasks under them take their test cases, and a change to them makes the work built on them suspect, as for any story. Its artifacts stay in the stage's usual directory (`stories/`).

### Adding a stage

Add a stage of your own between the business idea and the user story, such as a capability stage between epic and story:

- `type`: what BuildKeel calls it, in lowercase letters, digits and hyphens. It is also the name of its template, and of the working file in each artifact's directory (`capability.md`).
- `prefix`: the start of its IDs. Required, since no default exists.
- `width`: the number of digits in its IDs (3 when left out).
- `dir`: the directory its artifacts live in (the type when left out).
- `name`: what your team calls it (the type when left out).

An added stage needs a template, `templates/capability.md` in your spec tree (see [Using your own template](#using-your-own-template)). Setup settles it with you when you add the stage there; when you add one later, add its template too. Validation reports a stage that has none.

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

Each one names a stage or a kind of your process; validation reports one that is not. See [Defects and ad-hoc units](defects-and-adhoc.md).

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

A spec tree that is behind its remote is never a reason to stop: BuildKeel always warns about it, whatever the gate's mode, even with the gate off.

### Task plans

A task's own test plan is recorded as it is saved, with no approval: `taskPlans: record`, the default. To approve task plans like every other plan, set:

```yaml
process:
  taskPlans: approve
```

The plans of stories, epics and business ideas are always approved. See [Test plans](test-plans.md#a-tasks-own-plan-is-recorded).

### When the process changes

Changing the process never changes what is already approved. When you add a stage, stories approved under an epic stay approved; validation lists them under "Approved under earlier rules", and each is moved under a capability when its next version is approved.

## Templates

A template says what an artifact of one type must contain. BuildKeel drafts new artifacts from it, and checks every artifact against it before it can be approved.

A template looks like the artifact it describes. Its top block lists the fields and sections; its body is the starting point for a new artifact, with guidance in comments. This is the built-in story template:

```markdown
---
template: story
version: 1
description: A user story with numbered acceptance criteria. Its test plan covers every criterion.
fields:
  title: { required: true }
  parent: { required: true, type: link }
  scope: { type: list }
sections:
  Summary: { required: true }
  Story: { required: true, tracked: true }
  Acceptance criteria: { required: true, tracked: true, items: { prefix: AC, style: list } }
  Open questions: { offered: "Questions left open, each with what it is about, to settle later. They do not block approval: the approval summary lists them." }
  Notes: {}
---

## Summary

<!-- One or two sentences. Approved with the story, and what the agent reads about it when it is not the work at hand. -->

## Story

<!-- As a <who>, I want <what>, so that <why>. -->

## Acceptance criteria

<!-- One entry per criterion, each one behavior a test can check, with an ID: - **US-001-AC1** A reset link is emailed within one minute. -->

## Notes

<!-- Background, examples and links. Changes here never make other work suspect. -->
```

### Fields

| Setting | Meaning |
|---|---|
| `required` | The artifact cannot be approved without it. |
| `type` | `text` (the default), `list` such as `[src/reset/, src/email/]`, or `link`: another artifact's ID and version, such as `EP-01@v1`. |
| `tracked` | Whether a change to it makes work built on this artifact need review. |

Every artifact also has an `id` field, which BuildKeel manages. Every built-in template offers a `scope` field: the paths in the code the artifact covers, such as `[src/reset/]`. A task names the paths it will touch; a story or epic that describes code from before BuildKeel names the code it covers. BuildKeel uses scopes to say which artifacts describe a file, to warn when work strays outside them, and to suggest where a standalone defect belongs.

### Sections

| Setting | Meaning |
|---|---|
| `required` | The section must be present and not empty. A section holding only the template's guidance comments counts as empty. |
| `tracked` | Whether a change to it makes work built on this artifact need review. Leave background sections untracked so that rewording them disturbs nothing. |
| `offered` | A section the template offers but leaves out of its starting point, with one line saying what goes in it. It is added only when the work needs it, and then checked like any other section. |
| `items` | The section is a list of numbered entries. `prefix` is the letters in each entry's ID. `style` is `list` for entries like `- **US-001-AC1** ...` or `heading` for entries like `### US-001-TC1 ...`. `covers: required` makes each entry say which criteria it tests. With `style: heading`, `children` nests numbered `####` entries under each one, such as a requirement's scenarios: `children: { prefix: S, style: heading }` gives `### AUTH-R3 ...` its `#### AUTH-R3-S1 ...` entries. |

Every built-in template has a section for further material, **Notes**, where anything that fits no other section goes, so content brought in from elsewhere is kept rather than dropped.

Every built-in template also offers **Open questions**, for a question you chose to settle later, such as a gap `/bk:capture` found in the conversation. It is added only when it holds something. An open question never blocks approval: the approval preview and result list it, and in a Spec-driven tree the change's view shows a proposal's open questions at the top.

Business ideas, epics, stories and design documents have a **Summary** section. It is approved with the artifact, and it is what the agent reads about an artifact that is further up the chain than the work at hand.

### Entries and their IDs

Acceptance criteria, goals and test cases each have an ID made of the artifact's ID and a number: `US-001-AC2` is the second acceptance criterion of `US-001`, and `US-001-TC3` the third test case in its test plan. A number is never reused, even after its entry is removed. BuildKeel assigns the numbers: a new entry is written with `{{new}}` as its number, such as `US-001-AC{{new}}`, and numbered when the draft is saved. See [Test plans and coverage](test-plans.md).

A story's acceptance criteria:

```markdown
---
id: US-001
title: Request a reset link
parent: EP-01@v1
---

## Summary

A customer asks for a reset link and receives it by email.

## Story

As a customer who forgot my password, I want a reset link by email, so that I can get back into my account.

## Acceptance criteria

- **US-001-AC1** A reset link is emailed within one minute.
- **US-001-AC2** The link expires after 30 minutes.
```

Its test plan, where every test case says what it covers:

```markdown
---
parent: US-001@v1
---

## Test cases

### US-001-TC1 Reset link arrives
covers: [US-001-AC1]

1. Request a reset for a known address.
2. The email arrives within one minute.

### US-001-TC2 Expired link is refused
covers: [US-001-AC2]

1. Open a reset link 31 minutes after it was sent.
2. The page says the link has expired.
```

### The design document

The built-in design document is quick to fill in and complete in scope. Its starting point holds what most designs need; only the summary, context and design are required, so a small epic's design can be short. Further sections are offered, and added only when the work needs them. The design, the decisions, and the architecture, data and interfaces are tracked: a change to them makes the work built on the design suspect. A change in a Spec-driven tree uses the same design document, with the change as its parent.

```markdown
---
template: design
version: 1
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

### Using your own template

To change a template, copy the built-in one into a `templates/` folder at the root of your spec tree, keeping its file name (`story.md`, `test-plan.md`, and so on), and edit it. Raise its `version` whenever you change its rules: each approval records the template version the artifact was checked against.

BuildKeel uses your template in place of the built-in one for that type. Types you do not override keep the built-in template. When your organization keeps shared templates, BuildKeel looks in your spec tree first, then in the organization's templates, then in its built-in ones; see [Organization templates](organization-templates.md).

The built-in templates are `idea.md`, `epic.md`, `story.md`, `task.md`, `test-plan.md`, `design.md`, `defect.md` and `adhoc.md`.

A Spec-driven tree has four more of its own: `capability.md`, `proposal.md`, `spec-change.md` and `tasks.md`, overridden the same way. A change's design uses `design.md`. A Full SDLC tree never falls back to these four, so a stage you add with one of their names still needs its own template. See [Capability specs](capability-specs.md).

A stage or kind you add has no built-in template, so it needs one of its own, named after its type. Setup settles each with you: Claude drafts it from the closest built-in template, or you provide a file, which BuildKeel checks against the template format before using it. For the capability stage in the example above, `templates/capability.md`:

```markdown
---
template: capability
version: 1
description: A part of an epic that its stories deliver together.
fields:
  title: { required: true }
  parent: { required: true, type: link }
sections:
  Summary: { required: true }
  Scope: { required: true, tracked: true }
  Notes: {}
---

## Summary

<!-- Two or three sentences: what the agent reads about this capability when it works on a story under it. -->

## Scope

<!-- What this part of the epic delivers. Changes here make the stories under it suspect. -->

## Notes

<!-- Background and links. Changes here never make other work suspect. -->
```

### Changing a template

A template change never changes what is already approved: an approval records the template and version it was checked against, and stays valid. Validation lists approved artifacts that do not follow the current template under "Approved under earlier rules", with what each lacks, and `/bk:status` counts them. Each is checked against the current template when its next version is approved.

### Rules for each artifact type

Rules add your team's conventions without changing a template. They sit in `buildkeel.yaml` under `rules`, by artifact type, in either mode:

```yaml
rules:
  proposal:
    sections: [Non-goals]
    notes:
      - Name the rollout plan for any change users can see.
  story:
    sections: [Notes]
```

- `sections` are required on top of the template's. The template check reports one that is missing or empty, saying the tree's rules require it. A section the template only offers becomes required.
- `notes` are guidance Claude receives with the template whenever it drafts an artifact of that type.

An artifact approved before a rule was added stays approved: validation lists it under "Approved under earlier rules", and its next version is checked against the rule. Validation reports rules for a type the tree does not have, such as `story` in a Spec-driven tree.

### Coverage declarations

The built-in test plan template requires every test case to say what it covers (`covers: required`). BuildKeel relies on it: a change to a story makes exactly the test cases covering what changed suspect, and a criterion no test case covers is a gap. If your test plan template makes it optional, validation and `/bk:status` warn you: a test case without a `covers` line is never marked suspect when what it tests changes, and counts toward no criterion.

## What BuildKeel checks

Before an artifact can be approved, BuildKeel checks it against its template and lists every problem it finds:

- a required field that is missing, or a field in the wrong form;
- a required section that is missing or empty, or a section that appears twice;
- an entry without an ID, with another artifact's ID, or with an ID used twice;
- a test case that does not say what it covers;
- an entry that reuses the ID of one removed in an earlier version;
- in a test plan, a test case that covers something the plan may not cover, and, in a story's plan, an acceptance criterion that no test case covers (see [Test plans and coverage](test-plans.md)).
