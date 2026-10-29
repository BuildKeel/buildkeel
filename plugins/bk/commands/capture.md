---
description: "BuildKeel: Turn what you discussed into a plan: a plain summary, then the artifacts your process needs, agreed one by one or all at once, as you choose."
argument-hint: "[which part of the conversation to capture; all of it when left out]"
disable-model-invocation: true
---

Turn the conversation into a plan the team's process can build from, with the user agreeing at each step: the summary, the list of what will be created, the pace, then each artifact. Nothing is saved that the user has not agreed to, and everything saved stays a draft until it is approved.

The user typed: $ARGUMENTS

**Before anything else**, call the BuildKeel `query` tool with `view: "process"`, and do not show its result. If it says this repository is not set up for BuildKeel, tell the user so, and that /bk:init sets it up, then stop: ask nothing else. Otherwise go on straight away.

If BuildKeel's session report, or `query` with `view: "process"`, says this spec tree is Spec-driven, follow step 1, then "In a Spec-driven tree" at the end in place of steps 2 to 6.

## How each review goes

The summary, the plan and each artifact are reviewed the same way: shown in full in your reply, with your question in plain text at its end. The user's reply decides what follows:

- **Agreement**, such as "looks good", "yes" or "next": go on, and for an artifact, save it.
- **"Draft the rest"**: draft what is left in one go, and show it as a set, as "All at once" says.
- **Anything else is feedback**, "ok, but…" included: discuss it for as long as the user wants. Then list each point they raised with how you addressed it, or why you did not, show the final version, and ask again. Save nothing until they agree. When the only change is small, the final version may be just the changed parts, with a note that nothing else changed. When you cannot tell whether a reply agrees, ask.

When later discussion in this capture would change something the user already agreed, such as a story agreed before a decision on the next one, say so openly: which artifact, what changes and why. Show the change and take it through the same review, and save it with `save_draft` only once the user agrees. In a Spec-driven tree, read one file of the change with `query`, `view: "changes"`, its `id` and `file`, and save a change to one requirement with `save_draft`, `type: "spec-change"`, the change's `id`, its `capability` and `requirement`, rather than resending the whole file. Never change an agreed artifact silently, and never add a requirement, criterion or test case that was not discussed.

## 1. Say what you heard

Once that check is done, and before any other tool call, sum up the discussion in plain words, with no BuildKeel terms yet (no stages, IDs or templates):

- **What you set out to do**: the user's intent, in a sentence.
- **The idea**: what it is, and who it is for.
- **The approach**: the design choices and decisions discussed, and what was left open.
- **Pitfalls and constraints raised**: each one the conversation surfaced, such as a limit, a failure to handle or a detail easy to get wrong, in the user's terms, marked settled or open. Leave the list out when nothing was raised; never add one the conversation did not raise.

If the user typed something above, sum up that part of the conversation. If there is nothing to capture yet, say so, ask what they want to plan, and stop. If the conversation was compacted, say that its earlier parts may be missing from the summary, and ask the user to add anything left out.

Then ask whether to go on, with the summary in that same reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. The choices:

1. **Create the artifacts** (the default, listed first).
2. **Change something.** Take it as feedback, as "How each review goes" says, and show the summary again.
3. **Keep talking.** Stop here: nothing is drafted, and the conversation goes on.

Any other answer, such as a correction or a new thought, is more conversation: answer it as you would, and draft nothing.

### A problem someone reported

When the discussion is about a problem someone reported with how the system behaves, sort it once the user chooses to create the artifacts, before step 2.

