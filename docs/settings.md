# Settings

Every BuildKeel feature you can switch, with its values and its default. The defaults suit most teams, and setup asks only about stamping your own commits. Everything else starts at its default until you change it.

`/bk:settings` shows every setting as it applies in this repository, and says when one does not apply in the tree's mode. It changes nothing. For what each feature does, see [What BuildKeel does](what-buildkeel-does.md).

## How switches work

- **Checks that start agents, and Threads,** are `off`, `ask` or `auto`. With `ask`, Claude makes a one-line offer saying why the check would help here. With `auto`, it runs without asking, and Claude says why in a line.
- **Everything else** is `on` or `off`.
- **Where they are set:** in the `process` section of the spec tree's `buildkeel.yaml`, committed with the tree, so the whole team works with the same settings. Personal choices are the exception. They are kept on your machine: see [Personal settings](#personal-settings).

A setting you leave out takes its default. A setting that cannot be read, such as a misspelled key or a value that is not allowed, keeps its default too, so a mistake never stops work. Validation reports it, naming the nearest setting when a key is misspelled.

## Every setting

| Feature | Setting | Values | Default | Mode |
|---|---|---|---|---|
| Structured exploring | `planning.exploring` | on, off | on | both |
| Design options | `planning.design-options` | off, ask, auto; and `designers`, 1 or more | ask, 2 designers | both |
| Readiness check | `planning.readiness` | off, ask, auto; and `readers`, 1 to 3 | ask, 1 reader | both |
| Edge-case suggestions | `planning.edge-cases` | off, ask, auto | auto | both |
| Build-ready tasks | `planning.build-ready-tasks` | on, off | on | both |
| Plan check | `planning.plan-check` | on, off | on | both |
| Spikes | `planning.spikes` | on, off | on | both |
| Fresh agent per task | `runs.build`: the first choice in `/bk:build` | fresh-agents, here | fresh-agents | both |
| Parallel runs | `runs.parallel`: the most tasks built at the same time | 1 (off) or more | 3 | Full SDLC |
| TDD | `gates.tdd`: the done gate's TDD check | block, warn, off | warn | Full SDLC |
| | `checks.tdd`: at finish | reported, off | reported | Spec-driven |
| Changed-line coverage | `checks.coverage` | on, off | on | both |
| Mutation testing | `checks.mutation` | off, or `{ command: "..." }` | off | both |
| Review: spec compliance | `reviews.spec-compliance` | on, off | on | both |
| Review: code quality | `reviews.code-quality` | on, off | on | both |
| Review: break-it | `reviews.break-it` | on, off | on | both |
| Review after each task | `reviews.each-task` | on, off | on | both |
| Models and effort per role | `agents.roles`: a tier for each of the ten roles | inherit, or a tier | inherit | both |
| Tiers | `agents.tiers` | a model and an effort per host | standard, principal | both |
| Principal handoff | `agents.handoff` | `tier`: a tier, or none; `after`: failed fix rounds, 1 or more | principal, after 2 | both |
| Threads | `continuity.threads` | off, ask, auto | ask | both |
| Heads-up notes | `continuity.heads-up` | on, off | on | both |
| Learning loop | `continuity.learning-loop` | on, off | on | both |
| Test file patterns | `tests.paths`: patterns besides the usual ones | a list | none | both |
| Gates | `gates.approve`, `gates.start`, `gates.done` | block, warn, off | block | Full SDLC |
| Lock gate | `gates.lock` | block, warn, off | block | both |
| The done gate's review-findings check | `gates.review-findings` | block, warn, off | warn | Full SDLC |
| Stamping your own commits | asked at setup, changed by asking Claude | on, off | on | both |
| Usage stats | `/bk:stats on`, `off`, `delete`, `export` | on, off | on | both, per person |
| Guided first change | asked at setup | guide me, jump right in | guide me | Spec-driven, per person |

A setting for the other mode is reported by validation, and has no effect.

With every default written out, a Spec-driven tree reads:

```yaml
process:
  planning:
    exploring: on
    design-options: { mode: ask, designers: 2 }
    readiness: { mode: ask, readers: 1 }
    edge-cases: auto
    build-ready-tasks: on
    plan-check: on
    spikes: on
  runs:
    build: fresh-agents
  checks:
    tdd: reported
    coverage: on
    mutation: off
  reviews:
    spec-compliance: on
    code-quality: on
    break-it: on
    each-task: on
  agents:
    handoff: { tier: principal, after: 2 }
  continuity:
    threads: ask
    heads-up: on
    learning-loop: on
  tests:
    paths: []
```

