# Setting up a Full SDLC tree

This guide follows `/bk:init` from start to finish for a team that wants **Full SDLC**: work goes through your stages, from business idea down, with approvals and gates. It explains every question setup asks, in the order it asks them, why it asks, and what each answer does. By the end you have a spec tree ready for work. If you have not chosen a mode yet, see [Choosing a mode](comparing-modes.md); for the other mode, see [Setting up a Spec-driven tree](setting-up-spec-driven.md).

You need BuildKeel installed: see [Install in Claude Code](install-claude-code.md) or [Install in Antigravity](install-antigravity.md). Commands are shown in Claude Code's form; in Antigravity, use a hyphen: `/bk-init`.

## How setup asks

Setup asks one thing at a time and waits for your answer. Where a question has a default, the default is the first answer, and it names the actual value, such as "keep the start gate at block". Press Enter, or say so, to keep it.

You can always answer in your own words, covering several questions at once or only part of one. After each answer, Claude says which topics your answer settled, with what it understood for each, and which are left, then asks the next one. Claude never fills in what you did not say: anything it works out on its own, such as an ID prefix for a stage you added, is offered as a suggestion for you to confirm or change. When an answer is unclear, Claude asks about it; when it conflicts with something you said earlier, Claude names both and asks which holds.

Nothing is written until you have seen everything that will be set up, in full, and agreed to it.

## Before the first question: the folder

Setup first checks that the folder you run it in is a git repository. BuildKeel links code to its specs through git commits, so it needs one. When the folder is not a repository yet, setup tells you so before anything else:

```
/home/ana/payments is not a git repository. BuildKeel links code to its specs through git, so setup needs one. Nothing has been written.
```

Claude then asks: **Run git init for me** (the default) or **Stop**. With the first, BuildKeel runs `git init` in the folder:

```
Ran git init in /home/ana/payments: it is a git repository now, with no commits yet. Nothing else has been written. Ask the first setup question.
```

The last sentence is for Claude: it goes on to the first question. A folder that is already a repository goes straight on, and one already set up stops here, with how to point it at another spec tree.

## 1. Where the spec tree lives

The spec tree holds your plan: business ideas, epics, stories, tasks and their documents, with every approval.

- **In this repository**, in a `specs/` folder. Choose this for a team with one repository, or to try BuildKeel out.
- **An existing spec tree**, usually a repository of its own that several code repositories share. Clone it first and give its path. An existing tree keeps its own mode and process, so the rest of this guide does not apply: setup only registers your repository.
- **A new spec repository**, a repository of its own for the tree. Give a folder outside this repository, such as `../payments-specs`.

See [The spec tree](spec-tree.md).

## 2. The mode

Choose **Full SDLC**. **Spec-driven** is listed first, as the default. A tree keeps the mode it is created with; a Spec-driven tree can be moved to Full SDLC later with `/bk:migrate`, but not back. See [The two modes](modes.md).

## 3. Stamping your own commits

While a unit of work is active, BuildKeel adds a line such as `BuildKeel-Unit: TK-047` to every commit Claude makes, so each commit traces to the work it belongs to. If you agree, a git hook adds the same line to commits you make yourself, such as in a terminal. It does nothing when no unit is active. If your repository already manages its git hooks with a tool such as husky or lefthook, BuildKeel installs nothing and shows you the lines to add.

## 4. What setup will add

Setup now lists every file and setting it would add, and ends with BuildKeel's default process as a table:

