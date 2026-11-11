# Capture a plan

Turn a conversation, a document or a ticket into a plan in your team's templates. Claude drafts it with you, step by step, and writes nothing you have not agreed; in Full SDLC you then approve it.

## Before you start

- The repository is set up with `/bk:init`. See [Your first change](getting-started.md).
- You have talked the work through, or have material to bring. See [Talk it through and explore](exploring.md).

Everything Claude writes here holds what you decided, and nothing Claude assumed. It never adds a requirement, criterion or test case on its own.

## 1. Turn the conversation into a plan

`/bk:capture` turns what you discussed into a plan, with you agreeing at each step. Whatever Claude asks you to agree, it writes out in full in its reply, in the normal window, and asks in plain text at the end, never inside a question box.

1. Run the command:

   ```text
   /bk:capture
   ```

   To capture only part of a long conversation, say which: `/bk:capture the text message reset`.
2. Read the summary of what Claude heard.
   It says what you set out to do, the idea, the approaches weighed and the one chosen and why, the decisions discussed, what was left open, and the pitfalls and constraints raised, each marked settled or open. Each point is marked as what you said or what Claude proposed. When the session resumed a thread, the summary draws on the thread and the conversation since.
3. Choose **Create the artifacts**, **Change something**, or **Keep talking**.
   Any other answer, such as a correction, goes on with the conversation; nothing is drafted.
4. Check the plan Claude proposes, and answer it (see the panels below).
5. Choose the pace. Claude asks every time: **Step by step** (the default) or **All at once**.
6. Agree each draft, or give feedback.
   Any answer other than agreement is feedback, "ok, but…" included. Discuss it as long as you like. Claude then lists each point you raised with how it addressed it, or why it did not, shows the final version, and saves it only once you agree.
