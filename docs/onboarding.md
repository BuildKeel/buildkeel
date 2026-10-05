# Documenting existing code

Most teams set BuildKeel up on code that already exists. None of that code needs documenting before new work starts: from setup on, new work goes through your process, and code from before BuildKeel is never reported as untracked. When you want it described, there are two ways, and you can mix them:

- **As work touches it.** When a change touches code that nothing describes yet, the plan for it includes a description of how that code works today, so the change has a "before". See [Drafting with Claude](drafting.md#from-a-conversation).
- **All at once, area by area**, with `/bk:onboard`, whenever you choose.

Neither is a setting, and neither is offered unless you run a BuildKeel command or ask for a change. Either way, people lead: Claude proposes and drafts, and you correct, complete and approve. You can also write or correct any of it by hand.

## Version 0

What describes code from before BuildKeel is **version 0** of its artifact; anything made in BuildKeel starts at version 1. Version 0 reads like any artifact of its type, as if BuildKeel had been used from the start, and is drafted from the code and from what you bring: your issue tracker or wiki through tools you connected to Claude, files, and what people know. It is not held to the template or to the documents your process requires, so a section nobody knows can stay empty, but a person reads and approves it like any version. See [Version 0](approval.md#version-0-code-from-before-buildkeel) for how it is approved and recorded.

- **Its sources** are kept beside it, exactly as they were read, and frozen with it when it is approved. See [Sources kept with version 0](approval.md#sources-kept-with-version-0).
- **Its number** comes from its type's onboarded sequence, such as `US-E001`; new work keeps the normal one, `US-002`. See [Onboarded numbers](approval.md#onboarded-numbers).
- **When sources disagree** with each other or with the code, Claude asks which is intended. When the code is wrong, version 0 states the intended behavior, and the defect is recorded as a bug. When a ticket is out of date, version 0 follows the code.
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

An area is **onboarded** once every code file in it is described, by the paths an approved artifact covers or by the commits of linked work. One that work already touched shows as **partly done**, and onboarding it drafts only what is not described yet.

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

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-onboard`, `/bk-status`.
