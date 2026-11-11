# Your first change

This page sets up BuildKeel in a repository and walks through a first piece of work, from a conversation to finished code.

## Before you start

You need BuildKeel installed in Claude Code or Antigravity. See [Install](install.md).

## 1. Set up a repository

`/bk:init` asks you a few questions, one at a time, and sets up the repository from your answers.

1. Open a session in your repository.
2. Run:

   ```
   /bk:init
   ```

3. If the folder is not a git repository, let BuildKeel run `git init` for you when it offers.
4. Answer each question. You can answer in your own words: after each answer, Claude says what it settled and what is left, and it never fills in what you did not say.

### What each question means

**Where your spec tree lives.**

- **In this repository**, in a `specs/` folder. Choose this if this is your team's only repository, or to try BuildKeel out. You can move the folder to its own repository later.
- **An existing spec tree**, usually its own repository that several code repositories share. Clone it first, then give its path. You can also give the path straight away: `/bk:init ../payments-specs`.
- **A new spec repository**, a repository of its own for the spec tree, which your other code repositories can then point at. Give a folder outside this repository, such as `../payments-specs`: one that does not exist yet, an empty folder, or an empty repository you have cloned from your git host.

**The mode**, for a new spec tree. See [Choose a mode](modes.md).

- **Spec-driven**, the default: capability specs say how your system behaves, and each piece of work is a change to them, with no approvals or gates.
- **Full SDLC**: work goes through your team's stages, from business idea down, with approvals and gates.

An existing spec tree keeps its own mode, and setup tells you which it is:

```text title="/bk:init"
The spec tree follows Spec-driven: capability specs say how the system behaves, and each piece of work is a change to them, with no approvals or gates.
```

**Whether to stamp your own commits.** While you work on a unit, BuildKeel adds a line such as `BuildKeel-Unit: TK-047` to every commit Claude makes. A git hook adds the same line to commits you make yourself, unless you choose **Don't stamp them**. **Stamp my commits** is the default. It does nothing when no unit is active. Ask Claude to turn it off or on at any time. If your repository already manages git hooks with a tool such as husky, lefthook or pre-commit, BuildKeel installs nothing and shows you the lines to add to it.

**Your process**, for a new Full SDLC spec tree. BuildKeel lists every file and setting it will add, then shows its default process as a table: each stage, and the documents it needs approved before work under it starts.

```text title="/bk:init"
| Stage | Kind | First ID | Requires before work under it starts |
|---|---|---|---|
| business idea | business idea | BI-01 | nothing |
| epic | epic | EP-01 | design document |
| user story | user story | US-001 | test plan |
| task | task | TK-001 | nothing |
Documents that can be attached at any stage: test plan and design document.
Outside the stages, defect IDs start at DEF-001 and ad-hoc unit IDs at AH-001. A reported defect's parent is the work it affects: a user story.
Gates: approve block, start block, done block, lock block (block stops the action, warn lets it go ahead with a warning, off skips the check).
A task's own test plan is recorded as it is saved, not approved.
```

- Use it as it is, or say how your team works differently, in your own words, as much or as little as you like.
- Claude then asks about each topic your answer did not cover, one at a time: the stages, kinds of work within a stage, ID prefixes, the documents each stage requires, task test plans and the gates.
- It shows the whole process again in the same layout, saying plainly if something you asked for cannot be expressed, with the closest setting BuildKeel has.
- Each stage, kind or document you add needs a template: Claude drafts it, or you provide your own, and each is agreed before anything is written.

See [Process: stages, kinds and documents](process-and-templates.md) and [Full SDLC mode in depth](how-full-sdlc-works.md).

**Your numbering**, for a new Spec-driven spec tree. BuildKeel shows how the tree's IDs read: changes `CH-001`, requirements `AUTH-R1`, scenarios `AUTH-R1-S1`, defects and ad-hoc units. Keep them, or change them to match your team's, such as `RFC-0012`. See [Spec-driven mode in depth](how-spec-driven-works.md).

An existing spec tree keeps the process and numbering it already has.

**Whether to be guided**, in a Spec-driven tree, new or existing. Press Enter to take **Guide me through my first change**: at each step, Claude adds a line or two on what happened and what comes next, until that change is finished. Choose **Jump right in** to skip it. The answer is kept on your machine only, and you can change it at any time by saying so, such as "stop explaining".

## 2. Review and commit what it adds

BuildKeel does not commit anything during setup. You review the new files and commit them.

1. Look over the files setup added, listed below.
2. Commit them, the spec tree's `buildkeel.yaml` included. BuildKeel commits its own records, but never your settings.
3. If the spec tree is in another repository, commit and push it there too, so your team sees your repository registered.
4. For a new spec repository, commit its `buildkeel.yaml`, add a remote if it has none, and push it. Then, in each other code repository, run `/bk:init` and choose the existing spec tree.

