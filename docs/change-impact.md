# Change impact

When an approved artifact gets a new version, BuildKeel works out exactly what was built against the old one and is affected by the change: test cases, tasks, stories and the code of finished work. Each of these is **suspect** until someone decides whether it still holds. Nothing is stored to say so: BuildKeel works it out each time from the versions things were approved against, so it is always in step with the spec tree.

## What makes something suspect

Every link names the version it was made against, such as `parent: US-001@v1` in a task, and a test plan is approved against a version of the artifact it tests. Something is suspect when the version it is pinned to is older than the latest approved version and a tracked part it relies on differs between the two:

- A **test case** relies on what its `covers:` line names. It is suspect when a criterion it covers changed or was removed. A test case covering only `US-001-AC1` is not affected by a change to `US-001-AC2`.
- A **task, story, epic or defect** relies on all of its parent. It is suspect when any tracked part of the parent changed, an added criterion included.
- A **unit** also relies on the documents required of it and above it, such as its epic's design document, as they were when it was started. It is suspect when a tracked part of one of them changed: the design, the decisions, or the architecture, data or interfaces. The versions are kept with the unit's claim while it is in progress, and in its completion record once it is finished.
- A **design document**, or another document attached to an artifact, relies on all of its artifact, like a child.
- Two **related artifacts** rely on each other (see [Links between artifacts](#links-between-artifacts)).

Only tracked parts count. In the built-in templates these are the problem, goals and success measures of a business idea, the scope of an epic, the story and acceptance criteria of a user story, the description of a task or defect, the test cases of a test plan, and the design, decisions, architecture, data and interfaces of a design document. Summaries and notes never make anything suspect, and neither does a change in spacing, line wrapping or the order of entries: entries are matched by their IDs. A template can mark other sections and fields as tracked; see [Process and templates](process-and-templates.md).

The plan of an epic or a business idea can cover stories or epics that no link pins. When such a plan is approved, its approval record notes the version of each one its test cases cover (`pins`), and those count the same way.

## Links between artifacts

An artifact can name others outside its parent chain in its frontmatter:

```markdown
---
id: EP-05
title: Reset by text message
parent: BI-01@v1
related: [EP-01]
changes: [EP-01-DD]
---
```

- `related` says the two belong together, such as a new epic for an area an older epic describes. Each side is pinned to the other's version when the artifact naming the link is approved, and a tracked change on either side makes the other suspect: a new version of `EP-05` that changes its scope makes `EP-01` suspect, to review and decide like any suspect.
- `changes` says the work changes the document named, such as the design document that describes how password reset works today. The artifact cannot be finished until that document has a newer approved version than when the link was made, so the document keeps describing how the system works.

A linked artifact must be approved before the artifact naming it can be. `/bk:capture` adds these links for you: `related` when you place work somewhere other than it recommended, and `changes` when the work changes how something already built behaves.

## Version 0 and completing versions

[Version 0](approval.md#version-0-code-from-before-buildkeel) describes code as it was before BuildKeel, so approving it never makes anything suspect, even when it is added under a version that work was already built against.

When version 0 describes behavior that the version in force leaves out, the next version brings the two together: the version in force wherever they overlap, and version 0 only where the version in force says nothing. The same goes for a version that only fills in sections version 0 left empty. Neither changes any code, so the draft says which version it completes:

```markdown
---
id: US-005
title: Password reset
parent: EP-01@v1
completes: 1
---
```

Its approval record keeps `completes: 1`, and whatever was built against v1 counts as built against it: nothing becomes suspect. A criterion it adds is still a [coverage gap](test-plans.md#what-is-checked) until a version of the test plan covers it. The approve gate checks that `completes` names the version in force and that version 0 is approved; when the next version is drafted, a `completes` carried over from the one before is left out.

Version 1 of an artifact whose version in force is version 0 is a change like any other: what was built against version 0 becomes suspect, to review as below.

## Before approving a new version

Run `/bk:impact` with the artifact's ID while its new version is a draft, to see what approving it would make suspect:

```
/bk:impact US-001
```

```
Approving the draft of US-001 as v2 would make 2 items suspect. Nothing is marked until the draft is approved.

US-001 "Request a reset link", from v1 to the draft:
- US-001-AC2 changed
  was: - **US-001-AC2** The link expires after 30 minutes.
  now: - **US-001-AC2** The link expires after 15 minutes.
- US-001-AC3 added
  now: - **US-001-AC3** A used link cannot be used again.
Would become suspect (2):
1. Task TK-001 "Reset endpoint": any change to US-001 affects it.
   Finished (tasks/TK-001/completions/20261001T120000Z-sam.yaml): 1 commit in payments-api: a1b2c3d Add the reset endpoint.
   Files: src/reset/endpoint.ts, test/reset.test.ts.
2. Test case US-001-TC2 "Link expires" in US-001-TP v1: covers US-001-AC2.

It would open 1 coverage gap:
- US-001-AC3 is new. No test case can cover it until a version of US-001-TP written against US-001 v2 does, and no work under US-001 can start until then.
```

The preview changes nothing. A finished unit's commits and files are listed so you can judge whether its code still meets the new version.

## Once it is approved

From the moment the new version is approved:

- starting, approving or finishing work names what is suspect;
- [`/bk:status`](status.md) marks each suspect in the tree and lists them all;
- starting a unit is refused while it or anything above it is suspect;
- finishing a story or an epic is refused while anything under it is suspect;
- a criterion the new version adds is a [coverage gap](test-plans.md#what-is-checked) until a version of the test plan written against the new version covers it.

For example, after a new version of the epic EP-01 changes its scope:

```
Start of TK-001 refused by the start gate: 1 check failed.
1. The user story US-001 "Request a reset link", above TK-001, is suspect: built against EP-01 v1, and v2 changes Scope.
   To fix: Review it with /bk:impact US-001, and record whether it is still valid or needs change.
```

## Reviewing suspects

Run `/bk:impact` on its own to review every suspect:

```
2 items are suspect: built against an older version of something that has changed since in what they rely on.

US-001 "Request a reset link", from v1 to v2:
- US-001-AC2 changed
  was: - **US-001-AC2** The link expires after 30 minutes.
  now: - **US-001-AC2** The link expires after 15 minutes.
- US-001-AC3 added
  now: - **US-001-AC3** A used link cannot be used again.
Suspect (2):
1. Task TK-001 "Reset endpoint": any change to US-001 affects it.
   Finished (tasks/TK-001/completions/20261001T120000Z-sam.yaml): 1 commit in payments-api: a1b2c3d Add the reset endpoint.
   Files: src/reset/endpoint.ts, test/reset.test.ts.
2. Test case US-001-TC2 "Link expires" in US-001-TP v1: covers US-001-AC2.

Each stays suspect until the user decides, one at a time: still valid (it is kept as it is and counts as built against the new version) or needs change (a new draft of it, or of its test plan, to update and approve).
```

Claude then goes through them one at a time. For each, it shows the suspect with the old and new text of what changed, proposes a decision and says why, and records only what you choose:

- **Still valid** keeps it as it is. BuildKeel writes a re-pin record saying who reviewed it against which version, commits it on its own in the spec repo as `repin: TK-001 to US-001 v2`, and it is no longer suspect.
- **Needs change** opens its next version as a draft, with its parent link moved to the new version; for a test case, the next version of its plan. Claude can make the change with you. It stays suspect until that version is approved. A finished unit's new version can then be started again to change its code.
- A **defect found while building** has no versions (a reported defect is versioned like any artifact). For an open one, needs change means updating its file with you, such as what it expects: saving it moves it to the new version and records the decision, in one commit, and it stays suspect until then. For a finished defect, whose fix may no longer hold, BuildKeel records a new defect to check it, naming the old one and the new version, and the finished defect is no longer suspect.

A unit in progress that becomes suspect is decided before it is finished: `/bk:done` refuses it and names `/bk:impact`. Still valid lets it finish at once; needs change opens its next version, which it is finished against once approved. See [Finishing a unit](finishing-a-unit.md).

You can also run `/bk:impact US-001-TC2` to review one suspect, or `/bk:impact US-001` to see what a new version of US-001 made suspect.

## Re-pin records

Each decision that re-pins something is a file in the `repins/` folder of what was kept: the artifact's own folder, or its test plan's for a test case, such as `stories/US-001/test-plan/repins/20261002T093000Z-jane-doe-us-001-tc2.yaml`:

```yaml
target: US-001
testCase: US-001-TC2
from: 1
to: 2
decidedBy: Jane Doe <jane@example.com>
decidedAt: 2026-10-02T09:30:00Z
```

| Field | Meaning |
|---|---|
| `target` | The artifact whose new version was reviewed. |
| `testCase` | For a test case, its ID. Not present when the artifact holding the record was kept itself. |
| `from`, `to` | The version it was built against, and the version it counts as built against from now on. |
| `decidedBy` | The git identity set for the spec repo. |
| `decidedAt` | When, in UTC. |
| `decision` | `needs-change` for a defect that was changed to match, or followed up; not present for still valid. |
| `followUp` | For a finished defect that needs change: the new defect recorded to check it. |

Like approval and completion records, re-pin records are written once and never changed. Decisions made on different branches of the spec repo are separate files, so they merge without conflict; if two name different versions, the newer one counts.

## In a Spec-driven tree

In a Spec-driven tree (see [The two modes](modes.md)), what code and tests are built against is a [capability spec](capability-specs.md) version, and what can change under them is a requirement:

- **Tests** depend on the requirement of the scenario they are tagged with, at the version in force when the change they were written for was archived (its completion record lists them).
- **An archived change** depends on each requirement it added or modified, at the version its archiving wrote.
- **An open defect** linked to a requirement, such as `requirement: AUTH-R3@v1`, depends on it at the version it names. It is decided in its own file, not with a re-pin: Claude asks whether it still applies, and saves the file naming the new version, or the defect is closed. See [Defects and ad-hoc units](defects-and-adhoc.md#in-a-spec-driven-tree).

When a later version modifies or removes one of those requirements, compared by ID, what depends on it becomes suspect, with its commits and files. A new name for a requirement, or wording outside requirements, is not a change. What relies only on other requirements is left alone.

### Before archiving a change

Run `/bk:impact CH-002` on an open change to see what archiving it would make suspect. Nothing is marked yet:

```
Archiving CH-002 "Reset links expire" would make 2 items suspect. Nothing is marked yet.

AUTH, from v1 to what CH-002 would make it:
- AUTH-R2 removed by CH-002
  was:
    ### AUTH-R2 Request a reset link
    The system SHALL email a password reset link to a registered address on request.

    #### AUTH-R2-S1 Registered address
    - **WHEN** a user asks for a reset link for a registered email
    - **THEN** a reset link is emailed to that address
Would become suspect (2):
1. CH-001 "Sign in and reset", which built AUTH-R1, AUTH-R2.
   Finished (changes/CH-001/completions/20261010T080000Z-jane-doe.yaml): 1 commit in accounts-api: a1b2c3d Sign in and reset.
   Files: src/reset.ts, src/signin.ts.
2. The tests of AUTH-R2-S1 "Registered address", as CH-001 recorded them: test/reset.test.ts > emails a link [AUTH-R2-S1].
```

You can decide each one right away. **Still valid** keeps it as it is. **Needs change** adds a task to the change to revisit it, such as:

```
- [ ] 2.2 Revisit the tests of AUTH-R2-S1 (test/reset.test.ts > emails a link [AUTH-R2-S1]) for AUTH-R2, changed by CH-002. Verify: they check AUTH-R2 as it now reads, and pass.
```

The decisions are kept in the change's `impact.yaml` and carried out when it is archived, so nothing decided becomes suspect. `/bk:done` shows them with the suspects archiving would raise.

### After archiving

Anything not decided becomes suspect once the change is archived, and the status overview lists it. Review it with `/bk:impact`:

- **Still valid** writes a re-pin record now, in the directory of the archived change that holds the dependency, and commits it on its own.
- **Needs change** adds the task to an open change you pick, or to a new change Claude drafts with you first. It stays suspect until that change is archived, which re-pins it to the version then in force.

Suspects never block anything in a Spec-driven tree.

