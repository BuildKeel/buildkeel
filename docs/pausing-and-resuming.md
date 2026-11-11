# Pause, resume and hand over

Stop where you are and pick the work up later: in this session, a new one, on another machine, or as a teammate. Pausing is one step, whichever of these it will be: BuildKeel never asks where you will come back.

## 1. Pause a unit or change

With a unit or change active, a pause records where the work stands and releases it on this machine.

1. Run `/bk:pause`, or say so in words, such as "let's stop here for today" or "I'm switching machines".
2. Choose whether to commit what is not committed.
   Claude offers to commit it as work in progress, with the unit's commit line, or to leave it. Files left are named in the pause record. Nothing is discarded or stashed.
3. Read the working notes since the last checkpoint: decisions and why, constraints, dead ends, open questions and the next step, each with its source.
   They are checked before you see them, as [Working notes and threads](working-notes.md) explains.
4. Read what the pause will record, and agree to save it.

   ```text title="/bk:pause"
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

   ```text title="/bk:pause"
   Paused TK-001, held by Ana on laptop: recorded in tasks/TK-001/pauses/20261102T171500Z-k3q8.md, committed in the spec repo as 9a2b7c1.
   - Branch: bk/TK-001-reset-endpoint at 4c1d9e2
   - Tests: US-001-TC1 no test, US-001-TC2 no test
   - Open review findings: none
   - Left uncommitted: src/reset/endpoint.ts
   - Next: write the expiry check
   - Working notes kept: 1, in tasks/TK-001/notes/20261102T171500Z-m2xa.md
   - TK-001 is no longer active here, and its claim on this machine is released.
   ```

5. Accept the offer to push.
   Claude offers to push both the code repo and the spec repo, one push when the spec tree is in the code repo. You may decline; the work can then only be resumed on this machine until you push.

A unit paused twice keeps both pauses, and the working notes of every session.

> **In a Spec-driven tree.** A change's files are not committed while it is open. Pausing commits them as they stand, with the pause record, so the change can be resumed on another machine.

With no unit or change active, `/bk:pause` keeps the conversation as a thread instead: see [Threads and notes](#threads-and-notes).

## 2. Resume on any machine

`/bk:resume` brings paused work back where it was left, on this machine or another.

1. Open Claude Code or Antigravity in the repository.
   The session report mentions what is paused, and Claude offers it once, in a line, unless your first message is about something else.
2. Pull the spec tree if Claude offers to.
   If the spec tree was behind its remote at the last fetch, Claude offers to pull it once you turn to work, so that work paused elsewhere is there. Listing what is paused, and resuming, fetch the remote first, so work paused and pushed on another machine after your session began is found; when the spec tree is then behind, Claude offers to pull it.
3. Run `/bk:resume` to see what is paused, the most recent first.

   ```text title="/bk:resume"
   Paused, the most recent first (2):
   - TK-001 "Reset endpoint" (unit), paused by Ana on laptop just now. Next: write the expiry check
   - TH-001 "Reset by text message" (thread), paused by Ana on laptop just now. Next: Compare two text message providers on cost.
   ```

4. Resume one by its ID, such as `/bk:resume TK-001`.
   A unit or change starts on its branch, as `/bk:build` starts it, with a brief:

   ```text title="/bk:resume TK-001"
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

5. Carry on building from the next step.

On another machine, after a pull, the unit's branch is made from its remote copy, and the brief names any files left uncommitted on the first machine. `/bk:build` on a paused unit resumes it the same way, and lists paused units first among what can be started.

A thread resumed with `/bk:resume TH-001` shows its brief, and the conversation is then free:

```text title="/bk:resume TH-001"
## TH-001 "Reset by text message"
Open; paused 1 time, last by Ana on laptop just now.
```

## 3. Hand over to a teammate

Someone else's paused work, or your own paused on another machine, is resumed only once you confirm.

1. Ask the person handing over to pause the work and push.
2. Run `/bk:resume` with its ID, such as `/bk:resume TK-001`.
   Claude is told whose work it is:

   ```text title="/bk:resume TK-001"
   TK-001 was paused by Priya Shah on priya-laptop just now (2026-11-02 17:40 UTC), so resuming it here takes over Priya Shah's work, paused on priya-laptop. Left uncommitted there: src/reset/limit.ts; those changes are not here.
   ```

3. Answer Claude's question, such as "Take over Priya Shah's work on TK-001, paused just now?"
   On yes, the work moves to you, the handover is recorded in its history, and the brief says whose work it was:

   ```text title="/bk:resume TK-001"
   ## Resuming TK-001
   Taken over: this was Priya Shah's work, paused on priya-laptop just now. The handover is recorded in its history.
   - Next: add the rate limit
   ```

   If you decline, nothing changes.

A teammate can resume a thread the same way.

## Threads and notes

- **Threads.** With no unit or change active, `/bk:pause` keeps the conversation as a thread, such as `TH-004 "Reset by text message"`, shown in full before it is saved. What a thread holds, the Threads switch (`continuity.threads`), how a thread ends, and what happens when you forget to pause are in [Working notes and threads](working-notes.md).
- **Working notes.** A working note is something the work learned that the code and the spec do not say, each with its source and checked before you see it. Notes are also kept at each checkpoint, and become the context part of a unit's completion record: see [Working notes and threads](working-notes.md).
- **Heads-up notes.** When a unit starts, its context gives up to five notes that earlier work left about the files it will change. See [Notes on the code](heads-up-notes.md).
- **Looking back.** Ask Claude what was decided and why, and it answers from the working notes, threads and finished work, naming each source. See [Ask why the code is the way it is](looking-back.md).

## What stays on your machine

Working notes, pause records and threads are in the spec tree, so the team sees them once the spec repo is pushed. The transcripts of your conversations, and BuildKeel's record of them in the working tree's `.buildkeel/` folder, stay on your machine: they are never committed or pushed.

**More:** [Working notes and threads](working-notes.md), [Notes on the code](heads-up-notes.md), [Build](working-on-a-unit.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-pause`.
