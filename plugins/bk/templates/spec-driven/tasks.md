---
template: tasks
version: 1
description: The work of a change, as numbered tasks in groups ordered so that each builds on the ones before. A task is ticked once its verification passes.
fields:
  parent: { required: true, type: link }
---

## 1. <What this group delivers>

<!--
One checkbox per task, numbered within its group, each saying what is done and how its completion is verified.
Each group includes the tests and documentation its own work needs. Tick a task only once its verification passed.

- [ ] 1.1 Add the issue time to reset tokens. Verify: token tests for a new and an old token.
- [ ] 1.2 Refuse links older than 30 minutes. Verify: the "Expired link" scenario test (AUTH-R3-S1).
-->
