---
template: tasks
version: 2
description: The work of a change, as numbered tasks in groups ordered so that each builds on the ones before. A task is ticked once its verification passes.
fields:
  parent: { required: true, type: link }
---

## 1. <What this group delivers>

<!--
One checkbox per task, numbered within its group, saying what is done, with its lines under it: Files (what it creates, changes and tests), Uses (each with where it comes from: an earlier task, a file, or a library at the version the project depends on), Delivers (what later tasks rely on, with its signature), and Verify (the command and the result expected, naming the scenarios it checks). Interfaces: none stands for Uses and Delivers when a task uses and delivers nothing. Leave the code itself out.
Each group includes the tests and documentation its own work needs. Tick a task only once its verification passed; its Built line is written then.

- [ ] 1.1 Add the issue time to reset tokens.
  Files: change src/auth/token.ts; test test/auth/token.test.ts
  Uses: signToken (from src/auth/sign.ts)
  Delivers: issuedAt on ResetToken
  Verify: npx vitest run test/auth/token.test.ts, where the tests for a new and an old token pass
- [ ] 1.2 Refuse links older than 30 minutes.
  Files: change src/auth/reset.ts; test test/auth/reset.test.ts
  Uses: issuedAt on ResetToken (from 1.1)
  Delivers: isExpired(token: ResetToken, now: Date): boolean
  Verify: npx vitest run test/auth/reset.test.ts, where [AUTH-R3-S1] passes
-->
