# Changes

In a Spec-driven spec tree, each piece of work is a **change**. It says why the work is done, how it changes the behavior described in the [capability specs](capability-specs.md), how it is built when that needs saying, and the tasks to get there. A change stays open and editable until it is finished, and nothing in it is ever approved. See [The two modes](modes.md) for how the modes differ.

## A change's files

```
<spec root>/
  changes/CH-012/proposal.md      why the change is made and what it changes
  changes/CH-012/specs/AUTH.md    a spec change: how it alters the AUTH capability
  changes/CH-012/design.md        how it is built, only when that needs recording
  changes/CH-012/tasks.md         the tasks, as numbered checkboxes
```

Claude drafts a change from a conversation with `/bk:capture`, or with `/bk:new` (see [Drafting with Claude](drafting.md#in-a-spec-driven-tree)). Each file follows its template, which your team can replace or add rules to (see [Process and templates](process-and-templates.md)).

### The proposal

```markdown
---
id: CH-012
title: Password reset by text message
capabilities: [AUTH]
---

## Why

Users who cannot get to their email cannot reset their password.

## What changes

- Users with a verified phone can ask for a six-digit reset code by text message.
- A code expires 10 minutes after it is sent and works once.

## Capabilities

- **AUTH** (modified): password reset by text message.

## Impact

The reset endpoint, and a text message provider.
```

The proposal says why, what changes (marking anything that breaks existing users or callers as **BREAKING**), which capabilities are new or modified, and the impact. Its `capabilities` field lists the same codes. A change that alters no behavior, such as a refactor, says so with `noSpecChanges: true` and has no spec changes.

### Spec changes

A spec change alters one capability, naming each existing requirement by its ID:

```markdown
---
capability: AUTH
base: 1
---

## Added

### AUTH-R3 Reset by text message
The system SHALL text a six-digit reset code to a user's verified phone on request.

#### AUTH-R3-S1 Verified phone
- **WHEN** a user with a verified phone asks for a reset code by text
- **THEN** a six-digit code is texted to that phone

## Modified

### AUTH-R2 Request a reset link
The system SHALL email a password reset link to a registered address on request, unless the user asked for a code by text.

#### AUTH-R2-S1 Registered address
- **WHEN** a user asks for a reset link for a registered email
- **THEN** a reset link is emailed to that address
```

- **Added**: new requirements, each with its scenarios. They get their IDs when the change is saved.
- **Modified**: existing requirements by ID, each with its full new text and every scenario it keeps or gains. A new name under the same ID renames it, so tests tagged with its scenarios stay linked.
- **Removed**: requirements that no longer apply, each with a **Reason** and a **Migration** line saying what users or callers do instead.
- `base` is the version of the capability the spec change was written against. BuildKeel records it when the spec change is first saved, so finishing can tell when another change reached the same capability first.

A spec change for a capability the tree does not have yet creates it: it gives the capability's `title` and a **Purpose** section, and every requirement goes under Added. Claude proposes the capability's code, which you can change before it is saved.

Capability specs are never edited directly. A change's spec changes are merged into them only when the change is finished.

### The design

A change's design uses the built-in design document, with the change as its parent. It is optional: Claude drafts one when the change makes decisions worth recording, such as a new component, data, an interface or a trade-off. A question that can safely wait goes in an **Open questions** section. See [Process and templates](process-and-templates.md#the-design-document).

### Tasks

```markdown
---
parent: CH-012
---

## 1. Sending a code by text

- [ ] 1.1 Generate a six-digit code and store it with its send time. Verify: code store tests.
- [ ] 1.2 Text the code to the user's verified phone. Verify: the "Verified phone" scenario test (AUTH-R3-S1).
```

Tasks are numbered checkboxes in groups, ordered so that each builds on the ones before. Each says how its completion is verified, and each group includes the tests and documentation its own work needs. A task is ticked once its verification passes; a box holding an `x` is ticked. The change's progress is its ticked tasks, such as 1 of 2.

## Editing an open change

Every file of an open change can be changed at any time, by you or by Claude, with no new version and no approval: narrow the proposal after three tasks are done, rewrite a requirement, or add a task. Several changes can be open at once.

When Claude edits one file of a change, it checks the others against the edit and proposes the follow-on edits in the same reply, for you to accept or decline: a design decision that changes may mean two tasks change too. It never edits code as part of this.

## What BuildKeel checks

Nothing in a change is ever blocked. Each time a file is saved, BuildKeel reports what it lacks against its template, what does not fit the capability it changes (an added requirement that already exists, a modified or removed one that does not, a removal with no reason or migration, a requirement with no scenario), and where the proposal and the spec changes disagree:

```
CH-012: its proposal names AUTH, but it has no spec change for AUTH.
To fix: Add a spec change for AUTH, or remove AUTH from the proposal's capabilities.
```

The status overview and finishing a change report the same, and also references to requirements the change removes, scenarios with no tagged test, test tags naming no scenario, and ticked tasks whose requirement changed after the tick.

## Finishing a change

`/bk:done` finishes a change by archiving it: its spec changes are merged into the capability specs, each capability it touches gets its next version, and its files are frozen as its record. See [Finishing a change](finishing-a-unit.md#finishing-a-change).

## Discarding a change

A change you will not go on with can be discarded: ask Claude to discard it, such as "discard CH-002, it was replaced by CH-016". Claude first shows what goes:

```
Discarding CH-002 "Reset links expire" will:
- remove its 4 files: changes/CH-002/design.md, changes/CH-002/proposal.md, changes/CH-002/specs/AUTH.md, changes/CH-002/tasks.md
- write its discard record, changes/CH-002/discarded.yaml: its ID, title, who discarded it, when, and the reason
- commit both as "discard: CH-002" in the spec repo

No capability spec changes. The IDs it gave (AUTH-R3, AUTH-R3-S1) are never used again. Commits stamped with CH-002 stay with it, shown as belonging to a discarded change.
```

Nothing is removed until you confirm. Then the change's files are removed and its discard record is written, in one commit:

```yaml
change: CH-002
title: Reset links expire
discardedBy: Jane Doe <jane@example.com>
discardedAt: 2026-10-14T10:15:00Z
reason: replaced by CH-016
ids:
  - AUTH-R3
  - AUTH-R3-S1
```

- Only an open change can be discarded: an archived change is the record of work that was done.
- No capability changes, and the change's numbers, and those of the requirements and scenarios it added, are never given again.
- Discarding the active change releases its claim and clears it. A change another working tree on this machine is working on is discarded there.
- Commits stamped with the discarded change stay with it: the status overview shows them as belonging to a discarded change, with its reason.
- The discard record is never edited; the agent is blocked from changing it.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-capture`, `/bk-new`, `/bk-start`.
