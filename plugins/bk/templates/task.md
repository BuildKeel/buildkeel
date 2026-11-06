---
template: task
version: 2
description: A piece of a story built in one code repository.
fields:
  title: { required: true }
  parent: { required: true, type: link }
  repo: { required: true }
  scope: { type: list }
sections:
  Description: { required: true, tracked: true }
  Files: { required: true }
  Uses: { required: true }
  Delivers: { required: true }
  Verify: { required: true }
  Interfaces: { offered: "none, in place of Uses and Delivers, for a task that uses and delivers nothing." }
  Open questions: { offered: "Questions left open, each with what it is about, to settle later. They do not block approval: the approval summary lists them." }
  Notes: {}
---

## Description

<!-- What to build. Name the repository in the repo field, and list the paths it will touch in the scope field when you know them. Leave the code itself out: only what the implementer cannot decide alone, such as names, signatures and values from the spec. -->

## Files

<!-- The files it creates, changes and tests, found from the code, one per line, such as "- create: src/auth/expiry.ts", "- change: src/auth/reset.ts" and "- test: test/auth/reset.test.ts". -->

## Uses

<!-- What it uses, each with where it comes from (an earlier task, a file, or a library at the version the project depends on), such as "- issuedAt on ResetToken (from TK-011)", "- parseToken (from src/auth/tokens.ts)" or "- messages.create (from twilio 4.23.0)"; none when it uses nothing. -->

## Delivers

<!-- What later tasks rely on, with its signature, such as "- isExpired(token: ResetToken, now: Date): boolean", or none; this is the plan, and what is built is recorded when the task is finished. -->

## Verify

<!-- The command to run and the result expected, naming the test cases it checks, such as "npx vitest run test/auth/reset.test.ts, where [US-012-TC3] passes". -->

## Notes

<!-- Implementation hints and links. Changes here never make other work suspect. -->
