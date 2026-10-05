---
template: bug
version: 2
description: A defect. Attach it to the work and test case where it was found, or leave it standalone.
fields:
  title: { required: true }
  parent: { type: link }
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
