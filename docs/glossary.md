# Glossary

The words BuildKeel uses, in alphabetical order, each with a short definition and the page that explains it. For your team's own terms, see [The playbook](glossary-practices-adrs.md).

## A to C

**Acceptance criterion.** In Full SDLC, a condition a story must meet. Its ID extends the story's, such as `US-012-AC2`, and test cases declare the criteria they cover. See [Tests and traceability](test-plans.md).

**Active unit.** The unit of work a working tree is on, on its own branch. Each working tree has one, and its context is what Claude is given. See [Build](working-on-a-unit.md).

**Ad-hoc unit.** A unit for a change nothing planned, such as a small fix, recorded through `/bk:build`. Its ID reads like `AH-001`. See [Small fixes, defects and spikes](defects-and-adhoc.md).

**ADR.** An architecture decision record: a decision that is hard to reverse, surprising without its context, and the result of a real trade-off. It is replaced by a newer ADR, never edited. See [The playbook](glossary-practices-adrs.md).

**Approval record.** In Full SDLC, the file that records who approved which version of an artifact, when, and the hash of what was approved. See [Records and the audit trail](records.md).

**Archiving.** In Spec-driven, what finishing does to a change: its spec changes are merged, each capability it touches gets its next version, and its files are frozen as its record. See [Finish](finishing-a-unit.md).

**Artifact.** A markdown file in the spec tree with defined fields and sections. In Full SDLC, a business idea, epic, story, task or a document attached to one; in Spec-driven, a capability spec or a change. See [The spec tree and its artifacts](spec-tree.md).

**Baseline.** The commit each code repository was at when `/bk:init` set it up. Code up to the baseline is existing code, and commits before it are never reported as having no unit. See [Start on existing code](onboarding.md).

**Break-it.** The reviewer that writes tests to make the code fail. Its only evidence is a failing test, which BuildKeel runs itself. See [Reviews and the fix loop](reviews.md).

**Brief.** What `/bk:resume` shows: where things stand, the decisions and dead ends, open questions, the next step, and any files left uncommitted on another machine. See [Pause, resume and hand over](pausing-and-resuming.md).

**Build-ready tasks.** A switch under which every task names its Files, what it Uses and Delivers, and its Verify command, so a fresh agent can build it alone. See [Build](working-on-a-unit.md).

**Built line.** What a finished task actually delivered: as planned, changed, or missing. Later tasks are given it, not the plan. See [Build](working-on-a-unit.md).

**`BuildKeel-Unit` line.** The line in a commit that names the unit it belongs to. Commits after the baseline without one are listed as commits with no unit. See [Finish](finishing-a-unit.md).

**Capability spec.** In Spec-driven, the lasting requirements of one capability, with scenarios: how the system behaves now. Each version is written once, by finishing a change, and the highest version is in force. See [The spec tree and its artifacts](spec-tree.md).

**Change.** In Spec-driven, one piece of work: a proposal, spec changes, a design when the work needs one, and tasks. It is open until it is finished, and every file of it can be edited meanwhile. See [The spec tree and its artifacts](spec-tree.md).

**Checkpoint.** A point where BuildKeel saves the working notes since the last one. A pause is one too. See [Working notes and threads](working-notes.md).

**Claim.** A unit's hold on this machine, so another working tree here cannot start it. Claims are kept on your machine only, and released when the unit is finished or when you ask. See [Build](working-on-a-unit.md).

**Completion record.** The permanent record finishing writes: the versions built against, the branch and commits, the files changed, the test results and TDD evidence, every review finding and its answer, who finished it and when, and a context part with the decisions and notes for the next person. See [Records and the audit trail](records.md).

## D to H

**Decision record.** A decision kept with its source or evidence: a ruling on a building agent's question, the answer to a review finding, or a decision in the working notes. See [Records and the audit trail](records.md).

