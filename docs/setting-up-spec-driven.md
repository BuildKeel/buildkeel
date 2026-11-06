# Setting up a Spec-driven tree

This guide follows `/bk:init` from start to finish for a team that wants **Spec-driven** mode: capability specs say how your system behaves, and each piece of work is a change to them, with no approvals or gates. It explains every question setup asks, in the order it asks them, why it asks, and what each answer does. By the end you have a spec tree ready for your first change. If you have not chosen a mode yet, see [Choosing a mode](comparing-modes.md); for the other mode, see [Setting up a Full SDLC tree](setting-up-full-sdlc.md).

You need BuildKeel installed: see [Install in Claude Code](install-claude-code.md) or [Install in Antigravity](install-antigravity.md). Commands are shown in Claude Code's form; in Antigravity, use a hyphen: `/bk-init`.

## How setup asks

Setup asks one thing at a time and waits for your answer. Where a question has a default, the default is the first answer, and it names the actual value. Press Enter, or say so, to keep it. You can answer in your own words; Claude says what each answer settled and what is left, never fills in what you did not say, and asks when an answer is unclear. Nothing is written until you have seen everything that will be set up, in full, and agreed to it.

## Before the first question: the folder

Setup first checks that the folder is a git repository: BuildKeel links code to its specs through git commits. When it is not, setup says so before anything else:

```
/home/ana/payments is not a git repository. BuildKeel links code to its specs through git, so setup needs one. Nothing has been written.
```

Claude asks: **Run git init for me** (the default) or **Stop**. With the first, BuildKeel runs `git init` in the folder and goes on to the first question.

## 1. Where the spec tree lives

The spec tree holds your capability specs and changes.

- **In this repository**, in a `specs/` folder. Choose this for a team with one repository, or to try BuildKeel out.
- **An existing spec tree**, usually a repository of its own that several code repositories share. Clone it first and give its path. It keeps its own mode and numbering, so setup only registers your repository.
- **A new spec repository**, a repository of its own for the tree. Give a folder outside this repository, such as `../payments-specs`.

See [The spec tree](spec-tree.md).

## 2. The mode

Keep **Spec-driven**, the default. See [The two modes](modes.md). A Spec-driven tree can be moved to Full SDLC later with `/bk:migrate`, area by area.

## 3. Stamping your own commits

While a change or another unit of work is active, BuildKeel adds a line such as `BuildKeel-Unit: CH-001` to every commit Claude makes, so each commit traces to the work it belongs to. A git hook adds the same line to commits you make yourself. It does nothing when nothing is active. Setup asks: **Stamp my commits** (the default) or **Don't stamp them**. If your repository already manages its git hooks with a tool such as husky or lefthook, BuildKeel installs nothing and shows you the lines to add. To change it later, ask Claude to turn stamping off or on: turning it off uninstalls the hook. See [Settings](settings.md#personal-settings).

## 4. Numbering

Setup lists every file and setting it would add, then shows how the tree's IDs read, each with an example:

```
- Changes: CH-001, CH-002 and on.
- Capability codes: chosen for each capability spec from its name, such as AUTH for authentication.
- Requirements: the capability's code, R and a number, such as AUTH-R1.
- Scenarios: the requirement's ID, S and a number, such as AUTH-R1-S1.
- Defects: DEF-001. Ad-hoc units: AH-001.
```

What each one is:

- **Changes** are your pieces of work: each proposes how capabilities change, and is built and finished as one unit.
- **Capability codes** name each capability spec, such as `AUTH` or `BILL`. Claude proposes one from the capability's name when it is created, and you can change it then.
- **Requirements** are the behaviors a capability spec states, numbered under its code.
- **Scenarios** are the cases a test checks, numbered under their requirement. A test with `[AUTH-R1-S1]` in its name is linked to that scenario.
- **Defects** and **ad-hoc units** are work outside a change: code that does not do what was planned, or a small change recorded so every commit traces to something.

Claude asks whether to keep them (the default) or change them. Teams change them to match the IDs they already use, for example:

