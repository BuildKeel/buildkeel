---
description: "BuildKeel: Record a small change as an ad-hoc unit and start it, so its commits trace to something."
argument-hint: '"<the change>", e.g. "Fix typo in the reset email"'
---

Record a small change as a BuildKeel ad-hoc unit and start it. An ad-hoc unit needs no approval: it gets its permanent ID straight away, its commits carry that ID, and it is finished with /bk:done like any other unit.

The user typed: $ARGUMENTS

## Name the change

If the user described the change above, use it.

If the user typed nothing, ask straight away, before calling any tool: "What is the change?" Offer the choices with your tool for asking a question with choices, if you have one:

1. **The change we were just discussing** (the default, listed first), with the title you propose for it. Offer this only when the conversation names a change.
2. **Type a short description.** If they pick this, ask for it.

The title says what changes in a few words, such as "Fix typo in the reset email". If the change is a defect in work that was planned and tested, suggest recording it as a bug with /bk:new bug instead, and go on as the user prefers.

## Create and start it

1. Call the BuildKeel `save_draft` tool with `type: "adhoc"` and this content, with the title and a sentence or two saying what changes and why:

   ```
   ---
   id: {{id}}
   title: <title>
   ---

   ## Description

   <what changes and why>
   ```

   It gives the unit its ID and commits it in the spec repo. If the number counter cannot be reached, the ID ends in letters and digits instead of a number; it is still permanent.
2. Call the BuildKeel `start_work` tool with the new ID.
   - **Uncommitted changes:** show the files it lists. Files it says set BuildKeel up are committed on their own, as setting BuildKeel up, with no `BuildKeel-Unit` line, once the user agrees. For the rest, ask what to do, offering these choices: **commit them to the active unit** (the default, when there is one), with the message ending in `BuildKeel-Unit: <active unit ID>`; **set them aside**, after an explicit yes, with `git stash push --include-untracked -m "BuildKeel: set aside before starting <ID>"` (they come back with `git stash pop`); or **leave them, and do not start**. Then call `start_work` again. Never discard changes any other way.
   - **Started:** tell the user the ID and the branch.

## Make the change

Make the change, and commit it with a message ending in `BuildKeel-Unit: <ID>`. If tests cover it, run them with a JUnit XML report and record it with the BuildKeel `test_results` tool. Then offer to finish it with /bk:done.

Do not create or edit spec tree files yourself; `save_draft` writes the unit.
