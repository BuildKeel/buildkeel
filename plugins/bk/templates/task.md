---
template: task
version: 1
description: A piece of a story built in one code repository.
fields:
  title: { required: true }
  parent: { required: true, type: link }
  repo: { required: true }
  scope: { type: list }
sections:
  Description: { required: true, tracked: true }
  Open questions: { offered: "Questions left open, each with what it is about, to settle later. They do not block approval: the approval summary lists them." }
  Notes: {}
---

## Description

<!-- What to build. Name the repository in the repo field, and list the paths it will touch in the scope field when you know them. -->

## Notes

<!-- Implementation hints and links. Changes here never make other work suspect. -->
