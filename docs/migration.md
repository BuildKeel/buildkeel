# Migrating a spec tree

A spec tree declares its format in `buildkeel.yaml`, such as `format: 1`. Each version of BuildKeel reads and writes one format. When a later version of BuildKeel changes the format, a tree in the older one is upgraded with `/bk:migrate`, in one commit you can review. Nothing is ever rewritten silently.

## A tree in an older format

BuildKeel can still read it, so you can see your plan and its context, but it changes nothing until the tree is migrated:

```
This spec tree uses format 1; this version of BuildKeel uses format 2. The tree is read-only until it is migrated.
To fix: Run /bk:migrate to upgrade it in one reviewable commit.
```

## Migrate it

```
/bk:migrate
```

Claude shows what migrating changes before anything is written: the working files that change and `buildkeel.yaml`. Once you confirm, BuildKeel rewrites them and commits them alone in the spec repo as `migrate: format 1 to 2`.

Approved versions are never touched: frozen copies, approval records, completion records and re-pin records stay exactly as they were written, so every approval still matches its hash, and BuildKeel reads every format there has been. Push the spec repo afterwards. Everyone working in the tree needs a version of BuildKeel that uses the new format.

A tree already in the format BuildKeel uses has nothing to migrate:

```
The spec tree is already in format 1, the one this version of BuildKeel uses; there is nothing to migrate.
```

## A tree in a newer format

When a tree uses a newer format than your BuildKeel, you can read it but not change it. Update the plugin, then start a new session:

```
This spec tree uses format 2, which is newer than this version of BuildKeel supports (format 1). You can read it, but not change it.
To fix: Update the BuildKeel plugin, then start a new session.
```

A tree is never migrated back to an older format.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-migrate`.