```
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

Read it as the path of every piece of work: a business idea is split into epics, an epic into user stories, and a story into tasks when it spans more than one piece of code. Each row says what must be approved before work under it can start. "Outside the stages" are defects and small ad-hoc changes. An ad-hoc change, and a defect found while building, need no plan; a defect that users, customers or testers report sits under the work it affects and is approved like any artifact. Which kinds it can sit under is set by `defect.parents` in `buildkeel.yaml`, a user story by default: setup does not ask, and you can change it later (see [Process and templates](process-and-templates.md#seeing-and-changing-your-settings)). See [Process and templates](process-and-templates.md) for the parts of the process in detail.

Claude then asks whether your team uses this process as it is, or works differently.

- **Use it as it is**: nothing more is asked about the process. Go on to [Confirm and set up](#7-confirm-and-set-up).
- **It works differently**: describe how your team works, in your own words. Say as much or as little as you like: Claude asks about everything your description leaves out, one topic at a time, in this order.

## 5. Your process, topic by topic

### Stages

The stages are the levels work moves through. Business idea, epic and user story always exist; you can rename them, and the task stage is optional. You can add stages of your own between the business idea and the user story.

- **Renaming**: "we call stories features". The stage keeps what it is: BuildKeel still treats it as a user story for test plans, context and change impact, and uses your name everywhere it talks to you.
- **Adding**: "we have a feature level between epics and stories". An added stage behaves like an epic: it is approved, the stage below sits under it, and it is finished once everything under it is.

When you name a stage the default process does not have, Claude asks where it goes. Say your answer was:

> There are 5 stages: business idea, epic, feature, user story, task.

Feature could be a level of its own, with user stories under features, or a kind of work beside user stories (see the next topic). Claude asks which, and does not decide for you.

Work is done on stories, tasks, defects and ad-hoc units, so nothing can be added below a story. If you describe a stage after the code is built, such as a QA sign-off, Claude says the process has no such stage and offers the closest setting, such as the done gate's checks.

### Kinds within a stage

A stage can hold more than one kind of work. For example, your story stage might hold user stories, features and enhancements: all three are planned, approved, tested and built the same way, with acceptance criteria, a test plan and tasks under them, but your team names and tracks them separately. Each kind:

- is numbered in its own sequence: `US-001`, `FEAT-001`, `EN-001`;
- has its own template, so a feature can ask for different sections than a user story;
- has its own required documents, so features can need a design document while user stories do not;
- behaves as its stage does: a task can sit under any kind at the story stage, and takes its test cases.

When you capture new work, Claude proposes which kind it is, from where the work came from, and asks you to confirm it. Most teams need one kind per stage, which is the default.

### ID prefixes and numbering

Each stage and kind has a prefix and a number of digits: `US-001` is the prefix `US` with three digits. The default prefixes are in the table above. Examples of other numbering:

- `FEAT-0001`: prefix `FEAT`, four digits;
- `ST-01`: prefix `ST`, two digits;
- `PROJ-12`: prefix `PROJ`, two digits, if your tracker numbers that way.

Every stage and kind needs its own prefix, of 1 to 8 capital letters or digits, starting with a letter. A stage or kind you add has no default, so Claude suggests one, such as `FEAT` for feature, and says it is a suggestion you can change. IDs are given when an artifact is first approved, and never change.

### Documents each stage and kind requires

Documents describe how a stage's work is tested or built, and live with the artifact they belong to. Two are built in: the **test plan** (`US-001-TP`) and the **design document** (`EP-01-DD`). By default an epic needs an approved design document, and a story an approved test plan with no gaps, before work under it can start.

You can require different documents of each stage or kind, rename the built-in ones ("we call design documents tech specs"), and add documents of your own, such as a security review or a threat model, each with a two to four letter suffix for its IDs (`EP-01-SR`). Examples:

- "every feature needs a design doc": features require a test plan and a design document;
- "epics need a security review": a new document type, required of epics;
- "we don't write design docs for epics": epics require nothing.

### Test plans for tasks

Every story's test plan is approved. A task can also have a test plan of its own, for tests that are none of its story's test cases, such as the tests of a building block like a database client. By default a task's own plan is **recorded** as it is saved, with no approval, since the task itself was approved. Choose **approved** if your team wants every test plan reviewed.

### Gates

BuildKeel checks your work at four gates:

| Gate | Checks |
|---|---|
| approve | before an artifact is approved: it follows its template, and its parent is approved |
| start | before work starts: everything above the unit is approved and not suspect, and its required documents are approved |
| done | before a unit is finished: its test cases pass |
| lock | before the agent edits approved versions and records |

Each gate has a mode:

- **block**, the default: a failing check stops the action, with what to do about it. Choose it when you want the process to hold.
- **warn**: the action goes ahead, and each failing check is shown. Choose it while your team tries BuildKeel out, or adopts it a little at a time.
- **off**: the gate is not checked. Choose it only for a check your team does elsewhere.

Many teams start with every gate on warn and move them to block once the team is used to the flow.

### One answer, several topics

You do not have to answer topic by topic. Say your first answer was:

> Five stages: business idea, epic, feature, user story, task, and the gates should only warn for now.

Claude says what that settled: the stages, with feature as an added stage once you have confirmed where it sits, and every gate on warn. It lists what is left, kinds, prefixes, documents and test plans, and asks about kinds next. BuildKeel keeps the same count, so nothing can be written while a topic is left:

```
Setup topics settled: stages, gates. Left: kinds, prefixes, documents, test plans.
```

If a later answer conflicts with an earlier one, such as "every story needs a design doc" and then "features don't", Claude names both and asks whether features are the exception.

## 6. The process, as you described it

When no topic is left, Claude shows the whole process in the same layout as the default, with a line on what each stage or kind you added means. For a story stage with features and enhancements beside user stories:

```
| Stage | Kind | First ID | Requires before work under it starts |
|---|---|---|---|
| business idea | business idea | BI-01 | nothing |
| epic | epic | EP-01 | design document |
| user story | user story | US-001 | test plan |
|  | feature | FEAT-001 | test plan, design document |
|  | enhancement | EN-001 | test plan |
| task | task | TK-001 | nothing |
Documents that can be attached at any stage: test plan and design document.
Outside the stages, defect IDs start at DEF-001 and ad-hoc unit IDs at AH-001. A reported defect's parent is the work it affects: a user story.
Gates: approve block, start block, done block, lock block (block stops the action, warn lets it go ahead with a warning, off skips the check).
A task's own test plan is recorded as it is saved, not approved.