7. Decide each gap.
   When a draft needs something the conversation did not settle, such as a required section, an open pitfall or a missing detail, Claude tells you and asks, with no recommendation: **Put it in the spec as stated**, **Record it as an open question** (kept in the artifact's Open questions section; it does not block approval), **Flesh it out now**, or **Not relevant: leave it out**.
8. Answer the edge cases, the design options and the readiness check when they come up. See [What capture adds](#what-capture-adds).

Each pitfall you settled becomes a requirement, criterion or test case. At the end, any pitfall from the summary that no artifact covers is raised the same way as a gap. When later discussion would change something you already agreed, Claude says which artifact, what changes and why, and takes it through the same review.

### In Spec-driven

What Claude drafts is a change: a proposal, a spec change for each capability whose behavior it alters, a design only when needed, and tasks. Nothing in it is approved, and nothing is a draft: everything stays editable until the change is finished. See [The spec tree and its artifacts](spec-tree.md).

1. Claude reads the capability specs the work touches and proposes the change as a table of capabilities, each new or modified, with what changes in it, saying whether the change needs a design.
2. Choose **Looks right**, **Change the plan** or **Keep talking**, then the pace.
3. Step by step, Claude shows the proposal and saves it once you agree, which creates the change. Then it shows each spec change, the design if needed, and the tasks, one at a time.
4. All at once, it shows the whole change and saves it in one go once you agree.

IDs are given when the change is saved: the change's own, such as `CH-012`, and each new requirement and scenario, such as `AUTH-R3` and `AUTH-R3-S1`. A change captured from a thread names it, such as `thread: TH-004`. When the change is drafted, Claude names it and offers to build it: `/bk:build CH-012`.

### In Full SDLC

Claude drafts your business ideas, epics, stories, tasks, test plans and design documents from your templates. Everything it writes is a draft until you approve it.

1. Check the plan: a table of the artifacts your process needs, level by level, each marked as existing or new and given its purpose, with the documents each stage requires (by default a design document for an epic and a test plan for each story), and where Claude recommends the work fits in your tree, and why.
   When a stage holds several kinds of work, such as user stories and features, the table proposes the kind of each new artifact from where the work came from, for you to confirm or change.
2. Choose **Looks right**, **Place it somewhere else**, **Change the plan**, or **Keep talking**.
3. Step by step, Claude drafts the epic first, then its design document, then each story with its test plan, then the tasks as one batch. Each is drafted against the ones you already agreed to, shown with the pitfalls it covers, and saved once you agree, such as with **Looks good, next**. You can say **Draft the rest at once** at any step. If you stop partway, what you agreed to stays saved as drafts.
4. All at once, Claude drafts everything, then shows the set, and saves it once you agree.

Agreeing to an artifact here does not approve it. Once the last one is agreed, Claude offers to approve the set (see [step 4](#4-approve-the-plan-full-sdlc)).

> **Where the work goes.** If you place the work somewhere other than Claude recommended, such as a new epic instead of under `EP-01`, the new artifact is linked to the recommended one (`related: [EP-01]`), so a change to either makes the other worth a look. If the work changes how something already built behaves, and a document describes how it works today, such as `EP-01-DD`, the plan includes a new version of that document. See [When a requirement changes](change-impact.md).

## 2. Draft one artifact or a breakdown

`/bk:new` drafts straight from what you type, without a conversation first.

1. Name the type and, if you know it, the parent:

   ```text
   /bk:new story EP-01
   ```

   Types are `idea`, `epic`, `story`, `task`, `test-plan` and `design` (a design document). You can also use your team's own name for a stage or a document.
2. Or run `/bk:new` on its own. Claude asks what to draft, with examples; press Enter on the first choice and it suggests what to draft next from your tree.
3. Answer Claude's questions.
   Claude reads the template and the parent, asks for anything it cannot work out, one question at a time, and saves the draft.
4. To break a parent down, name the children and the parent:

   ```text
   /bk:new stories from EP-01
   ```

   Claude proposes a list of children, a title and a line each, and asks before writing them. For stories, it also drafts each story's acceptance criteria and a test plan whose test cases say which criteria they cover. You can break a business idea into epics, an epic into stories, and a story into tasks the same way.

### In Spec-driven

- `/bk:new change for <what>` drafts a change from what you type.
- `/bk:new spec change for CH-012`, or tasks or a design for an open change, adds or rewrites one file of it.
- `/bk:new` on its own asks what to draft, with examples, or suggests what an open change still lacks.

## 3. Bring your own material

Claude can fit existing requirement text to your template.

1. Paste the text, point Claude at a file, or name something it can read through tools you have connected to it, such as an issue in your tracker or a page in your wiki:

   ```text
   /bk:new design EP-01 from docs/password-reset-design.md
   ```

2. Check where each part went.
   Each part goes in the section it belongs to, keeping its meaning and its wording. Anything that fits no section goes in the section for further material, such as **Notes**.
3. Answer Claude's questions. For each required section the material does not cover, Claude asks you, one question at a time.

BuildKeel itself connects to no other tool: whatever Claude reads, it reads through your own setup.

## 4. Approve the plan (Full SDLC)

Approval turns a draft into an agreed version. Once approved, a version is frozen, and work can only start on a unit whose requirements are approved. Approving always takes two steps: BuildKeel approves only what its preview showed you.

1. Approve the set at the end of `/bk:capture`, or leave it.
   Once the last artifact is agreed, Claude asks whether to **Approve them now** or **Leave them as drafts**. Leave them when someone else approves your team's plans: they run `/bk:approve` later.
2. To approve later, or drafts from an earlier conversation, run `/bk:approve` and press Enter on the first choice, **The drafts from this conversation**. Or name the drafts yourself:

   ```text
   /bk:approve EP-draft-k3x9 EP-draft-k3x9-DD US-draft-m2p8 …
   ```

3. Read the preview of the set.
   Claude shows the whole set first, in the order it will be approved, parents and their documents before their children, with the number each will most likely get, and anything that would not pass, and why:

   ```text title="/bk:approve"
   Ready to approve 4 of 6 in one review, each with its own approval record and commit. US-draft-q7w4 would not pass, so it stays a draft, with what needs it.

   In order:
   1. EP-draft-k3x9 epic "Reset by text message" as v1: becomes EP-02 unless someone else approves one first
   2. EP-draft-k3x9-DD design document as v1: becomes EP-02-DD
   3. US-draft-m2p8 user story "Request a code by text" as v1: becomes US-002 unless someone else approves one first
   4. US-draft-m2p8-TP test plan as v1: becomes US-002-TP
   5. US-draft-q7w4 user story "Enter the code": would not pass.
      - stories/US-draft-q7w4/story.md: the "Acceptance criteria" section is missing.
        To fix: Add a "## Acceptance criteria" section.
   6. US-draft-q7w4-TP test plan: stays a draft, because US-draft-q7w4 would not pass.
   ```

4. Approve them, fix what would not pass first, or stop.
   Once you confirm, each artifact is approved in turn, through its own checks, with its own approval record and commit. If one is refused, the rest are still approved, and what needs it stays a draft. The result opens with what is now approved and what can start:

   ```text title="/bk:approve"
   Approved 4 of 6: EP-02, EP-02-DD, US-002 and US-002-TP. US-draft-q7w4 stays a draft: stories/US-draft-q7w4/story.md: the "Acceptance criteria" section is missing; US-draft-q7w4-TP waits for it.
   Ready to start now:
   - US-002 user story "Request a code by text"
   ```

When an artifact in the set has a new version of its parent approved in the same review, it is tied to that new version.

### Approve one artifact

1. Name it:

   ```text
   /bk:approve US-draft-k3x9
   ```

2. Read what approval will do. Claude shows you the artifact, checks it, and says what approval will write before anything is written:

   ```text title="/bk:approve US-draft-k3x9"
   Ready to approve user story US-draft-k3x9 "Reset link expires" as v1. Approving will:
   - give it its permanent number: the next user story number, US-002 unless someone else approves one first; its directory becomes stories/US-002/
   - rewrite references to US-draft-k3x9 in: stories/US-002/test-plan/plan.md
   - record it against its parent EP-01@v1
   - freeze v1 and record the approval by Jane Doe <jane@example.com>
   - commit only those files in the spec repo as "approve: US-002 v1", without pushing
   ```

3. Confirm in plain text. Nothing is approved until you do.
   When the draft changed after the preview, or there was no preview, nothing is written: Claude previews again and asks you on the new preview.
4. Approve what has become ready.
   Run `/bk:approve` on its own and press Enter on the first choice to see what is waiting, or type an ID. After each approval, Claude shows the same list again:

   ```text title="/bk:approve"
   Waiting for approval: 3.

   Ready to approve (1):
   - EP-01 epic "Password reset": v1

   Not ready yet (2):
   - US-001 user story "Request a reset link": The parent epic EP-01 "Password reset" is still a draft.
   - US-001-TP test plan: The parent user story US-001 "Request a reset link" is still a draft.
   ```

When an artifact has a document with a draft waiting, such as a story's test plan or an epic's design document, Claude offers to approve it next. The document is checked against the artifact's approved version, and it is approved and committed on its own. A task's own test plan is not approved: it is recorded as it is saved, and `/bk:approve` on one says so, unless your process approves task plans. See [Tests and traceability](test-plans.md).

### What is checked

Before an artifact can be approved, it has every field and section its template requires, every entry has its ID, and no entry reuses a removed entry's ID. Its parent is approved, and it is written against its parent's current approved version: a draft written against `EP-01@v1` cannot be approved once `EP-01` v2 is approved, so check it against v2 first. For a test plan, every `covers:` line names something the plan may cover, and a story's plan covers every acceptance criterion. If any check fails, nothing is written, and every failing check is listed with what to do:

```text title="/bk:approve US-draft-k3x9"
Approval of US-draft-k3x9 refused by the approve gate: 1 check failed.
1. The parent epic EP-01 "Password reset" is still a draft.
   To fix: Approve EP-01 first with /bk:approve EP-01.
```

A team can set the approve gate to `warn`, so approval goes ahead and the failing checks are shown, or `off`, with `process.gates.approve`. Ad-hoc units and defects found while building are not approved. A reported defect is approved like any draft, numbered in the defect sequence at its first approval.

### Permanent numbers

An artifact gets its permanent ID, such as `US-002`, when it is first approved. BuildKeel renames its directory from the draft ID and rewrites every reference to the draft ID in the spec tree's drafts: parent links, `covers:` lines and entry IDs such as `US-draft-k3x9-AC1`. A draft whose parent is the artifact being approved is tied to the new version, such as `US-002@v1`. Documents attached to an artifact have no number of their own: the test plan of `US-002` is `US-002-TP`, and the design document of `EP-02` is `EP-02-DD`.

Each type counts on its own: the first epic is `EP-01` and the first story `US-001`. The counters are kept on a branch of the spec repo's remote, `buildkeel/ids` (set `settings.idsBranch` in `buildkeel.yaml` to use another), never on your main branch. When two people approve at the same moment, one push is refused and that approval takes the next number. A spec repo with no remote keeps the counter on a local branch.

When the remote cannot be reached, the approval is still recorded, with the number pending. It shows as "approved, number pending" in `/bk:status`. It cannot be changed, its children cannot be approved, and work cannot start on it until it has its number, which is assigned the next time the remote can be reached. Approval records, commits and pushing, the pending record and repairing the counter are in [Records and the audit trail](records.md).

### In Spec-driven

A Spec-driven tree has no approvals. Agreeing is part of the review instead: while Claude shows you a document, such as a spec change during `/bk:capture`, typing `/bk:approve`, or replying "approved", agrees it, and Claude saves it and goes on. Nothing is frozen. With nothing under review, `/bk:approve` writes nothing, and says so, naming the open changes:

```text title="/bk:approve"
Nothing is waiting for agreement, and nothing was written: this spec tree is Spec-driven, so it has no approvals. While a document is under review in the conversation, /bk:approve or a reply such as "approved" agrees it.
Open changes, editable until each is finished with /bk:done:
- CH-002 "Reset links expire": 1 of 3 tasks done
Approvals, with drafts approved stage by stage and gates, come with Full SDLC: move the tree with /bk:migrate. The move is one way.
```

## 5. Change what you captured

How you change a plan depends on the mode.

### In Spec-driven

Every file of an open change can be changed at any time, by you or by Claude, with no new version and no approval: narrow the proposal after three tasks are done, rewrite a requirement, or add a task. Several changes can be open at once.

1. Ask Claude for the edit, such as "add a task to CH-012 for the rate limit".
   Claude can read one file of a change on its own, change, add or remove one requirement by its ID, and tick tasks by number, without rewriting the rest of the file.
2. Review the follow-on edits.
   When Claude edits one file of a change, it checks the others against the edit and names the follow-on edits in the same reply: a design decision that changes may mean two tasks change too. It shows each one, with what changes and why.
3. Agree each one. Claude saves it only once you agree. It never edits code as part of this.

What BuildKeel reports about a change as you save it is in [The spec tree and its artifacts](spec-tree.md).

### In Full SDLC

An approved version is never changed in place. A change to it becomes its next version.

1. Ask Claude for the change as usual. Saving it opens the next version as a draft:

   ```text
   Saved US-002 v2 as a draft at stories/US-002/story.md. v1 stays approved and in force until v2 is approved.
   ```

   The working file now holds v2; `versions/v1.md` is untouched.
2. Approve it: `/bk:approve US-002`. Its number stays the same.

This holds even when v1 was approved minutes ago and nothing is built on it, so anyone who built on it is told through [suspects](change-impact.md).

### Discard a draft

1. Ask Claude, such as "discard US-draft-k3x9, we are not doing text messages".
   A draft that was never approved goes with the drafts under it: its test plan or design document, and the stories or tasks drafted beneath it. Claude shows the list first, and names any other artifact whose text still mentions it, such as a task whose Uses line names it, so you can edit that afterwards.
2. Confirm. Nothing is removed until you do. A draft ID is never given again.

A new version in draft of an approved artifact can be discarded the same way, by its ID. Its file goes back to the version approved, which stays in force:

```text
Discarding the draft of TK-001 "Reset endpoint" v2 will:
- write tasks/TK-001/task.md back as v1, the version approved, which stays in force
- commit it in the spec repo, if any of it was committed
```

Approved versions and their records are never changed. When any of the draft was committed, the discard is committed as `discard: <ID>`, with your reason. Discarding an open change in Spec-driven is in [The spec tree and its artifacts](spec-tree.md).

## What capture adds

Along the way, capture adds these, each as the team's [switches](settings.md) say.

**Approaches are recorded.** The design document (Full SDLC) or the proposal (Spec-driven) gets an Approaches section from the conversation: the approaches considered, the one chosen and why, the non-goals and things to avoid. Nothing the conversation did not raise is added; when no other approach was weighed, it says so. A set with no such document keeps its approaches as working notes on its top new artifact.

**Edge-case suggestions.** When a story's test plan is drafted, or a change's scenarios, a fresh agent looks for the cases nobody has written: boundaries, empty and invalid input, errors, permissions, concurrency, and state left from earlier runs. By default it runs without asking (`planning.edge-cases: auto`); `ask` offers it in one line first, and `off` leaves it out. It proposes at most five, ranked by risk, each with the criterion it belongs to and a one-line reason, in the same review as the plan. You answer once, such as "add 1 and 3". More found at lower risk are counted, to show if you ask. A case one of the team's practices already covers is not proposed.

**Design options.** Before the tasks are drafted, when three or more tasks would use one interface, or it crosses from one code repository to another, Claude offers once, in one line, design options for it (`planning.design-options: ask`, the default; `auto` runs them without asking, `off` leaves them out). When they run, fresh agents, 2 by default, each propose a design from a different angle. Claude compares how much each hides behind a small interface, where changes and defects would collect, and where the seams go, and recommends one. The chosen design and those set aside are recorded as approaches. You can ask for design options for any interface at any time.

**The readiness check.** Before capture closes, for larger work, a fresh agent reads the agreed set as the person who will build it, and lists its questions. By default Claude offers it in one line, saying why:

```text
Offer the readiness check in one line, as this is larger work: it has a design document.
```

Larger work is a set with a design document, more than one story (or capability changed), more than three tasks, an interface one task delivers and another uses, a library the project does not depend on yet, or files in more than one code repository. Small work is skipped, with a line saying you can ask: "run the readiness check". The team can set it to run without asking (`auto`), or turn it off, with `planning.readiness`, and add readers: `{ mode: ask, readers: 2 }` adds a tester, and 3 adds an operator. Its questions come in one round: those the set or the conversation already answers are shown as edits; minor ones Claude settles, labeled "my call"; yours are listed together, the most important first, then asked one at a time, each with Claude's recommended answer. It is the one place Claude settles small questions itself.

**When agents can't be started,** edge-case suggestions, design options and the readiness check follow the same rule as every agent: Claude says why once. With `ask`, its offer says the check would run here, without a fresh reader; with `auto`, it runs here and says so. What it finds is labeled as Claude's own reading, not an independent one. See [Build](working-on-a-unit.md).

**The close.** After the readiness check come the gaps (pitfalls no artifact covers). Then, when the capture started from a thread, the thread is closed with a link to what was saved. In Full SDLC, capture then offers to approve the set; in Spec-driven it names the change and offers to build it.

## Details

**Draft IDs.** A draft has a temporary ID that starts with its type's prefix, so you can tell what it is: `BI-draft-…` for a business idea, `EP-draft-…`, `US-draft-…` and `TK-draft-…`, such as `US-draft-k3x9`. Its entries carry it too: `US-draft-k3x9-AC1`. BuildKeel numbers the entries itself, and never gives a removed entry's number to a new one. Drafts can refer to each other by these IDs, so you can draft a whole tree before approving any of it. When it is first approved, every reference to it is updated, and a document attached to a draft, such as `EP-draft-k3x9-DD`, takes the new ID with it. When a draft's parent is already approved, the draft is tied to the parent's approved version, such as `US-001@v1`.

**What is still missing.** After each save, Claude tells you whether the draft is ready for approval, and if not, what it still lacks, such as an empty required section or a test case that does not say what it covers:

```text
Created draft EP-01-DD (design document) at epics/EP-01/design/design.md. It is saved; 2 things stand in the way of approval, listed below.
```

Ask Claude to fill the gaps, or edit the draft and save again. To see a draft, ask Claude to show it, or run `/bk:status` to see where it sits in the tree.

**Design documents.** A design document says how an artifact's work is built, usually an epic's. It belongs to that artifact and is named after it: the design document of `EP-01` is `EP-01-DD`. Only its summary, context and design are required; further sections are offered and added only when the work needs them. See [Process: stages, kinds and documents](process-and-templates.md).

**A reported problem.** When the conversation is about a problem someone reported, capture checks it against the spec and the code linked to it before planning anything, and proposes its reading: a defect, a change in behavior, a gap, or code nothing describes yet. A confirmed defect is recorded as a defect; a change in behavior or a gap is planned as above. Defects are recorded with `/bk:new defect` too. A defect found while building is not a draft: it gets its permanent ID at once and needs no approval. A reported defect is drafted under the work it affects and approved like any artifact. See [Small fixes, defects and spikes](defects-and-adhoc.md).

**Code nothing describes yet.** If the work changes code that nothing describes yet, Claude finds it from the files the work will change, and the plan includes a **version 0** of what the work touches: how that code works today, with your change as its version 1, so the change has a "before". It appears in the table as, for example, a story marked "version 0, then the change as version 1". Choose **Looks right, without the version 0** to leave it out; the change is then drafted as new work. A version 0 drafted for a change covers only what the change touches, and a section nothing supports is left empty and listed for whoever approves it, with no question asked. `/bk:new` says so too, and offers to draft a version 0 of what it changes first, the default; the new artifact is then its version 1, or sits under it. Approving the plan approves version 0 first, each with its own record and commit:

```text
/bk:approve US-draft-k3x9@v0 US-draft-k3x9
```

How version 0 is drafted from the code and your sources, its numbers and its sources are in [Start on existing code](onboarding.md) and [Records and the audit trail](records.md).

**More:** [Build](working-on-a-unit.md), [Full SDLC mode in depth](how-full-sdlc-works.md), [Records and the audit trail](records.md), [The spec tree and its artifacts](spec-tree.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-capture`.
