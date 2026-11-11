# Working notes and threads

Working notes keep what the work learned that the code and the spec do not say, each with its source. A thread keeps an exploration you are not ready to plan, so you or a teammate can pick it up later.

## 1. Check the working notes

Claude keeps working notes as the work goes, and shows you each one.

1. Read the working notes Claude lists at each checkpoint: a ticked task, a finished unit, and a build run that stops.

   These are kept without asking. Claude lists what was kept in the same reply.
2. Ask Claude to correct or drop any note that is wrong.
3. When you pause with `/bk:pause`, read the working notes since the last checkpoint, shown with what the pause will record.

   ```text title="/bk:pause"
   Working notes to keep with it:
   - Dead end: a sliding expiry kept sessions alive on other devices [US-001-AC1]
   ```
4. Agree, and they are saved with the pause, such as in `tasks/TK-001/notes/20261102T171500Z-m2xa.md`.

A ruling given to an agent in a run is kept as a working note at once, so every later agent is given it. A unit paused twice keeps both pauses, and the working notes of every session.

When a unit is finished, its working notes become the context part of its completion record: decisions and why, those replaced, departures from the plan, dead ends, limitations, follow-ups and notes for the next person. See [Finish](finishing-a-unit.md).

The rest of a pause, and resuming, are in [Pause, resume and hand over](pausing-and-resuming.md).

## 2. Keep an exploration as a thread

With no unit or change active, a pause keeps the conversation as a thread, with a permanent ID and a title, such as `TH-004 "Reset by text message"`.

1. Run `/bk:pause`, or say so in words, such as "let's stop here for today".
2. Read the thread Claude shows in full before it is saved.

   ```text title="/bk:pause"
   A new thread "Reset by text message" would keep, in one commit in the spec repo, held by Ana on laptop:

   ## Intent
   Let people reset their password by a code sent by text message, for those who cannot reach their email.

   ## Approaches
   - A code by text message (leaning this way).
   - A magic link by text message.

   ## Decisions and constraints
   - Codes, not links.

   ## Dead ends and open questions
   - Which provider sends the texts?

   ## Next
   Compare two text message providers on cost.

   ## The user's words
   - "codes must work on another device, so no magic links"

   ## Code read
   - src/reset/endpoint.ts

   Working notes:
   - Decision: a code, not a magic link [the user said "codes must work on another device, so no magic links"]
   ```
3. Agree, and Claude saves it and tells you its ID.

   ```text title="The thread saved"
   Saved thread TH-001 "Reset by text message", in threads/TH-001/20261102T163000Z-p7td.md, committed in the spec repo as 5e81a0b. Tell the user its ID. Threads are in the spec tree, so the team can see them once it is pushed.

   Resume it with /bk:resume TH-001; capturing it into work with /bk:capture closes it.
   ```
4. Push the spec repo, so the team can see it.

Pick it up later with `/bk:resume TH-001`. Pausing it again adds to it.

What a pause does with nothing active follows the Threads switch, `continuity.threads`:

| Value | A pause with nothing active |
|---|---|
| `ask` | offers to save the thread. The default. |
| `auto` | saves the thread without asking. |
| `off` | saves nothing, and suggests `/bk:capture` when the idea is ready. |

With Threads `off`, the previous conversation is not offered for recovery either. Open threads stay, and can still be resumed, captured or dropped. Claude never offers to save a thread on its own during a conversation. See [Feature switches](settings.md).

## 3. Recover an exploration left unsaved

When you forget to pause, little is lost: the transcript of the conversation is still on your machine.

### At the next session

When the previous conversation in this repository, on this machine, explored something over three messages or more with no unit, and was never paused or captured, the next session offers once to recover it.

1. Start a new session in the same repository, on the same machine.
2. Read the offer, in one line. Claude is told:

   ```text title="The session report"
   - The previous conversation in this repository on this machine (started 2026-11-02, 3 messages from the user) ended with no unit, and was not paused or captured. Offer once, in one line, to recover it as a thread with /bk:pause, built from its whole transcript at /home/you/other.jsonl, which stays on this machine. If the user declines or says nothing of it, do not offer again.
   ```
3. Say yes, and Claude builds the thread from that transcript with `/bk:pause`, shown in full before it is saved.

Declined, it is not offered again.

### After compaction

When a conversation with no unit was compacted before it was saved, Claude is told so.

1. Run `/bk:pause`.

   Claude builds the thread from the whole transcript on disk, not from the summary.

## 4. Capture or drop a thread

A thread has no stages and no approval. It ends in one of two ways.

1. Resume it with `/bk:resume TH-001`, or carry on in the session that holds it.
2. Close it in one of two ways:
   - **Capture it.** Run `/bk:capture` to turn it into work. The thread is closed, linked to what it became. See [Capture a plan](capture.md).
   - **Drop it.** Tell Claude to drop it, with your reason.

A closed thread is kept, and can still be found. Nothing more is added to it: start a new thread instead. A closed thread that points at code becomes a Heads-up note for the next unit that changes that code (see [Notes on the code](heads-up-notes.md)).

## What a working note holds

A working note is something the work learned that the code and the spec do not say. It is one of these kinds:

- a **decision** and why;
- a **ruling** given to an agent in a run;
- a **constraint** or pitfall;
- a **dead end**;
- an **open question**;
- the **next step**.

Each names its source: your words, quoted exactly; a file and line; or a record, such as a requirement, a finding or a commit. A decision that replaces an earlier one says which, so both stay readable.

What someone seems to prefer is never recorded.

## How sources are checked

Before you see a note, it is checked twice:

1. **By BuildKeel:** a quote must be in what you wrote in this conversation, word for word (spacing and quote marks aside); a file and line must exist; a record must exist. Claude's own words never count as your quote.
2. **By a fresh agent,** the working-note checker: the source must support the note. A note that only mentions an option you once named, as if you had chosen it, is dropped.

A note that fails is dropped, and Claude tells you why. Your words in a thread are checked against what you wrote, as a working note's quote is.

## What a thread holds

- the intent and the idea;
- the approaches, and which way the discussion is leaning;
- decisions, constraints, dead ends and open questions, each with its source;
- the next thing to discuss;
- your words, kept apart from Claude's proposals;
- pointers to the code that was read, and any spike.

## What stays on your machine

Working notes, pause records and threads are in the spec tree, so the team sees them once the spec repo is pushed. The transcripts of your conversations, and BuildKeel's record of them in the working tree's `.buildkeel/` folder, stay on your machine: they are never committed or pushed.

**More:** [Pause, resume and hand over](pausing-and-resuming.md), [Ask why the code is the way it is](looking-back.md), [Talk it through and explore](exploring.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-pause`.
