---
description: "BuildKeel: Turn what you discussed into a plan: a plain summary, then the artifacts your process needs, agreed one by one or all at once, as you choose."
argument-hint: "[which part of the conversation to capture; all of it when left out]"
disable-model-invocation: true
---

Turn the conversation into a plan the team's process can build from, with the user agreeing at each step: the summary, the list of what will be created, the pace, then each artifact. Nothing is saved that the user has not agreed to, and everything saved stays a draft until it is approved.

The user typed: $ARGUMENTS

If BuildKeel's session report, or `query` with `view: "process"`, says this spec tree is Spec-driven, follow step 1, then "In a Spec-driven tree" at the end in place of steps 2 to 6.

## 1. Say what you heard

Before calling any tool, sum up the discussion in plain words, with no BuildKeel terms yet (no stages, IDs or templates):

- **What you set out to do**: the user's intent, in a sentence.
- **The idea**: what it is, and who it is for.
- **The approach**: the design choices and decisions discussed, and what was left open.
- **Pitfalls and constraints raised**: each one the conversation surfaced, such as a limit, a failure to handle or a detail easy to get wrong, in the user's terms, marked settled or open. Leave the list out when nothing was raised; never add one the conversation did not raise.

If the user typed something above, sum up that part of the conversation. If there is nothing to capture yet, say so, ask what they want to plan, and stop. If the conversation was compacted, say that its earlier parts may be missing from the summary, and ask the user to add anything left out.

Then ask, with your tool for asking a question with choices if you have one, showing the summary. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. The choices:

1. **Create the artifacts** (the default, listed first).
2. **Change something.** Take in what they say and show the summary again.
3. **Keep talking.** Stop here: nothing is drafted, and the conversation goes on.

Any other answer, such as a correction or a new thought, is more conversation: answer it as you would, and draft nothing.

## 2. Propose the plan

