# Decision records

Every decision made while work is planned and built is recorded with its source or its evidence: who decided what, why, and on what grounds. A requirement is never guessed, and no review finding is silently dropped. Months later, the next person can see why the code is the way it is, and a reviewer or an auditor can check each decision against what supported it.

There is no command for it and no setting. The records are written as the work goes, by BuildKeel's own operations, into the spec tree, so they are committed, pushed and shared with the team like any spec.

## Three kinds of decision

### Rulings

When an agent building a task asks a question, Claude answers it from the spec, the unit's working notes, the rulings already made, the glossary or the team's practices, and names where the answer came from. When nothing answers it, the run stops and you decide. A ruling is never invented to keep the run going.

Each ruling is kept at once as a working note of the kind *ruling*, with its source, so every later agent in the run is given it. See [Questions and rulings](building-with-agents.md#questions-and-rulings).

### Answers to review findings

Every finding a reviewer makes is checked against the code first, then answered one of three ways, each with its evidence:

- **fixed,** naming the commit that fixed it;
- **parked,** once you agree to handle it later, naming the defect that holds it;
- **rejected,** with the code, a test or the spec that shows the finding is wrong. Claude shows you each finding it rejects.

Each answer is a file of its own in the unit's `answers/` folder. A High or Medium finding left unanswered is reported when the unit is finished, and in Full SDLC it is a finding of the done gate's review-findings check. A Principal handoff that failed is recorded too, in `handoffs/`, with each fix tried and why it was rejected. See [Answering findings](reviews.md#answering-findings).

### Decisions in the working notes

What the conversation settles is saved as working notes at each checkpoint and pause: a **decision** and why, a **constraint** or pitfall, a **dead end**, an **open question**, and the **next step**, besides rulings. Each note has its source: your words, quoted exactly and checked against the transcript, or a file and line that must exist. A separate agent then checks that the source supports the note, and a note it does not support is left out, with the reason. A decision that replaces an earlier one says which, so both stay readable. See [Working notes](pausing-and-resuming.md#working-notes).

## Where they end up

- **While the work is open,** they are in the unit's or change's own folders: `notes/`, `reviews/`, `answers/` and `handoffs/`. See [The spec tree](spec-tree.md).
- **When it is finished,** the completion record holds every review finding with its answer, and a context part built from the working notes: decisions and why, those replaced, departures from the plan, dead ends, known limits, follow-ups and notes for the next person. An archived change carries the same. See [The completion record](finishing-a-unit.md#the-completion-record).
- **The switches in force** are noted beside them, so a reader can tell "reviewed, nothing found" from "built with reviews off". See [Records note the switches in force](settings.md#records-note-the-switches-in-force).

Records are never edited after they are written: a later decision is a new record that replaces the earlier one. The lock gate stops the agent from changing them directly.

## Finding them again

Ask Claude why, such as "why does the reset link last 60 minutes?". It searches the working notes, threads and completion records by ID, by file (following renames through git) or by text, and answers naming each source. See [Looking back](pausing-and-resuming.md#looking-back). When a unit starts, up to five of the notes earlier work left on its files are shown as [Heads-up notes](pausing-and-resuming.md#heads-up-notes-and-notes-on-the-code).

The decisions that are hard to reverse, and that shape more than one piece of work, belong in an architecture decision record instead: see [ADRs](glossary-practices-adrs.md).
