# What BuildKeel does not do

The limits BuildKeel keeps on purpose, so you can plan around them. Each says what BuildKeel does instead, and where to read more.

## Across machines

- **No shared test status.** Test results are recorded for the working tree they ran in, and labeled as local results. They are one machine's word, not a status every machine agrees on. See [Tests and traceability](test-plans.md).
- **No claims shared without a remote, or while offline.** A claim is shared through the spec repo's remote, on its `buildkeel/claims` branch. With no remote, claims stay on your machine, and a teammate can start the same unit. Offline, the start goes ahead with a warning, and two people can claim the same unit until the next status shows the clash to both. See [Status and usage](status.md#claims) and [Troubleshooting](troubleshooting.md#known-limits).
- **It does not push your code.** Finishing commits the completion record in the spec repo, and pushes it only when the tree's `settings.autoPush` is on. Pushing the code branch is up to you. See [Finish](finishing-a-unit.md).

## Other tools

- **No connectors of its own.** BuildKeel does not connect to other requirement or test management tools. Their content comes in through tools Claude can already read, such as your issue tracker through a tool you connected to Claude, a file, or the conversation, and is fitted to your templates, in drafting and in onboarding. See [Capture a plan](capture.md) and [Start on existing code](onboarding.md).
- **Three hosts only.** BuildKeel runs in Claude Code, Antigravity and Pi. See [Install](install.md).
- **It does not measure coverage.** Your test run writes the coverage report, and BuildKeel reads it. See [Tests and traceability](test-plans.md).

## Enforcement

- **It is not a security boundary.** Its hooks and gates keep Claude to the team's process. They do not protect files or code from a person or a tool that sets out to change them.
- **It does not stop edits made with other tools.** A file can always be changed with another editor, or by a shell command, which BuildKeel's edit checks do not see. It detects such changes instead: an approved version that no longer matches the hash in its approval record, or a record changed after it was written, shows in `/bk:status` and in validation. A commit made without a unit is listed under commits with no unit. See [Status and usage](status.md).
- **It does not stop code being written before its test.** The evidence that a test failed first is recorded and reported. In Full SDLC, a team can make its absence block finishing. See [TDD evidence](tdd.md).
- **It never starts a command for you.** Claude runs only the commands that read, `/bk:status`, `/bk:settings` and `/bk:stats`, on its own, and `/bk:pause` when you say words such as "let's stop here". Every other command waits for you to type it. Claude Code enforces this; Antigravity and Pi cannot, so there the agent is told the rule and follows it. See [Commands](commands.md).

## Tests

- **It does not read what a test checks.** A test belongs to a test case or scenario because its name carries the ID. A test with the right tag that checks the wrong thing passes. The checks on tests catch some of this, such as an assertion removed after the test was added, not all of it. See [TDD evidence](tdd.md).
- **It never asks Claude whether a test failed first.** It works that out from git and the test reports. See [TDD evidence](tdd.md).

## Your data and your history

- **It sends no data anywhere.** No artifact content, code or usage leaves your repositories and your machine. The network calls are git against your remotes, optional lookups and setup's optional repository with GitHub's CLI, and the version check: once a day, BuildKeel asks the npm registry for its latest version number. It sends nothing about you or your work. Turn it off in your settings (see [Personal settings](settings.md#personal-settings)). Your usage record stays on your machine. See [Status and usage](status.md).
- **It does not rewrite your git history.** Commits without a unit line are listed for you to keep or leave out, and nothing in history changes. See [Finish](finishing-a-unit.md).
- **It does not merge or delete spike branches.** You keep, delete or take from each one. See [Small fixes, defects and spikes](defects-and-adhoc.md).
- **It does not change a tree's format unless you ask.** A tree in an older format is read but not changed until you run `/bk:migrate`, and approved versions are never altered. See [Move to Full SDLC, or upgrade a tree](migration.md).
- **It does not move a tree back.** Moving a Spec-driven tree to Full SDLC is one way. See [Move to Full SDLC, or upgrade a tree](migration.md).

## What it does not record

- **No personal preferences.** BuildKeel does not record what someone seems to prefer, or anything inferred from a conversation alone. Patterns are drawn only from the records. See [The Learning loop](learning-loop.md).
- **No unsourced notes.** Every working note names its source: your words, quoted exactly, or a file and line. A separate agent checks that the source supports the note, and a note it does not support is left out. See [Working notes and threads](working-notes.md).
- **No requirement on Claude's own.** Claude names a gap in a plan rather than filling it in, and never adds a requirement you did not agree. See [Capture a plan](capture.md).

**More:** [Troubleshooting](troubleshooting.md), [Features](what-buildkeel-does.md).

Commands are shown in Claude Code's form. In Antigravity and Pi, use a hyphen: `/bk-status`.