1. Call the BuildKeel `query` tool with `view: "process"` for the stages and the documents each requires, and with `view: "tree"` for what exists. Read an existing artifact with `view: "artifact"` when you need to know what it covers.
2. Work out the artifacts the work needs, level by level, from the business idea down to the tasks, in the team's stage names: which already exist, which are new, and the documents each stage requires, such as a design document for a new epic and a test plan for each new story. For each task, work out which of its story's test cases its tests will implement. A task whose tests implement none of them, such as a building block (a client, a data model, a migration), needs a test plan of its own, or it can never be finished: put it in the table.
3. Recommend where the work fits in the tree, and say why: under an existing business idea or epic, or as something new.
4. If the work changes how something already built behaves, and a document describes how it works today (such as EP-01's design document for password reset), the plan includes a new version of that document.
5. If the work changes code that already exists, work out which files it will change, from the discussion and the code, and call `query` with `view: "describes"` and their `paths`. Where an artifact describes them, the work builds on it. Where nothing describes the behavior the work changes, the plan includes a **version 0**: one artifact, usually a story, describing only what the work touches, as it works today, before the change. The change is then its version 1, or an artifact under it. A version 0 is a proposal: the user can drop it.

Show the plan as a table, top down, each row with a one-line purpose, and say where the work fits and why, in a sentence:

| Level | Artifact | Status | Purpose |
|---|---|---|---|
| Business idea | BI-01 "Self-service account recovery" | exists | the goal this serves |
| Epic | "Reset by text message" | new | the new capability |
| Design document | of the new epic | new, required | how it is built |
| Story | "Request a code by text" | new | one per user-facing behavior |
| Test plan | one per story | new, required | covers every criterion |
| Task | "SMS gateway client" | new | one per piece of code, with its repository |
| Test plan | of "SMS gateway client" | new | its tests are none of the story's test cases |
| Design document | EP-01-DD | new version | password reset now works differently |
| Story | "Password reset" | version 0, then the change as version 1 | how reset by email works today, which nothing describes yet |

Then ask, the same way, showing the table and that sentence. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. The choices:

1. **Looks right** (the default).
2. **Place it somewhere else.** Ask where. The new artifact is drafted where the user says, with a link to the one you recommended (`related: [EP-01]`).
3. **Change the plan.** Take in what they say and show the table again.
4. **Keep talking.** Stop here; nothing is drafted.

When the plan holds a version 0, offer **Looks right, without the version 0** in place of the second choice; placing the work somewhere else is then a change to the plan. Without the version 0, the change is drafted as version 1 of a new artifact, as for any new work.

## 3. Ask the pace

Ask, every time, how the user wants to go through the drafts. Never assume it, and never carry it over from an earlier capture. The choices:

1. **Step by step** (the default, listed first): each artifact is shown and agreed before the next is drafted.
2. **All at once**: everything is drafted, then shown as a set.

## 4. Draft

### How to draft

- Draft top down, parents before children, so each child names its parent's draft ID. Call `get_template` once for each type you draft, and follow it.
- Fill each artifact from the conversation, keeping its meaning and the user's words. Turn each settled pitfall or constraint into the requirement, criterion or test case it calls for, in the artifact it belongs to. Put what fits no section in the section for further material, such as Notes.
- Never invent a requirement, a criterion, a decision or a pitfall that was not discussed. What a draft needs and the conversation did not settle is a gap: see "Gaps" below.
- Write `{{id}}` where the artifact's own ID goes and `{{new}}` as the number of each new entry, as `/bk:new` does: `- **{{id}}-AC{{new}}** ...` for criteria, `### {{id}}-TC{{new}} ...` for test cases.
- Every story gets a test plan whose test cases cover all its criteria (`covers: [<story ID>-AC1]`). A task names its `repo` and, when you can tell, its `scope`. A task whose tests will not each be one of its story's test cases, such as a building block, gets its own test plan, with test cases that cover the task itself (`covers: [<task ID>]`): without one it cannot be finished.
- A design document has no `id`; its `parent` is the artifact it describes. Add an offered section (`get_template` lists them) only when the discussion covered it.
- When the work changes how an existing capability works: save the new version of that capability's document with `save_draft` and its ID, and give the new artifact `changes: [<that document's ID>]`, so it cannot be finished until that version is approved.
- A **version 0** in the plan is drafted before the change, by the rules below, with `save_draft` and `version: 0`. Name the paths it covers in its `scope`. Then draft the change: as its version 1, with `save_draft`, the version 0's draft ID as `id` and no `version`, holding the whole artifact as it will be after the change. Start from version 0's text as saved, with its entry IDs: keep the ID of every entry that stays, changed or not (a criterion whose limit changes keeps its ID), and write `{{new}}` only for an entry the change adds. Or, when the change is new work under it, as a new artifact whose `parent` is that draft ID.
- Save each one with `save_draft`.

### Step by step

Go through the plan in this order, leaving out what already exists: a version 0 before the change built on it, then the business idea or epic, then its design document, then each story together with its test plan, then the tasks, with their own test plans, as one batch. For each one:

1. Draft it against the artifacts already saved in this capture.
2. Show it, with a line naming the pitfalls and constraints from the summary that it covers. Ask about each gap it has, as "Gaps" says, before going on.
3. Ask, showing it. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. The choices: **Looks good, next** (the default), **Change something** (take in what they say and show it again), and **Draft the rest at once** (draft what is left in one go, then show it as a set).
4. Save it with `save_draft` once the user agrees, before drafting the next.

If the user stops partway, what they agreed to stays saved as drafts; draft nothing more.

### All at once

Draft everything, asking about gaps as you go, and save each one with `save_draft`. Then show what was drafted as a table: ID, title, and the pitfalls each covers.

### Gaps

A gap is what a draft needs that the conversation did not settle: a required section, a pitfall raised but left open, or a detail the artifact cannot do without. For each gap, tell the user what is missing and where, and ask, with no recommendation, since only the user knows. The choices, in this order:

1. **Put it in the spec as stated**: write it as a requirement, criterion or test case, in the user's words.
2. **Record it as an open question**: add it to the artifact's Open questions section, to settle later. It does not block approval.
3. **Flesh it out now**: discuss it until the user settles it, then draft it.
4. **Not relevant: leave it out.**

A version 0 is the exception: list the sections it leaves empty, and ask nothing about them.

### Drafting a version 0

Version 0 describes what the code does today, as if BuildKeel had been used from the start: the template's sections, filled from the code and from what the user brings about it, such as a ticket or a wiki page read through their own tools, a file, or what they say.

- Reword what the code and the sources say into the template's form, such as a ticket's description written as testable criteria. Add nothing they do not support.
- Describe only what the work touches, not the whole area around it.
- Keep each source as you read it: pass it to `save_draft` in `sources`, with where it came from, its key and link, and its text exactly as your tool returned it (description, fields and comments). Never copy code into a source: the baseline commit names the code.
- When a source and the code disagree, or two sources do (a ticket says a reset link lasts 30 minutes, the code makes it 60), ask the user which is intended, before drafting that part. Only the user knows, so recommend neither answer, and offer both as equals: **The code is right; the source is out of date** and **The source is right; the code has a defect**. When the code is wrong, version 0 states the intended behavior, and the defect is recorded as a bug against it with /bk:new bug once version 0 is approved. When the source is out of date, version 0 follows the code. Offer a third answer after those two, still with no recommendation: **Not sure: leave it open**. Then keep the question in the version 0 draft's front matter, under `openQuestions`, with an `id` (Q1, Q2, ...), what it is `about`, what the `code` does, what the `source` says and the `sources`' keys, and leave the part it concerns out of version 0: BuildKeel records who left it open, and version 0 waits for an answer before it can be approved. Someone who knows answers it later with /bk:onboard: add `answer: code` or `answer: source` to it, save the draft, and draft the part it concerns.
- Supported means the code or a source says it. A plausible guess is not support: who a story is for and why, a business idea's problem and goals, or a design's context are rarely in the code. Leave a required section empty when nothing supports it, and do not ask about it here: `save_draft` lists what version 0 leaves empty, and the reviewer sees it.

## 5. What is left

List each pitfall or constraint from the summary that no saved artifact covers, and treat each as a gap, as above. Then show what was drafted as a table: ID, title, and its open questions, if any.

## 6. Next step

Agreeing to an artifact here does not approve it. Offer approval as the next step: /bk:approve shows the drafts from this capture as one set, with anything that would not pass, and approves them in one review once the user confirms, a version 0 before the change built on it. A task's own test plan is not in the set unless the process approves task plans: it is recorded when its task is approved. Do not approve anything yourself here.

Do not create or edit spec tree files yourself; `save_draft` does all writing.

## In a Spec-driven tree

The plan is one change: a proposal, a spec change for each capability whose behavior it alters, a design only when needed, and tasks. Nothing is approved.

1. **Read the capability specs first.** Call `query` with `view: "capabilities"`, then with the `id` of each capability the work touches, so the change starts from how the system behaves now. Check `view: "changes"` for an open change that already covers the work.
2. **Propose the change**, showing a table of the capabilities it adds or modifies, by code, with what changes in each, and say in a sentence whether it needs a design: only when it makes decisions worth recording, such as a new component, data, an interface or a trade-off. A change that alters no behavior, such as a refactor, says so and has no spec changes. For a new capability, propose a short code from its name, such as SMS, which the user can change before anything is saved. Then ask, the same way as in step 1, showing the table and that sentence. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. The choices: **Looks right** (the default), **Change the plan**, **Keep talking**.
3. **Ask the pace**, as in step 3 above: **Step by step** (the default) or **All at once**, every time.
4. **Draft the change.** Call `get_template` for proposal, spec-change, tasks and, when needed, design. Draft by "How to draft" and "Gaps" above: each settled pitfall becomes a requirement or scenario, and nothing is invented. A modified requirement keeps its ID and holds its full new text; a removed one says why and what replaces it. Each task says how its completion is verified, and each group holds the tests and docs its work needs.
   - **Step by step:** show the proposal, with the pitfalls it covers, and save it once the user agrees, with `save_draft`, `type: "change"` and the proposal as `content`: that creates the change. Then each spec change, then the design if one is needed, then the tasks, each shown, agreed and saved in turn with `save_draft`, its `type` (`spec-change`, `design` or `tasks`) and the change's `id`. Offer **Looks good, next** (the default), **Change something** and **Draft the rest at once** at each step, as above.
   - **All at once:** save them in one `save_draft` call with `type: "change"`, the proposal as `content`, and the others in `files`, then show them.
5. **Show what was saved**: the change's ID, its files, the IDs given, and anything `save_draft` lists as worth fixing. Treat each pitfall from the summary that no file covers as a gap, and each missing part `save_draft` names. Then offer /bk:start with the change's ID as the next step.
