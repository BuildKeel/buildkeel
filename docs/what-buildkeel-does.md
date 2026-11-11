# Features

Every BuildKeel feature, in each mode, with the key ones marked ★. Core features are always on, and each additional feature can be switched.

## How this page is laid out

The page has two parts:

1. **Core features** are always on.
2. **Additional features** are on by default, or offered, and each can be switched. Each gives its setting and default. [Feature switches](settings.md) lists them all.

Each part starts with what works the same in both modes, then what is Full SDLC only and Spec-driven only. Features marked ★ are the key ones. For the two modes, see [Choose a mode](modes.md).

## Core features

### In both modes

#### Conversation

- **Conversation comes first.** Until you run a command, or Claude is about to change a file, Claude talks as it would without BuildKeel: no stages, IDs or commands, beyond one offer to capture when the discussion has reached a point. It checks facts in the code before asking, and lays out options for a design choice. See [Talk it through and explore](exploring.md).
- **Reviews in the conversation.** Anything you are asked to agree, such as a summary, a plan, a document or what finishing will write, is shown in full in the reply. Agreement saves it. Anything else is feedback, answered point by point, with the final version shown before saving.
- **One topic at a time.** Setup, migration and onboarding ask one topic per message, with the default first. They assume nothing you did not say, and show everything before writing.
- **Commands only you start.** Claude runs only the commands that read (`/bk:status`, `/bk:settings`, `/bk:stats`) on its own. Every other command waits for you to type it. Claude Code enforces this; in Antigravity, Claude is told the rule. See [Commands](commands.md).
- **Ticks reported, not asked.** A task is ticked when its check passes, and Claude says so in a line, without asking.
- **Reminders to finish.** A reminder to run `/bk:done` when the work looks finished, or after a push, a pull request or a merge while a unit is active. It never blocks.
- **Freshness warnings.** The spec tree's remote is fetched in the background, and you are warned when the tree is behind as you start, approve or finish work. See [Build](working-on-a-unit.md).
- **A guided first change.** In a Spec-driven tree, a person who chooses it at setup gets a line or two at each step of their first change, saying what happened and what comes next.

#### Planning

- **Capture from conversation.** `/bk:capture` sums up what was discussed, with the pitfalls raised, then proposes what to draft. Each document is agreed before it is saved. It can also revise an open change. See [Capture a plan](capture.md).
- **Gaps decided by you.** When a draft needs something the conversation never settled, Claude names the gap rather than filling it in, and you choose: put it in as stated, keep it as an open question, work it out now, or leave it out.
- **Approaches recorded.** The design document or proposal records the options weighed, the one chosen and why, the non-goals and what to avoid. Nothing the conversation did not raise is added.

#### Building

- **Units of work and claims.** Work happens in units: a task, story, change, defect or ad-hoc unit. Each working tree has one active unit on its own branch, and a claim stops another working tree on the machine from starting the same one. See [Build](working-on-a-unit.md).
- **The code-edit gate.** When Claude is about to change code with no active unit, it stops and offers to capture, build the unit the change belongs to, record an ad-hoc unit, or, only if you choose, go ahead without one.
- **Scope drift warning.** While a unit is active, BuildKeel warns when edits go into areas the unit, its story and the work beside it do not relate to. See [Build](working-on-a-unit.md).
- **Build runs.** `/bk:build` shows what it would build and how each task is checked, then builds all of it, the next task only, or sets up to work together. A run stops on a failing test it cannot fix, an unclear requirement or a needed spec change. It keeps no progress file, so it carries on after compaction or on another machine.
- **Questions and rulings.** When a building agent asks a question, Claude answers from the spec, the working notes, the glossary or the practices, names the source, and keeps the answer as a ruling every later agent is given. When nothing answers it, the run stops and you decide. See [Build](working-on-a-unit.md).
- **Behavior questioned while building.** When agreed behavior looks wrong, Claude stops and asks. If you change it, every artifact it lives in is updated first, then the build goes on.
- **Models and effort per role.** Each agent role runs on a tier, a model and an effort per host, or inherits the session's. See [Models and effort per role](models.md).

#### Testing