What each stage and kind the team added means:
- feature (FEAT-001, a kind of user story built as a user story is): tasks sit under features; a feature is approved before work on it or under it starts; it is finished with /bk:done once its work is done, or once the tasks under it are.
- enhancement (EN-001, a kind of user story built as a user story is): tasks sit under enhancements; an enhancement is approved before work on it or under it starts; it is finished with /bk:done once its work is done, or once the tasks under it are.
```

Answer **go ahead** (the default), **change something**, in your own words, or **stop**, which writes nothing. After a change, Claude shows the whole table again, in the same layout.

## 7. Templates

Every stage, kind and document needs a template: it says what an artifact of that type must contain, and BuildKeel checks each artifact against it before it can be approved. The built-in stages and documents have built-in templates. Each stage, kind or document you added needs one of its own, and setup lists them:

```
Templates the process needs beyond the built-in ones:
- feature, for the feature kind at the user story stage: not given yet
- enhancement, for the enhancement kind at the user story stage: not given yet
```

Once you have agreed the process, Claude takes them one at a time. For each, it asks:

- **Claude drafts it** (the default). Claude starts from the closest built-in template, such as the user story template for a kind at the story stage, the epic template for a stage added above the story, or the design document template for a document of your own, and changes it to what you said about it. It shows you the template in full, and you use it or ask for changes.
- **I'll provide a file**. Give the path of your team's template. BuildKeel checks it with the same check validation uses. If it does not fit the template format, such as a file with no sections BuildKeel can read, Claude shows what is wrong and asks: **Claude fixes it** (the default) or **Use another file**. A fixed template is shown in full before it is used.

A template cannot be left for later: without it, nothing drafted of that type could be checked, and the new tree would fail validation straight away. If you ask to skip one, Claude explains this and asks again. Setup refuses to write while one is missing:

```
Nothing was written: setup is not settled yet.
- The process needs a template for the feature kind at the user story stage, and none was given.
  To fix: Settle it with the user: Claude drafts it from the closest built-in template, or the user provides a file; then pass it in templates as feature.
```

To change a template later, edit it in your spec tree's `templates/` folder. See [Templates](process-and-templates.md#templates).

## 8. Confirm and set up

Claude shows everything setup will write, in full, and asks whether to set up with it. Once you agree, BuildKeel writes the spec tree's settings, with your process, and every template you agreed, together, so the new tree passes validation from the start. It commits nothing: review the changes and commit them. See [Getting started](getting-started.md#what-it-adds) for each file it adds.

## Three complete processes

Each process below is shown as setup's table and as the `buildkeel.yaml` it writes. Your process can be changed later in the same file; see [Changing the process](process-and-templates.md#changing-the-process).

### The default chain

One kind at each stage, every gate blocking. A team that uses the process as it is gets a `buildkeel.yaml` with no process section:

```yaml
format: 3
mode: full-sdlc
repos:
  - name: payments
