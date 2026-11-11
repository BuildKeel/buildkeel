# Spec-driven mode in depth

A Spec-driven spec tree holds **capability specs**, which say how the system behaves now, and **changes**, each saying how one piece of work changes it. This page follows one change from a conversation to the capability's next version, then explains every question `/bk:init` asks when it sets up a Spec-driven tree.

## How the system behaves now

Nothing in a Spec-driven tree is approved. Work is planned as a change, built task by task, and finished, and finishing writes the capability's next version. The file formats are on [The spec tree and its artifacts](spec-tree.md#capability-specs).

The examples on this page come from a small accounts service with two capabilities: AUTH (signing in and resetting a password) and NOTIF (email).

Ask Claude what the system does, or run `/bk:status`, and Claude looks the capability specs up first:

```text title="/bk:status"
Capability specs (2), each at its version in force:
- AUTH "Authentication" v1: 2 requirements, 3 scenarios
- NOTIF "Notifications" v1: 1 requirement, 1 scenario
```

Each requirement has an ID, such as `AUTH-R2`, and each scenario under it extends that ID, such as `AUTH-R2-S1`. The version in force is the highest one: AUTH v1 here. A capability spec is never edited by hand. It changes only when a change is finished.

## From a conversation to a change

You talk the work through with Claude: reset links that never expire are a risk, so links should expire, and the email should say when. When the discussion has reached a point, `/bk:capture` turns it into a change, `CH-002 "Reset links expire"`, with four files:

- **The proposal**: why, and what changes in a few lines.
- **A spec change for AUTH**: requirement `AUTH-R3 Reset link expires` added, with its scenario `AUTH-R3-S1`, and `AUTH-R2` modified so the email says when the link expires.
- **A design**: each link carries its issue time, signed, and the endpoint refuses links that are too old.
- **Tasks**, each with how it is verified, such as `1.2 Refuse links older than 30 minutes. Verify: the "Expired link" scenario test (AUTH-R3-S1).`

Claude shows each file in full before saving it, and saves only what you agree to. See [Capture a plan](capture.md).

### Agreeing, not approving

A Spec-driven tree has no approvals: a change's files stay editable while it is open, and finishing it archives it as the record of the work. Agreeing is part of the review instead. While Claude shows you a document, such as a spec change during `/bk:capture`, typing `/bk:approve`, or replying "approved", agrees it, and Claude saves it and goes on. Nothing is frozen, and the change stays editable until it is finished; a later change to it goes through the review again.

With nothing under review, `/bk:approve` writes nothing, and says so, naming the open changes:

```text title="/bk:approve"
Nothing is waiting for agreement, and nothing was written: this spec tree is Spec-driven, so it has no approvals. While a document is under review in the conversation, /bk:approve or a reply such as "approved" agrees it.
Open changes, editable until each is finished with /bk:done:
- CH-002 "Reset links expire": 1 of 3 tasks done
Approvals, with drafts approved stage by stage and gates, come with Full SDLC: move the tree with /bk:migrate. The move is one way.
```

## Building the change

`/bk:build CH-002` starts the change on its own branch and loads its context:

```text title="/bk:build CH-002"
- Created its branch bk/CH-002-reset-links-expire from main.
- Claimed on this machine: other working trees cannot start CH-002 until it is finished or released.
```

Claude builds the tasks in order, each in a fresh agent when the session can start agents, with your conversation running the build, and fresh reviewers review each task once it is built. See [Build](working-on-a-unit.md) and [Reviews and the fix loop](reviews.md). Each commit ends with `BuildKeel-Unit: CH-002`, and a commit that does exactly one task adds `BuildKeel-Task: 1.2`. Each test carries the scenario it checks in its name, such as `it("refuses an expired link [AUTH-R3-S1]")`.

### A defect found while building

While building task 1.2, Claude opens an expired link and sees a stack trace where a message should be. That is a defect of the work under way: the code does not do what was agreed. Recorded with `/bk:new defect`, it is linked to the change and to the scenario whose test found it, and gets its number at once:

```text title="/bk:new defect"
Created defect DEF-002 "Expired link page shows a stack trace" at defects/DEF-002/defect.md, attached to CH-002, where AUTH-R3-S1 found it.
```

It needs no approval. It is fixed like any unit, with a regression test that names it, such as `[DEF-002]`.

### Behavior questioned while building

The code repository has a security policy: a reset link must expire within 15 minutes. The change says 30. Claude does not build something else, and does not edit the spec on its own: it stops, names `AUTH-R3` and the policy, and asks whether to keep the behavior as agreed or change it.

