# The playbook

The playbook is three things your team keeps in its spec tree, in both modes: the glossary of the team's terms, the practices for how it designs, tests and reviews code, and ADRs, the decisions that are hard to reverse, with why. Everyone, and every agent, then works with the same words, the same habits and the same reasons.

## Before you start

There is no command for the glossary or the practices: you settle them in the conversation. None of the three is added on Claude's own. Claude proposes, naming where the proposal came from: what you said, review findings that keep coming back, working notes, or a pattern in the records (see [The Learning loop](learning-loop.md)).

> **Nothing is saved until you agree.** Claude shows each entry, practice or ADR first, and writes nothing until you say yes.

## 1. Agree a term

A term is settled in the conversation, as you talk about the work.

1. Use the term as you normally would.
2. When Claude says the term conflicts with the glossary, or with how the code uses it, tell it which you mean.

   Claude asks this before anything else.
3. When Claude says a term is vague, or stands for two things, such as "account" for both a login and a billing customer, agree to the precise term it proposes for each, or give your own.
4. Read the entry Claude offers once the term is settled.

   ```text title="A proposed entry"
   A new glossary entry, customer, would read:
   - **customer**: someone who pays for a subscription (avoid: client)

   Nothing has been written yet. Show it to the user, and save it with apply: true once they agree. It needs no approval.
   ```
5. Agree, and Claude saves it.

   ```text title="The first entry saved"
   Saved customer v1 in the glossary, at glossary/customer/v1-k3q8.md, committed in the spec repo as 2b7e0c4. This is the tree's first entry: the glossary is created.
   - **customer**: someone who pays for a subscription (avoid: client)
   ```

An entry needs no approval. It is saved once you agree, and committed in the spec repo, so its history is kept. The first entry creates the glossary.

Each change to an entry is a new version, with the earlier wording kept. A change that adds a term to avoid lists the artifacts that use it, for you to reword through their own review.

## 2. Add or change a practice

A practice is added, reworded or switched off the same way, with no approval step.

1. Tell Claude the rule, such as "we never log tokens", or the practice to reword or switch off, by its ID.
2. Read the practice as Claude would save it.
3. Agree, and Claude saves it.

   ```text title="A new practice"
   Saved a new practice, P-16, at practices/P-16/v1-m2xa.md, committed in the spec repo as 81c4d2e. The reviewers, the readiness readers, edge-case suggestions and the designers read it from now on.
   - P-16 Test timezone boundaries (the team's own): Every date calculation has a test at a timezone boundary.
   ```

   ```text title="A practice switched off"
   Saved P-15, switched off, at practices/P-15/v1-p7td.md, committed in the spec repo as 0f3a9b6. The reviewers, the readiness readers, edge-case suggestions and the designers read it from now on.
   ```

