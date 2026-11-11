# Change your configuration

How to see the way BuildKeel is set up in your repository, and how to change the process, the templates and the feature switches, one step at a time.

## Before you start

You need a repository where `/bk:init` has already been run. If it has not, start with [Install](install.md).

> **Nothing changes by surprise.** BuildKeel never changes your setup after `/bk:init`. Every change below is an edit you make to a file in the spec tree, and it reaches your team only when you commit and push it.

## 1. See what you have now

Always start here. It tells you the mode, the process and which switches are on.

1. Open Claude Code or Antigravity in your repository.
2. Type `/bk:settings` and press Enter. In Antigravity, type `/bk-settings`.
3. Read the result. It shows how the repository is set up: the mode, where the spec tree lives, the process or the numbering, every switch with its value and its default, each agent role's model and effort, and each template with where it comes from.

   ```text title="/bk:settings"
   BuildKeel settings of this repository:
   - Mode: Spec-driven, spec tree format 4.
   - Spec tree: specs/, in this repository.
   - Usage record (your own choice): kept on this machine only.

   Numbering:
   - Changes: CH-001, CH-002 and on.
   - Requirements: the capability's code, R and a number, such as AUTH-R1.
   - Defects: DEF-001. Ad-hoc units: AH-001.
   Lock gate: block.

   Testing:
   - TDD at finish: reported (the default).
   - Mutation testing: off (the default).

   Review:
   - Spec compliance: on (the default).
   - Code quality: on (the default).
   - Break-it: on (the default).
   ```

   An example, shortened. Yours will show your own mode, numbering and switches.
4. Ask Claude to show any template in full, such as the story or defect template, if you want to read one.

`/bk:settings` changes nothing. If a setting in `buildkeel.yaml` has a problem, such as a misspelled key, it is listed at the top.

## 2. Change the process

The process is the path a piece of work follows. You can change:

- the numbering: the prefixes that IDs use, such as `CH-001` or `RFC-0012`;
- in Full SDLC, the stages: rename one, or add one between the business idea and the user story;
- the kinds of work a stage holds, such as user stories, features and enhancements;
- the documents each stage requires before work starts, such as a design document or a test plan;
- in Full SDLC, each gate: whether it blocks, warns or is off.

The process lives in the `process` section of `buildkeel.yaml`, at the root of the spec tree. Anything you leave out keeps its default.

1. Open `buildkeel.yaml` at the root of the spec tree.
2. Change the `process` section. Each setting, with an example, is on [Process: stages, kinds and documents](process-and-templates.md). Claude can show you the lines to write if you describe the change.
3. Add a template for every stage, kind or document you add, in the spec tree's `templates/` folder, named after its type, such as `templates/capability.md`. See [Templates](templates.md#2-add-a-template-for-a-new-stage-kind-or-document).
4. Ask Claude to validate the spec tree. It reports what no longer fits, such as an added stage with no template, or a prefix two types share.
5. Run `/bk:settings` again, and read the process as BuildKeel now sees it.

> **What happens to work already done.** IDs never change once they are written, and every finished unit keeps its record. Approved artifacts stay approved: validation lists any that no longer fit under "Approved under earlier rules", and each is checked against the new process at its next version. Work already started carries on: the documents a stage requires are checked only when work starts, so a unit already started is not stopped by a newly required document. A gate's new mode applies from the next action, including finishing work that is already open. If the process itself has a problem, every gate blocks until it is fixed.

## 3. Change a template

Every artifact has a template: a proposal, a spec change, a design, a task list, a user story and so on. BuildKeel looks for a template in three places, and the nearest one wins:

1. Your team's own template, in the spec tree's `templates/` folder.
2. Your organization's templates, pinned to a version.
3. BuildKeel's built-in defaults.

To change one:

