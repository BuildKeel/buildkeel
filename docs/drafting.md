# Drafting with Claude

Claude drafts your business ideas, epics, stories, tasks, test plans and design documents from your templates: a whole plan from a conversation, one artifact at a time, or a full breakdown of a parent. Everything it writes is a **draft**: nothing is approved until you approve it, and a draft goes through the same checks as one you wrote yourself.

## From a conversation

Talk the idea through with Claude first, as you would without BuildKeel: what it is for, the options, the design, the code it touches. BuildKeel stays out of that conversation. When you are ready, run:

```
/bk:capture
```

Claude works in two steps, and asks before each:

1. **What it heard.** A short summary in plain words: what you set out to do, the idea, and the approach and decisions discussed. Choose **Create the artifacts**, **Change something**, or **Keep talking**. Any other answer, such as a correction, simply goes on with the conversation; nothing is drafted.
2. **The plan.** A table of the artifacts your process needs, level by level, each marked as existing or new, with the documents each stage requires (by default a design document for an epic and a test plan for each story), and where Claude recommends the work fits in your tree, and why. Choose **Draft them all**, **Place it somewhere else**, **Change the plan**, or **Keep talking**.

Once you agree, Claude drafts every artifact with your templates, top down, and then asks you, one question at a time, for each required part the conversation never covered, such as how a feature will be rolled out. Nothing is invented to fill a gap. Approve the drafts in one review with `/bk:approve` (see [Approving artifacts](approval.md)). A task's own test plan is not among them: it is recorded when its task is approved (see [Test plans](test-plans.md#a-tasks-own-plan-is-recorded)).

To capture only part of a long conversation, say which: `/bk:capture the text message reset`.

If you place the work somewhere other than Claude recommended, such as a new epic instead of under `EP-01`, the new artifact is linked to the recommended one (`related: [EP-01]`), so a change to either makes the other worth a look. If the work changes how something already built behaves, and a document describes how it works today, such as `EP-01-DD`, the plan includes a new version of that document. See [Change impact](change-impact.md).

