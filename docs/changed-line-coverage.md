# Changed-line coverage

A test case can pass while part of the code the unit added never runs: a branch no test reaches, or an error path nobody tried. Changed-line coverage finds those lines. At finishing, BuildKeel lists each line the unit added or changed that no test ran, so you see untested new code line by line, not as a percentage of the whole project.

It is on by default, and only reports: no mode makes it block a finish.

## Giving BuildKeel the report

BuildKeel never measures coverage itself. Your test run writes a coverage report, and Claude gives it to BuildKeel with that run's test report. BuildKeel reads two formats:

- **lcov**, such as `coverage/lcov.info`;
- **Cobertura XML**, such as `coverage.xml` or `coverage.cobertura.xml`.

The format is recognized from the file's content, not its name. When the run is recorded, BuildKeel says the coverage was kept:

```
Coverage from coverage/lcov.info (lcov) is recorded with this run, for the check of changed lines at finishing.
```

A path with no file, or a file in neither format, is named, and the run is still recorded without its coverage.

Finishing uses the latest run of the unit that came with a coverage report. Run the whole suite with coverage before finishing: a report from a run of only some tests shows the lines the other tests cover as never run.

## Producing a report

Most test tools write one of the two formats with an option. For example:

| Tool | Command | Report |
|---|---|---|
| Vitest | `npx vitest run --coverage --coverage.reporter=lcov` | `coverage/lcov.info` |
| Jest | `npx jest --coverage --coverageReporters=lcov` | `coverage/lcov.info` |
| pytest, with pytest-cov | `pytest --cov --cov-report=xml` | `coverage.xml` (Cobertura) |
| .NET, with coverlet | `dotnet test --collect:"XPlat Code Coverage"` | `TestResults/<run>/coverage.cobertura.xml` |

Tell Claude the command your project uses, or put it in your test script, so every run writes the report. Add the report's folder to `.gitignore`: it is not part of the unit's code.

## Which lines count

- **The unit's own changes:** every line added or changed from the commit before the unit's first code commit to the latest commit. Uncommitted edits are not included, so commit before finishing.
- **Code files only:** test files are left out, found the same way as for red runs (see [How BuildKeel tells](tdd.md#how-buildkeel-tells)). So are the spec tree, when it is in the code repository, BuildKeel's own `.buildkeel/` folder, and the read-only copy of the glossary, practices and ADRs.
- **Lines the report instruments:** a blank line, a comment or a closing brace is not code the report counts, so it is never listed.
- **A line counts as run** when any test ran it, even once. Lines are checked, not branches: a one-line `if` whose condition a test ran counts as run, even when the branch it guards never was.

A unit whose commits change only test files has no changed lines to check.

**Paths.** File paths in the report are matched to the repository's files. An absolute path is read relative to the repository root, and so is a relative one. A Cobertura file name is read relative to the report's first `<source>`. If your tests run from a subfolder, such as one package of a monorepo, and the report gives paths relative to that subfolder, they do not match: run the tests from the repository root, or have the tool write absolute paths.

## What finishing shows

Under "TDD and the checks on tests", finishing shows one of these:

- **Lines no test ran**, by file, as ranges, such as `src/reset.ts: lines 4, 12-15` (see [At finishing](tdd.md#at-finishing) for an example).
- **Changed files the report does not cover at all**, listed apart, as "Not in the report at all". Usually the tests never loaded the file, or the report's paths do not match, as above.
- **Every changed line ran:** "every changed line the report instruments ran in a test".
- **No report:** "no run recorded a coverage report, so the changed lines were not checked for coverage". This is not a failure. It says the lines were not checked.

Each line no test ran has two possible answers:

- **tie it to a test case,** by writing a test or extending one, tagged with the test case it belongs to;
- **raise it as behavior no spec describes,** when the line does something no requirement asks for, so you can decide whether the spec should say it.

Neither is required: the lines are reported, and the unit can be finished with them listed.

The list is kept in the completion record, under `testFirst`, and in the run summary in the unit's `runs/` folder.

## Turning it off

`checks.coverage: off` in `buildkeel.yaml` turns it off in either mode, as [Settings](settings.md#testing) shows. Each unit's record notes whether it was on when the unit started, and finishing follows that. A unit started with it off says so in a line, and its changed lines are not checked.

## Related

- [TDD](tdd.md): red then green, the revert check and the test-file diff, which finishing shows beside the coverage.
- [Mutation testing](tdd.md#mutation-testing): whether the tests would notice if the changed code were wrong.
- [Test plans and coverage](test-plans.md): coverage of requirements by test cases, a different check: whether each requirement has a test, not whether each line ran.
