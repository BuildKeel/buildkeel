---
template: adr
version: 1
description: An architecture decision record, for a decision that is hard to reverse, surprising without its context, and the result of a real trade-off. Once accepted it is never edited; a new ADR replaces it.
fields:
  title: { required: true }
  replaces: { type: link }
  shapes: { type: list }
sections:
  Context: { required: true }
  Decision: { required: true }
  Alternatives: { required: true }
  Consequences: { required: true }
  Notes: { offered: "Background, links, and anything from a source that fits no other section." }
---

## Context

<!-- The situation and the forces at play that made a decision necessary. -->

## Decision

<!-- What was decided, in one or two sentences. -->

## Alternatives

<!-- One line per alternative weighed, with why it was not chosen. -->

## Consequences

<!-- What becomes easier and what becomes harder, including what the team now has to live with. List the requirements and designs it shapes in the shapes field. -->
