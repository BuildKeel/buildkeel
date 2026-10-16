# Documenting existing code

Most teams set BuildKeel up on code that already exists. None of that code needs documenting before new work starts: from setup on, new work goes through your process, and code from before BuildKeel is never reported as untracked. When you want it described, there are two ways, and you can mix them:

- **As work touches it.** When a change touches code that nothing describes yet, the plan for it includes a description of how that code works today, so the change has a "before". See [Drafting with Claude](drafting.md#from-a-conversation).
- **All at once, area by area**, with `/bk:onboard`, whenever you choose.

Neither is a setting, and neither is offered unless you run a BuildKeel command or ask for a change. Either way, people lead: Claude proposes and drafts, and you correct, complete and approve. You can also write or correct any of it by hand.

## Version 0

What describes code from before BuildKeel is **version 0** of its artifact; anything made in BuildKeel starts at version 1. Version 0 reads like any artifact of its type, as if BuildKeel had been used from the start, and is drafted from the code and from what you bring: your issue tracker or wiki through tools you connected to Claude, files, and what people know. It is not held to the template or to the documents your process requires, so a section nobody knows can stay empty, but a person reads and approves it like any version. See [Version 0](approval.md#version-0-code-from-before-buildkeel) for how it is approved and recorded.

- **Its sources** are kept beside it, exactly as they were read, and frozen with it when it is approved. See [Sources kept with version 0](approval.md#sources-kept-with-version-0).
- **Its number** comes from its type's onboarded sequence, such as `US-E001`; new work keeps the normal one, `US-002`. See [Onboarded numbers](approval.md#onboarded-numbers).
- **When sources disagree** with each other or with the code, Claude asks which is intended. When the code is wrong, version 0 states the intended behavior, and the defect is recorded as a bug. When a ticket is out of date, version 0 follows the code. When you do not know, answer **Not sure: leave it open**: see [Questions left open](#questions-left-open).
- **It counts as done:** its code already exists. Changing it starts with its version 1, held to the template, the gates and change impact like any version.

## Area by area

```
/bk:onboard
```

Run on its own, it shows where onboarding stands and offers the next step: continue with an area once there is a map, choosing among every area not onboarded yet, map the code when there is none, or fill in what earlier onboarding left empty.

### The map

Claude reads the code's layout and proposes its capability areas: what the product does, in its users' words, each with the paths it covers. Merge, split or rename them until the map fits; nothing is drafted before you agree. The map is kept in the spec tree, in `onboarding/map.yaml`, and each change to it is committed:

```
The map now has 3 areas, in onboarding/map.yaml, committed as "onboard: map of 3 areas" (5d1e2f3):

| Area | Repo | Paths | What it does |
|---|---|---|---|
| Password reset | payments-api | src/reset/ | Reset by email |
| Billing | payments-api | src/billing/ | Invoices and totals |
| Accounts | payments-api | src/accounts/ | Profiles and settings |
```

### One area

For each area, Claude reads its code as it was at the baseline and asks what you have about it: a project in your issue tracker, wiki pages, documents. Then it shows what the area needs, every stage of your process from the business idea down to the story, with the documents each stage requires:

- What a source or the code describes is drafted as version 0.
- Tasks and bugs come in only when a source has them and they are **finished**, as version 0 with their tracker keys. When one is approved, the commits made before the baseline that name its key are linked to it, so its old code is known. Open work is left out: it is drafted with `/bk:new` when someone takes it up.
- A document your process requires that no source has, such as an epic's design document or a story's test plan, is drafted as **version 1**, under the normal rules, so new work under the area can start as usual.

Once you agree, Claude drafts them all. For each required section nothing supports, it asks you, one question at a time, and **Leave it empty** is always an answer. Then the area's drafts are approved in one review, each version 0 before what builds on it.

Once the area is approved, Claude records every ticket it read for the area on the map, with what became of each: carried over, with the artifact it became, or left out, as open, in progress, or by your choice, with who chose. Nothing read slips through, and you can tell when an old tracker project has nothing left in it:

```
tickets:
  - key: PAY-14
    link: https://example.atlassian.net/browse/PAY-14
    title: Email template
    outcome: carried
    artifact: TK-E004
  - key: PAY-31
    title: Reset by text
    outcome: left-out
    why: open
```

After approval, Claude runs the tests and matches the existing ones to the new test cases, without changing the code, then shows which behavior has no test and which tests test no stated behavior. See [Existing tests](test-plans.md#existing-tests).

### Where it stands

Stop after any area and carry on later: progress is worked out from the spec tree itself, so it is the same on every machine.

```
Onboarding: 1 of 3 areas onboarded, from the map in onboarding/map.yaml.

| Area | Paths | Where it stands |
|---|---|---|
| Password reset | src/reset/ | onboarded: 2 of 2 files described |
| Billing | src/billing/ | not started: its one file is not described |
| Accounts | src/accounts/ | partly done: 1 of 2 files described |

Next area: Billing.
```

Below the table, each area with tickets recorded says how many were read, carried over and left out, and names those left out, such as `- Password reset: 12 read, 9 carried over, 3 left out (3 open). Left out: PAY-31 "Reset by text" (open), …`.

An area is **onboarded** once every code file in it is described, by the paths an approved artifact covers or by the commits of linked work. One that work already touched shows as **partly done**, and onboarding it drafts only what is not described yet.

## Questions left open

When the person documenting an area does not know which of two disagreeing sources is right, often because someone else wrote the code, they answer **Not sure: leave it open**. Claude offers it after the two answers, and recommends none of them. The question is kept in the version 0 draft's front matter, with both readings and who left it open, and the part it concerns is left out of version 0:

```
openQuestions:
  - id: Q1
    about: Reset link lifetime
    code: Links last 60 minutes (src/reset/token.ts)
    source: Links last 30 minutes
    sources: [PAY-12]
    leftOpenBy: Jane Doe <jane@example.com>
    leftOpenAt: 2026-10-15T09:12:00Z
```

A version 0 with a question left open cannot be approved, nor can what depends on it, such as its test plan; the rest of the area's drafts are approved in the same review. `/bk:onboard` lists the questions left open, and `/bk:status` counts them, so someone who knows can answer later: Claude asks them, records `answer: code` or `answer: source` with who answered and when, and drafts the part it concerns. When the source was right, the defect is recorded as a bug, as for any known defect. Answered questions are frozen with version 0.

In a Spec-driven tree, where a capability's version 0 is written once, the question is kept on its area of the map instead, and the requirement it concerns is left out of version 0. Answering it is followed by a change that adds the requirement.

## Adding version 0 to what BuildKeel already has

An artifact made in BuildKeel can get its version 0 later, describing its code as it was at the baseline. Its ID stays the same, and the version in force stays in force. When the version in force leaves out behavior that version 0 describes, Claude also drafts the next version with both, the version in force winning where they overlap. That version only completes the one in force, so nothing built on it becomes suspect, and the criteria it adds are coverage gaps until the test plan covers them. See [Version 0 and completing versions](change-impact.md#version-0-and-completing-versions).

## Filling in later

Sections left empty are listed when you run `/bk:onboard`, with what each artifact lacks:

```
Still as onboarding left them, with required sections empty (1):
- US-E002 story "Invoices" v0: Story, Acceptance criteria
Filling one in drafts its next version, which only completes it: nothing built on it becomes suspect.
```

Choose **Fill in what onboarding left empty**, and Claude asks for each empty section, one at a time; anything you still cannot answer can stay empty.

## Known defects

When you tell Claude a drafted behavior is a defect, not what was intended, version 0 is changed to state the intended behavior. Once the area is approved, the defect is recorded as a bug against that story, naming the criterion and what the code does instead, and is fixed like any bug. See [Bugs and ad-hoc units](bugs-and-adhoc.md).

## In the status overview

Once a version 0 or a map exists, `/bk:status` shows an **Existing code** section: how much of the code is described, how many areas are onboarded, and how many onboarded test cases have a test. Nothing in it needs attention, so it never appears in the line under the title, nor in the session report. See [The status overview](status.md#existing-code). `/bk:stats` counts what was documented area by area and what as work touched it.

## In a Spec-driven tree

In a Spec-driven tree (see [The two modes](modes.md)), existing code is described by [capability specs](capability-specs.md), and what describes code from before BuildKeel is a capability's **version 0**. It is written once a person has read and confirmed it, never drafted as a file first, and no change writes it.

`/bk:onboard` maps the code into areas as above, each to become one or more capabilities. For the next area, Claude reads its code and what you bring, then shows you each capability spec it drafts: a purpose, then requirements with their scenarios, under a code Claude proposes from its name, which you can change. Only when you confirm one is it saved:

```markdown
---
id: BILL
title: Billing
area: Billing
---

## Purpose

How customers are charged each month.

## Requirements

### BILL-R1 Monthly invoice
The system SHALL send each customer an invoice on the first day of the month.

#### BILL-R1-S1 First of the month
- **WHEN** the first day of a month begins
- **THEN** every active customer is sent an invoice for the month before
```

Its code is reserved and its requirements and scenarios numbered from the shared counter, like any others. Its record says who confirmed it and when, the code repository's baseline commit, and a hash of each source it was drafted from. It is committed on its own as `onboard: BILL v0`, and never edited: the first change to it makes version 1.

Where onboarding stands lists each area with the capabilities confirmed for it, from the `area` each names:

```
Onboarding, from the map in onboarding/map.yaml: each area is documented as capability specs, version 0, confirmed by a person.
- Billing: BILL v0, confirmed by Jane Doe <jane@example.com> on 2026-10-14
- Search: not started (src/search/)
```

As work touches undocumented code, capturing a change includes version 0 of a capability describing how that code works today. You can drop it; once you keep it, it is saved the same way before the change, and the change's spec change is written against version 0.

## Moving a Spec-driven tree to Full SDLC

A Spec-driven tree moves to Full SDLC through onboarding (see [The two modes](modes.md#moving-to-full-sdlc)). Its capability specs and archived changes are the sources, in place of old code and tickets, and your stages are drafted from them area by area, as version 0, for you to review and approve. The move goes one way.

**Starting.** Ask for it in `/bk:onboard`. It is refused while a change is open, naming each one: finish or discard them first. Claude shows the process the tree will follow, as `/bk:init` shows it for a new Full SDLC tree, and you take it or adjust it. Bugs and ad-hoc units keep their numbering. BuildKeel then writes `onboarding/conversion.yaml` and commits it as `onboard: start conversion to Full SDLC`. From then on no change can be opened, while bugs, ad-hoc units and looking up capability specs work as usual.

**The map.** Each area holds one or more capability specs, and each capability spec is in one area:

```yaml
areas:
  - name: Signing in
    repo: accounts-api
    capabilities: [AUTH]
  - name: Notifications
    repo: accounts-api
    capabilities: [NOTIF]
```

**Each area.** Claude reads the area's capability specs and the archived changes that wrote them, and proposes the artifacts your stages need, top down, as for any area. Each change it draws on is kept as a source of the version 0 it fed, with the change's ID as its key. Requirements become acceptance criteria and scenarios become test cases wherever they fit your stages; nothing maps one to one, so a stage your team added is drafted like any other. A document no source provides, such as a design document, is drafted as version 1. You review and approve the area's drafts as a set, and they get onboarded numbers, such as `US-E001`.

**Where each scenario went.** Once the area is approved, Claude shows a table of each scenario and the test case or criterion it became, and records it. A scenario that fits nothing is listed for you: you place it, or leave it out, and nothing is left out without your word. The record keeps both:

```yaml
startedBy: Jane Doe <jane@example.com>
startedAt: 2026-10-14T09:00:00Z
process: {}
placed:
  AUTH-R1-S1: US-E001-TC1
  AUTH-R2-S1: US-E001-TC3
  AUTH-R3-S1: US-E001-TC4
dropped: {}
```

An area is converted once each of its scenarios is placed or left out. Where it stands, from `/bk:onboard`:

```
Converting to Full SDLC, started by Jane Doe <jane@example.com> on 2026-10-14: 0 of 2 areas converted. The tree stays Spec-driven until every area is.

| Area | Capability specs | Where it stands |
|---|---|---|
| Signing in | AUTH | 3 of 4 scenarios placed or left out |
| Notifications | NOTIF | not started |

Not placed yet, in areas already begun: AUTH-R1-S2 "Wrong password". Place each on the criterion or test case it became, or leave it out if the user says so; nothing is dropped without their choice.

Next: Signing in.
```

You can stop after any area: the tree stays Spec-driven, and the next `/bk:onboard` carries on. Until the first area is approved you can also cancel, which removes the conversion and its drafts in one commit.

**The switch.** Once every area is converted, Claude asks you to confirm the switch. BuildKeel writes `mode: full-sdlc` and your process to `buildkeel.yaml`, marks the conversion finished with who and when, and commits both on their own as `onboard: switch to Full SDLC`. From then on work goes through your stages, approvals and gates.

**After the switch:**

- A test tagged with a scenario, such as `[AUTH-R3-S1]`, counts for the test case it became. Recording a report names each one, and Claude retags the test with the test case's ID the next time it changes it.
- Code that archived changes wrote stays linked: asking what describes a file names the change and the artifacts its requirements became.
- A bug found in a change keeps its link to that change, and its scenario stands for the test case it became.
- Each converted artifact names where its entries came from, so you can find the change behind a criterion:

```
Converted from the tree's capability specs (kept, read-only, as history):
- US-E001-TC1: scenario AUTH-R1-S1 of requirement AUTH-R1, added by CH-001 (AUTH v1)
- US-E001-TC3: scenario AUTH-R2-S1 of requirement AUTH-R2, added by CH-001 (AUTH v1)
- US-E001-TC4: scenario AUTH-R3-S1 of requirement AUTH-R3, added by CH-002 (AUTH v2)
```

The capability specs, archived changes and the conversion's record stay in the tree, read-only: the lock gate refuses edits to them, and validation checks them as before.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-onboard`, `/bk-status`.
