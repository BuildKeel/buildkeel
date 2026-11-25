# Execution records and analytics

Each task built in a run leaves an execution record: which agents worked on it, on which model, what they did, the tokens they used, and how it ended. The analytics files add a line for each, and one for each finished unit, so the team can see how its work goes over time. Both point to the work; neither copies spec text, code, test output or the conversation.

## Before you start

Nothing to turn on: every build run with `/bk:build` writes them, in both modes, whether a task is built in fresh agents or in the conversation. There is no switch.

## 1. Read a task's execution record

When a task's run ends, or stops, Claude closes it with the record's summary, the outcome first:

```text title="/bk:build"
Finished: TK-013's reset endpoint, with TK-013-TC1 and TK-013-TC2 red then green, reviewed clean in one round.
```

The record itself is in the task's folder, `tasks/TK-013/executions/<time>-<rand>.yaml`, or in a Spec-driven tree the change's, `changes/CH-004-.../executions/`, with the task's number:

```yaml
schema: 1
unit: "TK-013"
run: "run-20261122T091500Z-k3q8"
summary: "Finished: TK-013's reset endpoint, with TK-013-TC1 and TK-013-TC2 red then green, reviewed clean in one round."
outcome: "finished"
given:
  versions: ["TK-013 v1", "US-012 v2", "EP-03 v1"]
  context: { view: "implementer of TK-013", hash: "9f2c41d7a0b3e8c5" }
sessions:
  - role: "implementer"
    tier: "standard"
    model: "claude-sonnet-5-5"
    effort: "medium"
    started: "2026-11-22T09:15:04Z"
    minutes: 12
    round: 1
    usage: { input: 41200, output: 9800, cache-read: 310400, cache-write: 22100 }
    did: ["read src/auth/reset.ts", "write test/auth/reset.test.ts", "run npx vitest run test/auth", "buildkeel test_results", "edit src/auth/reset.ts"]
    asked: []
    chose:
      - { choice: "a map for pending codes", why: "lookups are by code", instead-of: "a list", at: "src/auth/reset.ts:42", checked: "supported" }
    outcome: "finished"
stops: []
departures: []
totals: { minutes: 15, usage: { input: 52900, output: 11200, cache-read: 402100, cache-write: 25300 }, rounds: 1 }
```

- **run:** each `/bk:build` is one build run, with its own ID. A run of tests is a test run, and its summaries are in `test-runs/`.
- **given:** what the agents were given, by reference: the versions, and the implementer's view by its hash.
- **sessions:** one entry per agent: its role, tier, model and effort, when it started and for how long, its fix round, the tokens it used, what it did (files read and written, a command's first line, the tools it called), what it asked, the choices it made by itself, and how it ended.
- **stops** and **departures:** why the run stopped on this task, and where the build departed from the plan.
- **totals:** minutes, tokens and fix rounds for the task.

When an agent's transcript cannot be read, what it did is taken from its report, and the record says so; its tokens are left out with the reason, never made up. A long list of actions, over 20 KB, is folded to a line per phase, such as `read 140 files`, and the record says so.

## 2. See the choices an agent made by itself

An implementer chooses only how to build: a data structure, a helper's name, how the code is split. It lists each such choice in its report, with why, what it was chosen over, and a file and line. The note checker reads each one and gives it a verdict:

- **supported:** kept in the record;
- **not supported:** left out of the record, and Claude tells you why;
- **about behavior,** something a user or a test could observe: Claude shows it to you at the end of the task, as something that should have been asked. **Keep it**, and it becomes a ruling with your words as its source; **Change it**, and it goes through the fix loop.

## 3. Find the tokens a unit used

Finishing a unit or a change totals the tokens over all its execution records, from `/bk:build` to `/bk:done`, in its completion record:

```yaml
usage:
  runs: 2
  tasks: 3
  minutes: 41
  usage: { input: 128000, output: 30100, cache-read: 905000, cache-write: 61000 }
```

When a session's tokens could not be read, the total leaves it out and names it, with why. Cost is never stored, only token counts. Claude Code and Pi record cache writes; Antigravity does not, and an older Antigravity records no token counts at all.

## 4. Read the analytics files

At the top of the spec tree, `analytics/` holds two files, one JSON line per entry, each with `schema: 1`:

- **`runs.jsonl`:** a line for each execution record, written in the same commit, or in a Spec-driven tree with the change's other files, committed when it is archived.
- **`units.jsonl`:** a line for each finished task, story, defect, ad-hoc unit or change, in the same commit as its completion record, with totals over its runs.

A line holds counts, names and pointers: which work, who and when, how it was built, its agent sessions with their tokens and action counts, stops, questions asked, own choices, findings by severity and answer, fix rounds, handoffs, tests and TDD evidence, size, departures, and a run's summary.

```json
{"schema":1,"unit":"TK-013","run":"run-20261122T091500Z-k3q8","at":"2026-11-22T09:31:10Z","outcome":"finished","built":"fresh-agents","sessions":[{"role":"implementer","tier":"standard","model":"claude-sonnet-5-5","effort":"medium","minutes":12,"round":1,"tokens":{"input":41200,"output":9800,"cache-read":310400,"cache-write":22100},"actions":{"read":1,"write":1,"run":1,"buildkeel":1,"edit":1}}],"stops":0,"questions":{"asked":0},"choices":{"made":1,"accepted":1,"behavior":0},"rounds":1,"departures":0,"size":{"filesWritten":2},"totals":{"minutes":15,"tokens":{"input":52900,"output":11200,"cache-read":402100,"cache-write":25300}},"summary":"Finished: TK-013's reset endpoint, with TK-013-TC1 and TK-013-TC2 red then green, reviewed clean in one round."}
```

The files are only ever added to, so two branches that each add lines merge with no conflict: setup writes `analytics/*.jsonl merge=union` in the tree's `.gitattributes`. When a finished unit's records are folded into its completion record, its lines stay.

## 5. Rebuild the analytics files

Ask Claude in your own words, such as "rebuild the analytics". It rebuilds both files whole from the records, those folded into completion records included, and commits them on their own:

```text
Rebuilt analytics/runs.jsonl (14 lines, one per execution record) and analytics/units.jsonl (6 lines, one per finished unit or change) whole from the records, those folded into completion records included, committed as 3c9e2a1.
```

> **What stays where.** Execution records, the analytics files and token totals are part of the spec tree, and are committed and pushed with it like other records. Your personal usage record for `/bk:stats` stays on your machine: see [Status and usage](status.md).

**More:** [Build](working-on-a-unit.md), [Records and the audit trail](records.md), [Models and effort per role](models.md).

Commands are shown in Claude Code's form. In Antigravity and Pi, use a hyphen: `/bk-build`.
