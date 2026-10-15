---
template: design
version: 1
description: How a stage's work is built, and the decisions behind it. Fill in what applies; add an offered section only when the work needs it.
fields:
  parent: { required: true, type: link }
sections:
  Summary: { required: true }
  Context: { required: true }
  Goals and non-goals: {}
  Design: { required: true, tracked: true }
  Decisions: { tracked: true }
  Risks and trade-offs: {}
  Architecture: { tracked: true, offered: "The components, how they connect, and where each one runs." }
  Data: { tracked: true, offered: "What is stored, its shape, and how it changes over time." }
  Interfaces: { tracked: true, offered: "The APIs, events and contracts other code relies on." }
  Security and privacy: { offered: "Who can do what, which data is sensitive, and how it is protected." }
  Performance and scale: { offered: "The expected load, the limits, and how the design meets them." }
  Operations: { offered: "How it is deployed, monitored and supported." }
  Rollout and rollback: { offered: "How it is released, and how it is undone if something goes wrong." }
  Testing approach: { offered: "How the design is tested beyond the test cases in its test plans." }
  Open questions: { offered: "Questions that can safely wait, each with who answers it and by when. A question whose answer would change the specs or tasks is answered first." }
  Notes: { offered: "Background, links, and anything from a source that fits no other section." }
---

## Summary

<!-- Two or three sentences: what is built and how. Approved with the document, and what the agent reads about it when working under it. -->

## Context

<!-- What exists today, and why this work is needed. -->

## Goals and non-goals

<!-- What the design must achieve, and what it deliberately leaves out. -->

## Design

<!-- How it works: the parts, what each does, and how they fit together. -->

## Decisions

<!-- One entry per decision: ### 1. <the choice>, then why, and the alternatives considered. -->

## Risks and trade-offs

<!-- What could go wrong or is given up, and how that is handled. -->
