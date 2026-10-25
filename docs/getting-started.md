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

**2. The mode**, for a new spec tree. See [The two modes](modes.md).

- **Spec-driven**, the default: capability specs say how your system behaves, and each piece of work is a change to them, with no approvals or gates.
- **Full SDLC**: work goes through your team's stages, from business idea down, with approvals and gates.

An existing spec tree keeps its own mode, and setup tells you which it is:

```
The spec tree follows Spec-driven: capability specs say how the system behaves, and each piece of work is a change to them, with no approvals or gates.
```

**3. Whether to stamp your own commits.** While you work on a unit, BuildKeel adds a line such as `BuildKeel-Unit: TK-047` to every commit Claude makes. If you agree, a git hook adds the same line to commits you make yourself. It does nothing when no unit is active. If your repository already manages git hooks with a tool such as husky, lefthook or pre-commit, BuildKeel installs nothing and shows you the lines to add to it.

**4. Your process**, for a new Full SDLC spec tree. BuildKeel lists every file and setting it will add, then shows its default process as a table: each stage, and the documents it needs approved before work under it starts.

```
| Stage | First ID | Requires before work under it starts |
|---|---|---|
| business idea | BI-01 | nothing |
| epic | EP-01 | design document |
| user story | US-001 | test plan |
| task | TK-001 | nothing |
Documents that can be attached at any stage: test plan and design document.
Outside the stages, bug IDs start at BUG-001 and ad-hoc unit IDs at AH-001.
Gates: approve block, start block, done block, lock block (block stops the action, warn lets it go ahead with a warning, off skips the check).
A task's own test plan is recorded as it is saved, not approved.
```

Use it as it is, or describe how your team works, in your own words and all at once, such as "we call stories features, every feature needs a design doc, epics need a security review, and the gates should only warn while we try it out". Claude turns that into a process and shows the table again, saying plainly if something you asked for cannot be expressed, with the closest setting BuildKeel has. Nothing changes until you confirm. See [Process and templates](process-and-templates.md).

A Spec-driven tree has no stages, so there is no process to choose. An existing spec tree keeps the process it already has.

**5. Whether to be guided**, in a Spec-driven tree, new or existing. Press Enter to be guided through your first change: at each step, Claude adds a line or two on what just happened and what comes next, until that change is finished. Choose **Jump right in** to skip it. The answer is kept on your machine only, and you can change it at any time by saying so, such as "stop explaining".

## What it adds

For a new spec tree in this repository:

| File | What it is |
|---|---|
| `specs/buildkeel.yaml` | The spec tree's settings, with this repository registered |
| `.buildkeel.yaml` | Says which spec tree this repository uses |
| `.gitignore` | Gains `.buildkeel/`, where BuildKeel keeps local state that is never committed |
| `.git/hooks/commit-msg` | Only if you chose to stamp your own commits |

A new Spec-driven tree's `buildkeel.yaml` says `mode: spec-driven`, in format 2, which BuildKeel 0.1.0 opens read-only; a new Full SDLC tree's says `mode: full-sdlc`, in format 1.

For an existing spec tree, your repository gets only `.buildkeel.yaml`, the `.gitignore` entry and, if you chose it, the hook. The spec tree's `buildkeel.yaml` gains an entry for your repository.

For a new spec repository, BuildKeel runs `git init` in the folder unless it is already a repository, and writes its `buildkeel.yaml` with your repository registered; your repository gets the same files as for an existing spec tree. Commit the new repository's `buildkeel.yaml`, add a remote if it has none, and push it, so your other code repositories and your team can use it: in each other repository, run `/bk:init` and choose the existing spec tree.

If your repository already has history, BuildKeel records its latest commit as the **baseline**. Code up to the baseline counts as existing work: BuildKeel never reports it as untracked, and new work is traced from the start.

Setup on a repository that already holds code ends by naming the two ways to document that code, and asks nothing about it:

```
This repository already holds code: it is documented as work touches it, with a version 0 of what each change touches, or all at once with /bk:onboard, whenever you choose.
```

As work touches it, the plan for a change includes a [version 0](approval.md#version-0-code-from-before-buildkeel) of what the change touches, describing how it works today. With `/bk:onboard`, you document it area by area. You can mix the two, and neither is needed before new work starts. See [Documenting existing code](onboarding.md).

BuildKeel does not commit anything during setup. Review the changes and commit them, the spec tree's `buildkeel.yaml` included: BuildKeel commits its own records, but never your settings. Until they are committed, `/bk:status` says so, and starting a unit asks you to commit them first. If the spec tree is in another repository, commit and push it there too, so your team sees your repository registered.

Setting BuildKeel up in a repository is your team's agreement to follow its process there. In a Spec-driven tree, code changes go through changes, each finished with a review against what it specifies. In a Full SDLC tree, they go through approved units of work, and their tests are checked before work is done.

## Check the result

Run `/bk:status`. It shows your spec tree, empty for now.

## A first piece of work

In a Spec-driven tree:

1. **Talk it through.** Discuss the idea with Claude as you would without BuildKeel. When behavior comes up, Claude looks up the capability specs first.
2. **Capture it.** Run `/bk:capture`. Claude sums up what you discussed and proposes a change: a proposal saying why and what, a spec change for each capability it adds or alters, a design when it makes decisions worth keeping, and tasks. You choose the pace: step by step, each file agreed before the next, or all at once. Nothing is saved until you agree. See [Changes](changes.md).
3. **Build it.** Run `/bk:start CH-001` to make the change the active unit on its own branch, then `/bk:build` to have Claude work through its tasks, ticking each as its verification passes. See [Working on a unit](working-on-a-unit.md).
4. **Finish it.** `/bk:done` reviews the code against the change's requirements, scenarios and design, reports what is missing, and once you choose, archives the change: each capability it touched gets its next version. See [Finishing a change](finishing-a-unit.md#finishing-a-change).

The change's files stay editable until it is finished, and nothing in it is approved.

In a Full SDLC tree:

1. **Talk it through.** Discuss the idea with Claude as you would without BuildKeel: what it is for, the options, the design, the code it touches. BuildKeel stays out of the conversation: Claude explains the options and trade-offs before asking, and when you say you are done, it asks once whether you want to explore more or capture it.
2. **Capture it.** Run `/bk:capture`. Claude sums up what you discussed, then shows the artifacts your process needs, such as an epic with its design document, stories with their test plans, and tasks, and where they fit in your tree. Then it asks the pace: step by step, each artifact agreed before the next, or all at once. Claude invents nothing: it asks you about each gap. See [Drafting with Claude](drafting.md).
3. **Approve it.** Run `/bk:approve` and approve the whole plan in one review. Each artifact is checked and approved in turn, with its own record and commit. See [Approving artifacts](approval.md).
4. **Build it.** Run `/bk:build` to have Claude start, build, test and finish every ready unit in turn, or `/bk:start TK-001` to work on one unit yourself. See [Working on a unit](working-on-a-unit.md).
5. **Finish it.** `/bk:done` checks the unit's tests and records what was built. A build run does this for each unit. See [Finishing a unit](finishing-a-unit.md).

To draft one artifact at a time instead, use `/bk:new`, such as `/bk:new change`, or `/bk:new idea` for a first business idea in Full SDLC.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-init`, `/bk-status`.
