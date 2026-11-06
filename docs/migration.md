# Migrating a spec tree

`/bk:migrate` does two things: it upgrades a spec tree in an older format, and it moves a Spec-driven tree to Full SDLC. It looks for a format upgrade first.

A spec tree declares its format in `buildkeel.yaml`, such as `format: 4`. Each version of BuildKeel reads and writes the formats it knows. Today that is format 4, in which every new tree is written. A tree made with BuildKeel 0.5.0 or earlier is in format 1, 2 or 3, and is upgraded with `/bk:migrate`, in one commit you can review. Nothing is ever rewritten silently.

## A tree in an older format

BuildKeel can still read it, so you can see your plan and its context, but it changes nothing until the tree is migrated:

```
This spec tree uses format 3; this version of BuildKeel uses format 4. The tree is read-only until it is migrated.
To fix: Run /bk:migrate to upgrade it in one reviewable commit.
```

## Migrate it

```
/bk:migrate
```

Claude shows what migrating changes before anything is written. From format 1, 2 or 3, only `buildkeel.yaml` changes: it gets `format: 4`, and a format 1 tree also names its mode, `mode: full-sdlc`, which it already followed. Everything this version adds goes in new files. Once you confirm, BuildKeel commits the change alone in the spec repo, such as `migrate: format 3 to 4`.

Approved versions are never touched: frozen copies, approval records, completion records and re-pin records stay exactly as they were written, so every approval still matches its hash.

Work in progress carries on. A unit started before the migration keeps its branch and claim, and you finish it as usual. Tasks written before have no Files, Uses, Delivers or Verify lines; BuildKeel reports them, and never refuses one for it. A unit with no recorded failing test before its code gets the TDD check's warning, or you state why it needed none.

Push the spec repo afterwards. Everyone working in the tree then needs this version of BuildKeel: an earlier one opens a format 4 tree read-only and asks for an update.

A tree already in a format BuildKeel uses has nothing to migrate:

```
The spec tree is already in format 4, the one this version of BuildKeel uses; there is nothing to migrate.
```

## A tree in a newer format

When a tree uses a newer format than your BuildKeel, you can read it but not change it. Update the plugin, then start a new session:

```
This spec tree uses format 4, which is newer than this version of BuildKeel supports (format 3). You can read it, but not change it.
To fix: Update the BuildKeel plugin, then start a new session.
```

This is what BuildKeel 0.5.0 says about a migrated tree. A tree is never migrated back to an older format.

## Moving a Spec-driven tree to Full SDLC

In a Spec-driven tree with no format upgrade due, `/bk:migrate` offers to move the tree to Full SDLC: **Not now** (the default) or **Move this tree to Full SDLC**. It is refused while a change is open. Your process and its templates are set up first, as for a new Full SDLC tree, then your stages are drafted from the capability specs and archived changes, area by area, for you to review and approve; the tree stays Spec-driven until every area is approved, and the next `/bk:migrate` carries on where you stopped. Open defects keep their IDs, each under the artifact it affects. The glossary, practices, ADRs, threads and notes on the code carry over as they are, and so do each archived change's working notes, test-run summaries and review findings; an accepted ADR counts as approved. In a Full SDLC tree there is nothing to move. See [Moving a Spec-driven tree to Full SDLC](onboarding.md#moving-a-spec-driven-tree-to-full-sdlc).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-migrate`.
