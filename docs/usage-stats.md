# Your usage

BuildKeel keeps a record of how you use it, on your own machine, so you can see what the process did for you: what you finished, how long it took, and what the checks caught along the way. The record never leaves your machine: BuildKeel sends nothing anywhere.

## See it

```
/bk:stats
```

Choose a period: the last 30 days (press Enter), the last 7 days, or all of it. You can also give a number of days: `/bk:stats 90`.

```
In the last 30 days (since 2026-09-02): 4 units finished, the gates stopped work 4 times and caught 3 coverage gaps, and 3 suspects were decided.
Recorded on this machine only, for Payments; nothing is sent anywhere.

Units finished: 4 (task 3, ad-hoc unit 1).
Recorded as ad-hoc units: 1 of 4 (25%).
Time from start to done: 1 h 3 min typically (the median), 2 h 30 min at the longest.

| Gate | Passed | Warned | Blocked |
|---|---|---|---|
| approve | 9 | 0 | 1 |
| start | 4 | 0 | 2 |
| done | 4 | 0 | 1 |

Coverage gaps caught by a gate: 3.
Suspects: 3 raised; 2 kept as still valid, 1 needing change.
Drafts: 11 created (8 captured from a conversation); 9 approvals.
Context loaded for a unit 14 times; 2 units started in a build run.
```

- **Units finished**, by type, and the share recorded as ad-hoc units.
- **Time from start to done**: from starting a unit to finishing it.
- **Gates**: how often each one let work through, warned, or stopped it. A gate that stopped an approval, a start or a finish caught something before it went further.
- **Coverage gaps caught**: acceptance criteria with no test case, found by the approve or start gate.
- **Suspects**: work built against something that changed since, and how each was decided. See [Change impact](change-impact.md).

Before anything is recorded, `/bk:stats` says there is nothing to show yet.

## What is recorded

One line for each of these, with the IDs, types, outcomes and time, and the coding agent it happened in:

- a draft created, and whether it came from a captured conversation;
- an approval;
- a gate's outcome, with the names of the checks that failed, such as `test-plan-gap`: every time a gate stops something, and a pass or a warning when the work goes ahead;
- a unit started, and whether a build run started it; a unit finished, with how long it took;
- something becoming suspect, and the decision on it;
- a unit's context loaded;
- an ad-hoc unit or a bug recorded.

The text of your requirements, designs, tests and code is never recorded.

The record is kept in `~/.buildkeel/usage/`, one file per spec tree, outside every repository: committing and pushing your work never includes it.

## Turn it off, delete it, or export it

Run `/bk:stats` and choose **Change the record**, or say what you want:

- `/bk:stats off`: nothing new is recorded. Everything else works as before.
- `/bk:stats on`: recording starts again.
- `/bk:stats delete`: deletes the record on this machine, after you confirm. It cannot be undone.
- `/bk:stats export`: writes this spec tree's record to a file you choose, such as `~/buildkeel-usage.jsonl`: one JSON line per event.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-stats`.
