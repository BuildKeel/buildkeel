# Records and the audit trail

As work is planned and built, BuildKeel writes records into the spec tree: who decided what, why, on what evidence, and what was built against which versions. This page explains each kind of record, where it is kept, and the properties that make the records an audit trail you can trust.

## Decisions with their evidence

Every decision made while work is planned and built is recorded with its source or its evidence. A requirement is never guessed, and no review finding is silently dropped. Months later, the next person can see why the code is the way it is, and a reviewer or an auditor can check each decision against what supported it.

There is no command for it and no setting. The records are written as the work goes, by BuildKeel's own operations, into the spec tree, so they are committed, pushed and shared with the team like any spec.

### Rulings

When an agent building a task asks a question, Claude answers it from the spec, the unit's working notes, the rulings already made, the glossary or the team's practices, and names where the answer came from. When nothing answers it, the run stops and you decide. A ruling is never invented to keep the run going.

Each ruling is kept at once as a working note of the kind *ruling*, with its source, so every later agent in the run is given it. See [Build](working-on-a-unit.md).

### Answers to review findings

Every finding a reviewer makes is checked against the code first, then answered one of three ways, each with its evidence:

- **fixed,** naming the commit that fixed it;
- **parked,** once you agree to handle it later, naming the defect that holds it;
- **rejected,** with the code, a test or the spec that shows the finding is wrong. Claude shows you each finding it rejects.

Each answer is a file of its own in the unit's `answers/` folder. A High or Medium finding left unanswered is reported when the unit is finished, and in Full SDLC it is a finding of the done gate's review-findings check. A Principal handoff that failed is recorded too, in `handoffs/`, with each fix tried and why it was rejected. See [Reviews and the fix loop](reviews.md).

### Decisions in the working notes

What the conversation settles is saved as working notes at each checkpoint and pause: a **decision** and why, a **constraint** or pitfall, a **dead end**, an **open question**, and the **next step**, besides rulings. Each note has its source: your words, quoted exactly and checked against the transcript, or a file and line that must exist. A separate agent then checks that the source supports the note, and a note it does not support is left out, with the reason. A decision that replaces an earlier one says which, so both stay readable. See [Working notes and threads](working-notes.md).

## Where records are kept

Records sit beside the unit they belong to: a task, story, defect or ad-hoc unit, or a change.

```
TK-047   Task "Implement verification token endpoint"
├── versions/      Full SDLC: each approved version, frozen with its hash
├── approvals/     Full SDLC: who approved which version, and when
├── switches/      which checks were on when the work started
├── runs/          the summary of its test runs: each test's first failing run, then its first passing run
├── notes/         the working notes, one file each time they are saved
├── pauses/        where the work stood at each pause, and who paused it
├── reviews/       each review's findings, each with an ID such as TK-047-Fk3q
├── answers/       how each finding was answered: fixed, parked or rejected, with its evidence
├── handoffs/      each Principal handoff that did not clear its finding
├── repins/        each time the work is confirmed still valid after what it was built against changed
└── completions/   what was built, against which versions, with which results, and why
```

