# TDD

TDD, test-driven development, means writing each test before its code. A test written before its code, and seen failing, shows that it checks the behavior: it failed while the behavior was missing and passed once the code was there. BuildKeel records that evidence as you work, from git and the test reports, and shows it when the unit is finished. It also runs checks on the tests themselves: whether they need the code, whether they were weakened, which changed lines no test ran, and, when you turn it on, which small changes to the code no test noticed.

None of this asks you to work in a particular order inside a commit. It asks for one habit: write the test, run it and see it fail, and commit it on its own before the code.

## Red, then green

1. Write the test, tagged with its test case's ID (see [Tests](finishing-a-unit.md#tests)).
2. Run it. It fails, because the code is not there yet. That run is the test's **red run**.
3. Commit the test on its own.
4. Write the code, run the tests again, and see them pass: the **green run**. Commit the code.

Claude works this way, and records each run with BuildKeel. You can do the same in a terminal; any run you give BuildKeel counts.

## How BuildKeel tells

BuildKeel never asks Claude whether a test failed first; it works it out from git. When a test report is recorded, BuildKeel notes the commit the working tree is on and the files changed since it. A failing run counts as a red run when **only test files** have changed since the last commit: the test is new or changed, and the code is not.

```
TK-001: 0 of 3 test cases pass, 2 fail, 1 without a current passing or failing result.
Read .buildkeel/report.xml: 2 tests, 2 tagged with a test case. Results are recorded for this working tree only (local results).

TDD:
- TK-001-TC1: red run recorded, with only test files changed since the last commit. Commit the test on its own now, before the code that makes it pass.
- US-001-TC1: red run recorded, with only test files changed since the last commit. Commit the test on its own now, before the code that makes it pass.

Test cases of TK-001 (local results):
- TK-001-TC1 Endpoint validates its input: failed: test/reset.test.ts > rejects a missing email [TK-001-TC1]
- US-001-TC1 Link arrives (from US-001-TP): failed: test/reset.test.ts > emails a reset link [US-001-TC1]
- US-001-TC2 Link expires (from US-001-TP): no tagged test, left for the story
```

A failing run with code files changed too is not a red run, and BuildKeel says why, naming the code files. A test case whose first recorded run passes has **no red run**:

```
- TK-001-TC1: passed with no red run on record. If a reason applies (characterization, refactor, no behavior), state it with exceptions; otherwise finishing reports it.
```

**Test files** are known by their names and folders: `*.test.*`, `*.spec.*`, `*_test.*` and `test_*.py`, and files under a `test/`, `tests/`, `__tests__/` or `src/test/` folder anywhere in the repository. A file a test report names is a test file too. When your tests live somewhere else, such as `spec/` or `*Tests.cs`, add their patterns:

```yaml
process:
  tests:
    paths: ["spec/**", "*Tests.cs"]
```

The runs are kept in `.buildkeel/test-evidence.json` in your working tree, never committed. When the unit is finished, and at each task of a change, a summary of them is written into the spec tree, in the unit's `runs/` folder, so the evidence travels: finishing on another machine finds the red runs there.

## When a test needs no red run

Some tests cannot fail first, and that is fine when you say why. Three reasons are accepted:

- **characterization**: the test describes how existing code behaves today, before you change it;
- **refactor**: the code changes shape and its behavior does not, so its tests pass before and after;
- **no behavior**: the change has no behavior to test first, such as configuration or a dependency upgrade.

Tell Claude which test case and why, and it records it:

```
Recorded: US-001-TC1 needs no red run (characterization): describes how the mailer answers today. Tell the user, in these words; it is shown again at finishing.
```

BuildKeel never infers an exception. The reason is shown at finishing and kept in the completion record.

## A red run that was never saved

If a test was committed on its own but its failing run was never given to BuildKeel, a **red check** can still show it. Claude asks BuildKeel for one: it makes a worktree at the commit that added the test, before the code, runs the test there, and records the run as its red run when it fails. The worktree is removed afterwards. A test committed together with its code cannot have a red check; finishing says so.

## The revert check

