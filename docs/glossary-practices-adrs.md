# The glossary, practices and ADRs

Three things a team keeps in its spec tree, in both modes, so that everyone, and every agent, works with the same words, the same habits and the same reasons:

- **the glossary:** the team's terms, each with what it means and the words to avoid in its place;
- **practices:** how the team designs, tests and reviews code, starting from BuildKeel's defaults;
- **ADRs,** architecture decision records: the decisions that are hard to reverse, with why.

None of them is added on Claude's own: Claude proposes, naming where the proposal came from (what you said, review findings that keep coming back, working notes, or a pattern in the records), and saves nothing until you agree.

## The glossary

A term is settled in the conversation, with no command. When you use a term in a way that conflicts with the glossary, or with how the code uses it, Claude says so and asks which you mean, before anything else. When a term is vague, or stands for two things, such as "account" for both a login and a billing customer, Claude proposes one precise term for each. Once a term is settled, Claude offers its entry:

```text
A new glossary entry, customer, would read:
- **customer**: someone who pays for a subscription (avoid: client)

Nothing has been written yet. Show it to the user, and save it with apply: true once they agree. It needs no approval.
```

An entry needs no approval: it is saved once you agree, and committed in the spec repo, so its history is kept. The first entry creates the glossary:

```text
Saved customer v1 in the glossary, at glossary/customer/v1-k3q8.md, committed in the spec repo as 2b7e0c4. This is the tree's first entry: the glossary is created.
- **customer**: someone who pays for a subscription (avoid: client)
```

Each change to an entry is a new version, with the earlier wording kept. A change that adds a term to avoid lists the artifacts that use it, for you to reword through their own review.

**Every save is checked.** When a draft uses a term the glossary says to avoid, the save goes ahead and says where:

```text
Terms the glossary says to avoid (reported; the save went ahead):
- US-001 line 9: "client"; the glossary says to use "customer"
```

**In every context.** The context of a unit holds the glossary entries for the terms it and the work above it use, and no others, so every agent working on it uses the team's words. `query` with `view: "glossary"` lists them all.

## Practices

BuildKeel ships a set of practices, each with its own ID, from `P-01`:

- **codebase design:** iceberg modules, a lot of behavior behind a small interface; an interface as everything a caller must know; a seam only where something varies; the removal test; testing through the interface; named exports;
- **test first:** red before green; one behavior per test, named by its case; refactor on green; saying why a test could not fail first;
- **test anti-patterns:** asserting on a mock, weakening a test to make it pass, logic in tests, tests that depend on each other;
- **review categories,** for the quality reviewer's findings.

The reviewers, the readiness readers, edge-case suggestions and the designers read them; an implementer is given them too. A default the team has not changed follows BuildKeel's wording in later releases.

The team can add a practice, reword one, or switch one off, each shown first and saved once you agree, with no approval step:

```text
Saved a new practice, P-16, at practices/P-16/v1-m2xa.md, committed in the spec repo as 81c4d2e. The reviewers, the readiness readers, edge-case suggestions and the designers read it from now on.
- P-16 Test timezone boundaries (the team's own): Every date calculation has a test at a timezone boundary.
```

```text
Saved P-15, switched off, at practices/P-15/v1-p7td.md, committed in the spec repo as 0f3a9b6. The reviewers, the readiness readers, edge-case suggestions and the designers read it from now on.
```

A practice switched off is no longer applied, and `query` with `view: "practices"` shows it as switched off.

## ADRs

Claude offers an ADR only for a decision that is hard to reverse, surprising without its context, and the result of a real trade-off between alternatives, such as keeping reset tokens in the database rather than as signed links because they must be revocable. Naming a helper function is none of these. An ADR states its context, the decision, the alternatives and why each was not chosen, its consequences, and the requirements and designs it shapes.

ADRs are numbered in order. How one is accepted depends on the mode:

- **In Full SDLC,** it is drafted, then approved through the approve gate with `/bk:approve`, which checks it has every section, and numbers it:

```text
Created draft ADR-draft-k3q8 at adrs/ADR-draft-k3q8/adr.md. It has everything it needs for approval.

It is approved through the approve gate, with /bk:approve ADR-draft-k3q8, and numbered then. Once approved, it is never edited.
```

```text
Approved ADR-0001 (was ADR-draft-k3q8), at adrs/ADR-0001/adr.md, committed in the spec repo as 6d2f8a1. It is never edited from now on.
```

- **In a Spec-driven tree,** it is accepted when you agree to save it.

`query` with `view: "adrs"` lists them, and `view: "artifact"` with an ADR's ID, a draft's included, shows one in full. An accepted ADR is never edited. When the decision changes, a new ADR names the one it replaces, and the old one is shown as replaced by it. A tree moved to Full SDLC keeps its accepted ADRs, counted as approved.

## The read-only copy in your code repository

BuildKeel writes a copy of the glossary, the practices and the accepted ADRs into each code repository the spec tree serves, so they can be read where the code is: by default `GLOSSARY.md`, `docs/practices.md` and `docs/adr/NNNN-<title>.md`. The paths are set in `.buildkeel.yaml`:

```yaml
copy:
  glossary: GLOSSARY.md
  practices: docs/practices.md
  adrs: docs/adr/
```

The glossary is copied once it has an entry, the practices once the team has one of its own (BuildKeel's defaults alone stay in the plugin), and ADRs once accepted. It is written even when the spec tree is inside the code repository.

- **When:** as a unit or change starts and as it is finished, or with `manage` and `action: "refresh-copy"`. Each refresh is its own commit, with the active unit's line, or, outside a unit, as setting BuildKeel up:

```text
- Refreshed the read-only copy: GLOSSARY.md, docs/practices.md, docs/adr/0001-reset-tokens-in-the-database.md, committed on its own as 3c9e1f7.
```

- **Marked as generated:** each file starts with a header saying BuildKeel writes it, holding a hash of what it wrote.
- **Claude's edits are refused,** naming the way to change it: through the glossary, a practice or an ADR.
- **A hand edit is kept.** At the next refresh, a file whose content no longer matches its hash is shown as a difference, offered as a proposed change, and left as it is until you answer:

```text
- GLOSSARY.md was edited by hand, so it was not overwritten. What BuildKeel would write (-) and what the file holds instead (+):
```

The copy is not code: it never makes test results stale, and reviews and the checks on tests leave it out.