**Sorting a report.** When someone reports that the system does something wrong, check it before recording anything: what the spec says about that behavior now (in a Spec-driven tree, `query` with `view: "capabilities"` and the capability's `id`; otherwise the stories and their acceptance criteria, with `query`), and the code linked to it (`query` with `view: "describes"` and the files involved). Then propose one reading, labelled as yours, such as "My reading: a defect", with what it rests on:

- **A defect**: the code does not do what the spec says. The code is fixed and the spec keeps its version. It is recorded as a defect with `source: reported`.
- **A change in behavior**: the code does what the spec says, and the user wants something else. The spec changes and gets a new version: in a Spec-driven tree through a change, otherwise through a new version of the story, or a new item of the team's kind for it, such as an enhancement.
- **A gap**: the spec says nothing about it. Settle with the user what it should do; that goes into the spec as a change in behavior.
- **Nothing describes this code yet**: `describes` finds no artifact for it. In Full SDLC, draft version 0 of the story the code belongs to first, stating the intended behavior, and record the defect with that draft as its parent; both are reviewed and approved together, version 0 first. In a Spec-driven tree, ask **Record it standalone** (the default) or **Document this code first**, as version 0 of a capability spec, then link the defect to its requirement.

Ask with your tool for asking a question with choices, your reading first, then the other readings, so the user confirms or overrides it. Record nothing until they answer. A defect found while building, such as a failing test of the work under way, needs no sorting: it is a defect of that work.

A defect is recorded as /bk:new defect records one: `get_template` for `defect`, then `save_draft` with `type: "defect"`, `source: reported` and the parent agreed. A change in behavior or a gap goes on to step 2 as work to plan, with the reading the user confirmed.

## 2. Propose the plan

1. Call the BuildKeel `query` tool with `view: "process"` for the stages and the documents each requires, and with `view: "tree"` for what exists. Read an existing artifact with `view: "artifact"` when you need to know what it covers.
2. Work out the artifacts the work needs, level by level, from the business idea down to the tasks, in the team's stage names: which already exist, which are new, and the documents each stage requires, such as a design document for a new epic and a test plan for each new story. For each task, work out which of its story's test cases its tests will implement. A task whose tests implement none of them, such as a building block (a client, a data model, a migration), needs a test plan of its own, or it can never be finished: put it in the table.
3. Recommend where the work fits in the tree, and say why: under an existing business idea or epic, or as something new.
4. If the work changes how something already built behaves, and a document describes how it works today (such as EP-01's design document for password reset), the plan includes a new version of that document.
5. When a stage holds more than one kind of work (`view: "process"` lists the kinds at each stage), propose a kind for each new artifact at that stage, from where the work came from, and say why in the table: an enhancement when it improves existing behavior, a feature when it adds something new, as the team's kinds are named. The user confirms or changes each kind as part of the plan; never draft one as a kind the user has not agreed to. Each is drafted with its kind as `type`, from that kind's template, and numbered in that kind's sequence.
6. If the work changes code that already exists, work out which files it will change, from the discussion and the code, and call `query` with `view: "describes"` and their `paths`. Where an artifact describes them, the work builds on it. Where nothing describes the behavior the work changes, the plan includes a **version 0**: one artifact, usually a story, describing only what the work touches, as it works today, before the change. The change is then its version 1, or an artifact under it. A version 0 is a proposal: the user can drop it.

Show the plan as a table, top down, each row with a one-line purpose, and say where the work fits and why, in a sentence:

| Level | Kind | Artifact | Status | Purpose |
|---|---|---|---|---|
| Business idea | business idea | BI-01 "Self-service account recovery" | exists | the goal this serves |
| Epic | epic | "Reset by text message" | new | the new capability |
| Design document | | of the new epic | new, required | how it is built |
| Story | user story | "Request a code by text" | new | one per user-facing behavior |
| Test plan | | one per story | new, required | covers every criterion |
| Task | task | "SMS gateway client" | new | one per piece of code, with its repository |
| Test plan | | of "SMS gateway client" | new | its tests are none of the story's test cases |
| Design document | | EP-01-DD | new version | password reset now works differently |
| Story | user story | "Password reset" | version 0, then the change as version 1 | how reset by email works today, which nothing describes yet |

The Kind column names each artifact's kind; when every stage holds one kind, it is the stage's name, and you may leave the column out.

Then ask, the same way, with the table and that sentence in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. The choices:

1. **Looks right** (the default).
2. **Place it somewhere else.** Ask where. The new artifact is drafted where the user says, with a link to the one you recommended (`related: [EP-01]`).
3. **Change the plan.** Take it as feedback, as "How each review goes" says, and show the table again.
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
- Save each one with `save_draft`, and only once the user has agreed to it.

### Step by step

Go through the plan in this order, leaving out what already exists: a version 0 before the change built on it, then the business idea or epic, then its design document, then each story together with its test plan, then the tasks, with their own test plans, as one batch. For each one:

1. Draft it against the artifacts already saved in this capture.
2. Show it, with a line naming the pitfalls and constraints from the summary that it covers. Ask about each gap it has, as "Gaps" says, before going on.
3. Ask, with it in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. The choices: **Looks good, next** (the default), **Change something** (feedback, as "How each review goes" says: the points with how each was addressed, then the final version), and **Draft the rest at once** (draft what is left in one go, then show it as a set).
4. Save it with `save_draft` once the user agrees, before drafting the next.

If the user stops partway, what they agreed to stays saved as drafts; draft nothing more.

### All at once

Draft everything, asking about gaps as you go. Show the set in full, each artifact with the pitfalls it covers, then a table of them all: title and the pitfalls each covers. Take the set through the review: feedback on any of them is answered as "How each review goes" says, with the final version of each artifact it changed. Once the user agrees, save them with `save_draft`, top down, each child naming the draft ID its parent was given.

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
- When a source and the code disagree, or two sources do (a ticket says a reset link lasts 30 minutes, the code makes it 60), ask the user which is intended, before drafting that part. Only the user knows, so recommend neither answer, and offer both as equals: **The code is right; the source is out of date** and **The source is right; the code has a defect**. When the code is wrong, version 0 states the intended behavior, and the defect is recorded against it with /bk:new defect once version 0 is approved. When the source is out of date, version 0 follows the code. Offer a third answer after those two, still with no recommendation: **Not sure: leave it open**. Then keep the question in the version 0 draft's front matter, under `openQuestions`, with an `id` (Q1, Q2, ...), what it is `about`, what the `code` does, what the `source` says and the `sources`' keys, and leave the part it concerns out of version 0: BuildKeel records who left it open, and version 0 waits for an answer before it can be approved. Someone who knows answers it later with /bk:onboard: add `answer: code` or `answer: source` to it, save the draft, and draft the part it concerns.
- Supported means the code or a source says it. A plausible guess is not support: who a story is for and why, a business idea's problem and goals, or a design's context are rarely in the code. Leave a required section empty when nothing supports it, and do not ask about it here: `save_draft` lists what version 0 leaves empty, and the reviewer sees it.

## 5. What is left

List each pitfall or constraint from the summary that no saved artifact covers, and treat each as a gap, as above. Then show what was drafted as a table: ID, title, and its open questions, if any.

## 6. Approve them, or leave them as drafts

Agreeing to an artifact here does not approve it: approving is a separate choice, with permanent numbers and frozen versions. Once the last artifact is agreed, ask in plain text, at the end of the reply with the table: **Approve them now** (the default), or **Leave them as drafts**, for another approver to approve later with /bk:approve.

- **Approve them now:** call the BuildKeel `approve` tool with `ids` set to every artifact agreed in this capture, without `apply`. Name a version 0 with `@v0`, such as `US-draft-k3x9@v0`, and keep the version built on it in the set too. A task's own test plan is not in the set unless the process approves task plans: it is recorded when its task is approved. Show the set as `approve` gives it, in the order it will be approved, with what each will become and anything that would not pass, and why. Then ask: **Approve them** (the default; any that would not pass stay drafts), **Fix what would not pass first** (each fix shown and saved with `save_draft` once the user agrees, then the set checked again), or **Stop**. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Only when the user confirms, call `approve` again with the same `ids` and `apply: true`, and show the result as it is.
- **Leave them as drafts:** approve nothing. Say that the drafts wait for /bk:approve, which shows them as one set.

Never approve anything the user has not confirmed in this conversation.

Do not create or edit spec tree files yourself; `save_draft` does all writing.

## In a Spec-driven tree

The plan is one change: a proposal, a spec change for each capability whose behavior it alters, a design only when needed, and tasks. Nothing is approved.

1. **Read the capability specs first.** Call `query` with `view: "capabilities"`, then with the `id` of each capability the work touches, so the change starts from how the system behaves now. Check `view: "changes"` for an open change that already covers the work.
   - **A late addition.** When the work would add a requirement to an open change with more than half its tasks ticked, ask once, in plain text, before drafting anything: does it belong in that change, or in a new one? Draft nothing until the user answers, and go on with the change they choose.
2. **Propose the change**, showing a table of the capabilities it adds or modifies, by code, with what changes in each, and say in a sentence whether it needs a design: only when it makes decisions worth recording, such as a new component, data, an interface or a trade-off. A change that alters no behavior, such as a refactor, says so and has no spec changes. For a new capability, propose a short code from its name, such as SMS, which the user can change before anything is saved. Then ask, the same way as in step 1, with the table and that sentence in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. The choices: **Looks right** (the default), **Change the plan**, **Keep talking**.
   - **Revising an open change.** When the work revises a change that is already open, call `query` with `view: "changes"` and its `id` first: besides its files, it gives what the work so far traces to, the files each ticked task's commits changed and the tests tagged with each requirement's scenarios. Add an **Affected** part to the table, for each requirement the revision removes or modifies: the tests tagged with its scenarios, the tasks that name it with the files their commits changed, and which ticked tasks no longer apply or now build on a changed requirement. Take the code from that trace, never from file names. Then ask the user about each affected ticked task, one at a time: **Keep it ticked**, **Rework it** (untick it and reword it as the revision needs), or **Drop it** (take it out of the tasks, with the code it leaves to remove named as a task when the user wants one). What the user decides goes into the tasks through the review.
   - **A new title.** When the revision changes what the change is about, show its current title beside the one you propose, and ask whether to change it. Change it only when the user agrees: the proposal is saved with the new title, and the change's folder is renamed with it. If the user says the title still fits, keep it.
3. **Ask the pace**, as in step 3 above: **Step by step** (the default) or **All at once**, every time.
4. **Draft the change.** Call `get_template` for proposal, spec-change, tasks and, when needed, design. Draft by "How to draft" and "Gaps" above: each settled pitfall becomes a requirement or scenario, and nothing is invented. A modified requirement keeps its ID and holds its full new text; a removed one says why and what replaces it. Each task says how its completion is verified, and each group holds the tests and docs its work needs.
   - **Step by step:** show the proposal, with the pitfalls it covers, and save it once the user agrees, with `save_draft`, `type: "change"` and the proposal as `content`: that creates the change. Then each spec change, then the design if one is needed, then the tasks, each shown, agreed and saved in turn with `save_draft`, its `type` (`spec-change`, `design` or `tasks`) and the change's `id`. Offer **Looks good, next** (the default), **Change something** and **Draft the rest at once** at each step, and answer feedback as "How each review goes" says.
   - **All at once:** show the whole change in full and take it through the review. Once the user agrees, save it in one `save_draft` call with `type: "change"`, the proposal as `content`, and the others in `files`.
5. **Show what was saved**: the change's ID, its files, the IDs given, and anything `save_draft` lists as worth fixing. Treat each pitfall from the summary that no file covers as a gap, and each missing part `save_draft` names. Then offer /bk:build with the change's ID as the next step.