1. Decide what you want: replace a template with your own, or keep it and add rules to it.
2. To replace it, ask Claude to show the current template in full, and save it as `templates/<type>.md` in the spec tree, keeping its file name, such as `templates/story.md`.
3. Edit your copy, and raise its `version` whenever you change its rules.
4. To keep the template and add rules instead, add them to `buildkeel.yaml` under `rules`. See [Templates](templates.md#3-add-rules-to-a-template).
5. Ask Claude to validate the spec tree, then run `/bk:settings` to check the template now comes from the tree.

> **What happens to work already done.** Changing a template never invalidates approved work. Each approval records the template and version it was checked against. Validation lists approved artifacts that do not follow the new template under "Approved under earlier rules", and each is checked against it at its next version.

## 4. Turn a feature switch on or off

Core features are always on. The stricter checks are switches, so your team can turn them on at its own pace. A switch is `on` or `off`. A check that starts agents can also be set to `ask`, which asks you first, or `auto`.

1. Run `/bk:settings` to see every switch and its current value.
2. Open `buildkeel.yaml` at the root of the spec tree, and set the switch in its `process` section, such as:

   ```yaml
   process:
     checks:
       mutation: { command: "npm run mutate" }
   ```

3. Run `/bk:settings` again to confirm the new value. A setting that cannot be read, such as a misspelled key, keeps its default and is listed at the top.

> **What happens to work already done.** Each record notes the switches in force, so work done while a check was off is never failed for it later.

### Every switch, and its default

All of these sit under `process` in `buildkeel.yaml`.

| Switch | What it controls | Default |
|---|---|---|
| `planning.exploring` | Structured exploring: playback, then two or three approaches | `on` |
| `planning.design-options` | Fresh agents each propose a design for a shared interface | `ask`, `2` designers |
| `planning.readiness` | Fresh agents read the plan and list their questions | `ask`, `1` reader |
| `planning.edge-cases` | A fresh agent proposes missing test cases | `auto` |
| `planning.build-ready-tasks` | Files, Uses, Delivers and Verify on every task | `on` |
| `planning.plan-check` | The report when tasks are saved | `on` |
| `planning.spikes` | Whether spikes can be started | `on` |
| `runs.build` | The first choice in `/bk:build`: fresh agents or here | `fresh-agents` |
| `runs.parallel` | Full SDLC: the most tasks built at the same time | `3` |
| `checks.tdd` | Spec-driven: TDD at finish | `reported` |
| `checks.coverage` | Changed-line coverage | `on` |
| `checks.mutation` | Mutation testing, with your tool's command | `off` |
| `reviews.spec-compliance` | The spec compliance reviewer | `on` |
| `reviews.code-quality` | The code quality reviewer | `on` |
| `reviews.break-it` | The break-it reviewer | `on` |
| `reviews.each-task` | A review after each task | `on` |
| `agents.roles` | The tier each agent role runs on | `inherit` |
| `agents.tiers` | The model and effort of each tier | `standard`, `principal` |
| `agents.handoff` | Principal handoff: the tier, and after how many failed fix rounds | `principal`, after `2` |
| `continuity.threads` | What a pause does with nothing active | `ask` |
| `continuity.heads-up` | Heads-up notes when a unit starts | `on` |
| `continuity.learning-loop` | Patterns in the records | `on` |
| `tests.paths` | Test file patterns besides the usual ones | none |

The gates, and the done gate's TDD and review-findings checks in Full SDLC, are part of the process: see [Gate modes](process-and-templates.md#gate-modes). Every value each switch takes is on [Feature switches](settings.md).

## 5. Share it with your team

Settings are committed with the spec tree, so everyone on the team works with the same checks, in Claude Code or in Antigravity.

1. Commit the change to the spec tree and push it, as you would any other change.
2. Your teammates get it the next time they pull.

Three things stay personal and are never shared: whether your own commits are stamped, your usage stats, and whether you chose the guided first change. Stamping is a git hook in your own copy of the repository; the other two are kept on your own machine. See [Personal settings](settings.md#personal-settings).

**More:** [Process: stages, kinds and documents](process-and-templates.md), [Templates](templates.md), [Feature switches](settings.md), [Models and effort per role](models.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-settings`.