A test that passes without the unit's code does not check what the unit built. The **revert check** finds such tests: BuildKeel makes a worktree at the commit before the unit's first code commit, puts the unit's test files in it as they are now, and Claude runs them there.

```
Prepared the revert check of TK-001 in /home/you/payments-api/.buildkeel/worktrees/revert-TK-001: the code as it was at 9c4e2a1, before TK-001's first code commit, with TK-001's test files as they are now (test/reset.test.ts).
Run TK-001's tagged tests there, from that directory, with a JUnit XML reporter writing into it, then call test_results with that report's path and purpose revert-check. Change nothing there; the worktree is removed once the run is recorded. If the tests cannot run there, call manage with action revert-check and remove true.
Until then, do not run the full test suite from the repository root: many test runners would find the copies of the tests in the worktree and run them against the old code.
```

### Installed dependencies in these worktrees

A new worktree holds only what git tracks, so it has no `node_modules` and no virtual environment. For the revert check, a red check and the break-it agent (see [Reviews](reviews.md)), BuildKeel links in the dependency folders your main checkout has installed and git ignores, so the tests run there without an install first:

- `node_modules`, wherever git finds one, such as one in each package of a workspace;
- `.venv`, `venv` and `vendor` at the top of the repository.

Each is a symbolic link, or a junction on Windows, and the message that prepares the worktree lists them. The agent never installs, updates or removes a package while a link is there, since that would change your main checkout. Removing the worktree removes the links first and leaves your folders as they were.

A folder is not linked when it holds links to your repository's own files, such as workspace packages in `node_modules` or an editable Python install: through the link, the tests would load your main checkout's code instead of the worktree's. The message names it, and the agent installs the dependencies in the worktree as your project does. A worktree for a task built in parallel gets no links, since its implementer may add or change a dependency.

```
Revert check of TK-001, from .buildkeel/worktrees/revert-TK-001/report.xml (at 9c4e2a1), without the unit's code:
- TK-001-TC1: fails without the code, so its test needs the code.
- US-001-TC1: passes without the code: its test does not check what the unit built.
- US-001-TC2: not run in the revert check.
Removed the worktree .buildkeel/worktrees/revert-TK-001.
```

A test case with a stated exception is left out of the check. If a run from the repository root picks up the worktree's copies of the tests anyway, BuildKeel ignores them and says so.

## The test-file diff

At finishing, BuildKeel compares each of the unit's tests with how it was when it was added, and reports what makes a test weaker:

- an assertion removed;
- a check made weaker, such as an exact value replaced by "is defined";
- an expected value changed;
- a test skipped, or focused with `only`;
- a timeout raised.

A test that is as it was is not mentioned.

## Coverage of changed lines

When a test run writes an lcov or Cobertura report, finishing also lists each line the unit added or changed that no test ran. It is on by default, and only reports. See [Changed-line coverage](changed-line-coverage.md).

## Mutation testing

Mutation testing makes small changes to the code, such as `>` to `>=`, and runs the tests against each one. A change no test notices is a **surviving mutant**: a gap in the tests, even where every line ran. Where [changed-line coverage](changed-line-coverage.md) asks whether a test ran a line, mutation testing asks whether a test would notice if that line were wrong.

It is off by default, because it is slow and needs a tool of your own. BuildKeel runs no mutation tool itself: it runs the command you give it and reads that tool's report.

### Turning it on

Give the command that runs your team's mutation tool:

```yaml
process:
  checks:
    mutation: { command: "npm run mutate" }
```

`checks.mutation: off`, or leaving it out, turns it off. Each unit's record notes the command in force when the unit started, and finishing follows that.

### When it runs

At finishing, when a unit's work has no mutation run yet, Claude runs your command once, without asking, before showing what finishing will record. The run is scoped to the unit's work: the environment variable `BUILDKEEL_CHANGED_FILES` holds the code files the unit changed, separated by spaces, with test files left out. Your command should mutate only those files, or a run over the whole project can take a long time:

```json
{
  "scripts": {
    "mutate": "stryker run --mutate \"$(echo $BUILDKEEL_CHANGED_FILES | tr ' ' ',')\" --reporters json"
  }
}
```

