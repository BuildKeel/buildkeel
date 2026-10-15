# Capability specs

In a Spec-driven spec tree, capability specs describe how the system behaves now. Each covers one lasting behavior, such as authentication or notifications: a purpose, then requirements, and for each requirement the scenarios a test can check. Work never edits a capability spec directly. A change proposes how it should change, and finishing the change writes the capability spec's next version. See [Spec-driven and Full SDLC](modes.md) for how the modes differ.

## Where they live

```
<spec root>/
  capabilities/AUTH/versions/v1.md     the text of version 1
  capabilities/AUTH/versions/v1.yaml   its record: the change that wrote it, its hash, who and when
  capabilities/AUTH/versions/v2.md     version 2, written when a later change was finished
  capabilities/AUTH/versions/v2.yaml
```

Each capability has a directory named by its code. A capability spec has no working file: every version is written once and never edited, and the highest version is the one in force. Two branches that finish changes to different capabilities merge without conflict.

## The format

```markdown
---
id: AUTH
title: Authentication
---

## Purpose

How people prove who they are, and get back in when they cannot.

## Requirements

### AUTH-R1 Sign in with email and password
The system SHALL sign a user in when their email and password match.

#### AUTH-R1-S1 Correct password
- **WHEN** a user signs in with their email and the right password
- **THEN** they are signed in and taken to their dashboard

#### AUTH-R1-S2 Wrong password
- **WHEN** a user signs in with the wrong password
- **THEN** they are told the email or password is wrong, without saying which
```

- **Purpose**: what the capability covers and why it exists, in a sentence or two.
- **Requirements**: one `###` heading per requirement, with its ID and a short name. Under it, the behavior in one or two sentences using SHALL or MUST, at most 500 characters.
- **Scenarios**: one `####` heading per scenario under its requirement, with its ID and a short name, then a WHEN line and a THEN line. Every requirement has at least one.

## IDs

Every capability has a short code, such as `AUTH`. Its requirements are numbered after it, `AUTH-R1`, `AUTH-R2`, and each requirement's scenarios after the requirement, `AUTH-R1-S1`, `AUTH-R1-S2`. Changes are numbered `CH-001`, `CH-002`. A test tagged with `[AUTH-R1-S2]` is linked to that scenario.

IDs are given when an item is first written, and they never change. A requirement keeps its ID when it is renamed or reworded, so links and test tags stay valid. Spec changes name existing requirements by ID.

- **Numbers come from the tree's counter**, the same counter approvals, bugs and ad-hoc units use, so two people adding requirements to `AUTH` at once never get the same number. One save takes every number it needs in a single step. Claude writes a new item as `AUTH-R{{new}}` and BuildKeel puts in the number when it saves.
- **Numbers are never reused**, even when a change is discarded: a requirement its change added is never numbered again.
- **A capability's code** is proposed by Claude from the capability's name, and you can ask for another before it is saved. It never changes after. The code is reserved in the counter, so two changes cannot create the same capability. If another change already holds it, BuildKeel says which one.
- **Offline**, when the counter cannot be reached, a new change, requirement or scenario gets an ID with a random suffix instead of a number, such as `AUTH-Rk3x9`, as bugs do. It is just as permanent. A new capability cannot be created offline, because its code must be reserved; the rest of the change can still be drafted, and the capability added once the counter can be reached.

### Setting the prefixes

The change prefix and the width of its number are set in `buildkeel.yaml`:

```yaml
process:
  change:
    prefix: RFC
    width: 4
```

The next change is then `RFC-0012`, say, and existing changes keep their IDs. The letters in requirement and scenario IDs, `R` and `S`, are set in the capability template, and the spec change template must use the same ones; validation reports it when they differ. Bug and ad-hoc prefixes are set as in Full SDLC, under `process.bug` and `process.adhoc`. IDs are always a prefix and a number.

## Versions

Finishing a change that alters a capability writes its next version, with a record beside it:

```yaml
capability: AUTH
version: 1
change: CH-001
hash: sha256:7ca92f69fbdfd5be6c4d8c827473e2d8bff6e3b91815fe96e845defca6370d57
archivedBy: Dana Lee <dana@example.com>
archivedAt: 2026-10-10T08:00:00Z
template:
  type: capability
  version: 1
  source: built-in
```

The record names the change that made the version, so you can always find why a requirement reads as it does. A capability documented from existing code with `/bk:onboard` starts at version 0, whose record names who confirmed it and the code it describes instead of a change.

## What BuildKeel checks

Validation checks every capability version against the hash in its record, so a version changed after it was written is reported, along with a missing record. It also checks the version in force and reports, by ID, a requirement with no scenario, a scenario missing its WHEN or THEN line, and requirement text over 500 characters:

```
capabilities/AUTH/versions/v2.md: AUTH-R3 has no scenario.
To fix: Add one under it as "#### AUTH-R3-S1 <name>", with a WHEN line and a THEN line.
```

## The template

Capability specs follow the built-in `capability.md` template. To change it, copy it into your spec tree's `templates/` folder, as for any template; the markers `R` and `S` in requirement and scenario IDs are set there. To require a section in every capability spec without changing the template, add a rule. See [Process and templates](process-and-templates.md).
