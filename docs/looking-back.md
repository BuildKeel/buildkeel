# Ask why the code is the way it is

Months later, you or someone new needs the reason behind a piece of code. Ask Claude, and it answers from what the work recorded, naming each source.

## 1. Ask Claude why

There is no command. Ask in words.

1. Ask what was decided and why, such as "what did we decide about token expiry?" or "why does the reset link last 60 minutes?".
2. To narrow it, name what you mean:
   - **an ID:** a unit, change or thread, such as `TK-001`, `CH-002` or `TH-004`;
   - **a file:** such as "why does reset.ts refuse a sliding expiry?";
   - **text:** words the notes would hold, such as "token expiry".

Claude looks with `query` and `view: "notes"`, by ID, by file or by text.

## 2. Read the answer and its sources

1. Read Claude's answer. Each point names its source: what it belongs to, such as `TK-001` or `TH-004`, and the source the note itself gives.
2. Ask Claude to show a record in full when you want more than the answer.

When nothing was noted, Claude says so: there is no working note, thread or completed work's context about it.

## What it searches

- **The working notes** of units and changes: decisions, rulings, constraints, dead ends, open questions and next steps.
- **The context of finished work,** in the completion records: decisions and why, those replaced, departures from the plan, dead ends, known limits, follow-ups and notes for the next person.
- **Threads,** each pause of each one, with its working notes.
- **Notes on the code,** except those switched off.

**By ID,** it finds everything that belongs to that unit, change or thread. **By file,** it finds the notes of every unit and change whose commits changed the file, following renames through git, and any note that names the file. **By text,** it finds the notes that hold every word you gave. The most recent come first.

Two more answers come without asking. When a unit starts, up to five notes earlier work left on its files are shown as [Heads-up notes](heads-up-notes.md). At finish and in the status overview, [the Learning loop](learning-loop.md) shows what recurs in the records.

The decisions that are hard to reverse, and that shape more than one piece of work, belong in an ADR instead: see [The playbook](glossary-practices-adrs.md#3-record-an-adr).

**More:** [Working notes and threads](working-notes.md), [Records and the audit trail](records.md).
