---
template: proposal
version: 1
description: Why a change is made, what it changes, and which capabilities it adds or alters. Its spec changes say exactly how behavior changes.
fields:
  title: { required: true }
  capabilities: { type: list }
  noSpecChanges: { type: boolean }
sections:
  Why: { required: true }
  What changes: { required: true }
  Capabilities: { required: true }
  Impact: { required: true }
  Non-goals: { offered: "What the change deliberately leaves out, so nobody builds it by mistake." }
  Open questions: { offered: "Questions left open, each with what it is about, to settle later. They do not block approval: the approval summary lists them." }
  Notes: { offered: "Background, links, and anything from a source that fits no other section." }
---

## Why

<!-- The problem or the opportunity, and why it is worth doing now. One or two short paragraphs. -->

## What changes

<!-- One line per change in behavior, interface or data. Mark each change that breaks existing users or callers with **BREAKING**. -->

## Capabilities

<!--
Each capability the change adds or alters, by code, with what changes in it. The capabilities field lists the same codes.

- **AUTH** (modified): reset links expire after 30 minutes.
- **SMS** (new): sending one-time codes by text message.

A change that alters no behavior, such as a refactor, says so here, sets noSpecChanges: true, and has no spec changes.
-->

## Impact

<!-- The code, APIs, dependencies, data and systems the change affects. -->
