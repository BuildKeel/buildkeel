---
template: test-plan
version: 2
description: The test cases for an artifact. Every test case declares which criteria or goals it covers.
fields:
  parent: { required: true, type: link }
sections:
  Approach: {}
  Test cases: { required: true, tracked: true, items: { prefix: TC, style: heading, covers: required } }
  Notes: { offered: "Test data, environments, and anything that fits no other section." }
---

## Approach

<!-- How the tests are run: unit, integration, end to end. -->

## Test cases

<!--
One heading per test case, with an ID, then a covers line and steps whose outcome a test can check.
A story's plan covers every criterion; a task's plan covers the task (TK-001) or its story's criteria;
an epic's plan covers stories under it or their criteria; a business idea's plan covers its epics or goals.

### US-001-TC1 Reset link arrives
covers: [US-001-AC1]

1. Request a reset for a known address.
2. The email arrives within one minute.
-->
