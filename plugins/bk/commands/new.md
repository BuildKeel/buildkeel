---
description: "BuildKeel: Draft an artifact, break a parent down into drafts of its children, or record a bug."
argument-hint: <type> [parent ID] [what to draft], e.g. story EP-01, stories from EP-01, or bug TK-001
disable-model-invocation: true
---

Draft BuildKeel artifacts with the user. Everything you produce is a draft: drafting never approves anything, and every draft goes through the same checks and approval as one written by hand. A bug is the exception: it is recorded at once, with its permanent ID, and needs no approval (see "Bugs" below).

The user typed: $ARGUMENTS

If BuildKeel's session report, or `query` with `view: "process"`, says this spec tree is Spec-driven, follow "In a Spec-driven tree" at the end instead of the sections before "Bugs".

## If the user typed nothing

Ask straight away, before calling any tool, with your tool for asking a question with choices if you have one. The question itself says what they could type, in one sentence, since some hosts show only the question and its choices: "What should I draft? For example: " followed by the examples.

Take the examples word for word from BuildKeel's session report when it gives them ("Examples of what to draft, in the team's words"): they use the names this team gives its stages, which may not be the usual ones. Only when it gives none, use `story EP-01`, `stories from EP-01`, `test-plan US-001` and `bug TK-001`.

Offer two choices: **Suggest what to draft next** (the default, listed first) and **Type what to draft**; if they pick the second, ask what to draft. If they pick the suggestion, call the BuildKeel `query` tool with `view: "tree"`, propose the most useful next drafts (such as stories for an epic that has none, or a missing test plan), and ask which to draft. Then carry on below with their answer as the request.

## Work out what to draft