That example uses Stryker, which takes the files to mutate as a comma-separated list, and writes its JSON report to `reports/mutation/mutation.json`. Any tool works that can be limited to a list of files and writes the report below.

### The report

BuildKeel reads JSON in the open mutation testing report schema, the format Stryker and other tools write: a `files` object, with each file's mutants and their status. Claude records the report with the run. A mutant counts as surviving when its status is `Survived`, or `NoCoverage`, when no test ran its code at all. Each one is named with its file, line, the kind of change, and the code it put there:

```
Read reports/mutation/mutation.json: 1 mutant survived, so no test noticed these changes:
- src/reset.ts:2 EqualityOperator: `age >= 30`
```

BuildKeel lists every surviving mutant the report holds, so a report from a run over other files lists those too. A report that is not JSON in that schema is refused, with the reason, and nothing is recorded.

### What finishing shows

Finishing shows the mutation run under "TDD and the checks on tests": no mutant survived, or each surviving mutant, or, when the run has not happened, the command to run with the files to pass. For each surviving mutant, the answer is a test that fails with the change, tagged with the test case it belongs to. Like coverage, it is reported and never blocks a finish. The surviving mutants are kept in the completion record.

## At finishing

Finishing shows the evidence for each test case of the unit, then the checks on its tests:

```
TDD and the checks on tests:
- TK-001-TC1: red at 06872dc, green at 72712eb
- US-001-TC1: no red run needed (characterization): describes how the mailer answers today
Revert check (9c4e2a1): 1 of 1 test cases fail without the unit's code.
Test-file diff, since each test was added:
- TK-001-TC1, test/reset.test.ts:3: check made weaker: `expect(body.error).toEqual("Email is required");` became `expect(body.error).toBeDefined();`
Coverage (coverage/lcov.info): changed lines no test ran. For each, tie it to a test case by writing or extending a test, or raise it as behavior no spec describes:
- src/reset.ts: lines 4
Mutation testing: not run yet. Run `npm run mutate` with BUILDKEEL_CHANGED_FILES set to the changed files (src/reset.ts), then record its JSON report with test_results and purpose mutation.
```

The same lines are kept in the completion record, under `testFirst` (see [The completion record](finishing-a-unit.md#the-completion-record)), and in the run summary written into the unit's `runs/` folder.

## Turning it on or off

In Full SDLC, TDD is the done gate's **TDD check**: a test case of the unit with no red run and no stated exception, or a test that passes without the unit's code. It has a mode of its own, set beside the gates:

```yaml
process:
  gates:
    tdd: warn    # block | warn | off
```

- **warn** (the default): finishing goes ahead, with the check's finding as a warning.
- **block**: finishing is refused until the test case has a red run, a red check, or a stated exception:

  ```
  Finish of TK-001 refused by the done gate: 1 check failed.
  1. TK-001-TC1 has no red run: no recorded run shows its test failing before the code.
     To fix: Next time, record a failing run of the test while only test files have changed, and commit the test before the code; or state an exception for TK-001-TC1 if one applies (characterization, refactor, no behavior).
  ```

- **off**: TDD is off. Red runs, the revert check and the test-file diff are not checked, and finishing says so in a line.

The check follows its own mode, whatever the done gate's: with `tdd: block`, it refuses even while the done gate itself only warns.

In a Spec-driven tree, TDD is reported when a change is finished, and never blocks it. `checks.tdd: off` turns it off:

```yaml
process:
  checks:
    tdd: off       # reported | off
    coverage: off  # on | off
```

Changed-line coverage is on by default in both modes, and `checks.coverage: off` turns it off. Mutation testing is off until you give its command, as [Mutation testing](#mutation-testing) says.

Each unit's record notes whether TDD was on when its work started, so work started with it off is never failed for missing red runs later. See [Settings](settings.md#testing).

## In a Spec-driven tree

Everything above works the same for a change, a defect and an ad-hoc unit: the red runs, the exceptions, the revert check, the test-file diff, coverage and mutation testing. The evidence is reported when the change is finished, and never blocks it. `checks.tdd: off` turns it off, as [Turning it on or off](#turning-it-on-or-off) says. Each time a task is ticked, a summary of the runs so far is saved in the change's `runs/` folder.
