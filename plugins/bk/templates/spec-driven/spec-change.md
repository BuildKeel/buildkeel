---
template: spec-change
version: 1
description: How a change alters one capability's requirements. Existing requirements are named by ID, so a rename keeps its ID.
fields:
  capability: { required: true }
  title: {}
  base: {}
sections:
  Purpose: { offered: "For a new capability: what it covers and why it exists, in one or two sentences." }
  Added: { tracked: true, items: { prefix: R, style: heading, children: { prefix: S, style: heading } } }
  Modified: { tracked: true, items: { prefix: R, style: heading, children: { prefix: S, style: heading } } }
  Removed: { tracked: true, items: { prefix: R, style: heading } }
---

<!-- The capability field names the capability by its code. For a new capability, also give its title (title: Text messages) and add a Purpose section. Leave out Added, Modified or Removed when the change has nothing in it. -->

## Added

<!--
New requirements, each with its scenarios, written as the capability spec writes them.

### AUTH-R3 Reset link expires
The system SHALL expire a reset link 30 minutes after it is sent.

#### AUTH-R3-S1 Expired link
- **WHEN** a user opens a reset link 31 minutes after it was sent
- **THEN** they are told the link expired and offered a new one
-->

## Modified

<!-- Existing requirements by ID, each with its full new text and every scenario it keeps or gains, not only what differs. A new name under the same ID renames it. -->

## Removed

<!--
Requirements that no longer apply, by ID, each with why and what users or callers do instead.

### AUTH-R1 Sign in with a security question
**Reason**: security questions are replaced by email codes.
**Migration**: users set up email codes at their next sign-in.
-->