- ★ **Requirement traceability.** A test carries the ID of the requirement it checks in its name, such as `[US-012-TC3]` or `[AUTH-R3-S1]`. BuildKeel reads JUnit XML reports and shows each test case or scenario as passed, failed or not run. Gates, TDD, gaps and reviews all read results this way. See [Finish](finishing-a-unit.md).
- **Gap detection.** Every acceptance criterion no test case covers, and every scenario with no tagged test, is reported. In Full SDLC, gaps block approving a test plan and starting the unit while those gates block. See [Tests and traceability](test-plans.md).
- **Stale results.** A passing result stops counting once the test plan or the code changes after the run.

#### Review

- **Final review at finish.** `/bk:done` reviews the work with fresh agents, by whichever reviewers are on. It reviews nothing twice, but always checks spec compliance. A review by the author never counts as independent. See [Reviews and the fix loop](reviews.md).
- **The fix loop.** In a run, an open High or Medium finding stops its task. After a fix, the review runs again on the fix. See [Reviews and the fix loop](reviews.md).
- **`/bk:review` on demand.** A review of the active unit, a named unit or change, or a range of commits, at any time.
- **Spec additions proposed.** Behavior the spec says nothing about, but a user would expect, is raised as a proposed addition, never as a failure. You decide whether it goes in.
- ★ **Decision records.** Every decision is recorded with its source or evidence: rulings on a building agent's questions, from the spec or from you; the answer to each review finding (fixed with its commit, parked with its ID, or rejected with evidence); and decisions in the working notes, with why. A requirement is never guessed, and no finding is silently dropped. See [Records and the audit trail](records.md).

#### Finishing

- ★ **Completion records.** Finishing writes a permanent record: the versions the unit was built against, its branch and commits, the files changed, the test results and TDD evidence, every review finding and its answer, who finished it and when, and a context part with the decisions, departures from the plan, dead ends and notes for the next person. See [Records and the audit trail](records.md).
- **Preview before writing.** Approving and finishing show what they will write first, and write only what was previewed.
- **Change impact and suspects.** When something changes, only what depended on it becomes suspect, and each suspect is decided as still valid or needs change, with a record. See [When a requirement changes](change-impact.md).
- **The lock gate.** Claude cannot edit approved versions, archived changes or records directly; only BuildKeel's own operations write them. Changes made outside Claude are detected and reported.
- **Unattributed commits reviewed.** Before finishing, commits on the unit's branch without a unit line are listed, to keep or leave out. History is never rewritten.
- **Pull request lookup.** Where the repository is on GitHub and GitHub's CLI is installed, the completion record names the pull requests holding the unit's commits.

#### Defects

- **Defects as units.** A defect is a unit of its own kind, built and finished like any other work. One found while building is linked to the unit and the test that found it. See [Small fixes, defects and spikes](defects-and-adhoc.md).
- **Report sorting.** Before a reported defect is saved, Claude checks it against the spec and the code, and proposes a defect, a change in behavior, a gap in the spec, or code nothing describes. You confirm or override.
- **Regression tests.** Finishing a defect needs a test tagged with its ID in Full SDLC; in a Spec-driven tree, finishing reminds you.
- **Closing without a fix.** A defect can be closed with a reason, such as a duplicate or one that cannot be reproduced, confirmed with you and recorded.

#### Existing code

- **Version 0 and the baseline.** The line is `/bk:init`: code up to each repository's baseline commit is existing code, documented as version 0 and never reported as untracked. See [Start on existing code](onboarding.md).
- **Guided onboarding.** `/bk:onboard` proposes a map of the code's areas, then drafts one area at a time from the code and the sources you bring. It runs any time after setup, and you can stop after any area. See [Start on existing code](onboarding.md).
- **Documenting as work touches it.** When planned work changes behavior nothing describes, the plan first describes only what the work touches, as version 0.
- **Existing tests matched.** Onboarding matches existing tests to test cases without renaming them.

#### Continuity

- **Working notes and checkpoints.** At each checkpoint and pause, BuildKeel saves the notes since the last one: decisions, rulings, constraints, dead ends, open questions and the next step, each with a source that is checked. See [Working notes and threads](working-notes.md).
- **Pause and resume.** `/bk:pause` records where things stand, and `/bk:resume` picks it up again with a brief, in a new session or on another machine. See [Pause, resume and hand over](pausing-and-resuming.md).
- **Teammate handover.** A teammate can resume someone else's paused work once they confirm; the handover is recorded.
- **Recovery when you forget to pause.** After compaction, or at the next session, an exploration that was never saved can be rebuilt from its transcript.
- **Looking back.** Ask why the code is the way it is, and Claude searches the working notes, threads and completion records, by ID, file or text. See [Ask why the code is the way it is](looking-back.md).