- **While the work is open,** decisions are in the unit's or change's own folders: `notes/`, `reviews/`, `answers/` and `handoffs/`. The full list of folders is on [The spec tree and its artifacts](spec-tree.md#records-beside-each-artifact).
- **When it is finished,** the completion record holds every review finding with its answer, and a context part built from the working notes. An archived change carries the same.
- **The switches in force** are noted beside them, so a reader can tell "reviewed, nothing found" from "built with reviews off". See [Feature switches](settings.md).
- **Also kept:** for a defect closed without a fix, who closed it and why (`closed.yaml`); for version 0, each source it was drafted from, as it was read (`sources/`); for a discarded change, who discarded it, when and why (`discarded.yaml`).

## The completion record

Finishing a unit writes its completion record in the unit's `completions/` folder, and commits it on its own in the spec repo as `done: <ID> v<N>`. It is the durable account of the work: the versions in force above the unit and the documents it was built against, the code repository and branch, each commit counted for the unit and the files they changed, each test case's result with its tests, the evidence that tests came first, for a task what it delivered as built, who finished it, when, and on which host. Its context part holds the decisions and why (with those replaced marked), departures from the plan, dead ends, known limits, follow-ups and notes for the next person.

Finishing a change archives it: its files are frozen with the hash of each, the capability versions it wrote are recorded, and its completion record also holds the requirements it added or modified, the final review, and what the checks reported.

The record stands on its own: after a squash merge replaces the commit IDs, it still says what was built, against which versions and with which results. Every field, with an example, is on [Finish](finishing-a-unit.md).

## Approvals in Full SDLC

In Full SDLC, approving a version writes two files: a frozen copy in `versions/`, and an approval record in `approvals/` naming the version, the hash of the frozen copy, who approved it (their git identity) and when, the template it was checked against, and the parent version it was approved against. Each approval is one commit in the spec repo, such as `approve: US-002 v1`. Because versions and approvals are files, squashing or rebasing the spec repo's history never loses them. Every field is on [Full SDLC mode in depth](how-full-sdlc-works.md#what-approval-writes).

A Spec-driven tree has no approvals. There, each capability version has its own record beside it, naming the change that wrote it, its hash, who and when (see [The spec tree and its artifacts](spec-tree.md#versions)).

## Commits linked to their unit

While a unit is active, every commit Claude makes ends with the unit's line, such as `BuildKeel-Unit: TK-001`, and with stamping on, commits you make yourself get the same line. In a Spec-driven tree, a commit that does exactly one task adds `BuildKeel-Task: 1.2`. A commit on the unit's branch without the line still counts for the unit.

The completion record lists each commit counted for the unit, with its subject line and whether it was counted by its line (`by: trailer`) or by its branch (`by: branch`), which ties the commits to the version of the unit that was finished. Commits after the baseline that belong to no unit are reported by the status overview (see [Status and usage](status.md)).

## Re-pin records

When a requirement changes, work built against the earlier version becomes suspect. Deciding that it is still valid writes a re-pin record in the `repins/` folder of what was kept: who reviewed it, against which version, and the version it counts as built against from now on. It is committed on its own in the spec repo, such as `repin: TK-001 to US-001 v2`. In a Spec-driven tree, the record is written in the directory of the archived change that holds the dependency. Every field is on [When a requirement changes](change-impact.md).

## How records are kept

Four properties hold for every record.

- **Each record is a new file, written once.** Records are written by BuildKeel's own operations only, as the work goes, and never edited afterwards: a later decision is a new record that replaces the earlier one. In Claude Code, the lock gate stops the agent from changing them, and a change made with another tool is reported by validation and by the status overview.
- **Two branches that add records merge without conflict.** A record's file name holds when it was written and a short random suffix, such as `20261101T183000Z-k3q8.md`, or when and who, such as `20261001T141200Z-jane-doe.yaml` for a completion record, so two branches write different files. A version of a glossary entry, a practice or a note on the code is named by its version and a suffix, such as `v2-k3q8.md`: when two branches each add the same version, both are kept and validation asks you to settle which one stands. When two re-pin decisions name different versions, the newer one counts.
- **Every link names the version it was made against.** A parent is named with its version, such as `EP-01@v1`. An approval record names its parent's version, and the versions of what it pins, relates to or changes. A completion record names the versions in force above the unit and the documents it was built against. A spec change names the capability version it was written against (`base`), a reported defect names the requirement it affects at the version in force, such as `AUTH-R2@v2`, and a re-pin record names the version it moves from and to. That is what lets BuildKeel tell exactly what a change makes suspect.
- **Every frozen file carries its hash.** Frozen copies, capability versions, the files of an archived change and the sources kept with version 0 are each checked against the hash in their record, so a file changed after it was written is reported.

## Finding them again

Ask Claude why, such as "why does the reset link last 60 minutes?". It searches the working notes, threads and completion records by ID, by file (following renames through git) or by text, and answers naming each source. See [Ask why the code is the way it is](looking-back.md). When a unit starts, up to five of the notes earlier work left on its files are shown as heads-up notes; see [Notes on the code](heads-up-notes.md).

The decisions that are hard to reverse, and that shape more than one piece of work, belong in an architecture decision record instead: see [The playbook](glossary-practices-adrs.md).

**More:** [Finish](finishing-a-unit.md), [When a requirement changes](change-impact.md), [Working notes and threads](working-notes.md), [Reviews and the fix loop](reviews.md).
