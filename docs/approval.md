# Approving artifacts

Approval turns a draft into an agreed version. Once a version is approved it is frozen: it never changes, and a change to the artifact becomes its next version. Work can only start on a unit whose requirements are approved.

## Approve an artifact

```
/bk:approve US-draft-k3x9
```

Claude shows you the artifact, checks it, and tells you what approval will do before anything is written:

```
Ready to approve user story US-draft-k3x9 "Reset link expires" as v1. Approving will:
- give it its permanent number: the next user story number, US-002 unless someone else approves one first; its directory becomes stories/US-002/
- rewrite references to US-draft-k3x9 in: stories/US-002/test-plan/plan.md
- record it against its parent EP-01@v1
- freeze v1 and record the approval by Jane Doe <jane@example.com>
- commit only those files in the spec repo as "approve: US-002 v1", without pushing
```

Nothing is approved until you confirm.

Run `/bk:approve` on its own and Claude asks what you want to approve. Press Enter on the first choice to see what is waiting, or type an ID:

```
Waiting for approval: 3.

Ready to approve (1):
- EP-01 epic "Password reset": v1

Not ready yet (2):
- US-001 user story "Request a reset link": The parent epic EP-01 "Password reset" is still a draft.
- US-001-TP test plan: The parent user story US-001 "Request a reset link" is still a draft.
```

After each approval, Claude shows the same list again, so you can see what has become ready.

When an artifact has a document with a draft waiting, such as a story's test plan or an epic's design document, Claude offers to approve it next. The document is checked against the artifact's approved version, and it is approved and committed on its own.

## Approve a whole plan in one review

After `/bk:capture` has drafted a plan, run `/bk:approve` and press Enter on the first choice, **The drafts from this conversation**, or name the drafts yourself: `/bk:approve EP-draft-k3x9 EP-draft-k3x9-DD US-draft-m2p8 …`. Claude shows the whole set first, in the order it will be approved, parents and their documents before their children, with the number each will most likely get, and anything that would not pass, and why:

```
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

Approve them, fix what would not pass first, or stop. Once you confirm, each artifact is approved in turn, through its own checks, with its own approval record and commit. If one is refused, the rest are still approved, and what needs it stays a draft. The result opens with what is now approved and what can start:

```
Approved 4 of 6: EP-02, EP-02-DD, US-002 and US-002-TP. US-draft-q7w4 stays a draft: stories/US-draft-q7w4/story.md: the "Acceptance criteria" section is missing; US-draft-q7w4-TP waits for it.
Ready to start now:
- US-002 user story "Request a code by text"
```

When an artifact in the set has a new version of its parent approved in the same review, it is tied to that new version.

## What is checked

Before an artifact can be approved:

- it has every field and section its template requires, every entry has its ID, and no entry reuses a removed entry's ID (see [Process and templates](process-and-templates.md));
- its parent is approved. A story cannot be approved while its epic is a draft;
- it is written against its parent's current approved version. A draft written against `EP-01@v1` cannot be approved once `EP-01` v2 is approved: check it against v2 first.
- for a test plan, every `covers:` line names something the plan may cover, and a story's plan covers every acceptance criterion (see [Test plans and coverage](test-plans.md)).

If any check fails, nothing is written, and every failing check is listed with what to do about it:

```
Approval of US-draft-k3x9 refused by the approve gate: 1 check failed.
1. The parent epic EP-01 "Password reset" is still a draft.
   To fix: Approve EP-01 first with /bk:approve EP-01.
