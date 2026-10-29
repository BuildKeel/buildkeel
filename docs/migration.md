# Migrating a spec tree

`/bk:migrate` does two things: it upgrades a spec tree in an older format, and it moves a Spec-driven tree to Full SDLC. It looks for a format upgrade first.

A spec tree declares its format in `buildkeel.yaml`, such as `format: 1`. Each version of BuildKeel reads and writes the formats it knows. Today that is format 3, in which every new tree is written, and formats 1 and 2, written by earlier versions. All three are current, so none needs migrating. When a later version of BuildKeel changes the format in a way older trees must follow, a tree in the older one is upgraded with `/bk:migrate`, in one commit you can review. Nothing is ever rewritten silently.

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

Claude shows what migrating changes before anything is written: the working files that change and `buildkeel.yaml`. Once you confirm, BuildKeel rewrites them and commits them alone in the spec repo as `migrate: format 3 to 4`.

Approved versions are never touched: frozen copies, approval records, completion records and re-pin records stay exactly as they were written, so every approval still matches its hash, and BuildKeel reads every format there has been. Push the spec repo afterwards. Everyone working in the tree needs a version of BuildKeel that uses the new format.

A tree already in a format BuildKeel uses has nothing to migrate:

```
The spec tree is already in format 1, the one this version of BuildKeel uses; there is nothing to migrate.
```

## A tree in a newer format

When a tree uses a newer format than your BuildKeel, you can read it but not change it. Update the plugin, then start a new session:

```
This spec tree uses format 4, which is newer than this version of BuildKeel supports (format 3). You can read it, but not change it.
To fix: Update the BuildKeel plugin, then start a new session.
```

A tree is never migrated back to an older format.

## Moving a Spec-driven tree to Full SDLC

In a Spec-driven tree with no format upgrade due, `/bk:migrate` offers to move the tree to Full SDLC: **Not now** (the default) or **Move this tree to Full SDLC**. It is refused while a change is open. Your process and its templates are set up first, as for a new Full SDLC tree, then your stages are drafted from the capability specs and archived changes, area by area, for you to review and approve; the tree stays Spec-driven until every area is approved, and the next `/bk:migrate` carries on where you stopped. Open defects keep their IDs, each under the artifact it affects. In a Full SDLC tree there is nothing to move. See [Moving a Spec-driven tree to Full SDLC](onboarding.md#moving-a-spec-driven-tree-to-full-sdlc).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-migrate`.
