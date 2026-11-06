# Pausing and resuming

Stop where you are and pick it up later: in this session, a new one, on another machine, or as a teammate. Pausing is one step, whichever of these it will be: BuildKeel never asks where you will come back.

## Pausing work on a unit or change

Run `/bk:pause`, or say so in words, such as "let's stop here for today" or "I'm switching machines". With a unit or change active, Claude:

1. **Offers to commit what is not committed** as work in progress, with the unit's commit line, or to leave it. Files left are named in the pause record. Nothing is discarded or stashed.
2. **Shows the working notes** since the last checkpoint: decisions and why, constraints, dead ends, open questions and the next step, each with its source. They are checked before you see them, as [Working notes](#working-notes) says.
3. **Shows what the pause will record,** and saves it once you agree.
4. **Offers to push** both the code repo and the spec repo, one push when the spec tree is in the code repo. You may decline; the work can then only be resumed on this machine until you push.

What the pause will record, as Claude shows it before saving:

```text
Pausing TK-001 would record, in one commit in the spec repo:
- Held by: Ana on laptop
- Branch: bk/TK-001-reset-endpoint at 4c1d9e2
- Tests: US-001-TC1 no test, US-001-TC2 no test
- Open review findings: none
- Left uncommitted: src/reset/endpoint.ts
- Next: write the expiry check

Working notes to keep with it:
- Dead end: a sliding expiry kept sessions alive on other devices [US-001-AC1]
```

Once saved, the unit is released on this machine, so it can be resumed anywhere:

```text
Paused TK-001, held by Ana on laptop: recorded in tasks/TK-001/pauses/20261102T171500Z-k3q8.md, committed in the spec repo as 9a2b7c1.
- Branch: bk/TK-001-reset-endpoint at 4c1d9e2
- Tests: US-001-TC1 no test, US-001-TC2 no test
- Open review findings: none
- Left uncommitted: src/reset/endpoint.ts
- Next: write the expiry check
- Working notes kept: 1, in tasks/TK-001/notes/20261102T171500Z-m2xa.md
- TK-001 is no longer active here, and its claim on this machine is released.
```

A unit paused twice keeps both pauses, and the working notes of every session.

In a Spec-driven tree, a change's files are not committed while it is open. Pausing commits them as they stand, with the pause record, so the change can be resumed on another machine.

## Keeping an exploration as a thread

With no unit or change active, `/bk:pause` keeps the conversation as a thread, with a permanent ID and a title, such as `TH-004 "Reset by text message"`. A thread holds:

- the intent and the idea;
- the approaches, and which way the discussion is leaning;
- decisions, constraints, dead ends and open questions, each with its source;
- the next thing to discuss;
- your words, kept apart from Claude's proposals;
- pointers to the code that was read, and any spike.

Claude shows the thread in full before it is saved. Your words in it are checked against what you wrote, as a working note's quote is. Then:

```text
Saved thread TH-001 "Reset by text message", in threads/TH-001/20261102T163000Z-p7td.md, committed in the spec repo as 5e81a0b. Tell the user its ID. Threads are in the spec tree, so the team can see them once it is pushed.

Resume it with /bk:resume TH-001; capturing it into work with /bk:capture closes it.
```

What a pause does with nothing active follows the Threads switch, `continuity.threads`: see [When you forget to pause](#when-you-forget-to-pause) and [Settings](settings.md#continuity).

A thread has no stages and no approval. Pausing it again adds to it. It ends in one of two ways:

- **captured,** when `/bk:capture` turns it into work, linked to what it became;
- **dropped,** with your reason. A dropped thread is kept, closed, and can still be found.

## Working notes

A working note is something the work learned that the code and the spec do not say. Each names its source: your words, quoted exactly; a file and line; or a record, such as a requirement, a finding or a commit. Before you see one, it is checked twice:

1. **By BuildKeel:** a quote must be in what you wrote in this conversation, word for word (spacing and quote marks aside); a file and line must exist; a record must exist. Claude's own words never count as your quote.
2. **By a fresh agent,** the working-note checker: the source must support the note. A note that only mentions an option you once named, as if you had chosen it, is dropped.

A note that fails is dropped, and Claude tells you why. What someone seems to prefer is never recorded.

Working notes are also kept at each checkpoint, without asking: a ticked task, a finished unit, and a build run that stops. Claude lists what was kept in the same reply; you can ask to correct or drop any of it. A ruling given to an agent in a run is kept as a working note at once, so every later agent is given it. When a unit is finished, its working notes become the context part of its completion record: decisions and why, those replaced, departures from the plan, dead ends, limitations, follow-ups and notes for the next person.

## Resuming

`/bk:resume` with an ID resumes that unit, change or thread. With none, it lists what is paused, the most recent first:

```text
Paused, the most recent first (2):
- TK-001 "Reset endpoint" (unit), paused by Ana on laptop just now. Next: write the expiry check
- TH-001 "Reset by text message" (thread), paused by Ana on laptop just now. Next: Compare two text message providers on cost.
```

**A unit or change** starts on its branch, as `/bk:build` starts it, with a brief:

```text
## Resuming TK-001
Paused by Ana on laptop just now.
- Next: write the expiry check
- Branch: bk/TK-001-reset-endpoint at 4c1d9e2
- Tests when paused: US-001-TC1 no test, US-001-TC2 no test
- Open review findings: none
- Left uncommitted here, and carried on with: src/reset/endpoint.ts

Working notes, oldest first:
- 2026-11-02 Dead end: a sliding expiry kept sessions alive on other devices [US-001-AC1]
```

On another machine, after a pull, its branch is made from its remote copy, and the brief names any files left uncommitted on the first machine. `/bk:build` on a paused unit resumes it the same way, and lists paused units first among what can be started.

**A thread** shows its brief, and the conversation is then free:

```text
## TH-001 "Reset by text message"
Open; paused 1 time, last by Ana on laptop just now.
```

When your session starts, the session report mentions what is paused, and Claude offers it once, in a line, unless your first message is about something else. If the spec tree was behind its remote at the last fetch, Claude offers to pull it once you turn to work, so that work paused elsewhere is there. Listing what is paused, and resuming, fetch the remote first, so work paused and pushed on another machine after your session began is found; when the spec tree is then behind, Claude offers to pull it.

## A teammate resuming

Someone else's paused work, or your own paused on another machine, is resumed only once you confirm. Claude is told:

```text
TK-001 was paused by Priya Shah on priya-laptop just now (2026-11-02 17:40 UTC), so resuming it here takes over Priya Shah's work, paused on priya-laptop. Left uncommitted there: src/reset/limit.ts; those changes are not here.
```

and asks you, such as "Take over Priya Shah's work on TK-001, paused just now?" On yes, the work moves to you, the handover is recorded in its history, and the brief says whose work it was:

```text
## Resuming TK-001
Taken over: this was Priya Shah's work, paused on priya-laptop just now. The handover is recorded in its history.
- Next: add the rate limit
```

## When you forget to pause

- **The next session:** when the previous conversation in this repository, on this machine, explored something over three messages or more with no unit, and was never paused or captured, the session report offers once to recover it as a thread, from its transcript. Declined, it is not offered again.
- **After compaction:** when a conversation with no unit was compacted before it was saved, Claude is told so, and `/bk:pause` builds the thread from the whole transcript on disk, not from the summary.
- **The Threads switch:** `continuity.threads` decides what a pause with no unit active does: `ask`, the default, offers to save the thread; `auto` saves it without asking; `off` saves nothing and suggests `/bk:capture` when the idea is ready. With it off, the previous conversation is not offered for recovery either. Claude never offers to save a thread on its own during a conversation.

## Looking back

Ask Claude what was decided and why, such as "what did we decide about token expiry?" or "why does reset.ts refuse a sliding expiry?". It looks through the working notes, threads and the context of finished work, with `query` and `view: "notes"`: by a unit's, change's or thread's ID, by a file (through the commits that changed it, renames followed), or by text. It answers from what it finds, naming each source.

## Heads-up notes, and notes on the code

When a unit starts, its context gives up to five **Heads-up notes**: notes that earlier work left about the files it will change. They are the working notes of the units whose commits changed them, notes for the next person from their completion records, notes on the code, and closed threads that point at them. The most specific and the most recent come first, each cut short with a pointer to the whole note.

Heads-up notes are on by default. `continuity.heads-up: off` in `buildkeel.yaml` leaves them out of the context; looking back still finds every note. See [Settings](settings.md#continuity).

A **note on the code** is a short note tied to files, such as `CN-001`: "the 30-minute limit is checked here and in the email job". Claude saves one only when you agree: when you ask it to remember something about a file, or when it proposes one from a pattern in the records. The next unit that changes one of those files gets it when it starts.

## What stays on your machine

Working notes, pause records and threads are in the spec tree, so the team sees them once the spec repo is pushed. The transcripts of your conversations, and BuildKeel's record of them in the working tree's `.buildkeel/` folder, stay on your machine: they are never committed or pushed.