**Defect.** A unit for code that does not do what the spec says. One found while building is linked to the unit and test that found it; a reported one is checked against the spec and the code first. Its ID reads like `DEF-001`. See [Small fixes, defects and spikes](defects-and-adhoc.md).

**Design document.** A document attached to an artifact, usually an epic, saying how its work is built, such as `EP-01-DD`. See [Process: stages, kinds and documents](process-and-templates.md).

**Draft.** In Full SDLC, an artifact not yet approved. It carries a temporary ID, such as `US-draft-k3x9`, until approval gives it its permanent number. See [Capture a plan](capture.md).

**Fix loop.** In a run, an open High or Medium review finding stops its task, and the review runs again on the fix. See [Reviews and the fix loop](reviews.md).

**Fresh agent.** A new agent given only what its task or check needs, never your conversation. Fresh agents build tasks, review work, and run the planning checks. See [Build](working-on-a-unit.md).

**Freshness.** The background check of whether the local spec tree is behind its remote. You are told when you start, approve or finish work. See [Build](working-on-a-unit.md).

**Full SDLC.** The mode with your team's chain of stages, by default business idea, epic, story and task, with approvals and gates. See [Choose a mode](modes.md).

**Gate.** A check on work: the approve, start and done gates check approvals before work starts and evidence before it finishes, and the lock gate guards approved files. Each gate blocks, warns or is off. See [Process: stages, kinds and documents](process-and-templates.md).

**Glossary.** The team's terms, each with its definition and the words to avoid in its place. It changes by agreement in the conversation, and every version is kept. See [The playbook](glossary-practices-adrs.md).

**Heads-up note.** One of up to five notes earlier work left about the files a unit will change, shown when the unit starts. See [Notes on the code](heads-up-notes.md).

## I to P

**Kind.** One of several kinds of work a stage can hold, such as user stories, features and enhancements under the same epics, each with its own prefix, numbering, template and required documents. See [Process: stages, kinds and documents](process-and-templates.md).

**Learning loop.** At finish and in status, BuildKeel looks for patterns in the records, such as review findings that keep coming back, and proposes a practice or a note on the code. See [The Learning loop](learning-loop.md).

**Lock gate.** The gate that stops Claude from editing approved versions, archived changes and records directly. Only BuildKeel's own operations write them, and changes made outside Claude are detected and reported. See [Records and the audit trail](records.md).

**Note on the code.** A short note tied to files, such as `CN-001`, saved only when you agree. The next unit that changes those files gets it. See [Notes on the code](heads-up-notes.md).

**Number counter.** The counters that give each approved artifact, defect and ad-hoc unit its permanent number, kept on a branch of the spec repo's remote. See [The spec tree and its artifacts](spec-tree.md).

**Onboarding.** Documenting code from before BuildKeel, area by area, with `/bk:onboard`. See [Start on existing code](onboarding.md).

**Pause record.** What `/bk:pause` writes: where the work stood and who held it. Once pushed, it is what tells the team the work is held. See [Pause, resume and hand over](pausing-and-resuming.md).

**Playbook.** The team's glossary, practices and ADRs, kept in the spec tree and read by every agent. See [The playbook](glossary-practices-adrs.md).

**Pointer file.** The `.buildkeel.yaml` at the root of each code repository, saying which spec tree it uses. See [The spec tree and its artifacts](spec-tree.md).

**Practice.** A short rule the team works by, such as `P-07`: BuildKeel's defaults plus the team's own, read by every reviewer and planning check. See [The playbook](glossary-practices-adrs.md).

**Principal handoff.** When fix rounds do not clear a review finding, the implementer runs once more on a stronger tier. If that fails too, the run stops with the whole story. See [Reviews and the fix loop](reviews.md).

## R to S

**Read-only copy.** The glossary, practices and accepted ADRs written into each code repository, marked as generated, for people and tools without BuildKeel. See [The playbook](glossary-practices-adrs.md).

**Red run.** A test's failing run, recorded before its code made it pass. BuildKeel works it out from git and the test reports. See [TDD evidence](tdd.md).

