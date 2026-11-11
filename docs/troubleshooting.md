# Troubleshooting

What to do when BuildKeel does not work as you expect, and the known limits to plan around. Each entry names what you see, then the steps to fix it.

## Install

### You are not sure the install worked

1. In Claude Code, run `/mcp`.
   The `buildkeel` server is listed as connected.
2. Run `/bk:status`.
   In a project that is not set up yet, it tells you how to set one up. In a project that is, it shows your spec tree.
3. In Antigravity, start a new conversation in the agent panel and run `/bk-status`.
4. In Antigravity, ask "Which BuildKeel tools do you have?".
   The agent lists twelve, from `get_context` to `resolve_suspect`. BuildKeel's server comes with the plugin, so it is not shown under **Additional options (…) > MCP Servers**, which lists the servers you added yourself.

### "BuildKeel needs Node.js 20 or later"

1. Run `node --version` in a terminal.
2. If Node.js is missing or older than 20, install it from [nodejs.org](https://nodejs.org) or with your version manager, for example `nvm install 20`.
3. In Claude Code, start a new session.
4. In Antigravity, run the install command again, then quit and reopen Antigravity.

### The `buildkeel` server is not connected in `/mcp`

1. Check that `node --version` works in the terminal you start Claude Code from.
2. Start a new session.

### Claude Code says to run `/reload-plugins`

1. Run `/reload-plugins`, or start a new session.

### `/status` does not show BuildKeel's overview

Claude Code has its own `/status`.

1. Run `/bk:status` instead.
2. To see every BuildKeel command, type `buildkeel` in the command menu: the commands are listed by their short name, with descriptions starting with "BuildKeel:".

### The first Antigravity conversation says BuildKeel's tools are not available

Antigravity starts BuildKeel's server when that conversation starts, and the conversation can begin before the server is ready.

1. Start a new conversation.
   BuildKeel's tools are there from then on.

### `/bk-status` is not listed, or a new Antigravity conversation has no BuildKeel tools either

1. Check that `node --version` works in a terminal.
2. Run the install command again.
3. Quit Antigravity and open it again with your project. Reloading a window is not enough: Antigravity keeps BuildKeel's server running until you quit.

### BuildKeel works in the wrong project in Antigravity

The agent passes the project's folder to every BuildKeel tool.

1. If it did not, ask it to call the tool again with `workspace` set to your project's folder.

### "… exists and is not a BuildKeel plugin; nothing was installed"

Another plugin already uses the folder `buildkeel` there. BuildKeel leaves it alone.

1. Look at the folder the message names, at the start of the message.
2. Decide yourself what to do with the other plugin. BuildKeel never removes it, and installs nothing there while it is there.

### BuildKeel is installed both for every project and for one

Both installs bring a server named `buildkeel`, and Antigravity runs only one of them.

1. Remove one of them: `npx buildkeel remove` for the install for every project, or `npx buildkeel remove --workspace /path/to/your/project` for a project install.
2. Quit and reopen Antigravity.

## Setup and settings

### A command says the repository is not set up

A command that asks you something first checks that the repository is set up. When it is not, it names `/bk:init` and asks nothing.

1. Run `/bk:init`.

### A setting seems to be ignored

A setting that cannot be read, such as a misspelled key or a value that is not allowed, keeps its default, so a mistake never stops work.

1. Ask Claude to "validate the spec tree".
   Validation reports the setting, naming the nearest setting when a key is misspelled.
2. Correct it in the `process` section of the spec tree's `buildkeel.yaml`.
3. Commit the change in the spec tree.
4. Run `/bk:settings` to see the value now in force.

### BuildKeel says the spec tree is not where the pointer says

BuildKeel tells you how to fix it, and changes nothing.

1. Open the `.buildkeel.yaml` pointer file at the root of your code repository.
2. If the shared path in `specs` is wrong for everyone, correct it and commit it.
3. If the spec repository is only checked out somewhere else on your machine, leave the pointer as it is and record the location in `~/.buildkeel/paths.yaml`, keyed by the pointer's `remote`:

   ```yaml
   specs:
     "git@example.com:acme/payments-specs.git": /Users/me/work/payments-specs
   ```

   This file stays on your machine and is never committed.

### BuildKeel says the spec tree uses an older format

BuildKeel reads the tree but does not change it.

1. Run `/bk:migrate`.
   It shows what migrating changes, then asks: **Migrate** (the default) or **Not now**.
2. Review the commit it makes. Approved versions and records are left exactly as they are, and work in progress carries on.

### BuildKeel says the spec tree uses a newer format

You can read the tree but not change it.

1. Update the BuildKeel plugin. See [Install](install.md).
2. Start a new session.

## Starting and building

### You are told the spec tree is behind its remote

When a session starts, BuildKeel fetches the spec repo's remote in the background. If the local tree is behind, you are told how far when you start, approve or finish work. Starting a unit warns about it and goes ahead.

1. Pull the spec repo to see the latest approvals.
2. Start or finish again, to be sure nothing changed.

### You are told the freshness check could not run

The fetch failed, for example with no connection. Work continues with your local copy.

1. Carry on, or check your connection.
2. Run `/bk:status` to see where the spec repo stands.

### A unit will not start

When something is missing, nothing changes, and every reason is listed with what to do about it, such as:

```text title="/bk:build TK-001"
Start of TK-001 refused by the start gate: 1 check failed.
1. The user story US-001 "Request a reset link", above TK-001, is not approved.
   To fix: Approve US-001 with /bk:approve US-001.
```

1. Read each reason and its "To fix" line.
2. For a suspect, decide it first with `/bk:impact`.
3. For a unit claimed by another working tree on this machine, work on it there, or ask Claude to release its claim.
4. Run `/bk:build` again.

### The active unit does not change while you have uncommitted changes

Every change belongs to exactly one unit, so Claude lists the changed files and asks what to do.

1. Choose one:
   - commit them to the active unit, with its `BuildKeel-Unit:` line;
   - set them aside with `git stash`, after you confirm, and bring them back later with `git stash pop`;
   - or leave them and do not start.

Your changes are never deleted.

### Claude stops before changing code

Claude is about to change code with no active unit.

1. Choose how to go on:
   - capture what you discussed, by running `/bk:capture` yourself;
   - build the unit the change belongs to, with `/bk:build`;
   - record it as an ad-hoc unit;
   - or say to go ahead without a unit. Those changes belong to no unit, and their commits are listed as commits with no unit.

### Agents can't be started

Agents may not start: the session has no tool for starting them, it is turned off in your settings, or the model tier a role names is not available. Claude says why, once, in a line, and retries once when an agent started but failed. Then it does the work here, labeled as done here, not by an independent agent.

1. Read the line Claude gives for why.
2. Run `/bk:settings` to see the switch and the model and effort of each agent role on this host.
3. If a role names a tier this host cannot use, change the tier. See [Models and effort per role](models.md).
4. If the switch is off and you want agents, turn it on. See [Feature switches](settings.md).

> **A review done here is not independent.** A final review done in the conversation is recorded as reviewed by the author. It does not satisfy the done gate's review-findings check, and the unit is reported as not independently reviewed.

### A run stopped, or the conversation was compacted mid-run

A run keeps no progress file of its own. Its ticks, completion records, test runs, reviews and commits are what it is picked up from.

1. Run `/bk:build` again on the same parent or change.
   It goes on from the first task not finished or ticked.

### The work on a claimed unit has stopped

A claim is released when its unit is finished.

1. Run `/bk:status` and look under **Claims**.
2. Ask Claude to release the unit's claim.
   Any working tree can then start it, and it is no longer the active unit in the working tree that held it. Its branch and commits stay as they are.

### An approval shows as "approved, number pending"

The number counter could not be reached, for example with no connection. The approval is still recorded.

1. Wait for the next approval or the next session, when the number is assigned.
2. To try at once, approve it again.

Until it has its number, it cannot be changed, its children cannot be approved, and work cannot start on it.

### BuildKeel says the number counter is behind the spec tree

Its branch was deleted, reset to an older commit, or the remote was replaced. Numbering stops rather than give out a number the tree already holds.

1. Ask Claude to repair the counter.
2. Check each counter it would raise and each capability code it would claim.
3. Agree, and it writes them in one commit to the counter's branch and pushes it.

## Finishing and sharing

### A unit will not finish

When something is missing, nothing is written, and every reason is listed with what to do, such as:

```text title="/bk:done TK-001"
Finish of TK-001 refused by the done gate: 1 check failed.
1. US-001-TC1 "Link arrives" fails: test/reset.test.ts > emails a reset link [US-001-TC1].
   To fix: Fix the code or the test, then run the tests with a JUnit XML report and record it with the BuildKeel test_results tool.
```

1. Commit any uncommitted work, and check out the unit's branch.
2. Read each reason and its "To fix" line.
3. Run the tests again with a JUnit XML report, and have Claude record it.
4. Run `/bk:done` again.

### The unit's branch has commits without a unit line

1. Press Enter to count them all for the unit, or choose the ones to leave out.
   Commits left out are named in the completion record. Nothing in git history is changed.

### Finishing says the changed lines were not checked for coverage

No run recorded a coverage report. This is not a failure.

1. Run the whole suite with coverage, writing an lcov or Cobertura report.
2. Have Claude record the run with its coverage report.
3. Run `/bk:done` again.

### Changed files show as "Not in the report at all"

Usually the tests never loaded the file, or the report's paths do not match the repository's files.

1. Run the tests from the repository root, or have the coverage tool write absolute paths.
2. Record the run again.

### An automatic push of an approval was refused

The approval is kept, and you are told why, for example because the remote has commits you do not have.

1. Pull the spec repo.
2. Push it again.

### `/bk:status` lists files changed outside BuildKeel

An approved version no longer matches the hash in its approval record, or a record was changed after it was written. For example:

```text title="/bk:status"
Changed outside BuildKeel:
- US-001 v1 was altered after approval: stories/US-001/versions/v1.md no longer matches the hash in stories/US-001/approvals/v1.yaml.
  To fix: Restore stories/US-001/versions/v1.md from git history. To change US-001, save a new version as a draft and approve it.
```

1. Restore the file from git history.
2. To change the artifact, save a new version as a draft and approve it.
3. Ask Claude to "validate the spec tree" to check that nothing else is reported.

### A conversation ended before you paused it

1. At the next session, accept the offer to recover the previous conversation as a thread.
   It is offered once, when that conversation explored something over three messages or more with no unit, and was never paused or captured.
2. After compaction in the same conversation, run `/bk:pause`.
   It builds the thread from the whole transcript on disk, not from the summary.

## Known limits

What BuildKeel does not do, or cannot know, so you can plan around it. See also [What BuildKeel does not do](does-not-do.md).

### Commit IDs in a completion record are not in your history

A completion record names the commits a unit was built in, by ID, as they were when it was finished. Rebasing, amending or squash-merging them afterwards gives them new IDs, and the record keeps the old ones: it is written once and never edited. It still says what was built, against which versions and with which results, so it stays valid.

1. Read the record for what was built: its versions, files and results still hold.
2. While a unit is still being built, rewrite its commits freely, but keep the `BuildKeel-Unit:` line when you amend or squash. BuildKeel finds them again by that line when you finish; without it, the commit counts as one with no unit.

### A finished unit's code is not on the remote

Finishing commits the completion record in the spec repo, and pushes it when the tree's `settings.autoPush` is on. BuildKeel never pushes your code. When the record reaches the remote and the code does not, your teammates see the unit as finished while its commits are not on the remote for them.

1. Push the code branch when you finish.
2. Run `/bk:status` to see the spec repo's records that are not pushed. It cannot see whether your teammates have your code.

### A teammate started the same unit on another machine

Claims are kept on your machine only: a teammate on another machine can start the same unit, and BuildKeel does not know.

1. Agree who works on what, as you would without BuildKeel.
2. Pause a unit with `/bk:pause` and push the spec repo when you hand it over. Its pause record is what tells everyone, and resuming it on another machine takes it over.

### A check fails because of a dependency's version

The revert check, a red check and the break-it agent run tests in a worktree with your main checkout's installed dependencies linked in (see [TDD evidence](tdd.md)). They are the versions installed now, even in a revert check at an older commit. A test that needs an older version of a package can fail there for that reason, not because of the code.

1. Read the reason Claude shows. When that happens, the check's worktree is removed with `manage` and `remove: true`, and the reason is shown.
2. Treat that failure as a matter of the installed version, not as evidence about the unit's code.

### A test case shows as having no test, or a tag counts where it should not

A test belongs to a test case or scenario because its name, or the line it is on, carries the ID in square brackets, such as `[US-012-TC3]`. BuildKeel reads tags from the text of your code and results from your JUnit report.

1. Keep the tag when you rename a test. A test renamed without its tag is no longer linked, and its test case shows as having no test.
2. Give each ID its own brackets. A bracket holding several IDs tags none of them.
3. Remove a tag left on code that no longer tests anything. A tag counts wherever it is, a comment or a docstring included.
4. Review what each test checks. BuildKeel does not read it: the checks on tests catch some changes, such as an assertion removed after the test was added (see [TDD evidence](tdd.md)), but a test that carries the right tag and checks the wrong thing passes.

**More:** [What BuildKeel does not do](does-not-do.md), [Install](install.md), [Status and usage](status.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-status`.