Until the settings are committed, `/bk:status` says so, and starting a unit asks you to commit them first.

### The files

For a new spec tree in this repository:

| File | What it is |
|---|---|
| `specs/buildkeel.yaml` | The spec tree's settings, with this repository registered |
| `.buildkeel.yaml` | Says which spec tree this repository uses |
| `.gitignore` | Gains `.buildkeel/`, where BuildKeel keeps local state that is never committed |
| `.git/hooks/commit-msg` | Unless you chose not to stamp your own commits |

A new tree's `buildkeel.yaml` names its mode, `mode: spec-driven` or `mode: full-sdlc`, in format 4, which older versions of BuildKeel open read-only.

For an existing spec tree, your repository gets only `.buildkeel.yaml`, the `.gitignore` entry and, if you chose it, the hook. The spec tree's `buildkeel.yaml` gains an entry for your repository.

For a new spec repository, BuildKeel runs `git init` in the folder unless it is already a repository, and writes its `buildkeel.yaml` with your repository registered. Your repository gets the same files as for an existing spec tree.

### Code that is already there

If your repository already has history, BuildKeel records its latest commit as the **baseline**. Code up to the baseline counts as existing work: BuildKeel never reports it as untracked, and new work is traced from the start.

Setup on a repository that already holds code ends by naming the two ways to document that code, and asks nothing about it:

```text title="/bk:init"
This repository already holds code: it is documented as work touches it, with a version 0 of what each change touches, or all at once with /bk:onboard, whenever you choose.
```

As work touches it, the plan for a change includes a version 0 of what the change touches, describing how it works today. With `/bk:onboard`, you document it area by area. You can mix the two, and neither is needed before new work starts. See [Start on existing code](onboarding.md).

> **What setting it up means.** Setting BuildKeel up in a repository is your team's agreement to follow its process there. In a Spec-driven tree, code changes go through changes, each finished with a review against what it specifies. In a Full SDLC tree, they go through approved units of work, and their tests are checked before work is done.

## 3. Check the result

Two commands show what setup did.

1. Run `/bk:status`. It shows your spec tree, empty for now.
2. Run `/bk:settings` to see how the repository is set up: the mode, the process and its gates or the numbering, and the templates. You can run it at any time.

## 4. Make your first change

The first piece of work goes from a conversation to finished code. The steps differ by mode.

### In Spec-driven

1. **Talk it through.** Discuss the idea with Claude as you would without BuildKeel. When behavior comes up, Claude looks up the capability specs first. See [Talk it through and explore](exploring.md).
2. **Capture it.** Run `/bk:capture`. Claude sums up what you discussed and proposes a change: a proposal saying why and what, a spec change for each capability it adds or alters, a design when it makes decisions worth keeping, and tasks. You choose the pace: step by step, each file agreed before the next, or all at once. Nothing is saved until you agree. See [Capture a plan](capture.md).
3. **Build it.** Run `/bk:build CH-001` to make the change the active unit on its own branch and have Claude work through its tasks, ticking each as its verification passes. See [Build](working-on-a-unit.md).
4. **Finish it.** Run `/bk:done`. It reviews the code against the change's requirements, scenarios and design, reports what is missing, and once you choose, archives the change: each capability it touched gets its next version. See [Finish](finishing-a-unit.md).

The change's files stay editable until it is finished, and nothing in it is approved.

### In Full SDLC

1. **Talk it through.** Discuss the idea with Claude as you would without BuildKeel: what it is for, the options, the design, the code it touches. BuildKeel stays out of the conversation. Claude explains the options and trade-offs before asking, and when you say you are done, it asks once whether you want to explore more or capture it. See [Talk it through and explore](exploring.md).
2. **Capture it.** Run `/bk:capture`. Claude sums up what you discussed, then shows the artifacts your process needs, such as an epic with its design document, stories with their test plans, and tasks, and where they fit in your tree. Then it asks the pace: step by step, each artifact agreed before the next, or all at once. Claude invents nothing: it asks you about each gap. See [Capture a plan](capture.md).
3. **Approve it.** Run `/bk:approve` and approve the whole plan in one review. Each artifact is checked and approved in turn, with its own record and commit.
4. **Build it.** Run `/bk:build` to have Claude start, build, test and finish every ready unit in turn, or `/bk:build TK-001` for one unit. See [Build](working-on-a-unit.md).
5. **Finish it.** Run `/bk:done`. It checks the unit's tests and records what was built. A build run does this for each unit. See [Finish](finishing-a-unit.md).

To draft one artifact at a time instead, use `/bk:new`, such as `/bk:new change`, or `/bk:new idea` for a first business idea in Full SDLC.

**More:** [Choose a mode](modes.md), [Start on existing code](onboarding.md), [Spec-driven mode in depth](how-spec-driven-works.md), [Full SDLC mode in depth](how-full-sdlc-works.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-init`.