#### Knowledge

- ★ **The team playbook.** A glossary of terms, changed by agreement in conversation; terms challenged as you talk, when one is used against the glossary or the code, or is vague, with one precise term proposed; terms to avoid flagged when specs are saved; and practices: BuildKeel's defaults plus the team's own, read by every reviewer and planning check. They are copied into each code repository, read-only, for tools and people without BuildKeel. See [The playbook](glossary-practices-adrs.md).
- ★ **ADRs.** An architecture decision record, offered only for a decision that is hard to reverse, surprising without its context, and the result of a real trade-off. It is replaced by a newer ADR, never edited.

#### Setup

- **Setup with `/bk:init`.** Where the spec tree lives, the mode, and stamping your own commits; then the process for Full SDLC, or the numbering for Spec-driven. Everything is shown before writing. See [Your first change](getting-started.md).
- **Templates and organization templates.** Every artifact type has a template, from the tree, a pinned organization source, or the built-in defaults. See [Templates](templates.md).
- **`/bk:settings` and `/bk:status`.** How the repository is set up, including every switch, and where everything stands. See [Status and usage](status.md).

#### Platform

- **Plain files you own.** The spec tree is markdown files in a git repository or folder. Every record is a new file, so branches merge without conflict. See [The spec tree and its artifacts](spec-tree.md).
- **Two hosts.** Claude Code and Antigravity, with the same tools, records and commands. Teams can mix hosts on one tree. See [The spec tree and its artifacts](spec-tree.md).
- **Data stays in your repositories.** No artifact content, code or usage is sent to any service. The only network calls are git against your remotes and optional GitHub CLI lookups.

### Full SDLC only

- **Your process.** A chain of stages, by default business idea, epic, story and task, which your team can rename, add to or skip, with kinds within a stage and the documents each requires. Test plans can sit at every level, end-to-end for a business idea down to the task, and each test case declares the criteria it covers, so change impact makes suspect only the tests a change touches. See [Process: stages, kinds and documents](process-and-templates.md).
- **Approval and locked versions.** An artifact is approved in the session, with a record of who approved which version and when, and then locked: a change makes a new version. A draft you will not go on with is discarded, with the drafts under it. See [Capture a plan](capture.md).
- **Gates and their modes.** The approve, start and done gates check approvals before work starts and evidence before it finishes. Each blocks, warns or is off, and explains every failing check. See [Process: stages, kinds and documents](process-and-templates.md).
- **Finding the work a defect affects.** When a reported defect's parent is not known, BuildKeel offers the units whose commits changed the code involved.

### Spec-driven only

- **Capability specs and changes.** Lasting requirements with WHEN/THEN scenarios, and each piece of work as a change, with no approvals or gates. See [The spec tree and its artifacts](spec-tree.md).
- **Archiving and overlapping changes.** Finishing a change merges its spec changes into the capability specs and versions them. Two changes to the same requirement are shown side by side for you to resolve.
- **Keeping a change consistent.** Editing one file of an open change makes Claude check the others and propose follow-on edits.
- **A follow-up change for what is left.** Finishing a change with unticked tasks or gaps offers a new change holding them.
- **Linking a standalone defect.** A defect linked to no requirement is offered the requirements its changed files implement.
- **Moving to Full SDLC.** `/bk:migrate` converts the tree, area by area. See [Move to Full SDLC, or upgrade a tree](migration.md).

## Additional features

### In both modes

#### Planning

