---
template: capability
version: 1
description: How one lasting behavior of the system works now. A purpose, then requirements, each with scenarios a test can check. Changed only by finishing a change.
fields:
  title: { required: true }
sections:
  Purpose: { required: true }
  Requirements: { required: true, tracked: true, items: { prefix: R, style: heading, children: { prefix: S, style: heading } } }
---

## Purpose

<!-- What this capability covers and why it exists, in one or two sentences. -->

## Requirements

<!--
One heading per requirement, with its ID and a short name. Under it, the behavior in one or two sentences using SHALL or MUST, at most 500 characters.
Then one heading per scenario, with its ID and a short name, and a WHEN line and a THEN line a test can check. Every requirement has at least one scenario.

### AUTH-R3 Reset link expires
The system SHALL expire a reset link 30 minutes after it is sent.

#### AUTH-R3-S1 Expired link
- **WHEN** a user opens a reset link 31 minutes after it was sent
- **THEN** they are told the link expired and offered a new one
-->
