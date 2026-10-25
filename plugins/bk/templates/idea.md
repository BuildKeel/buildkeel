---
template: idea
version: 1
description: A business idea, the top of the lineage. States the problem worth solving and how success is measured.
fields:
  title: { required: true }
  scope: { type: list }
sections:
  Summary: { required: true }
  Problem: { required: true, tracked: true }
  Goals: { required: true, tracked: true, items: { prefix: G, style: list } }
  Success measures: { tracked: true }
  Open questions: { offered: "Questions left open, each with what it is about, to settle later. They do not block approval: the approval summary lists them." }
  Notes: {}
---

## Summary

<!-- Two or three sentences. Approved with the idea, and what the agent reads about it when working on anything below it. -->

## Problem

<!-- Who has the problem, how often, and what it costs them today. -->

## Goals

<!-- One entry per goal, each an outcome that can be measured after release, with an ID: - **BI-01-G1** Customers recover their own accounts. -->

## Success measures

<!-- How you will know the goals are met. -->

## Notes

<!-- Background and links. Changes here never make other work suspect. -->
