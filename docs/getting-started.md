# Getting started

This guide sets up BuildKeel in a repository and walks through a first piece of work, from a conversation to finished code. You need BuildKeel installed first: see [Install in Claude Code](install-claude-code.md) or [Install in Antigravity](install-antigravity.md).

## Set up a repository

Open a session in your repository and run:

```
/bk:init
```

BuildKeel asks you a few questions, one at a time.

**1. Where your spec tree lives.**

- **In this repository**, in a `specs/` folder. Choose this if this is your team's only repository, or to try BuildKeel out. You can move the folder to its own repository later.
- **An existing spec tree**, usually its own repository that several code repositories share. Clone it first, then give its path. You can also give the path straight away: `/bk:init ../payments-specs`.
- **A new spec repository**, a repository of its own for the spec tree, which your other code repositories can then point at. Give a folder outside this repository, such as `../payments-specs`: one that does not exist yet, an empty folder, or an empty repository you have cloned from your git host.

**2. Whether to stamp your own commits.** While you work on a unit, BuildKeel adds a line such as `BuildKeel-Unit: TK-047` to every commit Claude makes. If you agree, a git hook adds the same line to commits you make yourself. It does nothing when no unit is active. If your repository already manages git hooks with a tool such as husky, lefthook or pre-commit, BuildKeel installs nothing and shows you the lines to add to it.

**3. Your process**, for a new spec tree. BuildKeel lists every file and setting it will add, then shows its default process as a table: each stage, and the documents it needs approved before work under it starts.

```
| Stage | First ID | Requires before work under it starts |
|---|---|---|
| business idea | BI-01 | nothing |
| epic | EP-01 | design document |
| user story | US-001 | test plan |
| task | TK-001 | nothing |
Documents that can be attached at any stage: test plan and design document.
```

Use it as it is, or adjust it: rename a stage (such as calling stories "features"), add a stage between the business idea and the story, or change which documents each stage requires. BuildKeel shows the table again after each change, and changes nothing until you confirm. See [Process and templates](process-and-templates.md).

An existing spec tree keeps the process it already has.

## What it adds

For a new spec tree in this repository:

| File | What it is |
|---|---|
| `specs/buildkeel.yaml` | The spec tree's settings, with this repository registered |
| `.buildkeel.yaml` | Says which spec tree this repository uses |
| `.gitignore` | Gains `.buildkeel/`, where BuildKeel keeps local state that is never committed |
| `.git/hooks/commit-msg` | Only if you chose to stamp your own commits |

For an existing spec tree, your repository gets only `.buildkeel.yaml`, the `.gitignore` entry and, if you chose it, the hook. The spec tree's `buildkeel.yaml` gains an entry for your repository.

For a new spec repository, BuildKeel runs `git init` in the folder unless it is already a repository, and writes its `buildkeel.yaml` with your repository registered; your repository gets the same files as for an existing spec tree. Commit the new repository's `buildkeel.yaml`, add a remote if it has none, and push it, so your other code repositories and your team can use it: in each other repository, run `/bk:init` and choose the existing spec tree.

If your repository already has history, BuildKeel records its latest commit as the **baseline**. Code up to the baseline counts as existing work: BuildKeel never reports it as untracked, and new work is traced from the start.

Setup on a repository that already holds code ends by naming the two ways to document that code, and asks nothing about it:

```
This repository already holds code: it is documented as work touches it, with a version 0 of what each change touches, or all at once with /bk:onboard, whenever you choose.
```

As work touches it, the plan for a change includes a [version 0](approval.md#version-0-code-from-before-buildkeel) of what the change touches, describing how it works today. With `/bk:onboard`, you document it area by area. You can mix the two, and neither is needed before new work starts. See [Documenting existing code](onboarding.md).

BuildKeel does not commit anything during setup. Review the changes and commit them, the spec tree's `buildkeel.yaml` included: BuildKeel commits its own records, but never your settings. Until they are committed, `/bk:status` says so, and starting a unit asks you to commit them first. If the spec tree is in another repository, commit and push it there too, so your team sees your repository registered.

Setting BuildKeel up in a repository is your team's agreement to follow its process there: code changes go through approved units of work, and their tests are checked before work is done.

## Check the result

Run `/bk:status`. It shows your spec tree, empty for now.

## A first piece of work

1. **Talk it through.** Discuss the idea with Claude as you would without BuildKeel: what it is for, the options, the design, the code it touches. BuildKeel stays out of the conversation until you ask to move work forward.
2. **Capture it.** Run `/bk:capture`. Claude sums up what you discussed, then shows the artifacts your process needs, such as an epic with its design document, stories with their test plans, and tasks, and where they fit in your tree. Nothing is drafted until you agree; then Claude drafts them all, and asks for anything the conversation left out. See [Drafting with Claude](drafting.md).
3. **Approve it.** Run `/bk:approve` and approve the whole plan in one review. Each artifact is checked and approved in turn, with its own record and commit. See [Approving artifacts](approval.md).
4. **Build it.** Run `/bk:build` to have Claude start, build, test and finish every ready unit in turn, or `/bk:start TK-001` to work on one unit yourself. See [Working on a unit](working-on-a-unit.md).
5. **Finish it.** `/bk:done` checks the unit's tests and records what was built. A build run does this for each unit. See [Finishing a unit](finishing-a-unit.md).

To draft one artifact at a time instead, use `/bk:new`, such as `/bk:new idea` for your first business idea.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-init`, `/bk-status`.
