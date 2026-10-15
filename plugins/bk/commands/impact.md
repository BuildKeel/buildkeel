---
description: "BuildKeel: Review what a change to an approved artifact affects: preview a new version before approving it, or decide on each suspect with the user."
argument-hint: "[ID], e.g. US-001 to preview its new version in draft, or US-001-TC2 to review one suspect; every suspect when left out"
---

Review change impact in BuildKeel with the user. A suspect is a task, story, epic, bug or test case built against an older version of something that has changed since, in what it relies on. Deciding on a suspect is the user's choice: never record a decision they have not confirmed in this conversation.

The user typed: $ARGUMENTS

If BuildKeel's session report, or `query` with `view: "process"`, says this spec tree is Spec-driven, follow "In a Spec-driven tree" at the end as well.

## Choose what to review

If the user named an artifact or test case above, use it.

If the user typed nothing, ask straight away, before calling any tool: "What do you want to review?" Offer the choices with your tool for asking a question with choices, if you have one, so the user can pick with the arrow keys and Enter:

1. **Every suspect** (the default, listed first).
2. **Type an ID:** an artifact with a new version in draft, to see what approving it would affect, or an artifact or test case to review on its own. If they pick this, ask for the ID.

## Show the impact

Call the BuildKeel `impact` tool, with `id` if there is one. Show its result as it is.

- **A preview of a draft:** nothing is marked yet. Say what approving it would make suspect and which coverage gaps it would open, then stop. Offer to approve it with /bk:approve when the user is ready, or to change the draft first.
- **Nothing suspect:** say so and stop.

## Review each suspect, one at a time

For each suspect in the result, in order:

1. Show what it is and what changed with the question in step 3, never in a choice's label or description. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. For a test case, read its plan with `query` (`view: "artifact"` and the plan's ID) and show the test case with the old and new text of what it covers. For a task, story, epic or bug, show its own text (`query`, `view: "artifact"`) with the old and new text of what changed above it. For a finished unit, show the commits and files its completion record lists.
2. Propose a decision, saying why in a sentence or two:
   - **Still valid** when the change does not affect what it says, builds or checks, such as a rewording, or a change to something it does not rely on in substance.
   - **Needs change** when what it says, builds or checks no longer matches the new text, such as a test case checking a 30-minute expiry when the criterion now says 15 minutes. For finished work, name the files that likely need to change.
3. Ask the user to decide, with your tool for asking a question with choices: your proposal first, then the other decision, then **Skip it for now**.
4. Record only what the user chose: call `resolve_suspect` with the `id` and the `decision` (`still-valid` or `needs-change`), and show its result as it is.
   - After **needs change**, offer to make the change now: read the draft it opened with `query`, change it with `save_draft`, show the user the result, and approve it with /bk:approve only when they confirm. For a unit already finished, its new version can be started again with /bk:start once approved, to change the code.
   - For a **bug**, needs change on an open bug means changing its file with the user and saving it with `save_draft`: the save records the decision. For a finished bug, `resolve_suspect` records a new bug to check it: show it, and offer to start it with /bk:start.

## Afterwards

Call `impact` without `id` and say how many suspects are left. If a test plan is still written against an older version of its story, suggest updating it to cover any new criteria.

Do not create or edit spec tree files yourself: `resolve_suspect` and `save_draft` do all writing, and re-pin records are never edited.

## In a Spec-driven tree

Suspects are tests tagged with a scenario, and archived changes, built against a requirement that a later capability version modified or removed. With an open change's ID, `impact` previews what archiving it would make suspect: decide each then or after it is archived, as its result says, passing that change in `change` to `resolve_suspect`. Needs change adds a task to revisit it: in the previewed change, or after archiving, in an open change the user picks (draft a new change with `save_draft` first if they want one). Show the task it added.