- changes as `RFC-0012`: prefix `RFC`, four digits;
- changes as `PROJ-12`: prefix `PROJ`, two digits;
- requirements as `AUTH-REQ1` and scenarios as `AUTH-REQ1-SC1`: the letters `REQ` and `SC`.

Answer in your own words, such as "changes should be RFC with four digits, and requirements REQ". Claude shows the IDs again as they will read and asks you to confirm:

```
- Changes: RFC-0001, RFC-0002 and on.
- Capability codes: chosen for each capability spec from its name, such as AUTH for authentication.
- Requirements: the capability's code, REQ and a number, such as AUTH-REQ1.
- Scenarios: the requirement's ID, SC and a number, such as AUTH-REQ1-SC1.
- Defects: DEF-001. Ad-hoc units: AH-001.
```

What changing each one does:

- A change, defect or ad-hoc prefix, or its number of digits, is written to the `process` section of `buildkeel.yaml`. The next change created is numbered with it, such as `RFC-0001`.
- The letters in requirement and scenario IDs are written into the tree's own capability spec and spec change templates, `templates/capability.md` and `templates/spec-change.md`, which must use the same letters. Validation reports it if they ever differ.

IDs are always a prefix and a number. A prefix is 1 to 8 capital letters or digits, starting with a letter; requirement and scenario letters are 1 to 4 capital letters, different from each other. Changing them later only affects what is numbered afterwards: IDs already given never change. See [Capability specs](capability-specs.md#ids).

## 5. Confirm and set up

Claude shows everything setup will write and asks whether to set up with it. Once you agree, BuildKeel writes the tree's `buildkeel.yaml` and, if you changed the requirement or scenario letters, the two templates. With changed numbering, `buildkeel.yaml` reads:

```yaml
format: 4
mode: spec-driven
repos:
  - name: payments
process:
  change:
    prefix: RFC
    width: 4
```

BuildKeel commits nothing during setup: review the changes and commit them. See [Getting started](getting-started.md#what-it-adds) for each file it adds.

## 6. Templates and rules

Every artifact in a Spec-driven tree has a built-in template, so setup asks nothing about them: the capability spec, and a change's proposal, spec changes, design and task list. Defects and ad-hoc units have theirs too. To change one later, copy it into your tree's `templates/` folder and edit it; see [Using your own template](process-and-templates.md#using-your-own-template). To add your team's conventions without changing a template, such as a section every proposal must have, use rules in `buildkeel.yaml`; see [Rules for each artifact type](process-and-templates.md#rules-for-each-artifact-type).

## 7. Being guided through your first change

Last, Claude asks whether to guide you through your first change: **Guide me through my first change** (the default) or **Jump right in**. When guided, Claude adds a line or two at each step of your first change, from capturing it to finishing it, on what just happened and what comes next. It stops when that change is finished, or when you say so, such as "stop explaining". The answer is kept on your machine only.

## Settings setup leaves at their defaults

Setup asks nothing about the checks on tests, the agents that build and review, or what a pause saves: each starts at a default that suits most teams. To change one later, add it to the `process` section of `buildkeel.yaml` and commit it with the spec tree. [Settings](settings.md) lists every one, with what turning it off or on does. With every default written out:

```yaml
process:
  planning:
    exploring: on               # on | off
    design-options: { mode: ask, designers: 2 }   # off | ask | auto
    readiness: { mode: ask, readers: 1 }          # off | ask | auto; 1 to 3 readers
    edge-cases: auto            # off | ask | auto
    build-ready-tasks: on       # on | off
    plan-check: on              # on | off
    spikes: on                  # on | off
  runs:
    build: fresh-agents         # fresh-agents | here: the first choice in /bk:build
  checks:
    tdd: reported               # reported | off
    coverage: on                # on | off
    mutation: off               # or: { command: "npm run mutate" }
  reviews:
    spec-compliance: on         # on | off
    code-quality: on            # on | off
    break-it: on                # on | off
    each-task: on               # on | off
  agents:
    roles:
      implementer: inherit      # inherit, or a tier: standard, principal, or your own
      spec-reviewer: inherit
      quality-reviewer: inherit
      final-spec-reviewer: inherit
      final-quality-reviewer: inherit
      break-it: inherit
      readiness-readers: inherit
      edge-cases: inherit
      designers: inherit
      note-checker: inherit
    handoff: { tier: principal, after: 2 }         # tier: none turns it off
  continuity:
    threads: ask                # off | ask | auto
    heads-up: on                # on | off
    learning-loop: on           # on | off
  tests:
    paths: []                   # test file patterns besides the usual ones
```

TDD is reported when a change is finished, or off, and review findings are reported, never blocking, so a Spec-driven tree has no gate modes for them; parallel runs are Full SDLC only too. Validation reports any of these set in a Spec-driven tree.

- **Structured exploring**: when you ask to explore an idea with structure, Claude plays back what it understood, keeping your words apart from its proposals, and offers two or three approaches.
- **Design options, the readiness check and edge-case suggestions** start fresh agents. Each is `off`, `ask` (a one-line offer saying why it would help) or `auto` (it runs and says why in a line). The readiness check is offered or run only for larger work, and you can ask for any of them at any time.
- **Build-ready tasks**: every task names its Files, what it Uses and Delivers, and its Verify command. **Plan check** reports problems in them when tasks are saved, and never blocks.
- **Spikes**: throwaway work on its own branch, to find something out.
- **The first choice in `/bk:build`**: a fresh agent per task, or here. The other is always offered too.
- **Principal handoff**: when fix rounds do not clear a review finding, the implementer gets one more round on a stronger tier. With `tier: none`, the run stops and asks you.
- **Changed-line coverage** and **mutation testing**: see [Changed-line coverage](changed-line-coverage.md) and [Mutation testing](tdd.md#mutation-testing). Mutation testing is off until you give the command that runs your team's mutation tool.
- **The reviewers and the review after each task**: each can be turned off.
- **Threads**: what a pause with no unit active does: `ask` offers to save the conversation as a thread, `auto` saves it, `off` saves nothing.
- **Heads-up notes** at the start of a unit, and the **Learning loop**, which looks for patterns in the records at finish and in status.
- **Test file patterns**, for tests outside the usual places. See [How BuildKeel tells](tdd.md#how-buildkeel-tells).

**Agents.** Each of the ten roles an agent plays, from the implementer to the note checker, runs with the session's model and effort (`inherit`) unless you give it a tier. Two tiers are ready to use, and you can change them or add your own under `agents.tiers`:

| Tier | Claude Code | Antigravity |
|---|---|---|
| standard | Sonnet at medium effort | `flash` |
| principal | Opus at high effort | the conversation's model |

```yaml
process:
  agents:
    tiers:
      careful: { claude-code: { model: opus, effort: max }, antigravity: { model: pro } }
    roles: { final-spec-reviewer: principal, final-quality-reviewer: principal, spec-reviewer: careful }
    handoff: { tier: careful, after: 2 }
```

Antigravity has no effort setting for agents, so an effort there is ignored, and `/bk:settings` says so.

**The read-only copy.** BuildKeel keeps a copy of the team's glossary, practices and accepted ADRs in each code repository, so they are read with the code. Its paths are set in that repository's `.buildkeel.yaml`, and default to:

```yaml
copy:
  glossary: GLOSSARY.md
  practices: docs/practices.md
  adrs: docs/adr/
```

A setting you leave out takes its default, and one that cannot be read keeps its default too, so a mistake never stops work: validation reports it. `/bk:settings` shows every setting as it applies.

## Next

Your tree is ready. Talk through what you want to build with Claude, as you would without BuildKeel, then run `/bk:capture` to turn the conversation into a change: a proposal, spec changes for the capabilities it alters, and tasks. See [Getting started](getting-started.md#a-first-piece-of-work) and [Changes](changes.md). To see your numbering and templates again at any time, run `/bk:settings`. For a change followed from start to finish, see [How Spec-driven mode works](how-spec-driven-works.md).
