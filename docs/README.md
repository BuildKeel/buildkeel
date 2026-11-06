# BuildKeel documentation

User documentation, kept beside the code it describes.

## Get started

- [Install in Claude Code](install-claude-code.md): what you need, installing for you or for a repository, updating and removing, and checking that it works.
- [Install in Antigravity](install-antigravity.md): what you need, installing for every project or for one, updating and removing, installing without npm, and checking that it works.
- [Getting started](getting-started.md): setting up a repository with /bk:init, what it adds, and a first piece of work from a conversation to finished code.
- [What BuildKeel does](what-buildkeel-does.md): every feature, the core ones first, then those you can switch, each by mode, with the key features marked.

## Spec-driven vs Full SDLC

- [The two modes](modes.md): what each mode holds, setting the mode when a spec tree is created, one mode per tree, and moving a tree to Full SDLC.
- [Choosing a mode](comparing-modes.md): which mode to choose, the two side by side, the same piece of work in each, and moving to Full SDLC.
- [Setting up a Spec-driven tree](setting-up-spec-driven.md): every question /bk:init asks, in order, with what each answer does: the folder check, where the tree lives, stamping commits, numbering with examples, templates and rules, the guide for a first change, and the settings setup leaves at their defaults.
- [Setting up a Full SDLC tree](setting-up-full-sdlc.md): every question /bk:init asks, in order, with what each answer does: stages, kinds within a stage, ID prefixes, documents, task test plans, gates and templates, the settings setup leaves at their defaults (checks on tests, reviews, agents, Threads and the read-only copy), ending with three complete processes and their buildkeel.yaml.
- [How Spec-driven mode works](how-spec-driven-works.md): one change followed from a conversation to the capability's next version: building task by task, a defect found while building, behavior questioned while building, finishing, and reported problems sorted into defects and changes in behavior.
- [How Full SDLC mode works](how-full-sdlc-works.md): one piece of work from a business idea down to a finished task: approving the plan, the start gate, building, a defect found while building, behavior questioned while building and the pause for approval, the done gate, the work above it, a reported defect and its approval, and a defect in code nothing describes.

## Plan the work

- [Capability specs](capability-specs.md): in a Spec-driven tree, how the system behaves now: the format, requirement and scenario IDs, versions written by finishing a change, and what BuildKeel checks.
- [Changes](changes.md): in a Spec-driven tree, a change's proposal, spec changes, design and tasks, editing an open change, and what BuildKeel checks.
- [Exploring and capturing](exploring-and-capturing.md): structured exploring, keeping an exploration as a thread, recovering one left unsaved, spikes, and what /bk:capture adds: the summary with your words kept apart, approaches recorded, edge-case suggestions, design options and the readiness check.
- [Drafting with Claude](drafting.md): turning a conversation into a plan with /bk:capture, drafting artifacts and breakdowns with /bk:new, bringing your own material, draft IDs, and what is still missing.
- [Approving artifacts](approval.md): approving with /bk:approve, a whole plan in one review, permanent numbers, approval records and commits, changing an approved artifact, locked files and validation.
- [Test plans and coverage](test-plans.md): test plans at every level, test case IDs, what is checked, gaps, the coverage view, and which test cases apply to a task.

## Build the work

- [Working on a unit](working-on-a-unit.md): starting and building a unit with /bk:build, Build-ready tasks and backfilling them, the Plan check, the Built line, building everything ready, what must be true, its branch and claim, the context Claude receives, sessions, freshness and working on several units at once.
- [Finishing a unit](finishing-a-unit.md): commit lines and test tags, recording test results, finishing with /bk:done, what must be true, what it built and the checks on its tests, commits without a unit line, the completion record, the next unit, and finishing a story or an epic.
- [Building with agents](building-with-agents.md): building each task in a fresh agent or here, and which comes first, what an agent is given, its statuses, questions and rulings, what a task uses checked as the run reaches it, parallel runs in worktrees and merging them, setting models and effort for each role and what Antigravity ignores, when agents can't be started, and picking up a run again.
- [Reviews](reviews.md): the three fresh reviewers and turning each off, what a review is given, severities and verdicts, recording and answering findings, the fix loop and Principal handoff, /bk:review, what /bk:done reviews, the done gate's review-findings check, and reviews when agents can't be started.
- [Decision records](decision-records.md): rulings, answers to review findings and the decisions in the working notes, each with its source or evidence: where they are kept, what the completion record holds, and finding them again.
- [Pausing and resuming](pausing-and-resuming.md): pausing a unit or change with /bk:pause, keeping an exploration as a thread, working notes and how they are checked, resuming with /bk:resume on any machine, a teammate taking over, Heads-up notes, and what stays on your machine.
- [TDD](tdd.md): red then green, how BuildKeel tells from git, stated exceptions, the red check and the revert check, the test-file diff, mutation testing, and turning TDD and the checks on tests on or off.
- [Changed-line coverage](changed-line-coverage.md): the lines a unit changed that no test ran: giving BuildKeel an lcov or Cobertura report, producing one, which lines count and how paths are matched, what finishing shows, and turning it off.
- [Defects and ad-hoc units](defects-and-adhoc.md): changes with nothing started, ad-hoc units through /bk:build, a defect or a change in behavior, defects found while building and reported defects, regression tests, closing without a fix, open defects, finding the work a reported defect affects, defects in a Spec-driven tree, and IDs given offline.

## Change and track

- [Change impact](change-impact.md): what a new version makes suspect, previewing it before approval, where suspects show, reviewing them with /bk:impact, and re-pin records.
- [The status overview](status.md): /bk:status, what each section shows, the Learning loop, claims and releasing them, commits with no unit after the baseline, and files changed outside BuildKeel.
- [Your usage](usage-stats.md): /bk:stats, what is recorded on your machine, and turning it off, deleting or exporting it. Nothing is sent anywhere.

## Existing code

- [Documenting existing code](onboarding.md): where existing code ends (the line is /bk:init), code from before BuildKeel, documented as work touches it or area by area with /bk:onboard; version 0, kept sources, onboarded numbers, finished work and old commits, existing tests, and filling in later.

## Team knowledge

- [The glossary, practices and ADRs](glossary-practices-adrs.md): the team's terms and how they are checked, BuildKeel's default practices and the team's own, architecture decision records in each mode, and the read-only copy in your code repository.

## Set up and maintain

- [Settings](settings.md): every feature switch with its values and default, personal settings, what turning a feature off or on does, and the switches each record notes.
- [The spec tree](spec-tree.md): where BuildKeel keeps your plan, the pointer file in each code repository, teams on both hosts, and format versions.
- [Process and templates](process-and-templates.md): seeing your settings at any time with /bk:settings and changing them, the default process, documents attached to a stage and which each stage requires, the design document, setting up the process, renaming and adding stages, kinds within a stage, ID prefixes, gate modes, templates and what BuildKeel checks before approval.
- [Organization templates](organization-templates.md): templates and a process shared across teams from a repository of their own, pinned to a version.
- [Migrating a spec tree](migration.md): moving a Spec-driven tree to Full SDLC with /bk:migrate, and upgrading a spec tree in an older format.

## Reference

- [Commands](commands.md): every command, what you can type, what it asks, and how it behaves in each mode.
- [Known limits](known-limits.md): commit IDs after a rebase or an amend, a finished unit whose code is not pushed, claims kept on one machine, and what tags in test names can and cannot tell.