**Re-pin.** The decision that a suspect is still valid against the new version of what it relies on, kept as a re-pin record. See [When a requirement changes](change-impact.md).

**Requirement.** In Spec-driven, a behavior stated with SHALL or MUST, such as `ACCT-R2`. It keeps its ID when renamed or reworded. See [The spec tree and its artifacts](spec-tree.md).

**Revert check.** A run of the unit's tests against the code as it was before the unit, to show the tests need the unit's code. See [TDD evidence](tdd.md).

**Ruling.** Claude's answer to a building agent's question, from the spec, the working notes, the glossary or the practices, with its source. Every later agent in the run is given it. See [Records and the audit trail](records.md).

**Scenario.** In Spec-driven, a WHEN and THEN case of a requirement, such as `ACCT-R2-S1`, checked by tests that carry its ID. See [Tests and traceability](test-plans.md).

**Spec change.** The part of a change that adds, modifies or removes requirements, naming existing ones by ID. See [The spec tree and its artifacts](spec-tree.md).

**Spec-driven.** The mode with capability specs and a change per piece of work, with no approvals or gates. See [Choose a mode](modes.md).

**Spec tree.** Where BuildKeel keeps your plan: markdown files in a git repository of their own, or in a folder of your code repository. See [The spec tree and its artifacts](spec-tree.md).

**Spike.** Throwaway code on its own `spike/<name>` branch, without tests or a unit. BuildKeel never merges or deletes the branch. See [Small fixes, defects and spikes](defects-and-adhoc.md).

**Stage.** A level of a Full SDLC process, by default business idea, epic, story and task. Your team can rename, add or skip stages. See [Process: stages, kinds and documents](process-and-templates.md).

**Stamping.** A git hook that adds the active unit's line to commits you make by hand. It is a personal setting. See [Feature switches](settings.md).

**Suspect.** Work or a test built against an older version of something that has changed since, in what it relies on. It is worked out from the tree, never stored, and each one is decided as still valid or needs change. See [When a requirement changes](change-impact.md).

**Switch.** The setting of an additional feature in `buildkeel.yaml`, such as `on`, `off`, `ask` or `auto`. Each record notes the switches in force. See [Feature switches](settings.md).

## T to W

**Task.** The smallest piece of planned work, with its Files, Uses, Delivers and Verify lines when Build-ready tasks is on. In Full SDLC it sits under a story; in Spec-driven it is a checkbox in a change. See [Build](working-on-a-unit.md).

**Test case.** In Full SDLC, an entry of a test plan, such as `US-012-TC3`, that declares the criteria it covers. A test belongs to it by carrying its ID in square brackets. See [Tests and traceability](test-plans.md).

**Test plan.** In Full SDLC, a document of test cases attached at any level, such as `US-012-TP`. A Spec-driven tree has none: its scenarios are what tests check. See [Tests and traceability](test-plans.md).

**Thread.** An exploration not yet ready to plan, such as `TH-004`, kept when you pause with nothing active. It is captured into work, or dropped with a reason. See [Working notes and threads](working-notes.md).

**Tier.** A named model and effort for each host, such as the standard and principal tiers, that an agent role runs on. See [Models and effort per role](models.md).

**Unit of work.** What a working tree builds and finishes: a task, a story built without tasks, a change, a defect or an ad-hoc unit. See [Build](working-on-a-unit.md).

**Version.** Every link between artifacts names a version, such as `US-012@v1`. An approved version is frozen, and a change makes a new one. See [The spec tree and its artifacts](spec-tree.md).

**Version 0.** What describes code from before BuildKeel. Everything made in BuildKeel starts at version 1. See [Start on existing code](onboarding.md).

**Working notes.** What the conversation settles on a unit or change: a decision and why, a ruling, a constraint, a dead end, an open question, the next step. Each names a source that is checked, and finishing turns them into the context part of the completion record. See [Working notes and threads](working-notes.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-init`.