```

Bugs and ad-hoc units are not approved.

## What approval writes

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
| `template` | The template the artifact was checked against: its type, its version, and whether it came from the spec tree's `templates/` folder (`tree`), the organization's templates (`org`, with `org` naming the source and the version pinned, such as `git@github.com:acme/buildkeel-templates.git@v1.0.0`; see [Organization templates](organization-templates.md)), or BuildKeel (`built-in`). Not present for version 0, which is held to no template. |
| `onboarded` | `true` for version 0: it describes code as it was before BuildKeel. |
| `baseline` | For version 0: the baseline commit of each code repository in `buildkeel.yaml`, the code it describes. |
| `sources` | For version 0: the hash of each source kept beside it, by its file name in `sources/`. Validation compares each source against it. |
| `empty` | For version 0: the sections its template asks for that it leaves empty, for a later version to fill in. |
| `completes` | For a version that only completes the one before it with what version 0 describes, or fills in what version 0 left empty: the version it completes. Nothing built against that version becomes suspect (see [Change impact](change-impact.md#version-0-and-completing-versions)). |
| `parent` | The parent and the version it was approved against. Not present for a business idea. |
| `pins` | For the test plan of an epic or a business idea: the version of each story or epic its test cases cover, as approved at the time. A later version that changes what a test case covers makes that test case suspect. Not present otherwise. |
| `related` | For an artifact that names related artifacts, such as `related: [EP-01]` in a new epic: the version of each in force when it was approved. A tracked change to either side then makes the other suspect. Not present otherwise. |
| `changes` | For an artifact whose work changes a document, such as `changes: [EP-01-DD]`: the version of the document in force when it was approved. The artifact cannot be finished until a newer version of the document is approved. Not present otherwise. |
| `draftId` | The draft ID the artifact had before its first approval. |

Because versions and approvals are files, squashing or rebasing the spec repo's history never loses them.

## Permanent numbers

An artifact gets its permanent ID, such as `US-002`, when it is first approved. BuildKeel renames its directory from the draft ID and rewrites every reference to the draft ID in the spec tree's drafts: parent links, `covers:` lines and entry IDs such as `US-draft-k3x9-AC1`. A draft whose parent is the artifact being approved is tied to the new version, such as `US-002@v1`. Documents attached to an artifact have no number of their own: the test plan of `US-002` is `US-002-TP`, and the design document of `EP-02` is `EP-02-DD`.

Each type counts on its own: the first epic is `EP-01` and the first story `US-001`. The counters are kept on a branch of the spec repo's remote, `buildkeel/ids` (set `settings.idsBranch` in `buildkeel.yaml` to use another), never on your main branch. BuildKeel fetches the counter, takes the next number and pushes it back; when two people approve at the same moment, one push is refused and that approval simply takes the next number. A spec repo with no remote keeps the counter on a local branch.

### Approving without a connection

When the remote cannot be reached, the approval is still recorded, with the number pending:

- `approvals/v1-pending.yaml` records who approved it, when, and the hash of what was approved, and it is committed as `approve: US-draft-k3x9 v1 (number pending)`;
- the artifact shows as "approved, number pending" in `/bk:status`;
- it cannot be changed, its children cannot be approved, and work cannot start on it until it has its number.

The number is assigned the next time the remote can be reached: at the next approval or the next session. The directory is renamed, references are rewritten, the frozen copy and `approvals/v1.yaml` are written with the original approver and time, and it is committed as `approve: US-002 v1`. The pending record stays as history.

## Version 0: code from before BuildKeel

Most teams set BuildKeel up on code that already exists. What describes that code is **version 0** of its artifact; anything made in BuildKeel starts at version 1. Version 0 reads like any artifact of its type, as if BuildKeel had been used from the start: Claude drafts it from the code and from the material you bring, such as a ticket or a wiki page read through your own tools, a file, or what you tell it. A person reads it, completes it and approves it, and you can write or correct any of it by hand.

Its draft is `onboard.md`, in the artifact's directory beside its working file, so version 0 and a change that builds on it can be drafted side by side. Approving version 0 checks only that its parent is approved, at any version. It is not held to the template or to the documents the process requires: a section nobody knows can stay empty, and the approval record lists it for a later version to fill in.

```
Ready to approve version 0 of user story US-draft-k3x9 "Password reset": it describes the code as it was before BuildKeel, so it is held to no template; a person reads it before it is approved. Approving will:
- give it its permanent number: the next onboarded user story number, US-E001 unless someone else approves one first; its directory becomes stories/US-E001/
- record it against its parent EP-01@v1
- freeze v0 and record the approval by Jane Doe <jane@example.com>, with its source frozen with it: jira-PAY-12.md
- record what it leaves empty, for a later version to fill in: Story
- commit only those files in the spec repo as "approve: US-E001 v0", without pushing
```

Once approved, version 0 is in force like any version, and `onboard.md` is gone: the frozen copy `versions/v0.md` holds it. It counts as approved when work starts under it, and as done when its parent is finished, since its code already exists. A change to it opens version 1, which is held to the template, the gates and [change impact](change-impact.md) like any other version.

### Onboarded numbers

An artifact first approved as version 0 is numbered in its type's onboarded sequence: its prefix, a letter, then the number, such as `US-E001`, `EP-E01` or `BUG-E001`. New work keeps the normal sequence, so the next story approved as version 1 is `US-002`. The letter is `E` unless the process sets another:

```yaml
process:
  onboarded:
    letter: H