You say 15 minutes. `AUTH-R3` is a requirement this change adds, so it is edited in place, and Claude names the follow-on edits (the scenario's 31 minutes, task 1.2, the proposal and the design) and takes each through the review:

```text
Replaced AUTH-R3 in the AUTH spec change of CH-002 "Reset links expire"; nothing else in it changed.
```

Had the behavior been a requirement of the version in force, one an earlier change wrote, the change would gain a spec change modifying it (the default), or you would open a separate change. Either way, the spec changes first and the code follows it. In code that nothing describes yet, the code is documented first, as version 0 of a capability spec, and changed on top of that.

### Ticking tasks

Once a task's verification passes, Claude ticks it and says so in a line, without asking. Each tick also saves a summary of the change's test runs so far in the spec tree, so the evidence that each test failed before its code travels with the tree:

```text
Ticked 1.2, 2.1 in CH-002 "Reset links expire": 3 of 3 tasks done. Saved a summary of its test runs so far, in the change's runs folder. BuildKeel leaves the tick and the summary uncommitted, as it does the change's files while it is open: finishing the change commits them with its archive.
Every task of CH-002 "Reset links expire" is done: tell the user they can run /bk:done to finish it.
```

### Finishing: the next version

`/bk:done` shows what finishing will write: the requirements and scenarios after the merge, the code linked to the change, which scenarios pass, and anything to look at. The final review by fresh reviewers checks the code against the requirements and the design, and you choose to finish or to fix something first. See [Finish](finishing-a-unit.md) and [Reviews and the fix loop](reviews.md).

Finishing writes AUTH v2 and freezes the change as the record of the work:

```text title="/bk:done"
Archived CH-002 "Reset links expire".
- Wrote AUTH v2 (capabilities/AUTH/versions/v2.md), naming CH-002.
```

AUTH v2 is now in force. It holds `AUTH-R3` as the change left it ("15 minutes after it is sent") and `AUTH-R2` as modified. AUTH v1 stays as it was, and every later change starts from v2.

## A defect, or a change in behavior

The rule is the same in both modes:

- **A defect**: the code does not do what the spec says. The code is fixed and the spec keeps its version. For example, `AUTH-R3` says 15 minutes, and links expire after 3.
- **A change in behavior**: the code does what the spec says, and the spec is wrong, no longer wanted, or silent. The spec changes and gets a new version, through a change. For example, links expire after 15 minutes, as `AUTH-R3` says, and support now wants an hour.

When someone reports a problem, Claude checks it against the spec in force and the code linked to it before recording anything, and proposes one reading: a defect, a change in behavior, a gap (the spec says nothing about it), or code nothing describes yet. It labels the reading as its own, says what it rests on, and records nothing until you confirm or pick another.

### A reported defect that is really a change in behavior

A customer writes that reset links "expire too fast". Claude reads `AUTH-R3` (15 minutes) and the code (15 minutes): the code does what the spec says. Its reading is a change in behavior, and it proposes drafting a change that modifies `AUTH-R3`, not a defect. If you agree, `/bk:capture` drafts it. If a defect had been recorded and later turned out this way, it is closed without a fix as a change in behavior, naming the change that takes it over, such as `CH-003`.

### A reported defect

A customer on one mail provider gets no reset email. `AUTH-R2` says the system sends one to a registered address, and the code fails for that provider: a defect. A reported defect names the requirement it affects, pinned to the version in force:

```text
Created defect DEF-004 "Reset email never arrives for some domains" at defects/DEF-004/defect.md, affecting AUTH-R2@v2.
```

Its context shows `AUTH-R2` as v2 states it, with its scenarios and the tests tagged with them. If a later change modifies `AUTH-R2` while the defect is open, the defect becomes suspect: Claude asks whether it still applies, and saves its file against the new version, or closes it. Finishing it leaves AUTH at its version: the code is fixed, the spec is not.

### A defect in code nothing describes

A customer reports that invoice totals round down. Claude asks BuildKeel what describes the billing code:

```text
Nothing describes src/billing/invoice.ts in accounts-api yet: no artifact's scope covers it, and no unit's commits changed it.
```

Claude says so, and asks whether to **record it standalone** (the default) or **document this code first**, as version 0 of a capability spec, and link the defect to its requirement. Recorded standalone:

```text
Created defect DEF-003 "Invoice totals round down" at defects/DEF-003/defect.md, standalone.
```

When a standalone defect is finished, BuildKeel looks at the files its fix changed, finds the requirements that archived changes built in them, and offers to link the defect to one.

### Where it all shows

`/bk:status` lists the capability specs, open and closed changes, and the defects, each with what it is linked to:

```text title="/bk:status"
Defects: 4 open, 0 done.
- DEF-001 "Reset email lands in spam": standalone, reported
- DEF-002 "Expired link page shows a stack trace": in CH-002, found while building
- DEF-003 "Invoice totals round down": standalone, reported
- DEF-004 "Reset email never arrives for some domains": affects AUTH-R2@v2, reported
```

See [Status and usage](status.md) and [Small fixes, defects and spikes](defects-and-adhoc.md).

## One piece of work, start to finish

The same reset links work, followed through every part of BuildKeel it touches:

1. **Exploring.** Ana talks the risk of links that never expire through with Claude, who checks AUTH's capability spec and the code, lays out two or three options, and keeps her words apart from its proposals. See [Talk it through and explore](exploring.md).
2. **A thread.** She stops before deciding: "let's stop here" keeps the conversation as `TH-001 "Reset links expire"`, shown in full and saved once she agrees, then pushed. See [Pause, resume and hand over](pausing-and-resuming.md).
3. **Capture.** Later, `/bk:resume TH-001` shows its brief. `/bk:capture` sums up, drafts the proposal with the approaches weighed, the spec change for AUTH (with edge-case suggestions: missing scenarios proposed by a fresh agent), the design and the tasks. Claude offers the readiness check, as the change has a design, and you take it. `CH-002` names the thread it came from, and the thread is closed with a link to it.
4. **A run in fresh agents.** `/bk:build CH-002` builds each task in a fresh agent, with the glossary terms and practices in its view; each tick keeps the working notes since the last one, listed in the same reply. See [Build](working-on-a-unit.md).
5. **Review.** Fresh reviewers review each task before it is ticked. See [Reviews and the fix loop](reviews.md).
6. **A pause on one machine.** After task 1.2, Ana pauses: the change's files, open until it is finished, are committed with the pause record, and both repositories are pushed.
7. **Finishing on another.** On her desktop, after a pull, `/bk:resume CH-002` confirms resuming work paused on another machine, starts the change on its branch with the brief, and the last task is built. `/bk:done` reviews the change, shows its context part, and archives it with AUTH's next version.

## Setting up a Spec-driven tree

`/bk:init` sets up a tree for **Spec-driven** mode: capability specs say how your system behaves, and each piece of work is a change to them, with no approvals or gates. Below is every question setup asks, in the order it asks them, why it asks, and what each answer does. By the end you have a spec tree ready for your first change. You need BuildKeel installed first: see [Install](install.md). If you have not chosen a mode yet, see [Choose a mode](modes.md); for the other mode, see [Full SDLC mode in depth](how-full-sdlc-works.md#setting-up-a-full-sdlc-tree).

### How setup asks

Setup asks one thing at a time and waits for your answer. Where a question has a default, the default is the first answer, and it names the actual value. Press Enter, or say so, to keep it. You can answer in your own words; Claude says what each answer settled and what is left, never fills in what you did not say, and asks when an answer is unclear. Nothing is written until you have seen everything that will be set up, in full, and agreed to it.

### Before the first question: the folder

Setup first checks that the folder is a git repository: BuildKeel links code to its specs through git commits. When it is not, setup says so before anything else:

```text title="/bk:init"
/home/ana/payments is not a git repository. BuildKeel links code to its specs through git, so setup needs one. Nothing has been written.
```

Claude asks: **Run git init for me** (the default) or **Stop**. With the first, BuildKeel runs `git init` in the folder and goes on to the first question.

### 1. Where the spec tree lives

The spec tree holds your capability specs and changes.

- **In this repository**, in a `specs/` folder. Choose this for a team with one repository, or to try BuildKeel out.
- **An existing spec tree**, usually a repository of its own that several code repositories share. Clone it first and give its path. It keeps its own mode and numbering, so setup only registers your repository.
- **A new spec repository**, a repository of its own for the tree. Give a folder outside this repository, such as `../payments-specs`.

See [The spec tree and its artifacts](spec-tree.md).

### 2. The mode

Keep **Spec-driven**, the default. See [Choose a mode](modes.md). A Spec-driven tree can be moved to Full SDLC later with `/bk:migrate`, area by area.

### 3. Stamping your own commits

While a change or another unit of work is active, BuildKeel adds a line such as `BuildKeel-Unit: CH-001` to every commit Claude makes, so each commit traces to the work it belongs to. A git hook adds the same line to commits you make yourself. It does nothing when nothing is active. Setup asks: **Stamp my commits** (the default) or **Don't stamp them**. If your repository already manages its git hooks with a tool such as husky or lefthook, BuildKeel installs nothing and shows you the lines to add. To change it later, ask Claude to turn stamping off or on: turning it off uninstalls the hook. See [Feature switches](settings.md).

### 4. Numbering

Setup lists every file and setting it would add, then shows how the tree's IDs read, each with an example:

```text
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

```text
- Changes: RFC-0001, RFC-0002 and on.
- Capability codes: chosen for each capability spec from its name, such as AUTH for authentication.
- Requirements: the capability's code, REQ and a number, such as AUTH-REQ1.
- Scenarios: the requirement's ID, SC and a number, such as AUTH-REQ1-SC1.
- Defects: DEF-001. Ad-hoc units: AH-001.
```

What changing each one does:

- A change, defect or ad-hoc prefix, or its number of digits, is written to the `process` section of `buildkeel.yaml`. The next change created is numbered with it, such as `RFC-0001`.
- The letters in requirement and scenario IDs are written into the tree's own capability spec and spec change templates, `templates/capability.md` and `templates/spec-change.md`, which must use the same letters. Validation reports it if they ever differ.

IDs are always a prefix and a number. A prefix is 1 to 8 capital letters or digits, starting with a letter; requirement and scenario letters are 1 to 4 capital letters, different from each other. Changing them later only affects what is numbered afterwards: IDs already given never change. See [IDs](spec-tree.md#requirement-and-scenario-ids).

### 5. Confirm and set up

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

BuildKeel commits nothing during setup: review the changes and commit them. See [Your first change](getting-started.md) for each file it adds.

### 6. Templates and rules

Every artifact in a Spec-driven tree has a built-in template, so setup asks nothing about them: the capability spec, and a change's proposal, spec changes, design and task list. Defects and ad-hoc units have theirs too. To change one later, copy it into your tree's `templates/` folder and edit it; see [Templates](templates.md). To add your team's conventions without changing a template, such as a section every proposal must have, use rules in `buildkeel.yaml`; see [Templates](templates.md).

### 7. Being guided through your first change

Last, Claude asks whether to guide you through your first change: **Guide me through my first change** (the default) or **Jump right in**. When guided, Claude adds a line or two at each step of your first change, from capturing it to finishing it, on what has happened and what comes next. It stops when that change is finished, or when you say so, such as "stop explaining". The answer is kept on your machine only.

Your tree is then ready. Talk through what you want to build with Claude, as you would without BuildKeel, then run `/bk:capture` to turn the conversation into a change: a proposal, spec changes for the capabilities it alters, and tasks. To see your numbering and templates again at any time, run `/bk:settings`.

## Settings left at their defaults

Setup asks nothing about the checks on tests, the agents that build and review, or what a pause saves: each starts at a default that suits most teams. To change one later, add it to the `process` section of `buildkeel.yaml` and commit it with the spec tree. [Feature switches](settings.md) lists every one, with what turning it off or on does. With every default written out:

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
- **Changed-line coverage** and **mutation testing**: see [Tests and traceability](test-plans.md) and [TDD evidence](tdd.md). Mutation testing is off until you give the command that runs your team's mutation tool.
- **The reviewers and the review after each task**: each can be turned off.
- **Threads**: what a pause with no unit active does: `ask` offers to save the conversation as a thread, `auto` saves it, `off` saves nothing.
- **Heads-up notes** at the start of a unit, and the **Learning loop**, which looks for patterns in the records at finish and in status.
- **Test file patterns**, for tests outside the usual places. See [TDD evidence](tdd.md).

### Agents and tiers

Each of the ten roles an agent plays, from the implementer to the note checker, runs with the session's model and effort (`inherit`) unless you give it a tier. Two tiers are ready to use, and you can change them or add your own under `agents.tiers`:

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

Antigravity has no effort setting for agents, so an effort there is ignored, and `/bk:settings` says so. See [Models and effort per role](models.md).

### The read-only copy

BuildKeel keeps a copy of the team's glossary, practices and accepted ADRs in each code repository, so they are read with the code. Its paths are set in that repository's `.buildkeel.yaml`, and default to:

```yaml
copy:
  glossary: GLOSSARY.md
  practices: docs/practices.md
  adrs: docs/adr/
```

A setting you leave out takes its default, and one that cannot be read keeps its default too, so a mistake never stops work: validation reports it. `/bk:settings` shows every setting as it applies.

**More:** [The spec tree and its artifacts](spec-tree.md), [Capture a plan](capture.md), [Finish](finishing-a-unit.md), [Feature switches](settings.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-init`.