- **The type**: idea, epic, story, task, test-plan, design (a design document) or bug, or a stage or document the team added (the user may use their team's own name for it). If it is not clear, ask. For a bug, follow "Bugs" below instead of the rest of this prompt.
- **The parent**: every type except a business idea has one: an artifact's parent is of the stage directly above it in the process (by default an epic's parent is a business idea, a story's an epic and a task's a story; with a stage added between epic and story, a story's parent is of that stage), and a test plan's parent is the artifact it tests. If the user did not name it, call the BuildKeel `query` tool with `view: "tree"`, suggest the likely parent, and ask.
- **One draft or a breakdown**: a request such as "stories from EP-01" or "break EP-01 down" asks for a set of children of one parent. Anything else is a single draft.
- **The user's own material**: if the user pasted text, named or uploaded a file, pointed to something in a tool you can read (such as an issue tracker or a wiki), or described the requirement, use it as the main input. Fit it to the template: put each part in the section it belongs to, keeping its meaning and wording; put what fits no section in the section for further material, such as Notes; and for each required section it does not cover, ask the user, one question at a time. Never invent a requirement, a criterion or a section to fill a gap, and never add a detail the material leaves open, such as how a notice reaches the customer: ask, or keep the wording as open as the material's.
- **What it should cover**: for a single draft, if the user has not said what it is about, ask before writing. Offer suggestions drawn from the parent, but do not choose the requirement for them. A breakdown needs no such question: its scope is the parent's.
- **Code nothing describes yet**: when the artifact changes how code that already exists behaves, such as a story or task that changes something already built, work out which files it will change and call `query` with `view: "describes"` and their `paths`. If nothing describes the behavior it changes, say so in one sentence, and ask with your tool for asking a question with choices: **Draft a version 0 of what it changes first** (the default, listed first): how that code works today, so the change has a "before"; or **Draft only the new artifact**. With version 0, draft it first (see "Version 0" below), then the requested artifact: as its version 1 when it changes the same behavior, or under it.

Ask one question at a time, with your recommendation, and only for what you cannot work out.

## Read before writing

1. Call `get_template` for the type. Your draft must contain every field and section the template declares, in that structure.
2. Call `query` with `view: "artifact"` and the parent's ID, and read it. For a breakdown, also read the parent's own parent when it helps.
3. Read the user's material, if any: the file, the pasted text, or what your tools return for the issue or page they named.

## Write each draft

- Fill every section with real content. Remove the template's guidance comments.
- Write `{{id}}` wherever the artifact's own ID goes: `id: {{id}}`. BuildKeel assigns the ID.
- Write each new numbered entry with `{{new}}` as its number: `- **{{id}}-AC{{new}}** ...` or `### {{id}}-TC{{new}} ...`. BuildKeel numbers them in order. When you revise an artifact, keep the ID of every entry that already has one, and write `{{new}}` for entries you add: a removed entry's ID is never given to a new one.
- Set `parent` to the parent's ID. BuildKeel pins it to the parent's approved version.
- Keep each **Summary** to two or three sentences that stand on their own: it is what the agent later reads about this artifact when working further down.
- Acceptance criteria are specific and testable, one behavior each.
- Save it with `save_draft` (type and content). To change a draft you already saved, pass its `id`.

## Version 0

Version 0 describes what code already does, as if BuildKeel had been used from the start, so a change to it has a "before". Draft it with `save_draft` and `version: 0`; to add one to an artifact that already exists, pass its `id` too. Name the paths it covers in its `scope`.

- Fill the template's sections from the code and from what the user brings about it, such as a ticket or a wiki page read through their own tools, a file, or what they say. Reword what they say into the template's form, such as a ticket's description written as testable criteria; add nothing they do not support.
- Describe only what the change touches.
- Keep each source as you read it: pass it in `sources`, with where it came from, its key and link, and its text exactly as your tool returned it (description, fields and comments). Never copy code into a source.
- When a source and the code disagree, or two sources do, ask the user which is intended before drafting that part. Only the user knows, so recommend neither answer, and offer both as equals: **The code is right; the source is out of date** and **The source is right; the code has a defect**. When the code is wrong, version 0 states the intended behavior, and the defect is recorded as a bug against it once version 0 is approved. When the source is out of date, version 0 follows the code. Offer a third answer after those two, still with no recommendation: **Not sure: leave it open**. Then keep the question in the version 0 draft's front matter, under `openQuestions`, with an `id` (Q1, Q2, ...), what it is `about`, what the `code` does, what the `source` says and the `sources`' keys, and leave the part it concerns out of version 0: BuildKeel records who left it open, and version 0 waits for an answer before it can be approved. Someone who knows answers it later with /bk:onboard: add `answer: code` or `answer: source` to it, save the draft, and draft the part it concerns.
- Supported means the code or a source says it; a plausible guess is not support, such as who a story is for and why. Leave a required section empty when nothing supports it, without asking: `save_draft` lists what is empty, for the reviewer.

The change that builds on it is then saved with `save_draft`, the version 0's draft ID as `id` and no `version`: that draft is its version 1. Start from version 0's text as saved, with its entry IDs: keep the ID of every entry that stays, changed or not (a criterion whose limit changes keeps its ID), and write `{{new}}` only for an entry the change adds. Both are approved in one review with /bk:approve, version 0 first.

## Test plans

A test plan belongs to one artifact (its `parent`), and every test case has a `covers:` line saying what it checks. A test plan has no `id` field: its frontmatter is only its `parent`, and it is named after that artifact, such as `US-001-TP`.

- **A story's plan** covers the story's acceptance criteria, such as `covers: [{{id}}-AC1]`. Every criterion must be covered, or the plan cannot be approved.
- **A task's plan** covers the task itself (its ID, such as `covers: [TK-047]`) and/or its story's criteria. Unless the process approves task plans, it is recorded, not approved: each save that passes its checks, once the task is approved, becomes its next version. The story's test cases already apply to the task. Draft a plan for the task whenever its tests will not each be one of those story test cases: a building block such as a token store or a data model, a migration, or a refactor. A task without a plan of its own can be finished only when at least one of its tests is tagged with a story test case and passes.
- **An epic's plan** (its integration test plan) covers stories under the epic, or their criteria.
- **A business idea's plan** (its end-to-end test plan) covers epics under the idea, or the idea's goals.

To see what a plan covers and what it leaves out, call `query` with `view: "coverage"` and the artifact's ID.

## Design documents

A design document says how an artifact's work is built, usually an epic's. It belongs to one artifact (its `parent`), has no `id` field, and is named after it, such as `EP-01-DD`. Its template keeps a short skeleton: fill in what applies, and add an offered section (`get_template` lists them, such as Rollout and rollback) only when the work needs it. The summary, context and design are required: ask for whichever the user's material does not give.

The process may require other documents of a stage, such as a team's threat model: draft them the same way, with their own template.

## Breakdowns

- **Stories from an epic**: draft several stories that together deliver the epic's scope, each with acceptance criteria. For each story, also draft its test plan with `save_draft` (type `test-plan`, parent set to the story's draft ID), with test cases written as `### {{id}}-TC{{new}} ...` and a `covers:` line listing the acceptance criteria each one checks. Every acceptance criterion must be covered by at least one test case.
- **Epics from a business idea**, or **tasks from a story**: draft the children the same way. A task names the code repository it is built in (`repo`) and, when you can tell, the paths it will touch (`scope`). Tasks are drafted from a story's latest approved version when it has one.
- **For each task**, decide which of the story's test cases its tests will implement, and say so in the list you propose. If its tests will not be story test cases, draft the task's own test plan too (type `test-plan`, parent set to the task's draft ID), with test cases that cover the task, such as `covers: [{{id}}]`.
- Before writing, show the user the list of children you propose (titles and a line each) and ask whether to go ahead or change it.

## Bugs

A bug is a defect in work that was planned: it is recorded straight away with its permanent ID, needs no approval, and is worked on like any unit. Finishing it needs a regression test with the bug's ID in its name, such as `it("keeps reset links for 30 minutes [BUG-005]", ...)`.

1. **Where it was found.** If the user named a task or story, use it. Otherwise ask, with your tool for asking a question with choices, offering **the active unit** first when there is one, then **another task or story: type its ID**, then **nowhere known yet** (a standalone bug, such as one a customer reported). A bug is attached to a task or a story, never to an epic or anything else.
2. **The test case that found it**, when a test failed: call `query` with `view: "coverage"` and the unit's ID to see the test cases that apply there, and offer them, with **none** last. A standalone bug has none.
3. **What is wrong.** Use the user's description, or ask for it in their own words: never offer descriptions you made up as choices, since a bug records what someone saw. Write a title that names the defect, such as "Reset link expires after 3 minutes".
4. Call `get_template` for `bug`, then `save_draft` with `type: "bug"` and the whole file: `id: {{id}}`, the title, `parent` set to the unit's ID and `testCase` to the test case's ID when there are any, and the sections filled in (what is wrong, steps to reproduce, expected, actual). Leave out sections you know nothing about rather than inventing them.
5. Show the result: the bug's ID, where it is attached, and that it can be started with /bk:build <ID>. If fixing it means a requirement must change, say so: that change is made as a new version of the story or task, approved as usual.

## Finish

List every draft you saved, with its ID and title, and anything `save_draft` reported as still missing. Offer to fix what is missing or to revise any draft. Remind the user that drafts are approved with /bk:approve; a task's own test plan, when `save_draft` says it is recorded, needs no approval.

Do not create or edit spec tree files yourself; `save_draft` does all writing.

## In a Spec-driven tree

What you draft is a change, or a file of an open change: its proposal, a spec change, its design or its tasks. Nothing is approved. A bug is recorded as in "Bugs", attached to the change whose work found it (its `parent` is the change's ID, its `testCase` the scenario whose test found it) or standalone; a fix that changes a requirement is made through a change.

- **If the user typed nothing**, ask what to draft, offering **Suggest what to draft next** (the default) and **Type what to draft**. The question itself gives examples: `change for reset by text message`, `spec change for CH-012` and `bug CH-012`. For a suggestion, call `query` with `view: "changes"` and propose what an open change still lacks, such as tasks or a spec change its proposal names.
- **Read before writing.** Call `query` with `view: "capabilities"`, and with the `id` of each capability the work touches. For a file of an open change, read the change with `view: "changes"` and its `id`. Call `get_template` for each file you draft.
- **A new change**: draft its proposal, a spec change per capability it adds or modifies, a design only when it makes decisions worth recording, and tasks, and save them in one `save_draft` call with `type: "change"`, the proposal as `content` and the rest in `files`. Before saving a new capability, propose its code from its name and let the user change it.
- **A file of an open change**: save it with `save_draft`, its type and the change's `id`; read it first with `query`, `view: "changes"`, the change's `id` and `file`. To change one requirement of a spec change, pass `capability` and `requirement` in place of `content`. Then check the change's other files against it and propose the follow-on edits, such as a task for a new requirement.
- Ask one question at a time, for what you cannot work out. If the user asks to go one artifact at a time, save and show each before the next.
- Finish by listing what was saved and anything `save_draft` lists as worth fixing, and offer /bk:build with the change's ID.
