# Templates

A template says what an artifact of one type must contain: BuildKeel drafts new artifacts from it, and checks every artifact against it before it can be approved. This page shows how to replace a template, add rules to one, and share one set of templates and a process across several teams.

## Before you start

You need a repository where `/bk:init` has been run. To see each template and where it comes from, run `/bk:settings`: see [Change your configuration](configuration.md#1-see-what-you-have-now).

Templates resolve in this order, the first match winning:

1. the spec tree's own `templates/` folder;
2. the organization's templates, at the version the spec tree pins;
3. BuildKeel's built-in templates.

> **What happens to work already done.** A template change never changes what is already approved: an approval records the template and version it was checked against, and stays valid. Validation lists approved artifacts that do not follow the current template under "Approved under earlier rules", with what each lacks, and `/bk:status` counts them. Each is checked against the current template when its next version is approved.

## 1. Replace a template

Copy the built-in template into your spec tree, and edit the copy.

1. Run `/bk:settings`, and ask Claude to show the template you want in full, such as the story template.
2. Save it in a `templates/` folder at the root of your spec tree, keeping its file name, such as `templates/story.md`.
3. Edit it.
4. Raise its `version` whenever you change its rules: each approval records the template version the artifact was checked against.
5. Ask Claude to validate the spec tree, and commit the template with the spec tree.

BuildKeel uses your template in place of the built-in one for that type. Types you do not override keep the built-in template.

The built-in templates are `idea.md`, `epic.md`, `story.md`, `task.md`, `test-plan.md`, `design.md`, `defect.md` and `adhoc.md`.

Two records have built-in templates in both modes, overridden the same way: `adr.md` for architecture decision records (context, decision, alternatives and consequences) and `thread.md` for a paused exploration. A team can add a section to its ADRs, such as "Security impact", and every ADR is then drafted and checked against it. A glossary entry, a practice, a note on the code, a working note and a pause record have fixed fields: no template changes them, and validation reports a template the tree holds for one.

A Spec-driven tree has four more of its own: `capability.md`, `proposal.md`, `spec-change.md` and `tasks.md`, overridden the same way. A change's design uses `design.md`. A Full SDLC tree never falls back to these four, so a stage you add with one of their names still needs its own template. See [Spec-driven mode in depth](how-spec-driven-works.md).

The task template requires each task to state its Files, Uses, Delivers and Verify (or `Interfaces: none` in place of Uses and Delivers); a task saved without one is refused, naming the field, and a team's own task template that leaves any of them out is reported (see [Build](working-on-a-unit.md)).

## 2. Add a template for a new stage, kind or document

A stage, kind or document you add to the process has no built-in template, so it needs one of its own, named after its type.

1. Name the file after the type, such as `templates/capability.md` for a capability stage.
2. Ask Claude to draft it from the closest built-in template, or write your own.
3. Ask Claude to validate the spec tree. Validation reports a stage, kind or document that has no template.

At setup, `/bk:init` settles each with you: Claude drafts it from the closest built-in template, or you provide a file, which BuildKeel checks against the template format before using it. See [Process: stages, kinds and documents](process-and-templates.md#1-set-up-the-process). For the capability stage, `templates/capability.md`:

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

## 3. Add rules to a template

Rules add your team's conventions without changing a template, in either mode.

1. Open `buildkeel.yaml` at the root of the spec tree.
2. Add a `rules` section, by artifact type:

   ```yaml
   rules:
     proposal:
       sections: [Non-goals]
       notes:
         - Name the rollout plan for any change users can see.
     story:
       sections: [Notes]
   ```

3. Ask Claude to validate the spec tree, and commit the change.

- `sections` are required on top of the template's. The template check reports one that is missing or empty, saying the tree's rules require it. A section the template only offers becomes required.
- `notes` are guidance Claude receives with the template whenever it drafts an artifact of that type.

An artifact approved before a rule was added stays approved: validation lists it under "Approved under earlier rules", and its next version is checked against the rule. Validation reports rules for a type the tree does not have, such as `story` in a Spec-driven tree.

## 4. Share templates across teams

When several teams use BuildKeel, a platform or process team can keep one set of templates and one process for all of them, in a repository of its own. Each team's spec tree points at it and pins a version, so a team's templates change only when the team decides to move to a new version.

1. Create a repository with a `templates/` folder holding a template per type, in the same format as a spec tree's own, and optionally a `process.yaml` holding a process. Either can be left out, and `templates/` needs only the types the organization wants to standardize:

   ```text
   buildkeel-templates/
     templates/
       story.md
       test-plan.md
       capability.md
     process.yaml
   ```

2. Write the process in `process.yaml`, if you share one. It has the same settings as the `process` section of `buildkeel.yaml`, at the top level:

   ```yaml
   chain:
     - type: idea
     - type: epic
     - type: capability
       prefix: CAP
       width: 2
       dir: capabilities
     - type: story
     - type: task
   gates:
     start: block
     done: block
   ```

3. Commit the templates, then tag and push the release. Each release is a git tag:

   ```sh
   git add templates process.yaml
   git commit -m "BuildKeel templates v1.0.0"
   git tag v1.0.0
   git push origin main v1.0.0
   ```

4. In each team's spec tree, name the repository and the tag in `buildkeel.yaml`:

   ```yaml
   format: 4
   mode: full-sdlc
   templates:
     org:
       source: git@github.com:acme/buildkeel-templates.git
       version: v1.0.0
   ```

   `source` is any git remote the team can fetch, or a path, which is taken from the spec tree's root.
5. Commit the change, so that the whole team moves to the organization's templates together.
6. Run `/bk:settings`: it lists every type with its template's source and version.

The process resolves the same way as templates: each setting in the spec tree's `buildkeel.yaml` wins over the organization's, and anything neither sets keeps its default.

The first time BuildKeel works in the project on a machine, it fetches that tag once and keeps a copy under `~/.buildkeel/org-templates/`. After that, nothing is fetched again for that version, and everything works offline. If the tag cannot be fetched (no connection, no access, a mistyped source), validation and `/bk:status` say why, and the types the spec tree does not override have no template until it is fetched: BuildKeel never quietly falls back to its built-in templates, since that would change what artifacts are checked against.

Asking for one type's template names its source too, and validation lists the templates and process settings the spec tree overrides.

### Override locally

A team can still differ where it needs to:

- a template in the spec tree's `templates/` folder replaces the organization's for that type;
- a setting in the `process` section of `buildkeel.yaml` replaces the organization's: the chain, `defect`, `adhoc`, or one gate's mode.

Validation lists each local override, so the difference from the organization stays visible:

```text
Templates and process come from the organization's templates git@github.com:acme/buildkeel-templates.git@v1.0.0. Overridden locally:
- the story template: templates/story.md overrides the organization's
- the start gate: warn in buildkeel.yaml overrides the organization's block
```

## 5. Move to a newer version

The version is always a tag. Validation refuses an organization source without a version, a version such as `latest` or `main` that follows whatever is newest, and a version that is a branch rather than a tag. When the organization publishes a new version, nothing changes for a team until it changes `version` in its `buildkeel.yaml`. A copy already fetched is kept, even if the organization moves the tag later.

1. Change `version` in the spec tree's `buildkeel.yaml` to the new tag.
2. Commit it.
3. Ask Claude to validate the spec tree, or run `/bk:status`, to see the approved artifacts that do not follow the new templates.

> **What happens to work already done.** Moving to a new version never changes what is already approved: each approval records the template and the organization version it was checked against, and stays valid. Validation then lists the approved artifacts that do not follow the new templates under "Approved under earlier rules", with what each lacks, and `/bk:status` counts them. Each is checked against the new templates when its next version is approved.

## How a template is built

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

Acceptance criteria, goals and test cases each have an ID made of the artifact's ID and a number: `US-001-AC2` is the second acceptance criterion of `US-001`, and `US-001-TC3` the third test case in its test plan. A number is never reused, even after its entry is removed. BuildKeel assigns the numbers: a new entry is written with `{{new}}` as its number, such as `US-001-AC{{new}}`, and numbered when the draft is saved. See [Tests and traceability](test-plans.md).

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

### Coverage declarations

The built-in test plan template requires every test case to say what it covers (`covers: required`). BuildKeel relies on it: a change to a story makes exactly the test cases covering what changed suspect, and a criterion no test case covers is a gap. If your test plan template makes it optional, validation and `/bk:status` warn you: a test case without a `covers` line is never marked suspect when what it tests changes, and counts toward no criterion.

The design document's template is on [Process: stages, kinds and documents](process-and-templates.md#the-design-document), and what BuildKeel checks before approval on [What BuildKeel checks](process-and-templates.md#what-buildkeel-checks).

**More:** [Change your configuration](configuration.md), [Process: stages, kinds and documents](process-and-templates.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-settings`.
