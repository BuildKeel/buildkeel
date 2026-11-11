# Move to Full SDLC, or upgrade a tree

`/bk:migrate` does two things: it upgrades a spec tree in an older format, and it moves a Spec-driven tree to Full SDLC. It looks for a format upgrade first, and nothing is ever rewritten without your confirmation.

## Before you start

You need a repository with a spec tree, set up with `/bk:init`. To move to Full SDLC, finish or discard every open change first.

> **Approved work is never touched.** Neither task rewrites frozen copies, approval records, completion records or re-pin records. An upgrade changes only `buildkeel.yaml`; a move to Full SDLC drafts new artifacts beside your capability specs, which stay in the tree as history.

## 1. Upgrade a tree in an older format

A spec tree declares its format in `buildkeel.yaml`, such as `format: 4`. Every new tree is written in format 4. A tree made with an earlier BuildKeel is in format 1, 2 or 3: BuildKeel can still read it, so you can see your plan and its context, but it changes nothing until the tree is migrated.

1. Run `/bk:migrate`.
2. Read what migrating changes. Claude shows it before anything is written.
3. Choose **Migrate** (the default) or **Not now**.
4. Once you confirm, BuildKeel commits the change alone in the spec repo, such as `migrate: format 3 to 4`.
5. Push the spec repo.
6. Ask everyone working in the tree to update BuildKeel: an earlier version opens a format 4 tree read-only and asks for an update.

From format 1, 2 or 3, only `buildkeel.yaml` changes: it gets `format: 4`, and a format 1 tree also names its mode, `mode: full-sdlc`, which it already followed. Everything this version adds goes in new files.

> **What happens to work already done.** Every approval still matches its hash. Work in progress carries on: a unit started before the migration keeps its branch and claim, and you finish it as usual. Tasks written before have no Files, Uses, Delivers or Verify lines; BuildKeel reports them, and never refuses one for it. A unit with no recorded failing test before its code gets the TDD check's warning, or you state why it needed none.

## 2. Move a Spec-driven tree to Full SDLC

The capability specs and archived changes are the sources, and your stages are drafted from them area by area, as version 0, for you to review and approve. `/bk:onboard` only documents code, and sends you to `/bk:migrate` when you ask it to move the tree. The move goes one way. In a Full SDLC tree there is nothing to move.

