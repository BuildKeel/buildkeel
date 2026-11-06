# Reviews

Code is reviewed by three fresh agents, none of which wrote it or sees the conversation that built it:

1. **The spec reviewer** checks the work against each requirement, acceptance criterion or scenario, by its ID.
2. **The quality reviewer** reviews the diff for its quality.
3. **The break-it agent** writes tests that try to break the code.

Reviewers change nothing: no file, branch or commit. What they find is recorded on the unit or change, and each finding stays open until it is fixed, parked as a defect, or rejected with evidence.

## When reviews run

- **After each task in a run**, as `/bk:build` builds it, whether in a fresh agent or here. `reviews.each-task: off` turns these off: the work is then reviewed when it is finished.
- **The final review**, when `/bk:done` finishes the unit or change. It reviews nothing twice: see [What /bk:done reviews](#what-bkdone-reviews).
- **Whenever you ask**, with `/bk:review`.

## Turning reviewers off

Each reviewer can be turned off on its own in `buildkeel.yaml`, and all three are on by default:

```yaml
process:
  reviews:
    spec-compliance: on   # the spec reviewer
    code-quality: on      # the quality reviewer
    break-it: off         # the break-it agent
    each-task: on         # the review after each task
```

A reviewer that is off is not started, and the review input names it as switched off. Spec compliance still runs at finish when no review has run, or every reviewer is off, so nothing is finished without a check against its spec. Each unit's record notes the reviewers that were on, so a reader can tell "reviewed, nothing found" from "built with reviews off". See [Settings](settings.md#review).

## What a review is given

Each review gets a package built from the records, not from the conversation: the diff of the unit's own commits, found by their `BuildKeel-Unit` line, so another unit's commit on the same branch is left out; the spec by ID, with the design; and the evidence of its test runs. For a task of a change, only that task's commits are in it.

```
Review packages for TK-001:
- /home/you/payments-api/.buildkeel/review/TK-001: diff.patch, 2 commits (89b89f8, e8d1eb3), changing test/reset.test.ts, src/reset.ts; view.md, the spec by ID, the design, and the test evidence, with no working notes or rulings
```

The break-it agent also gets a worktree of its own, a second checkout of the code as it is, where it writes and runs its tests. The dependency folders your main checkout has installed, such as `node_modules`, are linked into it, so its tests run without an install (see [Installed dependencies in these worktrees](tdd.md#installed-dependencies-in-these-worktrees)). Its tests are never committed, and the worktree is removed once its review is recorded.

## What each reviewer reports

**The spec reviewer** first lists anything it chose not to judge, with why. Then it gives each requirement, criterion or scenario one verdict: **met**, with its evidence (a passing tagged test, or a file and line), **partly met**, with what is missing, or **not met**. Partly met and not met are findings, Medium unless the reviewer shows they are High.

**The quality reviewer** reviews the diff for alignment with the plan, code quality, architecture, testing, production readiness, and each of your team's practices. Each finding has a severity:

- **High**: a defect in the code, a security issue, a risk of losing data, or broken functionality;
- **Medium**: a problem of architecture, missing functionality, poor error handling, or a gap in the tests;
- **Low**: style, an optimization, or the polish of docs.

Each finding names a file and line, says what is wrong and why it matters, and how to fix it when that is not obvious. A finding with no file and line is dropped. The review ends with what was done well and a verdict: ready, ready with fixes, or not ready.

**The break-it agent**'s findings are its tests that fail. For each, Claude asks you whether it is a defect found while building (the test becomes its regression test) or a question about the spec, where the agreed behavior is what is wrong. Tests that pass are thrown away.

**Behavior the spec does not mention**, but a user would expect, such as a limit on how often a reset can be asked for, is never a requirement not met. Reviewers propose it as an addition to the spec, and you decide.

## Findings are recorded

Claude records each reviewer's report as it is. Each finding gets an ID, such as `TK-001-Faip`:

```
Recorded the code quality review of TK-001 (final), by a fresh agent, in tasks/TK-001/reviews/20261102T183019Z-0z2c.md, committed in the spec repo as 1d6dd2c.
Findings:
- TK-001-Faip High src/reset.ts:3 (production readiness): The reset token is written to the log
- TK-001-Feqq Low src/reset.ts:1 (code quality): reset is a vague name for a request handler
Dropped, with no file and line: "error handling could be better".
```

Each review is a file of its own in the unit's `reviews/` folder in the spec tree, committed when it is recorded.

## Answering findings

Claude checks each finding against the code before acting on it: a finding is not right only because a reviewer made it. Then it is answered one of three ways:

- **fixed**, naming the commit that fixed it;
- **parked**, once you agree to handle it later: recorded as a defect found while building, and the finding names the defect;
- **rejected**, with the evidence: the code, a test or the spec that shows it is wrong. Claude shows you each finding it rejects, with its evidence.

```
Answered TK-001-Faip (High, src/reset.ts:3): fixed in b10cae8, in tasks/TK-001/answers/TK-001-Faip.md, committed as 7a8cab7.
```

```
Answered TK-001-Fafq (Medium): parked as DEF-001, in tasks/TK-001/answers/TK-001-Fafq.md, committed as 95e1175.
```

A Low finding can stay open.

## The fix loop

In a run, an open High or Medium finding stops its task. Claude gives the finding to the task's implementer to fix, then the fix is reviewed again by the reviewers that are on. A fix and its review are one round.

**Principal handoff.** Like an engineer's stuck work handed to a principal engineer: after two rounds that leave a finding open, the implementer runs once more on the handoff tier, *principal* unless the team names another (see [Models and effort for each role](building-with-agents.md#models-and-effort-for-each-role)), with the finding and what each round tried. The usual reviewers check its fix.

When the principal's round leaves the finding open too, the run stops and shows the whole story: the finding, each fix tried and why its review rejected it, and the principal's attempt. You choose how to go on, with Claude's recommendation:

- **Fix it together here**;
- **Park it**, as a defect or a follow-up: the task stays not done in this run;
- **Reject the finding**, with its evidence.

While the finding is open, the task is never ticked or finished, whatever the gate modes say. The failed handoff is recorded, and three of them make a pattern for the [Learning loop](status.md#the-learning-loop).

Principal handoff is on by default. `agents.handoff` sets the tier and the number of failed rounds before it, such as `{ tier: careful, after: 3 }`, and `tier: none` turns it off: the run then stops and asks you after the fix rounds. See [Settings](settings.md#building).

## /bk:review

`/bk:review` reviews the active unit or change, or the one you name, such as `/bk:review TK-001`, with the reviewers that are on. Its findings are recorded on it, and you decide how to answer each. You can also give a range of commits, such as `/bk:review main..HEAD`: a range belongs to no unit, so its review is shown and not recorded.

## What /bk:done reviews

`/bk:done` runs the final review before it shows what finishing will record, in both modes. It reviews nothing twice:

1. The commits since the last review are reviewed, and only those, by the reviewers that are on.
2. With nothing new since the last reviews, there is no quality or break-it review at finish.
3. Spec compliance always runs at finish when no review has run on the work, or every reviewer is off.
4. A change built in a run gets one spec-compliance review of the whole change at finish, even when every task was reviewed, because each task's reviewer judged only that task's requirements.

The review input says which reviewers to start, on how many commits, and why, so Claude starts only those.

## The final review and the done gate

Finishing shows each finding with how it was answered:

```
Reviews: the final review by fresh reviewers has run.
Findings (3, 0 High or Medium still open):
- TK-001-Faip High src/reset.ts:3 (production readiness): The reset token is written to the log [fixed in b10cae8]
- TK-001-Fafq Medium (US-001-AC2): Nothing expires the link after 30 minutes [parked as DEF-001]
- TK-001-Feqq Low src/reset.ts:1 (code quality): reset is a vague name for a request handler [open, Low]
```

In Full SDLC, the done gate's review-findings check fails for a unit with a High or Medium finding neither fixed, parked nor rejected, or with no final review. Low findings are not part of it. The check has its own mode, warn by default: it is shown with the finish, and the unit can be finished. Set it to block to refuse the finish instead, or to off:

```yaml
process:
  gates:
    review-findings: block
```

```
Finish of TK-001 refused by the done gate: 2 checks failed.
1. TK-001-Faip High src/reset.ts:3 (production readiness): The reset token is written to the log: a High finding, neither fixed, parked nor rejected.
   To fix: Check it against the code, then fix it and answer it as fixed with its commit, park it as a defect once the user agrees, or reject it with its evidence (review, action answer).
```

In a Spec-driven tree, finishing a change reports its findings and never blocks on them, with **Fix first** as the default choice while a High or Medium finding is open.

Every finding, with its reviewer and how it was answered, is kept in the unit's completion record, and for a change, with the archived change.

## When agents can't be started

When the session cannot start agents, Claude follows the rule every agent follows (see [When agents can't be started](building-with-agents.md#when-agents-cant-be-started)): it says why once, retries once if an agent started but failed, then reviews the work in the conversation, as each reviewer would, and records it as reviewed by the author. A review by the author is not an independent review: it does not count as the final review for the done gate, which reports the unit as not independently reviewed, and the completion record says who reviewed it.
