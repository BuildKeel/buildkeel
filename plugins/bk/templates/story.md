---
template: story
version: 1
description: A user story with numbered acceptance criteria. Its test plan covers every criterion.
fields:
  title: { required: true }
  parent: { required: true, type: link }
  scope: { type: list }
sections:
  Summary: { required: true }
  Story: { required: true, tracked: true }
  Acceptance criteria: { required: true, tracked: true, items: { prefix: AC, style: list } }
  Notes: {}
---

## Summary

<!-- One or two sentences. Approved with the story, and what the agent reads about it when it is not the work at hand. -->

## Story

<!-- As a <who>, I want <what>, so that <why>. -->

## Acceptance criteria

<!-- One entry per criterion, each one behavior a test can check, with an ID: - **US-001-AC1** A reset link is emailed within one minute. -->

## Notes

<!-- Background, examples and links. Changes here never make other work suspect. -->