1. Run `/bk:migrate`. When the tree's format needs no upgrade, Claude explains the move.
2. Choose **Not now** (the default) or **Move this tree to Full SDLC**. The move is refused while a change is open, naming each one: finish or discard them first.
3. Set up the process the tree will follow, exactly as `/bk:init` does for a new Full SDLC tree: use it as it is, or describe how your team works and answer each topic left, one at a time. See [Process: stages, kinds and documents](process-and-templates.md#1-set-up-the-process).
4. Settle a template for each stage, kind or document you add. No area is drafted until the process and its templates are settled.
5. Agree to go ahead. BuildKeel writes `onboarding/conversion.yaml`, with the templates, and commits them as `onboard: start conversion to Full SDLC`.
6. Agree the map of areas Claude proposes from the capability specs, as a table with what each covers.
7. For each area, read the table of artifacts Claude proposes, top down in your stage names, and choose **Draft them all** (the default), **Change the plan**, **Skip this area** or **Stop**.
8. Review the area's drafts, and approve them as a set. They get onboarded numbers, such as `US-E001`.
9. Agree the table of where each scenario went: the test case or criterion it became. Place or leave out any scenario that fits nothing.
10. Say which approved artifact each open defect without a parent affects, when Claude asks.
11. Repeat for each area. You can stop after any one: the next `/bk:migrate` carries on.
12. When every area is converted, confirm the switch. BuildKeel writes `mode: full-sdlc` and your process to `buildkeel.yaml`, marks the conversion finished with who and when, writes each open defect's new parent, and commits them on their own as `onboard: switch to Full SDLC`.
13. Push the spec repo.

From the start of the conversion until the switch, no change can be opened, while defects, ad-hoc units and looking up capability specs work as usual. The tree stays Spec-driven until every area is converted.

> **What happens to work already done.** Defects and ad-hoc units keep their numbering, and open defects keep their IDs, each under the artifact it affects. The glossary, practices, ADRs, threads and notes on the code carry over as they are, and so do each archived change's working notes, test-run summaries and review findings; an accepted ADR counts as approved.

## Formats and their messages

When a tree is in an older format, BuildKeel says so, and changes nothing until it is migrated:

```text title="A tree in an older format"
This spec tree uses format 3; this version of BuildKeel uses format 4. The tree is read-only until it is migrated.
To fix: Run /bk:migrate to upgrade it in one reviewable commit.
```

A tree already in the format BuildKeel uses has nothing to migrate:

```text title="/bk:migrate"
The spec tree is already in format 4, the one this version of BuildKeel uses; there is nothing to migrate.
```

When a tree uses a newer format than your BuildKeel, you can read it but not change it. Update the plugin, then start a new session:

```text title="A tree in a newer format"
This spec tree uses format 4, which is newer than this version of BuildKeel supports (format 3). You can read it, but not change it.
To fix: Update the BuildKeel plugin, then start a new session.
```

This is what an earlier BuildKeel says about a migrated tree. A tree is never migrated back to an older format.

## The conversion in detail

### The map

Each area holds one or more capability specs, and each capability spec is in one area:

```yaml
areas:
  - name: Signing in
    repo: accounts-api
    capabilities: [AUTH]
  - name: Notifications
    repo: accounts-api
    capabilities: [NOTIF]
```

### Each area

Claude reads the area's capability specs and the archived changes that wrote them, and proposes the artifacts your stages need, top down, as for any area of existing code (see [Start on existing code](onboarding.md)). Each change it draws on is kept as a source of the version 0 it fed, with the change's ID as its key. Requirements become acceptance criteria and scenarios become test cases wherever they fit your stages; nothing maps one to one, so a stage your team added is drafted like any other. Claude adds nothing the sources do not support, and asks you about each required section nothing supports, with **Leave it empty** as a choice. A document no source provides, such as a design document, is drafted as version 1.

### Where each scenario went

Once the area is approved, Claude shows a table of each scenario and the test case or criterion it became, and records it. A scenario that fits nothing is listed for you: you place it, or leave it out, and nothing is left out without your word. The record, `onboarding/conversion.yaml`, keeps both:

```yaml
startedBy: Jane Doe <jane@example.com>
startedAt: 2026-10-14T09:00:00Z
process: {}
placed:
  AUTH-R1-S1: US-E001-TC1
  AUTH-R2-S1: US-E001-TC3
  AUTH-R3-S1: US-E001-TC4
dropped: {}
```

An area is converted once each of its scenarios is placed or left out, and each open defect in it has a parent. Where it stands, from `/bk:migrate`:

```text title="/bk:migrate"
Converting to Full SDLC, started by Jane Doe <jane@example.com> on 2026-10-14: 0 of 2 areas converted. The tree stays Spec-driven until every area is; /bk:migrate carries the conversion on.

| Area | Capability specs | Where it stands |
|---|---|---|
| Signing in | AUTH | 3 of 4 scenarios placed or left out |
| Notifications | NOTIF | not started |

Open defects, carried over with their IDs:
- DEF-001 "Reset email lands in spam" (in no area): no parent yet; it could go under US-E001
An open defect with no parent keeps its area from being converted. Ask the user which approved artifact it affects, then record it with manage action=convert, convert=place and defects, such as { DEF-006: US-E001 }.

Not placed yet, in areas already begun: AUTH-R1-S2 "Wrong password". Place each on the criterion or test case it became, or leave it out if the user says so; nothing is dropped without their choice.

Next: Signing in.
```

### Open defects

Open defects keep their IDs. A defect linked to a requirement goes under the artifact that requirement's scenarios became, such as `US-E001`. Any other open defect is listed with the area its change or its code falls in, and Claude asks you which approved artifact it affects; its area is not converted until you choose. When the tree switches, each open defect's file names its new parent, and a scenario that found it becomes the test case it was placed on.

### Stopping and cancelling

You can stop after any area: the tree stays Spec-driven, and the next `/bk:migrate` carries on. Until the first area is approved you can also cancel, which removes the conversion and its drafts in one commit.

## After the switch

From then on work goes through your stages, approvals and gates.

- A test tagged with a scenario, such as `[AUTH-R3-S1]`, counts for the test case it became. Recording a report names each one, and Claude retags the test with the test case's ID the next time it changes it.
- Code that archived changes wrote stays linked: asking what describes a file names the change and the artifacts its requirements became.
- Each open defect goes under the artifact the conversion gave it, and a scenario that found it becomes the test case it was placed on.
- Each converted artifact names where its entries came from, so you can find the change behind a criterion:

  ```text
  Converted from the tree's capability specs (kept, read-only, as history):
  - US-E001-TC1: scenario AUTH-R1-S1 of requirement AUTH-R1, added by CH-001 (AUTH v1)
  - US-E001-TC3: scenario AUTH-R2-S1 of requirement AUTH-R2, added by CH-001 (AUTH v1)
  - US-E001-TC4: scenario AUTH-R3-S1 of requirement AUTH-R3, added by CH-002 (AUTH v2)
  ```

The capability specs, archived changes and the conversion's record stay in the tree, read-only: the lock gate refuses edits to them, and validation checks them as before.

**More:** [Choose a mode](modes.md), [Full SDLC mode in depth](how-full-sdlc-works.md), [Start on existing code](onboarding.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-migrate`.
