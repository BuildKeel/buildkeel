# Notes on the code

Earlier work leaves notes about the files it changed. With Heads-up notes on, a unit's context gives up to five of them about the files it will change, so a lesson arrives before the mistake is made again.

## 1. Leave a note on the code

A note on the code is a short note tied to files, such as `CN-012`: "the 30-minute limit is checked here and in the email job".

1. Ask Claude to remember something about a file, such as "remember that the 30-minute limit is checked here and in the email job".
2. Read the note Claude would save: the files, the note itself, and its source.

   ```text title="A proposed note on the code"
   A new note on the code would say, for src/reset/endpoint.ts: the 30-minute limit is checked here and in the email job [the user said "the 30-minute limit is checked here and in the email job"]
   The next unit that changes one of these files gets it when it starts.
   Nothing has been written yet. Show it to the user, and save it with apply: true only once they agree.
   ```
3. Agree, and Claude saves it.

   ```text title="The note saved"
   Saved CN-012 v1, a note on the code for src/reset/endpoint.ts, by Ana on laptop, in code-notes/CN-012/v1-k3q8.md, committed in the spec repo as 7c2e4b9. The next unit that changes one of these files gets it when it starts.
   ```

   An example. Yours will show your own files and IDs.

Claude saves a note on the code only when you agree. Besides your asking, it may propose one from a pattern in the records: see [The Learning loop](learning-loop.md).

Before a note is saved, each file it names must exist in the code repo, and its source is checked as a working note's is (see [How sources are checked](working-notes.md#how-sources-are-checked)). A note whose source does not hold is not saved, and Claude says why. To change a note, ask Claude: the change is saved as the note's next version.

## 2. See the notes when a unit starts

The notes come with the unit's context, with no command of their own.

1. Start a unit with `/bk:build`.
2. Read the **Heads-up notes on these files** part of its context.

   ```text title="Heads-up notes on these files"
   ## Heads-up notes on these files
   - CN-012, 2026-11-02, Note on the code: the 30-minute limit is checked here and in the email job [the user said "the 30-minute limit is checked here and in the email job"] (whole note: code-notes/CN-012/v1-k3q8.md)
   - TK-001, 2026-11-02, Dead end: a sliding expiry kept sessions alive on other devices [US-001-AC1] (whole note: tasks/TK-001/notes/20261102T171500Z-m2xa.md)
   ```

   An example. Each line names what the note belongs to, when it was written, what kind of note it is, its source, and where the whole note is.
3. Open the whole note when one is cut short, or ask Claude to show it.

Ask Claude to show the context of any unit at any time, such as "show the context of TK-002". See [Build](working-on-a-unit.md) for the rest of the context.

## 3. Turn Heads-up notes on or off

Heads-up notes is a switch, `continuity.heads-up`. It is on by default.

1. Open the spec tree's `buildkeel.yaml`.
2. Set `heads-up` under `continuity`, in the `process` section, to `off` or `on`.

   ```yaml
   process:
     continuity:
       heads-up: off
   ```
3. Commit it, so the whole team works with the same setting.
4. Run `/bk:settings` to see the setting as it now applies.

> **Nothing is lost.** With Heads-up notes off, the notes are left out of the context, and nothing more changes. Every note is kept, and [looking back](looking-back.md) still finds them. Turning it on again gives them from the next unit started.

## What a note holds

A Heads-up note is one of four kinds:

- **A working note** of a unit or change whose commits changed one of the files, found through the commits' unit lines, with renames followed. See [Working notes and threads](working-notes.md).
- **A note for the next person,** from the completion record of such a unit. See [Finish](finishing-a-unit.md).
- **A note on the code** that names one of the files.
- **A closed thread** whose code read points at one of the files.

A note on the code holds:

- its ID, such as `CN-012`, numbered in order;
- the files it is about, relative to the code repo;
- the note itself, in a sentence or two;
- its source: your words, quoted exactly; a file and line; or a record;
- who wrote it, and when.

Each note on the code is kept in the spec tree, in `code-notes/` under its ID, one file for each version, and committed in the spec repo. The team sees it once the spec repo is pushed.

## Which notes are shown

- **Up to five.** The notes that name one of the unit's files themselves come first, then those from units whose commits changed them. Within each, the most recent come first.
- **Cut short.** Each note is cut to 60 words, with a pointer to the whole note.
- **The files it will change** are the files its tasks list in their Files lines.
- **Not its own.** The unit's own working notes are left out: they come in its pause brief instead (see [Pause, resume and hand over](pausing-and-resuming.md)).
- **Nothing to say:** when no earlier work left a note on the files, the part is left out of the context.

## When a note stops showing

- **Others come first.** Only five are shown, so a note drops off when five more specific or more recent notes are about the same files.
- **Heads-up notes is off.** No note is shown, until it is on again.
- **A note on the code is switched off.** Ask Claude to switch it off: it is saved as a new version, and starting a unit no longer gives it. Ask again to switch it on. A note on the code switched off is left out of looking back too.
- **A thread is still open.** A thread is shown only once it is closed, captured or dropped.

**More:** [Working notes and threads](working-notes.md), [Ask why the code is the way it is](looking-back.md), [Feature switches](settings.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-build`.
