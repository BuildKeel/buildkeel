# Known limits

What BuildKeel does not do, or cannot know, so you can plan around it.

## Commit IDs after a rebase or an amend

A completion record names the commits a unit was built in, by ID, as they were when it was finished. Rebasing, amending or squash-merging those commits afterwards gives them new IDs, and the record keeps the old ones: it is written once and never edited. It still says what was built, against which versions and with which results, so it stays valid. But its commit IDs may no longer be found in your history.

While a unit is still being built, rewriting its commits is fine: BuildKeel finds them again by their `BuildKeel-Unit:` line when you finish. Keep the line when you amend or squash, or the commit counts as one with no unit.

## A spec commit and a code push that did not happen

Finishing commits the completion record in the spec repo, and pushes it when the tree's `settings.autoPush` is on. BuildKeel never pushes your code. When the record reaches the remote and the code does not, because the push failed or was not made yet, your teammates see the unit as finished and its commits are not on the remote for them yet. Push the code branch when you finish. `/bk:status` lists the spec repo's records that are not pushed, but it cannot see whether your teammates have your code.

## Claims on one machine

When you start a unit, BuildKeel claims it on your machine, so another working tree there cannot start it too. Claims are kept on your machine only: a teammate on another machine can start the same unit, and BuildKeel does not know. Pausing a unit is what tells everyone: its pause record goes into the spec repo, and resuming it on another machine takes it over. Agree who works on what as you would without BuildKeel.

## Linked dependencies are the ones installed now

The revert check, a red check and the break-it agent run tests in a worktree with your main checkout's installed dependencies linked in (see [TDD](tdd.md#installed-dependencies-in-these-worktrees)). They are the versions installed now, even in a revert check at an older commit. A test that needs an older version of a package can fail there for that reason, not because of the code. When that happens, the check's worktree is removed with `manage` and `remove: true`, and the reason is shown.

## Tests linked by tags

A test belongs to a test case or scenario because its name, or the line it is on, carries the ID in square brackets, such as `[US-012-TC3]`. BuildKeel reads tags from the text of your code and results from your JUnit report:

- A test renamed without its tag is no longer linked: its test case shows as having no test.
- A tag counts wherever it is, a comment or a docstring included, so a tag left on code that no longer tests anything still counts as a tagged test.
- What a test checks is not read. The checks on tests catch some changes, such as an assertion removed after the test was added (see [TDD](tdd.md)), but a test that carries the right tag and checks the wrong thing passes.
- A bracket holding several IDs tags none of them. Give each ID its own brackets.