```

An ID never changes. Version 0 added later to `US-005` leaves it `US-005`.

### Adding version 0 under a later version

An artifact already approved in BuildKeel can get its version 0 later, describing the code as it was at the baseline. Name it with `@v0`:

```
/bk:approve US-005@v0
```

The version in force stays as it is; version 0 comes before it in the history, and nothing becomes suspect. An artifact has one version 0 at most. When the version in force leaves out behavior that version 0 describes, the next version brings the two together, and says that it only completes the version in force (`completes` in its record).

### Version 0 and its change in one review

When work changes code that nothing describes yet, its plan can hold version 0 of what the code does today and the change as version 1 of the same artifact. Approve them in one review, and version 0 is approved first:

```
/bk:approve US-draft-k3x9@v0 US-draft-k3x9
```

Each gets its own approval record and commit: `approve: US-E001 v0`, then `approve: US-E001 v1`.

### Sources kept with version 0

Each source a version 0 is drafted from is kept beside it in `sources/`, one file per source, exactly as it was read: for an issue tracker entry, its description, fields and comments. Attachments, images and history stay behind its link, and only what your tool returned is kept. Code is never copied: the baseline commit in the approval record names it.

```
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

BuildKeel lists the sources in a Sources section at the end of version 0, with their links. Until version 0 is approved, a source can be read again, replacing the earlier copy, or dropped. Approval freezes them: their hashes go into the approval record, the agent cannot edit them, and validation reports a source that was changed or added afterwards.

### The approval record of version 0

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

## Commits and pushing

Each approval is one commit in the spec repo, `approve: US-002 v1`, holding only that approval's files. Anything else you have changed or staged in the spec repo stays out of it. If the spec tree is a folder of your code repository, the commit is made on the branch you have checked out. On a unit's branch, such as `bk/TK-001-…` after finishing that unit, Claude tells you so before and after approving: units started from your main branch do not see the approval until that branch is merged into it. Switch to your main branch first to have the approval there straight away.

Pushing is up to you: after each approval Claude tells you how many approvals are not pushed yet. To push every approval as soon as it is committed, set this in `buildkeel.yaml`:

```yaml
settings:
  autoPush: true
```

If an automatic push is refused, for example because the remote has commits you do not have, the approval is kept and you are told why. Where your spec repo's main branch only accepts pull requests, approval commits travel in a pull request like any other change.

## Changing an approved artifact

Ask Claude for the change as usual. Saving it opens the next version as a draft:

```
Saved US-002 v2 as a draft at stories/US-002/story.md. v1 stays approved and in force until v2 is approved.
```

The working file now holds v2; `versions/v1.md` is untouched. Approve v2 with `/bk:approve US-002`. Its number stays the same.

## Locked files

The agent cannot edit, in Claude Code:

- frozen copies in `versions/`;
- approval records in `approvals/`, and the completion and re-pin records BuildKeel writes later;
- the sources kept with an approved version 0, in `sources/`;
- the file of an approved artifact that has no new version open, or whose number is pending.

An attempt is blocked, and the agent is told to save a new version instead. Edits made with other tools are not prevented. They are detected: ask Claude to validate the spec tree.

## Validating the spec tree

Ask Claude to "validate the spec tree". It checks every artifact against its template, every link between artifacts, duplicate IDs and numbers (for example after a merge), duplicate or missing versions, and every frozen copy, and every source kept with a version 0, against the hash in its approval record:

```
Found 1 problem:
- US-001 v1 was altered after approval: stories/US-001/versions/v1.md no longer matches the hash in stories/US-001/approvals/v1.yaml.
  To fix: Restore stories/US-001/versions/v1.md from git history. To change US-001, save a new version as a draft and approve it.
```

Validation never changes anything.

## Gate mode

The checks above stop an approval by default. A team can set the approve gate to `warn`, so approval goes ahead and the failing checks are shown, or `off`:

```yaml
process:
  gates:
    approve: warn
```

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-approve`, `/bk-status`.
