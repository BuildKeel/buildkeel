# The Learning loop

With the Learning loop on, BuildKeel looks for what recurs in the spec tree's own records, such as a kind of review finding that keeps coming back, or a file that keeps getting defects. It shows each pattern with the records behind it, and Claude proposes what to do about it: a practice, or a note.

## 1. See what it proposes

The Learning loop speaks at finish and in the status overview, and only when it has a pattern to show.

1. Run `/bk:status`, and read its **Learning loop** section: the patterns in the records now.
2. Or finish a unit: finishing shows the patterns that unit is part of, through its records or the files it changed. See [Finish](finishing-a-unit.md).
3. Read each pattern: what recurs, the records behind it, and what Claude proposes for it.

Ask Claude for the patterns in the records at any time, too. It looks with `query` and `view: "patterns"`.

## 2. Accept or decline a proposal

Nothing is saved without your agreement.

1. Read what Claude proposes for the pattern: a practice, a note on missing tests, or a note on the code.
2. To accept, say so. Claude shows the practice or the note as it would be saved.
3. Agree, and Claude saves it, as any practice or note on the code is saved. See [Add or change a practice](glossary-practices-adrs.md#2-add-or-change-a-practice) and [Leave a note on the code](heads-up-notes.md#1-leave-a-note-on-the-code).
4. To decline, say so. Claude records that you declined it, committed in the spec repo.

A pattern you decline is not proposed again until a new record is added to it.

## 3. Turn it on or off

The Learning loop is a switch, `continuity.learning-loop`. It is on by default.

1. Open the spec tree's `buildkeel.yaml`.
2. Set `learning-loop` under `continuity`, in the `process` section, to `off` or `on`.

   ```yaml
   process:
     continuity:
       learning-loop: off
   ```
3. Commit it, so the whole team works with the same setting.
4. Run `/bk:settings` to see the setting as it now applies.

> **Nothing else changes.** With the Learning loop off, it stops looking: status and finishing show no patterns. Practices and notes saved from it stay as they are.

## The patterns it looks for

It looks only in the spec tree's own records.

| Pattern | What counts | Proposed as |
|---|---|---|
| **Repeated review findings** | a kind of review finding in three units or more | a practice |
| **A file with repeated defects** | a file changed by three defects or more | a note on the code, for that file |
| **Weakened tests** | tests that passed without their code, or were weakened, in three units or more | a note on missing tests |
| **A reversed decision** | a decision replaced by a later one: one is enough | a note on the code |
| **Failed Principal handoffs** | three or more in all, with the findings they were about | a practice |

Each pattern is shown with the records behind it: the units, the defects, the findings or the notes. See [Reviews and the fix loop](reviews.md) for findings and Principal handoffs, and [TDD evidence](tdd.md) for tests that passed without their code.

## Where it speaks

- **At finish:** the patterns the unit is part of, through its records or the files it changed, with what Claude proposes.
- **In the status overview:** every pattern to propose now, in its own section, shown only when there is one. See [Status and usage](status.md).

Each pattern shown is one never declined, or one with a new record added since it was.

**More:** [The playbook](glossary-practices-adrs.md), [Notes on the code](heads-up-notes.md), [Feature switches](settings.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-status`.
