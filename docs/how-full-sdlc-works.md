# Full SDLC mode in depth

A Full SDLC spec tree follows your team's process: a chain of stages from a business idea down to the work you build, the documents each stage needs, and approvals and gates along the way. This page follows one piece of work from a business idea to a finished task, then explains every question `/bk:init` asks when it sets up a Full SDLC tree, three complete processes, and how approval and locking work.

## From a conversation to an approved plan

With the default process, a business idea is split into epics, an epic into user stories, and a story into tasks; an epic has a design document, and a story a test plan. See [Process: stages, kinds and documents](process-and-templates.md) for the chain.

The examples on this page come from a payments service: business idea BI-01 "Self-service account recovery", epic EP-01 "Password reset" with its design document, user story US-001 "Request a reset link" with its test plan, and task TK-001 "Reset endpoint". Along the way: a defect found while building, behavior questioned while building and the pause for approval, a reported defect and its approval, and a defect in code nothing describes yet.

You talk the work through with Claude. When it has reached a point, `/bk:capture` proposes where it goes in the chain and drafts each artifact, shown in full before it is saved. A draft has a draft ID, such as `US-draft-k3x9`, until it is approved. See [Capture a plan](capture.md).

Approving a plan takes one review with `/bk:approve`: parents and their documents first, each with its own approval record, commit and permanent number.

```text title="/bk:approve"
Approved all 6 in one review: BI-01, EP-01, EP-01-DD, US-001, US-001-TP and TK-001.
Ready to start now:
- DEF-001 defect "Reset link expires early"
- TK-001 task "Reset endpoint"
```