A practice switched off is no longer applied, and `query` with `view: "practices"` shows it as switched off. BuildKeel's own defaults are reworded or switched off this way too: see [BuildKeel's default practices](#buildkeels-default-practices).

## 3. Record an ADR

Claude offers an ADR when a decision is hard to reverse, surprising without its context, and the result of a real trade-off between alternatives.

1. Settle the decision in the conversation, such as keeping reset tokens in the database rather than as signed links because they must be revocable.
2. Agree when Claude offers an ADR for it.

   Naming a helper function is none of the three, so it gets no ADR.
3. Read the draft. It states its context, the decision, the alternatives and why each was not chosen, its consequences, and the requirements and designs it shapes.
4. Accept it, as your mode does:
   - In Full SDLC, approve it with `/bk:approve`, such as `/bk:approve ADR-draft-k3q8`.
   - In a Spec-driven tree, agree to save it.

   [ADRs in each mode](#adrs-in-each-mode) shows what you see in each.

> **An accepted ADR is never edited.** When the decision changes, record a new ADR that names the one it replaces. The old one is then shown as replaced by it.

## How terms are checked

**Every save is checked.** When a draft uses a term the glossary says to avoid, the save goes ahead and says where:

```text title="A save with a term to avoid"
Terms the glossary says to avoid (reported; the save went ahead):
- US-001 line 9: "client"; the glossary says to use "customer"
```

**In every context.** The context of a unit holds the glossary entries for the terms it and the work above it use, and no others, so every agent working on it uses the team's words. See [Build](working-on-a-unit.md).

`query` with `view: "glossary"` lists every entry.

## BuildKeel's default practices

BuildKeel ships a set of practices, each with its own ID, from `P-01`:

- **codebase design:** iceberg modules, a lot of behavior behind a small interface; an interface as everything a caller must know; a seam only where something varies; the removal test; testing through the interface; named exports;
- **test first:** red before green; one behavior per test, named by its case; refactor on green; saying why a test could not fail first;
- **test anti-patterns:** asserting on a mock, weakening a test to make it pass, logic in tests, tests that depend on each other;
- **review categories,** for the quality reviewer's findings.

The reviewers, the readiness readers, edge-case suggestions and the designers read them. An implementer is given them too.

A default the team has not changed follows BuildKeel's wording in later releases.

## ADRs in each mode

ADRs are numbered in order. How one is accepted depends on the mode.

### In Full SDLC

An ADR is drafted, then approved through the approve gate with `/bk:approve`, which checks it has every section, and numbers it:

```text title="A draft ADR"
Created draft ADR-draft-k3q8 at adrs/ADR-draft-k3q8/adr.md. It has everything it needs for approval.

It is approved through the approve gate, with /bk:approve ADR-draft-k3q8, and numbered then. Once approved, it is never edited.
```

```text title="/bk:approve ADR-draft-k3q8"
Approved ADR-0001 (was ADR-draft-k3q8), at adrs/ADR-0001/adr.md, committed in the spec repo as 6d2f8a1. It is never edited from now on.
```

### In Spec-driven

An ADR is accepted when you agree to save it. A tree moved to Full SDLC keeps its accepted ADRs, counted as approved. See [Move to Full SDLC, or upgrade a tree](migration.md).

### In both modes

`query` with `view: "adrs"` lists them, and `view: "artifact"` with an ADR's ID, a draft's included, shows one in full. An accepted ADR is never edited. When the decision changes, a new ADR names the one it replaces, and the old one is shown as replaced by it.

## The read-only copy

BuildKeel writes a copy of the glossary, the practices and the accepted ADRs into each code repository the spec tree serves, so they can be read where the code is. By default these are `GLOSSARY.md`, `docs/practices.md` and `docs/adr/NNNN-<title>.md`. The paths are set in `.buildkeel.yaml`:

```yaml
copy:
  glossary: GLOSSARY.md
  practices: docs/practices.md
  adrs: docs/adr/
```

The glossary is copied once it has an entry, the practices once the team has one of its own (BuildKeel's defaults alone stay in the plugin), and ADRs once accepted. The copy is written even when the spec tree is inside the code repository.

- **When:** as a unit or change starts and as it is finished, or with `manage` and `action: "refresh-copy"`. Each refresh is its own commit, with the active unit's line, or, outside a unit, as setting BuildKeel up:

  ```text title="A refresh"
  - Refreshed the read-only copy: GLOSSARY.md, docs/practices.md, docs/adr/0001-reset-tokens-in-the-database.md, committed on its own as 3c9e1f7.
  ```
- **Marked as generated:** each file starts with a header saying BuildKeel writes it, holding a hash of what it wrote.
- **Claude's edits are refused,** naming the way to change it: through the glossary, a practice or an ADR.
- **A hand edit is kept.** At the next refresh, a file whose content no longer matches its hash is shown as a difference, offered as a proposed change, and left as it is until you answer:

  ```text title="A file edited by hand"
  - GLOSSARY.md was edited by hand, so it was not overwritten. What BuildKeel would write (-) and what the file holds instead (+):
  ```

The copy is not code. It never makes test results stale, and reviews and the checks on tests leave it out.

**More:** [The Learning loop](learning-loop.md), [Reviews and the fix loop](reviews.md), [Records and the audit trail](records.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-approve`.
