# BuildKeel documentation

User documentation, kept beside the code it describes.

## Get started

- [Install](install.md): installing in Claude Code or Antigravity, for one project only or without npm, checking it works, updating and removing, and what to do when something goes wrong.
- [Your first change](getting-started.md): setting up a repository with /bk:init, what each question means, the files it adds, checking the result, and a first piece of work in each mode.
- [Choose a mode](modes.md): which mode to choose, what each holds, the two side by side, the same work in each, setting the mode, one mode per tree, and moving to Full SDLC.
- [Start on existing code](onboarding.md): documenting existing code as work touches it or area by area with /bk:onboard, the baseline, version 0, kept sources, onboarded numbers, finished work and old commits, existing tests, and filling in later.

## Do the work

- [Talk it through and explore](exploring.md): talking an idea through with Claude first, asking for structured exploring, what Claude plays back, and when to capture, pause or spike.
- [Capture a plan](capture.md): turning a conversation into a plan with /bk:capture, drafting artifacts, breakdowns and your own material with /bk:new, approving a plan in Full SDLC, changing what you captured, and what capture adds: approaches, edge cases, design options and the readiness check.
- [Build](working-on-a-unit.md): starting a unit with /bk:build, building in fresh agents or here, following a run with its questions and rulings, parallel runs, picking a run up again, what must be true to start, Build-ready tasks with the Plan check and the Built line, and the context Claude and each agent receive.
- [Finish](finishing-a-unit.md): committing with the unit line and tagging tests, recording test results, running /bk:done and its preview, the next unit, finishing a story or an epic, the done gate, the completion record field by field, and finishing a change.
- [Small fixes, defects and spikes](defects-and-adhoc.md): small fixes as ad-hoc units, recording defects found while building or reported, fixing them with a regression test, closing one without a fix, and spikes for throwaway work.
- [Pause, resume and hand over](pausing-and-resuming.md): pausing a unit or change with /bk:pause, resuming it on any machine with /bk:resume, handing work to a teammate, and what stays on your machine.

## Checks and reviews

- [Tests and traceability](test-plans.md): tagging tests with test case IDs, recording results, coverage and gaps, matching existing tests, test plans at every level, and changed-line coverage from an lcov or Cobertura report.
- [TDD evidence](tdd.md): turning TDD on, working red then green, stating an exception, reading the evidence at finishing, the red and revert checks, the test-file diff, mutation testing, and the switches for each.
- [Reviews and the fix loop](reviews.md): the three fresh reviewers, reviews at /bk:done and with /bk:review, answering findings, the fix loop and Principal handoff, turning reviewers off, and the done gate's review-findings check.
- [When a requirement changes](change-impact.md): previewing what a new version makes suspect, reviewing suspects with /bk:impact and deciding each, what makes something suspect, where suspects show, and re-pin records.

## Team memory

- [The playbook](glossary-practices-adrs.md): agreeing a term, adding or switching off a practice, recording an ADR, how terms are checked, BuildKeel's default practices, ADRs in each mode, and the read-only copy in each code repository.
- [Notes on the code](heads-up-notes.md): leaving a note on the code, the Heads-up notes a unit gets when it starts, turning them on or off, what a note holds, which are shown and when one stops showing.
- [Working notes and threads](working-notes.md): the working notes kept at each checkpoint and pause, keeping an exploration as a thread, recovering one left unsaved, capturing or dropping a thread, and how sources are checked.
- [Ask why the code is the way it is](looking-back.md): asking Claude why, by ID, file or text, reading the answer and its sources, and what it searches.
- [The Learning loop](learning-loop.md): seeing what it proposes in /bk:status and at finish, accepting or declining a proposal, turning it on or off, the patterns it looks for, and where it speaks.

## Configure

- [Change your configuration](configuration.md): seeing the setup with /bk:settings, changing the process, templates and feature switches in buildkeel.yaml, every switch with its default, and sharing changes with the team.
- [Process: stages, kinds and documents](process-and-templates.md): setting up the process, changing it later, the default chain, the documents a stage requires, the design document, stages, kinds and ID prefixes, gate modes and task plans, and what is checked before approval.
- [Templates](templates.md): replacing a template, adding one for a new stage, kind or document, rules per type, organization templates pinned to a version with local overrides and upgrades, and how a template is built.
- [Feature switches](settings.md): every switch with its values, default and mode, what each does, personal settings, turning a feature off or on, and the switches each record notes.
- [Models and effort per role](models.md): the ten roles, tiers, giving a role a tier, Principal handoff, and what Antigravity ignores.
- [Move to Full SDLC, or upgrade a tree](migration.md): upgrading a tree in an older format, the area-by-area move to Full SDLC with /bk:migrate, and what holds after the switch.

## How it is organised

- [The spec tree and its artifacts](spec-tree.md): where the plan lives, the record folders beside each artifact, IDs and the number counter, buildkeel.yaml and the pointer file, teams on both hosts, format versions, and the format of capability specs and changes.
- [Spec-driven mode in depth](how-spec-driven-works.md): one change followed from a conversation to the capability's next version, defects and changes in behavior, every /bk:init question for a Spec-driven tree, and the settings left at their defaults.
- [Full SDLC mode in depth](how-full-sdlc-works.md): one piece of work followed from a business idea to a finished task, every /bk:init question for a Full SDLC tree, three complete processes, and what approval checks, writes and locks.
- [Records and the audit trail](records.md): rulings, answers to findings and decisions with their evidence, where records are kept, completion, approval and re-pin records, commits linked to their unit, and how records are kept.
- [Status and usage](status.md): the overview with /bk:status, releasing a claim, your usage with /bk:stats, turning it off, deleting or exporting it, what each section of the overview shows, and what usage stats record.

## Reference

- [Commands](commands.md): every command, what you can type, what it asks, and how it behaves in each mode.
- [Features](what-buildkeel-does.md): every feature, the core ones first, then those you can switch, each by mode, with the key features marked.
- [Glossary](glossary.md): the product's terms in alphabetical order, each with a short definition and the page that explains it.
- [What BuildKeel does not do](does-not-do.md): the limits BuildKeel keeps on purpose: across machines, other tools, enforcement, tests, your data and history, and what it does not record.
- [Troubleshooting](troubleshooting.md): symptoms and what to do about them, for installing, setup and settings, starting and building, finishing and sharing, and the known limits.