An approved version is locked: a change to it opens its next version, and the approved one stays in force until that is approved. See [Approval and locking](#approval-and-locking).

## Starting and building the work

`/bk:build TK-001` runs the start gate: the task and everything above it approved, none of them suspect, and every document the process requires approved, such as the story's test plan with no gaps. Then the task gets its branch and its claim on this machine:

```text title="/bk:build TK-001"
- Created its branch bk/TK-001-reset-endpoint from main.
- Claimed on this machine: other working trees cannot start TK-001 until it is finished or released.
```

Claude receives the task's context: what to build, why (the story, with each acceptance criterion and the test case for it), the epic's design, and the open defects. Each commit ends with `BuildKeel-Unit: TK-001`, and each test carries its test case in its name, such as `it("expires links [US-001-TC2]")`. See [Build](working-on-a-unit.md).

Under a story with several tasks, each task can be built by a fresh agent that gets only that task's context, with your conversation running the build, and independent tasks can be built at the same time. Fresh reviewers review each task once it is built: one checks it against the spec by ID, one reviews its code, and one writes tests that try to break it. See [Reviews and the fix loop](reviews.md).

### A defect found while building

While building TK-001, Claude opens an expired link and sees a stack trace where a message should be. That is a defect of the work under way: the code does not do what was agreed. Recorded with `/bk:new defect`, it is attached to the task, with the test case that found it, and gets its number at once:

```text title="/bk:new defect"
Created defect DEF-002 "Expired link page shows a stack trace" at defects/DEF-002/defect.md, attached to TK-001@v1, where US-001-TC2 found it.
```

The work is already approved, so the defect needs no approval of its own and can be started straight away. It needs a regression test with `[DEF-002]` in its name.

### Behavior questioned while building

The code repository has a security policy: a reset link must expire within 15 minutes. US-001-AC2 says 30. Claude does not build something else, and does not edit the spec on its own: it stops, names US-001-AC2 and the policy, and asks whether to keep the criterion as agreed or change it.

You say 15 minutes. The spec changes first. Claude saves the story's next version, which opens it as a draft beside the approved one:

```text
Saved US-001 v2 as a draft at stories/US-001/story.md. v1 stays approved and in force until v2 is approved.
```

Then it previews what approving it would make suspect, so everything the change touches is drafted together:

```text
Approving the draft of US-001 as v2 would make 2 items suspect. Nothing is marked until the draft is approved.

US-001 "Request a reset link", from v1 to the draft:
- US-001-AC2 changed
  was: - **US-001-AC2** The link expires after 30 minutes.
  now: - **US-001-AC2** The link expires 15 minutes after it is sent.
Would become suspect (2):
1. Task TK-001 "Reset endpoint": any change to US-001 affects it.
2. Test case US-001-TC2 "Link expires" in US-001-TP v1: covers US-001-AC2.
```

The build pauses until the new versions are approved. Once US-001 v2 is, the task is suspect, and the start gate holds it:

```text
Start of TK-001 refused by the start gate: 1 check failed.
1. The task TK-001 "Reset endpoint" is suspect: built against US-001 v1, and v2 changes US-001-AC2.
```

You review it with `/bk:impact`: TK-001 still holds against v2, so Claude records that, and the work goes on against the new version:

```text title="/bk:impact"
Recorded that TK-001 is still valid against US-001 v2, so it is no longer suspect. The decision is kept in:
```

When the start gate is set to warn, you can tell Claude to carry on before the new versions are approved; it says that it builds against versions not yet approved. See [When a requirement changes](change-impact.md).

### Finishing

`/bk:done` runs the final review by fresh reviewers, then the done gate: the work committed on the task's branch, every test case that applies to it passing in a test report recorded with the test results, and its review findings answered. Finishing writes the completion record: what was built, against which approved versions, and with which results.

```text title="/bk:done"
Finished TK-001 "Reset endpoint" v1: its completion record keeps what was built, against which approved versions, and with which test results.
```

A story built through tasks is finished once everything under it is: its tasks finished, its defects fixed or closed, and its test cases passing. Until then, `/bk:done US-001` names what is left:

```text title="/bk:done US-001"
Finish of US-001 refused by the done gate: 3 checks failed.
1. The defect DEF-001 "Reset link expires early", under US-001, is not finished.
   To fix: Start it with /bk:build DEF-001 and finish it with /bk:done.
2. The defect DEF-002 "Expired link page shows a stack trace", under US-001, is not finished.
   To fix: Start it with /bk:build DEF-002 and finish it with /bk:done.
```

The epic, then the business idea, are finished the same way. See [Finish](finishing-a-unit.md).

## A defect, or a change in behavior

The rule is the same in both modes:

- **A defect**: the code does not do what the spec says. The code is fixed, and the spec keeps its version. For example, US-001-AC2 says 15 minutes, and links expire after 3.
- **A change in behavior**: the code does what the spec says, and the spec is wrong, no longer wanted, or silent. The spec changes and gets a new version: a new version of the story, or a new item of the team's kind for it, such as an enhancement. For example, links expire after 15 minutes, as US-001-AC2 says, and support now wants an hour.

When someone reports a problem, Claude checks it against the approved spec and the code linked to it before recording anything, and proposes one reading: a defect, a change in behavior, a gap (the spec says nothing about it), or code nothing describes yet. It labels the reading as its own, says what it rests on, and records nothing until you confirm or pick another. A defect that later turns out to change behavior is closed without a fix as a change in behavior, naming what takes it over, such as `US-001@v3`.

### A reported defect

A customer on one mail provider gets no reset email. US-001 says the email arrives within a minute: a defect. A defect that users, customers or testers report is planned work, so it goes through the lifecycle of the chain. Its parent is the work it affects, a user story unless your team chose other kinds in `defect.parents`, and it is drafted first:

```text
Created draft DEF-draft-1f21 (defect) at defects/DEF-draft-1f21/defect.md. It follows its template and has everything it needs for approval.
```

It cannot be started until it is approved:

```text
Start of DEF-draft-1f21 refused by the start gate: 1 check failed.
1. The defect DEF-draft-1f21 "Reset email never arrives for some domains" is not approved and has no permanent number yet.
```

Approving it gives it its number in the defect sequence:

```text
Approved DEF-003 v1 (was DEF-draft-1f21). It is locked now: a change opens v2, and v1 stays in force until then.
```

When the affected work is not known, Claude asks BuildKeel which work changed the code involved and which artifacts' scope covers it, and offers what it finds as the parent, for you to pick.

### A defect in code nothing describes

A customer reports that invoice totals round down. Claude asks BuildKeel what describes the billing code:

```text
Nothing describes src/billing/invoice.ts in payments-api yet: no artifact's scope covers it, and no unit's commits changed it.

No story describes these files, so a reported defect in them has no parent yet: draft version 0 of the story the defect touches first, stating the intended behavior, and use it as the defect's parent.
```

Claude drafts version 0 of an invoicing story, describing the code as it was before BuildKeel and stating the intended rounding, then the defect with that draft as its parent, and you review and approve both in one set, version 0 first:

```text
Approved all 2 in one review: US-E001@v0 and DEF-004.
```

See [Start on existing code](onboarding.md) for version 0.

### Where it all shows

`/bk:status` shows the tree with each artifact's state, suspects, coverage gaps, and the defects, each with its parent and where it came from:

```text title="/bk:status"
Defects: 4 open, 0 done.
- DEF-001 "Reset link expires early": in TK-001, found while building
- DEF-002 "Expired link page shows a stack trace": in TK-001, found while building
- DEF-003 "Reset email never arrives for some domains": in US-001, reported
- DEF-004 "Invoice totals round down": in US-E001, reported
```

See [Status and usage](status.md) and [Small fixes, defects and spikes](defects-and-adhoc.md).

## One piece of work, start to finish

The same password reset work, followed through every part of BuildKeel it touches:

1. **Exploring.** Ana talks reset links through with Claude: a link or a code, how long it lasts, what the email says. Claude checks the code, lays out the options and keeps her words apart from its own proposals. When she calls it a "client", the glossary says "customer", and Claude asks which she means. See [Talk it through and explore](exploring.md).
2. **A thread.** It is late; Ana says "let's stop here". With no unit active, `/bk:pause` keeps the conversation as `TH-001 "Password reset links"`, shown in full and saved once she agrees, then pushed. See [Pause, resume and hand over](pausing-and-resuming.md).
3. **Capture.** The next day, `/bk:resume TH-001` shows its brief, and the talk goes on. `/bk:capture` sums it up, drawing on the thread, with the approaches weighed. It drafts the epic, its design document with those approaches, the story with its test plan (with edge-case suggestions: up to five missing test cases proposed by a fresh agent), and the tasks. As the set is larger work, Claude offers the readiness check; you take it, and its questions are settled. Closing the capture closes the thread, linked to the epic, and the set is approved in one review.
4. **A run in fresh agents.** `/bk:build US-001` builds each task in a fresh agent, with the glossary terms and practices in its view. Each answer to an agent's question is kept as a working note, so later agents have it. See [Build](working-on-a-unit.md).
5. **Review.** Fresh reviewers review each task: its spec by ID, its code, and tests that try to break it. A High finding is fixed before the run goes on. See [Reviews and the fix loop](reviews.md).
6. **A pause on one machine.** Halfway through TK-002, Ana switches to her desktop: `/bk:pause` commits her work in progress, records where things stand with the working notes, and pushes both repositories.
7. **Finishing on another.** On the desktop, after a pull, `/bk:resume TK-002` asks to confirm resuming work paused on another machine, starts the task on its branch with the brief, and Ana carries on. `/bk:done` runs the final review and the done gate, and shows the context part of the completion record: the decisions, the dead ends, and notes for the next person, which the next unit to change these files is given when it starts.

## Setting up a Full SDLC tree

`/bk:init` sets up a tree for **Full SDLC**: work goes through your stages, from business idea down, with approvals and gates. Below is every question setup asks, in the order it asks them, why it asks, and what each answer does. You need BuildKeel installed first: see [Install](install.md). If you have not chosen a mode yet, see [Choose a mode](modes.md); for the other mode, see [Spec-driven mode in depth](how-spec-driven-works.md#setting-up-a-spec-driven-tree).

### How setup asks

Setup asks one thing at a time and waits for your answer. Where a question has a default, the default is the first answer, and it names the actual value, such as "keep the start gate at block". Press Enter, or say so, to keep it.

You can always answer in your own words, covering several questions at once or only part of one. After each answer, Claude says which topics your answer settled, with what it understood for each, and which are left, then asks the next one. Claude never fills in what you did not say: anything it works out on its own, such as an ID prefix for a stage you added, is offered as a suggestion for you to confirm or change. When an answer is unclear, Claude asks about it; when it conflicts with something you said earlier, Claude names both and asks which holds.

Nothing is written until you have seen everything that will be set up, in full, and agreed to it.

### Before the first question: the folder

Setup first checks that the folder you run it in is a git repository. BuildKeel links code to its specs through git commits, so it needs one. When the folder is not a repository yet, setup tells you so before anything else:

```text title="/bk:init"
/home/ana/payments is not a git repository. BuildKeel links code to its specs through git, so setup needs one. Nothing has been written.
```

Claude then asks: **Run git init for me** (the default) or **Stop**. With the first, BuildKeel runs `git init` in the folder:

```text
Ran git init in /home/ana/payments: it is a git repository now, with no commits yet. Nothing else has been written. Ask the first setup question.
```

The last sentence is for Claude: it goes on to the first question. A folder that is already a repository goes straight on, and one already set up stops here, with how to point it at another spec tree.

### 1. Where the spec tree lives

The spec tree holds your plan: business ideas, epics, stories, tasks and their documents, with every approval.

- **In this repository**, in a `specs/` folder. Choose this for a team with one repository, or to try BuildKeel out.
- **An existing spec tree**, usually a repository of its own that several code repositories share. Clone it first and give its path. An existing tree keeps its own mode and process, so the rest of setup does not apply: setup only registers your repository.
- **A new spec repository**, a repository of its own for the tree. Give a folder outside this repository, such as `../payments-specs`.

See [The spec tree and its artifacts](spec-tree.md).

### 2. The mode

Choose **Full SDLC**. **Spec-driven** is listed first, as the default. A tree keeps the mode it is created with; a Spec-driven tree can be moved to Full SDLC later with `/bk:migrate`, but not back. See [Choose a mode](modes.md).

### 3. Stamping your own commits

While a unit of work is active, BuildKeel adds a line such as `BuildKeel-Unit: TK-047` to every commit Claude makes, so each commit traces to the work it belongs to. A git hook adds the same line to commits you make yourself, such as in a terminal. It does nothing when no unit is active. Setup asks: **Stamp my commits** (the default) or **Don't stamp them**. If your repository already manages its git hooks with a tool such as husky or lefthook, BuildKeel installs nothing and shows you the lines to add. To change it later, ask Claude to turn stamping off or on: turning it off uninstalls the hook. See [Feature switches](settings.md).

### 4. What setup will add

Setup now lists every file and setting it would add, and ends with BuildKeel's default process as a table:

```text
| Stage | Kind | First ID | Requires before work under it starts |
|---|---|---|---|
| business idea | business idea | BI-01 | nothing |
| epic | epic | EP-01 | design document |
| user story | user story | US-001 | test plan |
| task | task | TK-001 | nothing |
Documents that can be attached at any stage: test plan and design document.
Outside the stages, defect IDs start at DEF-001 and ad-hoc unit IDs at AH-001. A reported defect's parent is the work it affects: a user story.
Gates: approve block, start block, done block, lock block (block stops the action, warn lets it go ahead with a warning, off skips the check).
A task's own test plan is recorded as it is saved, not approved.
```

Read it as the path of every piece of work: a business idea is split into epics, an epic into user stories, and a story into tasks when it spans more than one piece of code. Each row says what must be approved before work under it can start. "Outside the stages" are defects and small ad-hoc changes. An ad-hoc change, and a defect found while building, need no plan; a defect that users, customers or testers report sits under the work it affects and is approved like any artifact. Which kinds it can sit under is set by `defect.parents` in `buildkeel.yaml`, a user story by default: setup does not ask, and you can change it later (see [Process: stages, kinds and documents](process-and-templates.md)).

Claude then asks whether your team uses this process as it is, or works differently.

- **Use it as it is**: nothing more is asked about the process. Go on to [Confirm and set up](#8-confirm-and-set-up).
- **It works differently**: describe how your team works, in your own words. Say as much or as little as you like: Claude asks about everything your description leaves out, one topic at a time, in the order below.

### 5. Your process, topic by topic

**Stages.** The stages are the levels work moves through. Business idea, epic and user story always exist; you can rename them, and the task stage is optional. You can add stages of your own between the business idea and the user story.

- **Renaming**: "we call stories features". The stage keeps what it is: BuildKeel still treats it as a user story for test plans, context and change impact, and uses your name everywhere it talks to you.
- **Adding**: "we have a feature level between epics and stories". An added stage behaves like an epic: it is approved, the stage below sits under it, and it is finished once everything under it is.

When you name a stage the default process does not have, Claude asks where it goes. Say your answer was:

> There are 5 stages: business idea, epic, feature, user story, task.

Feature could be a level of its own, with user stories under features, or a kind of work beside user stories (see the next topic). Claude asks which, and does not decide for you.

Work is done on stories, tasks, defects and ad-hoc units, so nothing can be added below a story. If you describe a stage after the code is built, such as a QA sign-off, Claude says the process has no such stage and offers the closest setting, such as the done gate's checks.

**Kinds within a stage.** A stage can hold more than one kind of work. For example, your story stage might hold user stories, features and enhancements: all three are planned, approved, tested and built the same way, with acceptance criteria, a test plan and tasks under them, but your team names and tracks them separately. Each kind:

- is numbered in its own sequence: `US-001`, `FEAT-001`, `EN-001`;
- has its own template, so a feature can ask for different sections than a user story;
- has its own required documents, so features can need a design document while user stories do not;
- behaves as its stage does: a task can sit under any kind at the story stage, and takes its test cases.

When you capture new work, Claude proposes which kind it is, from where the work came from, and asks you to confirm it. Most teams need one kind per stage, which is the default.

**ID prefixes and numbering.** Each stage and kind has a prefix and a number of digits: `US-001` is the prefix `US` with three digits. The default prefixes are in the table above. Examples of other numbering:

- `FEAT-0001`: prefix `FEAT`, four digits;
- `ST-01`: prefix `ST`, two digits;
- `PROJ-12`: prefix `PROJ`, two digits, if your tracker numbers that way.

Every stage and kind needs its own prefix, of 1 to 8 capital letters or digits, starting with a letter. A stage or kind you add has no default, so Claude suggests one, such as `FEAT` for feature, and says it is a suggestion you can change. IDs are given when an artifact is first approved, and never change.

**Documents each stage and kind requires.** Documents describe how a stage's work is tested or built, and live with the artifact they belong to. Two are built in: the **test plan** (`US-001-TP`) and the **design document** (`EP-01-DD`). By default an epic needs an approved design document, and a story an approved test plan with no gaps, before work under it can start.

You can require different documents of each stage or kind, rename the built-in ones ("we call design documents tech specs"), and add documents of your own, such as a security review or a threat model, each with a two to four letter suffix for its IDs (`EP-01-SR`). Examples:

- "every feature needs a design doc": features require a test plan and a design document;
- "epics need a security review": a new document type, required of epics;
- "we don't write design docs for epics": epics require nothing.

**Test plans for tasks.** Every story's test plan is approved. A task can also have a test plan of its own, for tests that are none of its story's test cases, such as the tests of a building block like a database client. By default a task's own plan is **recorded** as it is saved, with no approval, since the task itself was approved. Choose **approved** if your team wants every test plan reviewed.

**Gates.** BuildKeel checks your work at four gates:

| Gate | Checks |
|---|---|
| approve | before an artifact is approved: it follows its template, and its parent is approved |
| start | before work starts: everything above the unit is approved and not suspect, and its required documents are approved |
| done | before a unit is finished: its test cases pass |
| lock | before the agent edits approved versions and records |

Each gate has a mode:

- **block**, the default: a failing check stops the action, with what to do about it. Choose it when you want the process to hold.
- **warn**: the action goes ahead, and each failing check is shown. Choose it while your team tries BuildKeel out, or adopts it a little at a time.
- **off**: the gate is not checked. Choose it only for a check your team does elsewhere.

Many teams start with every gate on warn and move them to block once the team is used to the flow. The done gate also has two checks with modes of their own, warn by default: the TDD check and the review-findings check. See [Settings left at their defaults](#settings-left-at-their-defaults).

**One answer, several topics.** You do not have to answer topic by topic. Say your first answer was:

> Five stages: business idea, epic, feature, user story, task, and the gates should only warn for now.

Claude says what that settled: the stages, with feature as an added stage once you have confirmed where it sits, and every gate on warn. It lists what is left, kinds, prefixes, documents and test plans, and asks about kinds next. BuildKeel keeps the same count, so nothing can be written while a topic is left:

```text
Setup topics settled: stages, gates. Left: kinds, prefixes, documents, test plans.
```

If a later answer conflicts with an earlier one, such as "every story needs a design doc" and then "features don't", Claude names both and asks whether features are the exception.

### 6. The process, as you described it

When no topic is left, Claude shows the whole process in the same layout as the default, with a line on what each stage or kind you added means. For a story stage with features and enhancements beside user stories:

```text
| Stage | Kind | First ID | Requires before work under it starts |
|---|---|---|---|
| business idea | business idea | BI-01 | nothing |
| epic | epic | EP-01 | design document |
| user story | user story | US-001 | test plan |
|  | feature | FEAT-001 | test plan, design document |
|  | enhancement | EN-001 | test plan |
| task | task | TK-001 | nothing |
Documents that can be attached at any stage: test plan and design document.
Outside the stages, defect IDs start at DEF-001 and ad-hoc unit IDs at AH-001. A reported defect's parent is the work it affects: a user story.
Gates: approve block, start block, done block, lock block (block stops the action, warn lets it go ahead with a warning, off skips the check).
A task's own test plan is recorded as it is saved, not approved.

What each stage and kind the team added means:
- feature (FEAT-001, a kind of user story built as a user story is): tasks sit under features; a feature is approved before work on it or under it starts; it is finished with /bk:done once its work is done, or once the tasks under it are.
- enhancement (EN-001, a kind of user story built as a user story is): tasks sit under enhancements; an enhancement is approved before work on it or under it starts; it is finished with /bk:done once its work is done, or once the tasks under it are.
```

Answer **go ahead** (the default), **change something**, in your own words, or **stop**, which writes nothing. After a change, Claude shows the whole table again, in the same layout.

### 7. Templates

Every stage, kind and document needs a template: it says what an artifact of that type must contain, and BuildKeel checks each artifact against it before it can be approved. The built-in stages and documents have built-in templates. Each stage, kind or document you added needs one of its own, and setup lists them:

```text
Templates the process needs beyond the built-in ones:
- feature, for the feature kind at the user story stage: not given yet
- enhancement, for the enhancement kind at the user story stage: not given yet
```

Once you have agreed the process, Claude takes them one at a time. For each, it asks:

- **Claude drafts it** (the default). Claude starts from the closest built-in template, such as the user story template for a kind at the story stage, the epic template for a stage added above the story, or the design document template for a document of your own, and changes it to what you said about it. It shows you the template in full, and you use it or ask for changes.
- **I'll provide a file**. Give the path of your team's template. BuildKeel checks it with the same check validation uses. If it does not fit the template format, such as a file with no sections BuildKeel can read, Claude shows what is wrong and asks: **Claude fixes it** (the default) or **Use another file**. A fixed template is shown in full before it is used.

A template cannot be left for later: without it, nothing drafted of that type could be checked, and the new tree would fail validation straight away. If you ask to skip one, Claude explains this and asks again. Setup refuses to write while one is missing:

```text
Nothing was written: setup is not settled yet.
- The process needs a template for the feature kind at the user story stage, and none was given.
  To fix: Settle it with the user: Claude drafts it from the closest built-in template, or the user provides a file; then pass it in templates as feature.
```

To change a template later, edit it in your spec tree's `templates/` folder. See [Templates](templates.md).

### 8. Confirm and set up

Claude shows everything setup will write, in full, and asks whether to set up with it. Once you agree, BuildKeel writes the spec tree's settings, with your process, and every template you agreed, together, so the new tree passes validation from the start. It commits nothing: review the changes and commit them. See [Your first change](getting-started.md) for each file it adds.

Your tree is then ready. Talk through what you want to build with Claude, as you would without BuildKeel, then run `/bk:capture` to turn the conversation into the artifacts your process needs. To see your process, gates and templates again at any time, run `/bk:settings`.

### Settings left at their defaults

Setup asks nothing about the checks on tests, the agents that build and review, or what a pause saves: each starts at a default that suits most teams. To change one later, add it to the `process` section of `buildkeel.yaml` and commit it with the spec tree. [Feature switches](settings.md) lists every one, with what turning it off or on does. With every default written out:

```yaml
process:
  gates:
    tdd: warn                   # block | warn | off: the done gate's TDD check
    review-findings: warn       # block | warn | off
  planning:
    exploring: on               # on | off
    design-options: { mode: ask, designers: 2 }   # off | ask | auto
    readiness: { mode: ask, readers: 1 }          # off | ask | auto; 1 to 3 readers
    edge-cases: auto            # off | ask | auto
    build-ready-tasks: on       # on | off
    plan-check: on              # on | off
    spikes: on                  # on | off
  runs:
    build: fresh-agents         # fresh-agents | here: the first choice in /bk:build
    parallel: 3                 # the most tasks built at the same time; 1 is off
  checks:
    coverage: on                # on | off
    mutation: off               # or: { command: "npm run mutate" }
  reviews:
    spec-compliance: on         # on | off
    code-quality: on            # on | off
    break-it: on                # on | off
    each-task: on               # on | off
  agents:
    roles:
      implementer: inherit      # inherit, or a tier: standard, principal, or your own
      spec-reviewer: inherit
      quality-reviewer: inherit
      final-spec-reviewer: inherit
      final-quality-reviewer: inherit
      break-it: inherit
      readiness-readers: inherit
      edge-cases: inherit
      designers: inherit
      note-checker: inherit
    handoff: { tier: principal, after: 2 }         # tier: none turns it off
  continuity:
    threads: ask                # off | ask | auto
    heads-up: on                # on | off
    learning-loop: on           # on | off
  tests:
    paths: []                   # test file patterns besides the usual ones
```

- **The done gate's checks** have modes of their own, set beside the gates: the TDD check (see [TDD evidence](tdd.md)), and the review-findings check: a final review ran, and every High or Medium finding was fixed, parked or rejected. Both warn by default.
- **Parallel runs**: when `/bk:build` builds independent tasks at the same time, it builds at most this many.
- **Structured exploring**: when you ask to explore an idea with structure, Claude plays back what it understood, keeping your words apart from its proposals, and offers two or three approaches.
- **Design options, the readiness check and edge-case suggestions** start fresh agents. Each is `off`, `ask` (a one-line offer saying why it would help) or `auto` (it runs and says why in a line). The readiness check is offered or run only for larger work, and you can ask for any of them at any time.
- **Build-ready tasks**: every task names its Files, what it Uses and Delivers, and its Verify command. **Plan check** reports problems in them when tasks are saved, and never blocks.
- **Spikes**: throwaway work on its own branch, to find something out.
- **The first choice in `/bk:build`**: a fresh agent per task, or here. The other is always offered too.
- **Principal handoff**: when fix rounds do not clear a review finding, the implementer gets one more round on a stronger tier. With `tier: none`, the run stops and asks you.
- **Changed-line coverage** and **mutation testing**: see [Tests and traceability](test-plans.md) and [TDD evidence](tdd.md). Mutation testing is off until you give the command that runs your team's mutation tool.
- **The reviewers and the review after each task**: each can be turned off.
- **Threads**: what a pause with no unit active does: `ask` offers to save the conversation as a thread, `auto` saves it, `off` saves nothing.
- **Heads-up notes** at the start of a unit, and the **Learning loop**, which looks for patterns in the records at finish and in status.
- **Test file patterns**, for tests outside the usual places. See [TDD evidence](tdd.md).

**Agents.** Each of the ten roles an agent plays, from the implementer to the note checker, runs with the session's model and effort (`inherit`) unless you give it a tier. Two tiers are ready to use, and you can change them or add your own under `agents.tiers`:

| Tier | Claude Code | Antigravity |
|---|---|---|
| standard | Sonnet at medium effort | `flash` |
| principal | Opus at high effort | the conversation's model |

```yaml
process:
  agents:
    tiers:
      careful: { claude-code: { model: opus, effort: max }, antigravity: { model: pro } }
    roles: { final-spec-reviewer: principal, final-quality-reviewer: principal, spec-reviewer: careful }
    handoff: { tier: careful, after: 2 }
```

Antigravity has no effort setting for agents, so an effort there is ignored, and `/bk:settings` says so. See [Models and effort per role](models.md).

**The read-only copy.** BuildKeel keeps a copy of the team's glossary, practices and accepted ADRs in each code repository, so they are read with the code. Its paths are set in that repository's `.buildkeel.yaml`, and default to:

```yaml
copy:
  glossary: GLOSSARY.md
  practices: docs/practices.md
  adrs: docs/adr/
```

A setting you leave out takes its default, and one that cannot be read keeps its default too, so a mistake never stops work: validation reports it. `/bk:settings` shows every setting as it applies.

## Three complete processes

Each process below is shown as setup's table and as the `buildkeel.yaml` it writes. Your process can be changed later in the same file; see [Process: stages, kinds and documents](process-and-templates.md).

### The default chain

One kind at each stage, every gate blocking. A team that uses the process as it is gets a `buildkeel.yaml` with no process section:

```yaml
format: 4
mode: full-sdlc
repos:
  - name: payments
```

```text
| Stage | Kind | First ID | Requires before work under it starts |
|---|---|---|---|
| business idea | business idea | BI-01 | nothing |
| epic | epic | EP-01 | design document |
| user story | user story | US-001 | test plan |
| task | task | TK-001 | nothing |
Documents that can be attached at any stage: test plan and design document.
Outside the stages, defect IDs start at DEF-001 and ad-hoc unit IDs at AH-001. A reported defect's parent is the work it affects: a user story.
Gates: approve block, start block, done block, lock block (block stops the action, warn lets it go ahead with a warning, off skips the check).
A task's own test plan is recorded as it is saved, not approved.
```

### User stories, features and enhancements

The story stage holds three kinds. Features also need a design document, and the templates `templates/feature.md` and `templates/enhancement.md` are settled at setup. A defect someone reports can sit under a user story or a feature, set by `defect.parents`.

```yaml
format: 4
mode: full-sdlc
repos:
  - name: payments
process:
  chain:
    - type: idea
    - type: epic
    - type: story
      kinds:
        - type: feature
          prefix: FEAT
          requires: [test-plan, design]
        - type: enhancement
          prefix: EN
    - type: task
  defect:
    parents: [story, feature]
```

```text
| Stage | Kind | First ID | Requires before work under it starts |
|---|---|---|---|
| business idea | business idea | BI-01 | nothing |
| epic | epic | EP-01 | design document |
| user story | user story | US-001 | test plan |
|  | feature | FEAT-001 | test plan, design document |
|  | enhancement | EN-001 | test plan |
| task | task | TK-001 | nothing |
Documents that can be attached at any stage: test plan and design document.
Outside the stages, defect IDs start at DEF-001 and ad-hoc unit IDs at AH-001. A reported defect's parent is the work it affects: a user story or a feature.
Gates: approve block, start block, done block, lock block (block stops the action, warn lets it go ahead with a warning, off skips the check).
A task's own test plan is recorded as it is saved, not approved.

What each stage and kind the team added means:
- feature (FEAT-001, a kind of user story built as a user story is): tasks sit under features; a feature is approved before work on it or under it starts; it is finished with /bk:done once its work is done, or once the tasks under it are.
- enhancement (EN-001, a kind of user story built as a user story is): tasks sit under enhancements; an enhancement is approved before work on it or under it starts; it is finished with /bk:done once its work is done, or once the tasks under it are.
```

A kind's `requires` defaults to its stage's: enhancements need a test plan, as user stories do. A kind's folder is its type, such as `feature/FEAT-001/feature.md`, unless you set `dir`.

### An added stage, a document, and warning gates

A feature level between epics and stories, a security review required of every epic, and every gate but the lock gate on warn while the team tries BuildKeel out. Setup settles two templates: `templates/feature.md` and `templates/security-review.md`.

```yaml
format: 4
mode: full-sdlc
repos:
  - name: payments
process:
  chain:
    - type: idea
    - type: epic
      requires: [design, security-review]
    - type: feature
      prefix: FT
      dir: features
    - type: story
    - type: task
  documents:
    - type: security-review
      name: security review
      suffix: SR
  gates:
    approve: warn
    start: warn
    done: warn
    lock: block
```

```text
| Stage | Kind | First ID | Requires before work under it starts |
|---|---|---|---|
| business idea | business idea | BI-01 | nothing |
| epic | epic | EP-01 | design document, security review |
| feature (added) | feature | FT-001 | nothing |
| user story | user story | US-001 | test plan |
| task | task | TK-001 | nothing |
Documents that can be attached at any stage: test plan, design document and security review.
Outside the stages, defect IDs start at DEF-001 and ad-hoc unit IDs at AH-001. A reported defect's parent is the work it affects: a user story.
Gates: approve warn, start warn, done warn, lock block (block stops the action, warn lets it go ahead with a warning, off skips the check).
A task's own test plan is recorded as it is saved, not approved.

What each stage and kind the team added means:
- feature (FT-001): user stories sit under features; a feature is approved before work under it starts; it is finished with /bk:done once everything under it is done.
```

## Approval and locking

Approval turns a draft into an agreed version. Once a version is approved it is frozen: it never changes, and a change to the artifact becomes its next version. Work can only start on a unit whose requirements are approved. How to approve, one artifact or a whole plan, is on [Capture a plan](capture.md). This section explains what approval checks and writes, and what is locked afterwards.

### What is checked

Before an artifact can be approved:

- it has every field and section its template requires, every entry has its ID, and no entry reuses a removed entry's ID (see [Process: stages, kinds and documents](process-and-templates.md));
- its parent is approved. A story cannot be approved while its epic is a draft;
- it is written against its parent's current approved version. A draft written against `EP-01@v1` cannot be approved once `EP-01` v2 is approved: check it against v2 first;
- for a test plan, every `covers:` line names something the plan may cover, and a story's plan covers every acceptance criterion (see [Tests and traceability](test-plans.md)).

If any check fails, nothing is written, and every failing check is listed with what to do about it:

```text
Approval of US-draft-k3x9 refused by the approve gate: 1 check failed.
1. The parent epic EP-01 "Password reset" is still a draft.
   To fix: Approve EP-01 first with /bk:approve EP-01.
```

These checks stop an approval by default. A team can set the approve gate to `warn`, so approval goes ahead and the failing checks are shown, or `off`:

```yaml
process:
  gates:
    approve: warn
```

Ad-hoc units and defects found while building are not approved. A reported defect is approved like any draft, numbered in the defect sequence at its first approval. A task's own test plan is recorded as it is saved, not approved, unless your process approves task plans.

### What approval writes

Approving version 1 of `US-002` writes two files that are never changed afterwards:

- `stories/US-002/versions/v1.md`, a frozen copy of the version as approved;
- `stories/US-002/approvals/v1.yaml`, the approval record:

```yaml
artifact: US-002
version: 1
hash: sha256:9f2c4e…
approvedBy: Jane Doe <jane@example.com>
approvedAt: 2026-10-01T08:12:57Z
template:
  type: story
  version: 1
  source: built-in
parent: EP-01@v1
draftId: US-draft-k3x9
```

| Field | Meaning |
|---|---|
| `artifact`, `version` | What was approved. |
| `hash` | The SHA-256 of the frozen copy, with line endings normalized. Validation compares the frozen copy against it. |
| `approvedBy` | The git identity (`user.name` and `user.email`) set for the spec repo. Approval is refused when none is set. |
| `approvedAt` | When, in UTC. |
| `template` | The template the artifact was checked against: its type, its version, and whether it came from the spec tree's `templates/` folder (`tree`), the organization's templates (`org`, with `org` naming the source and the version pinned, such as `git@github.com:acme/buildkeel-templates.git@v1.0.0`; see [Templates](templates.md)), or BuildKeel (`built-in`). Not present for version 0, which is held to no template. |
| `onboarded` | `true` for version 0: it describes code as it was before BuildKeel. |
| `baseline` | For version 0: the baseline commit of each code repository in `buildkeel.yaml`, the code it describes. |
| `sources` | For version 0: the hash of each source kept beside it, by its file name in `sources/`. Validation compares each source against it. |
| `empty` | For version 0: the sections its template asks for that it leaves empty, for a later version to fill in. |
| `completes` | For a version that only completes the one before it with what version 0 describes, or fills in what version 0 left empty: the version it completes. Nothing built against that version becomes suspect (see [When a requirement changes](change-impact.md)). |
| `parent` | The parent and the version it was approved against. Not present for a business idea. |
| `pins` | For the test plan of an epic or a business idea: the version of each story or epic its test cases cover, as approved at the time. A later version that changes what a test case covers makes that test case suspect. Not present otherwise. |
| `related` | For an artifact that names related artifacts, such as `related: [EP-01]` in a new epic: the version of each in force when it was approved. A tracked change to either side then makes the other suspect. Not present otherwise. |
| `changes` | For an artifact whose work changes a document, such as `changes: [EP-01-DD]`: the version of the document in force when it was approved. The artifact cannot be finished until a newer version of the document is approved. Not present otherwise. |
| `draftId` | The draft ID the artifact had before its first approval. |

Because versions and approvals are files, squashing or rebasing the spec repo's history never loses them.

### Permanent numbers

An artifact gets its permanent ID, such as `US-002`, when it is first approved. BuildKeel renames its directory from the draft ID and rewrites every reference to the draft ID in the spec tree's drafts: parent links, `covers:` lines and entry IDs such as `US-draft-k3x9-AC1`. A draft whose parent is the artifact being approved is tied to the new version, such as `US-002@v1`. Documents attached to an artifact have no number of their own: the test plan of `US-002` is `US-002-TP`, and the design document of `EP-02` is `EP-02-DD`. Each type counts on its own: the first epic is `EP-01` and the first story `US-001`. The numbers come from the counter; see [The counter](spec-tree.md#the-counter).

When the remote cannot be reached, the approval is still recorded, with the number pending:

- `approvals/v1-pending.yaml` records who approved it, when, and the hash of what was approved, and it is committed as `approve: US-draft-k3x9 v1 (number pending)`;
- the artifact shows as "approved, number pending" in `/bk:status`;
- it cannot be changed, its children cannot be approved, and work cannot start on it until it has its number.

The number is assigned the next time the remote can be reached: at the next approval or the next session. The directory is renamed, references are rewritten, the frozen copy and `approvals/v1.yaml` are written with the original approver and time, and it is committed as `approve: US-002 v1`. The pending record stays as history.

### Version 0

Most teams set BuildKeel up on code that already exists. What describes that code is **version 0** of its artifact; anything made in BuildKeel starts at version 1. How to draft it is on [Start on existing code](onboarding.md). Its draft is `onboard.md`, beside the working file. Approving version 0 checks only that its parent is approved, at any version, and that it leaves no question open: a question nobody could answer yet, between two sources that disagree, keeps it a draft until someone answers it. It is not held to the template or to the documents the process requires: a section nobody knows can stay empty, and the approval record lists it for a later version to fill in.

```text
Ready to approve version 0 of user story US-draft-k3x9 "Password reset": it describes the code as it was before BuildKeel, so it is held to no template; a person reads it before it is approved. Approving will:
- give it its permanent number: the next onboarded user story number, US-E001 unless someone else approves one first; its directory becomes stories/US-E001/
- record it against its parent EP-01@v1
- freeze v0 and record the approval by Jane Doe <jane@example.com>, with its source frozen with it: jira-PAY-12.md
- record what it leaves empty, for a later version to fill in: Story
- commit only those files in the spec repo as "approve: US-E001 v0", without pushing
```

Once approved, version 0 is in force like any version, and `onboard.md` is gone: the frozen copy `versions/v0.md` holds it. It counts as approved when work starts under it, and as done when its parent is finished, since its code already exists. A change to it opens version 1, which is held to the template, the gates and change impact like any other version.

- **Onboarded numbers.** An artifact first approved as version 0 is numbered in its type's onboarded sequence: its prefix, a letter, then the number, such as `US-E001`, `EP-E01` or `DEF-E001`. New work keeps the normal sequence, so the next story approved as version 1 is `US-002`. The letter is `E` unless the process sets another, such as `process: { onboarded: { letter: H } }`. An ID never changes: version 0 added later to `US-005` leaves it `US-005`.
- **Version 0 under a later version.** An artifact already approved in BuildKeel can get its version 0 later, describing the code as it was at the baseline, named with `@v0`: `/bk:approve US-005@v0`. The version in force stays as it is; version 0 comes before it in the history, and nothing becomes suspect. An artifact has one version 0 at most. When the version in force leaves out behavior that version 0 describes, the next version brings the two together, and says that it only completes the version in force (`completes` in its record).
- **Version 0 and its change in one review.** When work changes code that nothing describes yet, its plan can hold version 0 of what the code does today and the change as version 1 of the same artifact: `/bk:approve US-draft-k3x9@v0 US-draft-k3x9` approves version 0 first, and each gets its own approval record and commit: `approve: US-E001 v0`, then `approve: US-E001 v1`. A reported defect in code nothing describes is approved the same way: version 0 of the story it touches, then the defect under it, version 0 first.
- **Sources kept with version 0.** Each source a version 0 is drafted from is kept beside it in `sources/`, one file per source, exactly as it was read: for an issue tracker entry, its description, fields and comments. Attachments, images and history stay behind its link, and only what your tool returned is kept. Code is never copied: the baseline commit in the approval record names it. BuildKeel lists the sources in a Sources section at the end of version 0, with their links. Until version 0 is approved, a source can be read again, replacing the earlier copy, or dropped. Approval freezes them: their hashes go into the approval record, the agent cannot edit them, and validation reports a source that was changed or added afterwards.

```text
---
source: Jira
key: PAY-12
link: https://acme.atlassian.net/browse/PAY-12
readAt: 2026-10-03T09:14:00Z
readBy: Jane Doe <jane@example.com>
---

Summary: Reset links
Description: Links last an hour.
Comment (Ana): agreed.
```

The approval record of version 0:

```yaml
artifact: US-E001
version: 0
hash: sha256:4d1a7b…
approvedBy: Jane Doe <jane@example.com>
approvedAt: 2026-10-03T09:20:41Z
onboarded: true
baseline:
  payments-api: 4f2a9c1
sources:
  jira-PAY-12.md: sha256:a83c02…
empty:
  - Story
parent: EP-01@v1
draftId: US-draft-k3x9
```

### Commits and pushing

Each approval is one commit in the spec repo, `approve: US-002 v1`, holding only that approval's files. Anything else you have changed or staged in the spec repo stays out of it. If the spec tree is a folder of your code repository, the commit is made on the branch you have checked out. On a unit's branch, such as `bk/TK-001-…` after finishing that unit, Claude tells you so before and after approving: units started from your main branch do not see the approval until that branch is merged into it. Switch to your main branch first to have the approval there straight away.

Pushing is up to you: after each approval Claude tells you how many approvals are not pushed yet. To push every approval as soon as it is committed, set this in `buildkeel.yaml`:

```yaml
settings:
  autoPush: true
```

If an automatic push is refused, for example because the remote has commits you do not have, the approval is kept and you are told why. Where your spec repo's main branch only accepts pull requests, approval commits travel in a pull request like any other change.

An approved version is never changed in place. Asking Claude for a change saves the next version as a draft (`Saved US-002 v2 as a draft at stories/US-002/story.md. v1 stays approved and in force until v2 is approved.`), and the working file holds v2 while `versions/v1.md` is untouched. This holds even when v1 was approved minutes ago and nothing is built on it, so anyone who built on it is told through suspects. Discarding a draft never changes an approved version or its records; when any of the draft was committed, the discard is committed as `discard: <ID>`, with your reason. See [Capture a plan](capture.md).

### Locked files

The agent cannot edit, in Claude Code:

- frozen copies in `versions/`;
- approval records in `approvals/`, and the completion and re-pin records BuildKeel writes later;
- the sources kept with an approved version 0, in `sources/`;
- the file of an approved artifact that has no new version open, or whose number is pending.

An attempt is blocked, and the agent is told to save a new version instead. This is the lock gate. Edits made with other tools are not prevented. They are detected: ask Claude to validate the spec tree.

### Validating the spec tree

Ask Claude to "validate the spec tree". It checks every artifact against its template, every link between artifacts, duplicate IDs and numbers (for example after a merge), duplicate or missing versions, and every frozen copy, and every source kept with a version 0, against the hash in its approval record:

```text
Found 1 problem:
- US-001 v1 was altered after approval: stories/US-001/versions/v1.md no longer matches the hash in stories/US-001/approvals/v1.yaml.
  To fix: Restore stories/US-001/versions/v1.md from git history. To change US-001, save a new version as a draft and approve it.
```

Validation never changes anything.

**More:** [Capture a plan](capture.md), [The spec tree and its artifacts](spec-tree.md), [Records and the audit trail](records.md), [Process: stages, kinds and documents](process-and-templates.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-approve`.