```

```
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

### User stories, features and enhancements

The story stage holds three kinds. Features also need a design document, and the templates `templates/feature.md` and `templates/enhancement.md` are settled at setup. A defect someone reports can sit under a user story or a feature, set by `defect.parents`.

```yaml
format: 3
mode: full-sdlc
repos:
  - name: payments
process:
  chain:
    - type: idea
    - type: epic
    - type: story
      kinds:
        - type: feature
          prefix: FEAT
          requires: [test-plan, design]
        - type: enhancement
          prefix: EN
    - type: task
  defect:
    parents: [story, feature]
```

```
| Stage | Kind | First ID | Requires before work under it starts |
|---|---|---|---|
| business idea | business idea | BI-01 | nothing |
| epic | epic | EP-01 | design document |
| user story | user story | US-001 | test plan |
|  | feature | FEAT-001 | test plan, design document |
|  | enhancement | EN-001 | test plan |
| task | task | TK-001 | nothing |
Documents that can be attached at any stage: test plan and design document.
Outside the stages, defect IDs start at DEF-001 and ad-hoc unit IDs at AH-001. A reported defect's parent is the work it affects: a user story or a feature.
Gates: approve block, start block, done block, lock block (block stops the action, warn lets it go ahead with a warning, off skips the check).
A task's own test plan is recorded as it is saved, not approved.

What each stage and kind the team added means:
- feature (FEAT-001, a kind of user story built as a user story is): tasks sit under features; a feature is approved before work on it or under it starts; it is finished with /bk:done once its work is done, or once the tasks under it are.
- enhancement (EN-001, a kind of user story built as a user story is): tasks sit under enhancements; an enhancement is approved before work on it or under it starts; it is finished with /bk:done once its work is done, or once the tasks under it are.
```

A kind's `requires` defaults to its stage's: enhancements need a test plan, as user stories do. A kind's folder is its type, such as `feature/FEAT-001/feature.md`, unless you set `dir`.

### An added stage, a document of your own, and gates that warn

A feature level between epics and stories, a security review required of every epic, and every gate but the lock gate on warn while the team tries BuildKeel out. Setup settles two templates: `templates/feature.md` and `templates/security-review.md`.

```yaml
format: 3
mode: full-sdlc
repos:
  - name: payments
process:
  chain:
    - type: idea
    - type: epic
      requires: [design, security-review]
    - type: feature
      prefix: FT
      dir: features
    - type: story
    - type: task
  documents:
    - type: security-review
      name: security review
      suffix: SR
  gates:
    approve: warn
    start: warn
    done: warn
    lock: block
```

```
| Stage | Kind | First ID | Requires before work under it starts |
|---|---|---|---|
| business idea | business idea | BI-01 | nothing |
| epic | epic | EP-01 | design document, security review |
| feature (added) | feature | FT-001 | nothing |
| user story | user story | US-001 | test plan |
| task | task | TK-001 | nothing |
Documents that can be attached at any stage: test plan, design document and security review.
Outside the stages, defect IDs start at DEF-001 and ad-hoc unit IDs at AH-001. A reported defect's parent is the work it affects: a user story.
Gates: approve warn, start warn, done warn, lock block (block stops the action, warn lets it go ahead with a warning, off skips the check).
A task's own test plan is recorded as it is saved, not approved.

What each stage and kind the team added means:
- feature (FT-001): user stories sit under features; a feature is approved before work under it starts; it is finished with /bk:done once everything under it is done.
```

## Next

Your tree is ready. Talk through what you want to build with Claude, as you would without BuildKeel, then run `/bk:capture` to turn the conversation into the artifacts your process needs. See [Getting started](getting-started.md#a-first-piece-of-work) and [Drafting with Claude](drafting.md). To see your process, gates and templates again at any time, run `/bk:settings`. For a piece of work followed from start to finish, see [How Full SDLC mode works](how-full-sdlc-works.md).
