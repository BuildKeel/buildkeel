---
template: epic
version: 1
description: A body of work that delivers part of a business idea, broken down into user stories.
fields:
  title: { required: true }
  parent: { required: true, type: link }
  scope: { type: list }
sections:
  Summary: { required: true }
  Scope: { required: true, tracked: true }
  Out of scope: { tracked: true }
  Notes: {}
---

## Summary

<!-- Two or three sentences. Approved with the epic, and what the agent reads about it when working on its stories' tasks. -->

## Scope

<!-- What this epic delivers. -->

## Out of scope

<!-- What it deliberately leaves out. -->

## Notes

<!-- Background and links. Changes here never make other work suspect. -->
