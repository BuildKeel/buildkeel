# Building with agents

When `/bk:build` builds more than one task, Claude can build each in a fresh agent: a separate agent that starts with only that task's context, does the work, and reports back. Your conversation stays in charge of the run. It starts each agent, checks what it did, has the task reviewed, and finishes it (Full SDLC) or ticks it (Spec-driven). An agent never finishes, ticks or approves anything.

A fresh agent sees only what it needs, so a long run does not fill one conversation, and each task is built without the history of the ones before it. BuildKeel ships its agents with the plugin, for Claude Code and for Antigravity: there is nothing to install or turn on.

## Fresh agents or here

When `/bk:build` shows what it would build, it asks how to go on:

1. **Build them all, each in a fresh agent**: the default.
2. **Build them all here**, in this conversation: the default when the team sets `runs.build: here`, or when the session cannot start agents, such as when the tool for starting agents is turned off in your settings. Claude says why.
3. **Build the next one only**, then stop and name the next.
4. **Set it up and work together**: start it, build nothing, and ask you how to begin.

In Full SDLC, when some ready tasks are independent of each other, it also offers to build them at the same time (see [Parallel runs](#parallel-runs)). A single task can be built in a fresh agent too: ask for it.

Built here or in agents, each task is reviewed after it is built, by the reviewers that are on, unless reviews after each task are off. Finishing then reviews only what is new since: see [What /bk:done reviews](reviews.md#what-bkdone-reviews).

The default is **Fresh agent per task**, set with `runs.build` in `buildkeel.yaml`: `fresh-agents` or `here`. It only decides which choice comes first: the other is always offered too. See [Settings](settings.md#building).

## What each agent is given

Each agent gets the task's own context, the interfaces the tasks before it built, and the rulings made so far in the run. It does not get the whole plan or your conversation. Claude asks BuildKeel for that view, which starts like this:

```
# Active unit: TK-001 v1 "Reset endpoint"
BI-01 v1 › EP-01 v1 › US-001 v1 › TK-001 v1
Commits: end every message with "BuildKeel-Unit: TK-001".
Tests: put the test case ID in the test's name, such as [TK-001-TC1]. Record each run's JUnit XML report with test_results.
Your part: build this task test first, commit with the line above, and end with your status: finished, finished with concerns, has a question, or blocked. Do not finish the unit, tick a task, approve anything or change the spec tree.
```

Then come the task, why it is wanted, its acceptance criteria with their test cases, and its design, as in [The context Claude receives](working-on-a-unit.md). When a task uses something an earlier task delivered, the view says what that task built, from its `Built:` line, and not what was planned (see [The Built line](working-on-a-unit.md#the-built-line)). In a change, the agent gets its one task, not the whole task list.

The agent builds test first (see [TDD](tdd.md)), commits with the unit's line, records its test runs, and ends with one status:

- **finished**: the run goes on to the review.
- **finished with concerns**: Claude shows each concern. A concern about what was agreed stops the run and asks you.
- **has a question**: see [Questions and rulings](#questions-and-rulings).
- **blocked**: the run stops, says why, and asks you.

Before the review, Claude checks the agent's work: its commits carry the unit's line, and its test runs are recorded. If an agent cannot be started, Claude follows [When agents can't be started](#when-agents-cant-be-started).

## Questions and rulings

When an agent asks a question, Claude first looks for the answer in the spec, then in the unit's notes and the rulings already made, and, once your tree has them, in the glossary and your team's practices.

- **The answer is there**: Claude answers with it, names where it comes from, and says the ruling to you in a line, such as: "US-001-AC2 says the link expires after 30 minutes." Each later agent in the run is given the ruling too.
- **Nothing answers it**: the run stops and Claude asks you one question, with its recommendation. A requirement is never guessed, by Claude or by the agent.

## What a task uses, checked as the run reaches it

Before a run starts, and again before each task, Claude asks BuildKeel for the run's plan. It orders the tasks, each after the tasks it uses, and checks everything each one uses against what is there now: an earlier task's `Built:` line, the file it names, and your project's dependencies.

```
Run of CH-002: 2 tasks to build, in this order: 2.2, 2.3.
- 2.2 Email the code: what it uses is there
  - createResetCode (from 2.1): built differently, built as createResetCode(user: User), in place of createResetCode(userId)
- 2.3 Store the code: something it uses is missing
  - ResetCode (from 2.1): missing, its Built line says ResetCode was not built

Next: 2.2, ready to start. Call this view again before each task: it is checked against what the tasks before it built.
```

Something built differently is given to the agent as it was built, and the run goes on. Something missing stops the run before that task, names it, and asks you how to go on. Tasks that use each other in a loop stop the run before it begins.

## Parallel runs

In a Full SDLC tree, tasks that are independent can be built at the same time: neither uses what the other delivers, directly or through other tasks, and they list no file in common in their Files. The run's plan says which:

```
Can be built at the same time, up to 3 at once, each in its own worktree: TK-001 and TK-002 and TK-003; then TK-004.
```

Each task gets a worktree of its own, a second checkout of your repository under `.buildkeel/worktrees/`, with the task started there on its own branch. Its agent works only there, and BuildKeel checks its edits against that task:

```
Added TK-001's worktree at /home/you/payments-api/.buildkeel/worktrees/TK-001, from this checkout's commit (4abbce1), and started TK-001 there on its branch bk/TK-001-reset-endpoint: it is the active unit there, and claimed by that worktree.
```

Each task is reviewed and finished on its own branch. Once a batch is finished, the branches are merged, in task order, onto one branch for the run, `bk/run-<parent ID>`, one at a time, with the tests run after each merge. First, BuildKeel compares what each task actually changed:

```
Parallel run of US-001: TK-014 on bk/TK-014-health-check, TK-015 on bk/TK-015-version-endpoint, merged in this order onto bk/run-US-001, which starts from HEAD.
- TK-014 changed src/health.ts, src/routes.ts
- TK-015 changed src/routes.ts, src/version.ts
Changed by more than one task: src/routes.ts (TK-014, TK-015). Their branches may conflict, and the tests after each merge matter more.
Outside the task's Files: src/routes.ts (TK-014); src/routes.ts (TK-015).
```

A conflict undoes the merge and stops the run to ask you:

```
Merging TK-015's branch bk/TK-015-version-endpoint onto bk/run-US-001 conflicts in src/routes.ts. The merge was undone, and nothing else was merged.
```

If you tell Claude to resolve it, the merge is left open, only the files in conflict can be changed, and the merge is committed once no conflict marker is left. A failing test after a merge stops the run too. At the end, `bk/run-<parent ID>` holds the whole run, and one pull request from it reviews it all.

The most tasks run at the same time is 3 by default. `1` turns parallel runs off, and a change applies from the next run:

```yaml
process:
  runs:
    parallel: 2
```

In a Spec-driven tree, a change's tasks are built one after another.

## Models and effort for each role

Each agent runs as one of ten roles: the implementer; the spec reviewer and the quality reviewer after each task; the final spec reviewer and the final quality reviewer at finish; break-it; the readiness readers; edge-case suggestions; the designers; and the note checker. By default every role uses your session's model and effort. To set one, name a tier for it:

```yaml
process:
  agents:
    roles: { implementer: principal, spec-reviewer: standard, quality-reviewer: standard }
    handoff: { tier: principal, after: 2 }
```

Two tiers are ready to use:

- **standard**: Sonnet at medium effort in Claude Code, `flash` in Antigravity;
- **principal**: Opus at high effort in Claude Code, the conversation's model in Antigravity.

You can change them or add your own under `tiers`, each with a model and an effort for each host; either can be `inherit`. Principal handoff is the tier for one more round of fixes when the fix rounds do not clear a review's finding (see [The fix loop](reviews.md#the-fix-loop)): the principal tier after 2 rounds by default, or `tier: none` to stop and ask you instead.

`/bk:settings` shows each role as it runs on your host, and how Claude starts each agent. In Claude Code:

```
Agents, as they run in Claude Code:
- The implementer: the principal tier: opus at high effort.
- The spec reviewer, after each task: the standard tier: sonnet at medium effort.
- The quality reviewer, after each task: the standard tier: sonnet at medium effort.
- The final spec reviewer, at finish: inherits the session's model and effort.
- The final quality reviewer, at finish: inherits the session's model and effort.
- Break-it: inherits the session's model and effort.
- The readiness readers: inherits the session's model and effort.
- Edge-case suggestions: inherits the session's model and effort.
- The designers: inherits the session's model and effort.
- The note checker: inherits the session's model and effort.
- Principal handoff's round: the principal tier: opus at high effort.
```

Antigravity sets an agent's model only in the agent's own definition and has no effort setting for agents. So BuildKeel ships two of each agent there, one on the conversation's model and one on `flash`, and Claude starts the one the role's tier names. An effort is ignored there, and a tier that names a model other than `flash` runs on the conversation's model; `/bk:settings` says so:

```
Agents, as they run in Antigravity:
- The implementer: the principal tier: the conversation's model.
- The spec reviewer, after each task: the standard tier: flash.
```

## When agents can't be started

Agents may not start: the session has no tool for starting them, it is turned off in your settings, or the model tier a role names is not available. Every feature that starts agents then follows the same rule:

1. **Claude says why, once,** in a line.
2. **It retries once** when an agent started but failed, before treating agents as unavailable.
3. **It follows the feature's switch.** With `off`, nothing happens. With `ask`, the offer says the check would run here, without a fresh reader. With `auto`, and for the implementer and the reviewers, which have no such switch, Claude does the work here and says so in a line.
4. **It labels the result** as done here, not by an independent agent: in what it shows you, and in the record. A question or a proposal is shown as Claude's own reading.
5. **It never counts where independence is the point.** A final review done here does not satisfy the done gate's review-findings check, so the unit is reported as not independently reviewed.

## Picking up a run again

A run keeps no progress file of its own. Its ticks, completion records, test runs, reviews and commits are what it is picked up from, after the conversation is compacted or on another machine. Running `/bk:build` again on the same parent or change goes on from the first task not finished or ticked.
