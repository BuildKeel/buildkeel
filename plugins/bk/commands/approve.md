---
description: "BuildKeel: Approve a draft or a new version after checking it, or a set of drafts, such as a captured plan, in one review."
argument-hint: "[artifact IDs], e.g. US-draft-k3x9, US-001-TP, or several IDs for one review"
---

Help the user approve a BuildKeel artifact. Approval is the user's decision: never approve anything they have not confirmed in this conversation.

The user typed: $ARGUMENTS

If BuildKeel's session report, or `query` with `view: "process"`, says this spec tree is Spec-driven, it has nothing to approve: call `approve` once and show its answer as it is.

## Choose what to approve

If the user named one artifact above, approve it as below. If they named several, approve them as a set (see "A set in one review").

If the user typed nothing, ask straight away, before calling any tool: "What do you want to approve?" Offer the choices with your tool for asking a question with choices, if you have one, so the user can pick with the arrow keys and Enter:

1. **The drafts from this conversation, in one review** (the default, listed first): offer this only when drafts were saved in this conversation, such as by /bk:capture, and name them in the choice.
2. **Show what is ready to approve** (the default when there are no drafts from this conversation).
3. **Type an artifact ID.** If they pick this, ask for the ID.

If they pick "Show what is ready", call the BuildKeel `query` tool with `view: "drafts"` and ask which to approve, showing its result as it is: what is ready to approve, and what is not ready yet with the reason. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. Offer the ready ones as choices with the one you recommend first; several can be approved as a set. If nothing is ready, say what is blocking the drafts and stop.

## A set in one review

1. Call the BuildKeel `approve` tool with `ids` set to every artifact in the set, without `apply`. A version 0, which describes code as it was before BuildKeel, is named with `@v0`, such as `US-draft-k3x9@v0`; when the change built on it is a new version of the same artifact, the set holds both, `US-draft-k3x9@v0` and `US-draft-k3x9`, and version 0 is approved first. It shows the whole set in the order it will be approved, parents and their documents first, with what each will become and anything that would not pass, and why. Show it as it is.
2. Ask, with your tool for asking a question with choices, showing the set as `approve` gave it: **Approve them** (the default; if some would not pass, the rest are approved and those stay drafts with what needs them), **Fix what would not pass first** (then fix each with `save_draft`, one at a time with the user, and check the set again), or **Stop**. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence.
3. Only when the user confirms, call `approve` again with the same `ids` and `apply: true`. Show the result as it is: it opens with what is now approved and what can start, then each approval, each its own record and commit.

## One artifact

1. Call `query` with `view: "artifact"` and the ID, and show the user the artifact so they know what they are approving. For a new version of an approved artifact, also call `query` with `view: "artifact"`, the ID and `version` set to the approved version, and say what changed since then.
2. Call the BuildKeel `approve` tool with the `id` and without `apply`. It runs the approve gate and does not write anything.
   - If it is refused, show every failing check with its fix, as it is. Offer to fix the draft (save the fix with `save_draft`, passing the draft's `id`) or to approve the parent first. Do not approve anything else in its place without asking.
   - Otherwise, show what approval will do (the permanent number it will get, references that change, the commit) and ask the user to confirm. For a version 0, say that it describes the code as it was before BuildKeel and what it leaves empty: approving it means a person has read it.
3. Only when the user confirms, call `approve` again with the same `id` and `apply: true`. Show the result, which opens with what was approved: the permanent ID, the files written, the commit, and whether it was pushed. If the number is pending because the spec repo's remote could not be reached, say so plainly: the approval is recorded, work on it cannot start until it has its number, and the number is assigned the next time the remote can be reached.

## Its documents

If the result says a task's own test plan was recorded with it, say so in a line: it needs no approval. If the result says the approved artifact has a document with a draft waiting, such as its test plan or design document, tell the user and ask whether to approve it now. If they agree, go through the same steps for the document's ID: show it, check it without `apply`, and approve it only after they confirm. Each approval is its own commit.

## Afterwards

Call `query` with `view: "drafts"` and show what is still waiting for approval, ready or not, as it is.

If the approval result said approvals are not pushed, remind the user to push the spec repo when they are ready to share them. Then suggest the next step: approving something that is now ready, starting a unit that is ready with /bk:start, or building everything ready with /bk:build.

Do not create or edit spec tree files yourself: `approve` and `save_draft` do all writing, and approved versions and approval records are never edited.
