---
description: "BuildKeel: Pause where you are, to come back in a new session or on another machine: the work on a unit or change, or an exploration with no unit, kept as a thread."
argument-hint: "[nothing, or an ID], e.g. TK-013; the active unit when left out"
---

Pause the work with the user, so that it can be picked up again in this session, in a new one, or on another machine, by them or a teammate. It is one step wherever they come back: never ask where they will come back. Phrases such as "let's stop here" or "I'm switching machines" mean the same as this command. Nothing is ever discarded.

The user typed: $ARGUMENTS

**Before anything else**, call the BuildKeel `query` tool with `view: "process"`, and do not show its result. If it says this repository is not set up for BuildKeel, tell the user so, and that /bk:init sets it up, then stop: ask nothing else. Otherwise go on straight away.

## What is paused

- **A unit or change is active** (or the user named one): its work is paused, as "Pausing work" says.
- **Nothing is active:** the conversation is an exploration, kept as a thread, as "Keeping a thread" says.

## Pausing work

1. **Uncommitted changes.** Run `git status` in the code repo. When files are changed, list them and ask, with your tool for asking a question with choices: **Commit them as work in progress** (the default), committed with the message `WIP: <what they hold>` ending with `BuildKeel-Unit: <the unit's ID>`, or **Leave them as they are**, named in the pause record. Never discard or stash anything.
2. **Working notes.** Draft the working notes since the last checkpoint or pause, and check them, as below, steps 1 and 2.

   **Working notes.** At this checkpoint, draft the working notes since the last checkpoint or pause: what the work learned that the code and the spec do not say. Each is one of these: a decision and why (with `replaces` naming an earlier decision it replaces), a constraint or pitfall, a dead end (what was tried, and why it failed), an open question, or the next step. Rulings are kept already. Give each its source: the user's own words, copied exactly, as `quote`; a `file` and `line`; or a `record`, such as a requirement, a finding or a commit. Never record an inference about a person, such as what they seem to prefer. With nothing new to note, leave notes out.
   1. **BuildKeel's check:** call `save_draft` with `type: "working-notes"`, the unit's or change's `id` and the `notes`, without `apply`. It says which pass, and drops the rest with the reason.
   2. **The note checker:** give it the notes that passed in one batch, with their sources and nothing else, started in the note checker role as `query` with `view: "settings"` names it. When it cannot be started, follow "When agents can't be started": check each yourself as the checker would, and say the notes were checked here. Keep only the notes it supports, and tell the user each one dropped, with why.
   3. **Keep them** as this step says. At a checkpoint, the result lists what was kept: show that list in the same reply, without asking first; the user may ask to correct or drop any of it. A pause shows them first, and keeps them once the user agrees.
3. **The pause.** Call `manage` with `action: "pause"`, the `id` when the user named one, `notes` with the notes the checker supports, and `next` with the next step in a sentence. Show what it would record, in full, with the working notes and their sources, and ask. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Only once the user agrees, call it again with `apply: true`.
4. **Push.** Say what the result says about pushing, and offer to push both the code repo and the spec repo (one push when the spec tree is in the code repo), so the work can be resumed on another machine. The user may decline: then say it can only be resumed on this machine until they push.
5. **Done.** Say in a line that it is paused, and that /bk:resume with its ID resumes it.

**When agents can't be started,** the same everywhere:
1. **Say why, once,** in a line: you have no tool for starting agents here, it is turned off, or the model tier the settings name is not available.
2. **Retry once** when an agent started but failed, before treating agents as unavailable.
3. **Follow the step's switch:** off, nothing happens; ask, the offer says it would run here, without a fresh reader; auto, or a step with no switch (an implementer or a reviewer), do it here and say so in a line.
4. **Label what you did here** as done here, not by an independent agent: in what you show, and in the record (`by: "author"` for a review), and present a question or proposal as your own reading.
5. **Never count it where independence is the point:** a final review done here does not satisfy the review-findings check, so say the work was not independently reviewed.

## Keeping a thread

An exploration with no unit is kept as a thread: its ID, such as TH-004, stays with it, and it has no stages and no approval. First call `manage` with `action: "pause"` and no `id`: it says what the Threads switch asks for.

- **ask**, the default: the steps below, saving only once the user agrees.
- **auto:** the same steps, but save it with `apply: true` without asking, then show it in full and say its ID.
- **off:** save nothing. Say so in a line, and suggest /bk:capture when the idea is ready. Open threads stay, and can still be resumed, captured or dropped.

1. **Draft it** from the whole conversation. If BuildKeel said this conversation was compacted and the exploration is not saved, read the whole transcript on disk first, and build the thread from it rather than from the summary; then pass `fromTranscript: true`. When this pause adds to a thread resumed in this conversation, use its ID. Its `content` follows the thread template (`get_template` with `type: "thread"`): the intent and the idea; the approaches, and which way the discussion is leaning; decisions and constraints; dead ends and open questions; the next thing to discuss; and, apart from your proposals, the user's own words, each a bullet with their words in quotes, exactly as they wrote them. Add the code read, as pointers, and any spike, with its branch or the files it left. Write "None yet" in a section the conversation has nothing for. Give the decisions, constraints, dead ends and open questions as `notes` too, each with its source, as working notes are. Never record an inference about a person.
2. **Check it:** call `save_draft` with `type: "thread"`, a short `title` (or the `id` of the thread it adds to), the `content` and the `notes`, without `apply`. It checks each of the user's words and each note's source, and leaves out what does not hold, with the reason: tell the user each. Give the notes that pass to the note checker, as "Pausing work" says, and keep only those it supports.
3. **Show it** in full, and ask. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Only once the user agrees, call it again with `apply: true`, and tell the user the thread's ID. With Threads set to auto, save it first, then show it with its ID.
4. **Push.** Offer to push the spec repo, so the thread can be resumed on another machine or by a teammate. Threads are visible to the team once pushed.

When the user drops an idea instead, ask for the reason in their words, then call `save_draft` with `type: "thread"`, its `id` and `drop` set to the reason: it is closed, and can still be found.

Do not create or edit spec tree files yourself: the BuildKeel tools write every record.
