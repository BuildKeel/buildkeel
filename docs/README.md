# BuildKeel documentation

User documentation, kept beside the code it describes.

## Get started

- [Install in Claude Code](install-claude-code.md): what you need, installing for you or for a repository, updating and removing, and checking that it works.
- [Install in Antigravity](install-antigravity.md): what you need, installing for every project or for one, updating and removing, installing without npm, and checking that it works.
- [Getting started](getting-started.md): setting up a repository with /bk:init, what it adds, and a first piece of work from a conversation to finished code.

## Spec-driven vs Full SDLC

- [The two modes](modes.md): what each mode holds, setting the mode when a spec tree is created, one mode per tree, and moving a tree to Full SDLC.
- [Choosing a mode](comparing-modes.md): which mode to choose, the two side by side, the same piece of work in each, and moving to Full SDLC.

## Plan the work

- [Capability specs](capability-specs.md): in a Spec-driven tree, how the system behaves now: the format, requirement and scenario IDs, versions written by finishing a change, and what BuildKeel checks.
- [Changes](changes.md): in a Spec-driven tree, a change's proposal, spec changes, design and tasks, editing an open change, and what BuildKeel checks.
- [Drafting with Claude](drafting.md): turning a conversation into a plan with /bk:capture, drafting artifacts and breakdowns with /bk:new, bringing your own material, draft IDs, and what is still missing.
- [Approving artifacts](approval.md): approving with /bk:approve, a whole plan in one review, permanent numbers, approval records and commits, changing an approved artifact, locked files and validation.
- [Test plans and coverage](test-plans.md): test plans at every level, test case IDs, what is checked, gaps, the coverage view, and which test cases apply to a task.

## Build the work

- [Working on a unit](working-on-a-unit.md): starting a unit with /bk:start, building everything ready with /bk:build, what must be true, its branch and claim, the context Claude receives, sessions, freshness and working on several units at once.
- [Finishing a unit](finishing-a-unit.md): commit lines and test tags, recording test results, finishing with /bk:done, what must be true, commits without a unit line, the completion record, the next unit, and finishing a story or an epic.
- [Bugs and ad-hoc units](bugs-and-adhoc.md): changes with nothing started, /bk:adhoc, recording bugs with /bk:new bug, regression tests, open bugs, attaching a standalone bug, and IDs given offline.

## Change and track

- [Change impact](change-impact.md): what a new version makes suspect, previewing it before approval, where suspects show, reviewing them with /bk:impact, and re-pin records.
- [The status overview](status.md): /bk:status, what each section shows, claims and releasing them, commits with no unit after the baseline, and files changed outside BuildKeel.
- [Your usage](usage-stats.md): /bk:stats, what is recorded on your machine, and turning it off, deleting or exporting it. Nothing is sent anywhere.

## Existing code

- [Documenting existing code](onboarding.md): code from before BuildKeel, documented as work touches it or area by area with /bk:onboard; version 0, kept sources, onboarded numbers, finished work and old commits, existing tests, and filling in later.

## Set up and maintain

- [The spec tree](spec-tree.md): where BuildKeel keeps your plan, the pointer file in each code repository, and format versions.
- [Process and templates](process-and-templates.md): the default process, documents attached to a stage and which each stage requires, the design document, setting up the process, renaming and adding stages, ID prefixes, gate modes, templates and what BuildKeel checks before approval.
- [Organization templates](organization-templates.md): templates and a process shared across teams from a repository of their own, pinned to a version.
- [Migrating a spec tree](migration.md): what happens when a spec tree is in an older format, and upgrading it with /bk:migrate.

## Reference

- [Commands](commands.md): every command, what you can type, what it asks, and how it behaves in each mode.
