---
template: defect
version: 3
description: "A defect: code that does not do what was agreed. Set source to reported (by users, customers or testers; approved before work on it starts) or found (while building or testing; the unit being built is its parent, with the test case that found it)."
fields:
  title: { required: true }
  source: { required: true }
  parent: { type: link }
  requirement: {}
  testCase: {}
  severity: {}
  scope: { type: list }
sections:
  Description: { required: true, tracked: true }
  Steps to reproduce: {}
  Expected: {}
  Actual: {}
  Notes: { offered: "Logs, links, and anything from a report that fits no other section." }
---

## Description

<!-- What is wrong. -->

## Steps to reproduce

<!-- Numbered steps. -->

## Expected

<!-- What should happen. -->

## Actual

<!-- What happens instead. -->