- **Structured exploring.** When you ask to explore an idea, Claude plays back its understanding with your words kept apart from its proposals, and offers two or three approaches with a recommendation. `planning.exploring`, on by default. See [Talk it through and explore](exploring.md).
- **Design options.** For an interface three or more tasks would share, or one that crosses repositories, fresh agents each propose a design from a different angle, and one is recommended. `planning.design-options`, ask by default, with 2 designers. See [Capture a plan](capture.md).
- **The readiness check.** For larger work, fresh agents read the agreed plan as the people who will build, test and run it, and list their questions, settled before building starts. `planning.readiness`, ask by default, with 1 reader.
- **Edge-case suggestions.** When a test plan or a change's scenarios are drafted, a fresh agent proposes up to five missing cases, ranked by risk. You answer once. `planning.edge-cases`, auto by default.
- **Build-ready tasks.** Every task names its Files, what it Uses and Delivers, and its Verify command, and records what it actually delivered in its Built line. A fresh agent can build a task alone, and the order of work is worked out. As a run reaches each task, what it uses is checked against what the earlier tasks actually built, the files named and the project's dependencies, and a task whose foundation is missing never starts. `planning.build-ready-tasks`, on by default. See [Build](working-on-a-unit.md).
- **The Plan check.** When tasks are saved, BuildKeel checks what each uses, the files named, coverage, vague lines and loops, and reports without blocking. `planning.plan-check`, on by default.
- **Spikes.** Throwaway code on its own `spike/<name>` branch, without tests or a unit. BuildKeel never merges or deletes the branch, and what it showed is offered as working notes. `planning.spikes`, on by default. See [Small fixes, defects and spikes](defects-and-adhoc.md).

#### Building

- **A fresh agent per task.** Each task is built by a new agent given only its task's context, what earlier tasks built, and the decisions so far, so late tasks are built as carefully as early ones. `runs.build`, fresh-agents by default; the other choice is always offered. See [Build](working-on-a-unit.md).
- ★ **Principal handoff.** When fix rounds do not clear a review finding, the implementer runs again on a stronger tier, like stuck work handed to a principal engineer. If that fails too, the run stops with the whole story, and the task is never finished with the finding open. `agents.handoff`, the principal tier after 2 failed rounds by default. See [Reviews and the fix loop](reviews.md).

#### Testing

- ★ **TDD.** Red then green, recorded from git and the test reports; the revert check, which shows the tests fail without the unit's code; and the test-file diff, which reports tests weakened to pass. `gates.tdd`, warn by default, in Full SDLC; `checks.tdd`, reported by default, in Spec-driven. See [TDD evidence](tdd.md).
- **Changed-line coverage.** Each line the unit changed that no test ran, from an lcov or Cobertura report. `checks.coverage`, on by default. See [Tests and traceability](test-plans.md).
- **Mutation testing.** Your team's mutation tool, run on the changed lines, with each surviving mutant reported. `checks.mutation`, off until you give its command. See [TDD evidence](tdd.md).

#### Review

- ★ **Review by three fresh agents.** Spec compliance, judging each requirement met, partly met or not met with evidence; code quality, with findings rated High, Medium or Low; and break-it, which tries to make the code fail with tests. None of them sees the session that wrote the code. `reviews.spec-compliance`, `reviews.code-quality` and `reviews.break-it`, each on by default. See [Reviews and the fix loop](reviews.md).
- **Review after each task.** In a run, each task is reviewed before the next starts. `reviews.each-task`, on by default.

#### Continuity

- **Threads.** A pause with nothing active saves the exploration as a thread, such as `TH-004 "Reset by text message"`, with the idea, the approaches, the decisions and your words. `continuity.threads`, ask by default. See [Working notes and threads](working-notes.md).
- ★ **Heads-up notes.** Starting a unit shows up to five notes earlier work left on the files it will change. `continuity.heads-up`, on by default. See [Notes on the code](heads-up-notes.md).
- ★ **The Learning loop.** At finish and in status, BuildKeel looks for review findings that keep coming back, files that keep getting defects, repeated gate failures or weakened tests, reversed decisions, and failed principal handoffs, and proposes a practice or a note on the code. `continuity.learning-loop`, on by default. See [The Learning loop](learning-loop.md).

#### Setup

- **Stamping your own commits.** A git hook adds the active unit's line to commits you make by hand. On by default; setup asks, and Claude turns it off or on when you ask. See [Feature switches](settings.md).
- **Usage stats.** A record on your own machine of what BuildKeel caught for you, summarized by `/bk:stats`. On by default; `/bk:stats off` turns it off. See [Status and usage](status.md).

### Full SDLC only

- **Parallel runs.** Independent tasks built at the same time, each in its own worktree, then merged one after another with the tests run again. `runs.parallel`, 3 by default; 1 turns it off. See [Build](working-on-a-unit.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-capture`.