A Full SDLC tree has the same settings, with `runs.parallel` and the done gate's checks under `gates` in place of `checks.tdd`:

```yaml
process:
  gates:
    tdd: warn
    review-findings: warn
  runs:
    build: fresh-agents
    parallel: 3
```

The setup guides write out every setting with its values beside it: see [Setting up a Spec-driven tree](setting-up-spec-driven.md#settings-setup-leaves-at-their-defaults) and [Setting up a Full SDLC tree](setting-up-full-sdlc.md#settings-setup-leaves-at-their-defaults).

## Planning

- **Structured exploring** (`planning.exploring`). When you ask to explore an idea, Claude plays back what it understood, with your words kept apart from its proposals, and offers two or three approaches. Off, Claude still checks facts in the code before asking, without the structure. See [Exploring and capturing](exploring-and-capturing.md).
- **Design options** (`planning.design-options`). Fresh agents each propose a design for an interface several tasks share. Set the number of designers beside the mode, such as `{ mode: auto, designers: 3 }`.
- **Readiness check** (`planning.readiness`). For larger work, fresh agents read the agreed plan as the people who build, test and run it, and list their questions. 1 reader is the builder, 2 adds a tester, and 3 adds an operator.
- **Edge-case suggestions** (`planning.edge-cases`). When a test plan or a change's scenarios are drafted, a fresh agent proposes up to five missing cases. With `auto`, the default, it runs and says so in a line. You still answer its proposals once.
- **Build-ready tasks** (`planning.build-ready-tasks`). Every task names its Files, what it Uses and Delivers, and its Verify command, and records its Built line when it is finished. See [Working on a unit](working-on-a-unit.md#what-each-task-states).
- **Plan check** (`planning.plan-check`). When tasks are saved, BuildKeel checks what they use, the files they name and their coverage, and reports problems. It never blocks.
- **Spikes** (`planning.spikes`). Throwaway code on its own `spike/<name>` branch. Off, starting a spike is refused. Spike branches from before are left as they are. See [Spikes](exploring-and-capturing.md#spikes).

## Building

- **Fresh agent per task** (`runs.build`). The first choice `/bk:build` offers: each task in a fresh agent, or here, in this conversation. The other is always offered too. See [Building with agents](building-with-agents.md#fresh-agents-or-here).
- **Parallel runs** (`runs.parallel`, Full SDLC). The most independent tasks built at the same time, each in its own worktree. `1` builds one after another. A change applies from the next run. See [Parallel runs](building-with-agents.md#parallel-runs).
- **Principal handoff** (`agents.handoff`). When fix rounds leave a review finding open, the implementer gets one more round on the handoff tier. `after` is the number of failed fix rounds before it, 2 by default. `tier: none` turns it off: the run then stops and asks you after the fix rounds. See [The fix loop](reviews.md#the-fix-loop).

## Testing

- **TDD**. Red then green, the revert check and the test-file diff. In Full SDLC it is the done gate's check, `gates.tdd`: `warn` shows a finding with the finish, `block` refuses it, `off` says nothing. In a Spec-driven tree, `checks.tdd` is `reported` at finish, or `off`. See [TDD](tdd.md).
- **Changed-line coverage** (`checks.coverage`). The lines the unit changed that no test ran, from an lcov or Cobertura report. Reported, never gated. See [Changed-line coverage](changed-line-coverage.md).
- **Mutation testing** (`checks.mutation`). Off until you give the command that runs your team's mutation tool, such as `{ command: "npm run mutate" }`.
- **Test file patterns** (`tests.paths`). Where your tests live, when it is not one of the usual places. See [How BuildKeel tells](tdd.md#how-buildkeel-tells).

## Review

- **Each reviewer** can be turned off on its own: `reviews.spec-compliance`, `reviews.code-quality` and `reviews.break-it`. Spec compliance still runs at finish when no review has run, or every reviewer is off. See [What /bk:done reviews](reviews.md#what-bkdone-reviews).
- **Review after each task** (`reviews.each-task`). Off, a run builds each task without reviewing it, and the work is reviewed when it is finished.
- **The done gate's review-findings check** (`gates.review-findings`, Full SDLC). A final review ran, and every High or Medium finding was fixed, parked or rejected. It warns by default. See [The final review and the done gate](reviews.md#the-final-review-and-the-done-gate).

## Continuity

- **Threads** (`continuity.threads`). What a pause does with nothing active. `ask` offers to save the conversation as a thread, `auto` saves it without asking, and `off` saves nothing and suggests `/bk:capture` when the idea is ready. Open threads stay, and can still be resumed or closed. See [Keeping an exploration as a thread](pausing-and-resuming.md#keeping-an-exploration-as-a-thread).
- **Heads-up notes** (`continuity.heads-up`). Starting a unit shows up to five notes earlier work left on the files it will change. See [Heads-up notes](pausing-and-resuming.md#heads-up-notes-and-notes-on-the-code).
- **Learning loop** (`continuity.learning-loop`). Patterns in the records, shown at finish and in status, and proposed as a practice or a note on the code. See [The Learning loop](status.md#the-learning-loop).

## Agents and models

Each of the ten roles an agent plays runs with your session's model and effort (`inherit`) unless you give it a tier. The roles are `implementer`, `spec-reviewer`, `quality-reviewer`, `final-spec-reviewer`, `final-quality-reviewer`, `break-it`, `readiness-readers`, `edge-cases`, `designers` and `note-checker`. Two tiers are built in, *standard* and *principal*, and you can change them or add your own:

```yaml
process:
  agents:
    tiers:
      careful: { claude-code: { model: opus, effort: max }, antigravity: { model: pro } }
    roles: { implementer: principal, final-spec-reviewer: careful }
    handoff: { tier: careful, after: 2 }
```

See [Models and effort for each role](building-with-agents.md#models-and-effort-for-each-role), and [When agents can't be started](building-with-agents.md#when-agents-cant-be-started) for what happens without them.

## Gates

In Full SDLC, the approve, start, done and lock gates each have a mode: `block` (the default), `warn` or `off`. See [Gate modes](process-and-templates.md#gate-modes). A Spec-driven tree's only gate is the lock gate, with the same modes.

## Personal settings

These are each person's own, kept on their machine, and never in `buildkeel.yaml`:

- **Stamping your own commits.** A git hook adds the active unit's line to commits you make by hand. It is on by default: setup asks, with **Stamp my commits** first. To change it later, ask Claude to turn stamping off or on. Turning it off uninstalls BuildKeel's hook. In a repository whose hooks another tool manages, such as husky or lefthook, Claude shows the lines to add or take out instead.
- **Usage stats.** A record on your machine of what BuildKeel did for you. `/bk:stats off` stops it, `/bk:stats on` starts it again, and `/bk:stats delete` and `/bk:stats export` delete or export it. See [Your usage](usage-stats.md).
- **The guided first change.** In a Spec-driven tree, setup asks whether to be guided through your first change. Tell Claude to stop or start explaining at any time.

## Turning a feature off or on

Changing a setting changes only what happens from then on. For some features, work done meanwhile is affected too:

- **Nothing more:** Structured exploring, Design options, the Readiness check, Edge-case suggestions, Plan check, Parallel runs, Principal handoff, Changed-line coverage, Mutation testing, Heads-up notes and the Learning loop.
- **A gap:** work done while it was off has no records from it. These are TDD, each reviewer, the review after each task and Build-ready tasks. Turning Build-ready tasks on backfills it: open tasks get their Files, Uses, Delivers and Verify lines as an ordinary edit, and each finished task gets an as-built record, labeled as written later. `/bk:status` says how many finished tasks that covers; Claude shows their records, and writes them in one commit once you agree. See [Backfilling Build-ready tasks](working-on-a-unit.md#backfilling-build-ready-tasks).
- **Something to tidy:** turning Spikes off leaves earlier spike branches, which `/bk:status` lists for you to keep or delete. Turning Threads off leaves open threads, which can still be resumed, captured or dropped. Turning stamping off uninstalls the hook. Turning usage stats off keeps the record until you delete it.

## Records note the switches in force

When a unit or change starts, and again when it is finished, its record notes the switches that change what a check expects or what the record shows: TDD, changed-line coverage, mutation testing, each reviewer and the review after each task, Build-ready tasks, Principal handoff, and the way it was built, in fresh agents or here.

Each check reads the switches noted when the work started. A unit started with TDD off is never failed for missing red runs, and a reader can tell "reviewed, nothing found" from "built with reviews off". The switches that only shape the conversation, such as Structured exploring, Threads, usage stats and the guided first change, are not noted.