If the work changes code that nothing describes yet, Claude finds it from the files the work will change, and the plan includes a **version 0** of what the work touches: how that code works today, with your change as its version 1, so the change has a "before". It appears in the table as, for example, a story marked "version 0, then the change as version 1". Choose **Draft them all, without the version 0** to leave it out; the change is then drafted as new work. A version 0 drafted for a change covers only what the change touches, and a section nothing supports is left empty and listed for whoever approves it, with no question asked. Approving the plan approves version 0 first. See [Code from before BuildKeel](#code-from-before-buildkeel).

## Draft one artifact

```
/bk:new story EP-01
```

Name the type and, if you know it, the parent. Run `/bk:new` on its own and Claude asks what to draft, with examples; press Enter on the first choice and it suggests what to draft next from your tree. Claude reads the template and the parent, asks for anything it cannot work out (one question at a time), and saves the draft. Types are `idea`, `epic`, `story`, `task`, `test-plan` and `design` (a design document); you can also use your team's own name for a stage or a document.

When the artifact changes code that nothing describes yet, Claude says so and offers to draft a version 0 of what it changes first, the default; the new artifact is then its version 1, or sits under it.

## Break a parent down

```
/bk:new stories from EP-01
```

Claude proposes a list of children, a title and a line each, and asks before writing them. For stories, it also drafts each story's acceptance criteria and a test plan whose test cases say which criteria they cover. You can break a business idea into epics, an epic into stories, and a story into tasks the same way.

## Bring your own material

Paste existing requirement text, point Claude at a file, or name something it can read through tools you have connected to it, such as an issue in your tracker or a page in your wiki. Claude fits it to the template: each part goes in the section it belongs to, keeping its meaning and its wording, and anything that fits no section goes in the section for further material, such as **Notes**. For each required section the material does not cover, Claude asks you, one question at a time.

```
/bk:new design EP-01 from docs/password-reset-design.md
```

BuildKeel itself connects to no other tool: whatever Claude reads, it reads through your own setup.

## Code from before BuildKeel

What describes code that existed before BuildKeel is [version 0](approval.md#version-0-code-from-before-buildkeel) of its artifact: the artifact as it would read had BuildKeel been used from the start. Claude drafts it from the code and from what you bring about it, such as a ticket or a wiki page it reads through your own tools, a file, or what you tell it:

- What the code and the sources say is reworded into the template's form, such as a ticket's description written as testable criteria. Nothing they do not support is added.
- Each source is kept beside version 0 as it was read, with where it came from and its link, and listed in its Sources section. Code is never copied: the baseline commit names it.
- When a source and the code disagree, such as a ticket that says a reset link lasts 30 minutes where the code makes it 60, Claude asks which is intended before drafting that part. When the code is wrong, version 0 states the intended behavior, and the defect is recorded as a bug against it. When the ticket is out of date, version 0 follows the code. When nobody here knows, answer **Not sure: leave it open**: the question is kept in the draft, that part is left out, and version 0 waits for someone who knows (see [Questions left open](onboarding.md#questions-left-open)).

You read it, complete it or correct it, and approve it. You can also write any of it by hand. To document existing code area by area rather than as work touches it, see [Documenting existing code](onboarding.md).

## Design documents

A design document says how an artifact's work is built, usually an epic's. It belongs to that artifact and is named after it: the design document of `EP-01` is `EP-01-DD`. Its template is quick to fill in: a summary, the context, goals and non-goals, the design, numbered decisions with why and what else was considered, and risks and trade-offs; only the summary, context and design are required. Further sections, such as architecture, data, interfaces, security, operations, or rollout and rollback, are offered and added only when the work needs them. See [Process and templates](process-and-templates.md#the-design-document).

## Draft IDs

A draft has a temporary ID that starts with its type's prefix, so you can tell what it is: `BI-draft-…` for a business idea, `EP-draft-…`, `US-draft-…` and `TK-draft-…`, such as `US-draft-k3x9`. Its entries carry it too: `US-draft-k3x9-AC1`. BuildKeel numbers the entries itself, and never gives a removed entry's number to a new one. Drafts can refer to each other by these IDs, so you can draft a whole tree before approving any of it. An artifact gets its permanent ID, such as `US-001`, when it is first approved, and every reference to it is updated then. A document attached to a draft, such as `EP-draft-k3x9-DD`, takes the new ID with it.

When a draft's parent is already approved, the draft is tied to the parent's approved version, such as `US-001@v1`.

## What is still missing

After each save, Claude tells you whether the draft is ready for approval, and if not, what it still lacks, such as an empty required section or a test case that does not say what it covers:

```
Created draft EP-01-DD (design document) at epics/EP-01/design/design.md. It is saved; 2 things stand in the way of approval, listed below.
```

Ask Claude to fill the gaps, or edit the draft and save again. To see a draft, ask Claude to show it, or run `/bk:status` to see where it sits in the tree.

Bugs are recorded with `/bk:new bug` too, but they are not drafts: a bug gets its permanent ID at once and needs no approval. See [Bugs and ad-hoc units](bugs-and-adhoc.md).

## In a Spec-driven tree

In a Spec-driven tree, what Claude drafts is a [change](changes.md): a proposal, a spec change for each capability whose behavior it alters, a design only when needed, and tasks. Nothing in it is approved, and nothing is a draft: everything stays editable until the change is finished.

- **`/bk:capture`** starts the same way, with a summary of what Claude heard. It then reads the capability specs the work touches and proposes the change as a table of capabilities, each new or modified, with what changes in it, saying whether the change needs a design. Choose **Draft the change**, **Change the plan** or **Keep talking**. Once you agree, Claude drafts the whole change in one save and asks, one question at a time, for anything the conversation left out.
- **`/bk:new change for <what>`** drafts a change from what you type; **`/bk:new spec change for CH-012`**, or tasks or a design for an open change, adds or rewrites one file of it. Run `/bk:new` on its own and Claude asks what to draft, with examples, or suggests what an open change still lacks.
- **IDs are given when the change is saved**, not at approval: the change's own, such as `CH-012`, and each new requirement and scenario, such as `AUTH-R3` and `AUTH-R3-S1`. See [Capability specs](capability-specs.md#ids).
- To go one file at a time, say so: Claude saves the proposal first, then shows each other file before the next.

When the change is drafted, start it with `/bk:start CH-012`.

## Next

Approve drafts with `/bk:approve`, one at a time or as a whole plan.

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-capture`, `/bk-new`, `/bk-status`, `/bk-start`.
