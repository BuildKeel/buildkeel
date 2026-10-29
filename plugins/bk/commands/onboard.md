---
description: "BuildKeel: Document code that existed before BuildKeel, area by area: map the code, then draft each area for people to review and approve."
argument-hint: "[an area to onboard, or nothing to choose]"
disable-model-invocation: true
---

Document the code that existed before BuildKeel with the user, one capability area at a time. People lead it: you propose and draft, the user corrects, completes and approves, and nothing is approved without them. They can stop after any area and carry on later; whatever they leave is documented as work touches it.

What describes code from before BuildKeel is version 0 of its artifact: the artifact as it would read had BuildKeel been used from the start, drafted from the code and from the material the user brings.

The user typed: $ARGUMENTS

If BuildKeel's session report, or `query` with `view: "process"`, says this spec tree is Spec-driven, follow "In a Spec-driven tree" at the end in place of "Onboard an area" and the sections after it.

## Choose what to do

Call the BuildKeel `query` tool with `view: "onboarding"`; it changes nothing. Then ask straight away, the default listed first, with what the view said in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool.

- When there is a map: **Continue with an area**, **Adjust the map**, **Fill in what onboarding left empty** (only when the view lists anything), **Stop**. When the user continues, ask which area, as in "Choose an area" below.
- When there is none: **Map the code** (the default), **Fill in what onboarding left empty** (only when the view lists anything), **Stop**.

If the user typed an area's name above, onboard that area. Ask one question at a time, each with your recommendation, and only for what you cannot work out. Two kinds of question carry no recommendation, because only the user knows the answer: which of two disagreeing sources is intended, and what a section nothing supports should say.

Topics for this step, for each area, in this order:

- **the artifacts** the area needs, and the kind of each where a stage holds more than one;
- **each disagreement** between a source and the code, or between two sources;
- **each required section** nothing supports.

Work from the topics listed for this step. The user may answer in their own words, several topics at once or part of one. After each answer, say which topics it settled, with what you understood for each, and which are left; then ask the next one left, one topic per message. Where a topic has a default, list keeping it first, naming its actual value, and give examples where they help. Anything you work out that the user did not say is a proposal: ask it as that topic's question, with it as the default, and never use it without the user's answer. Ask about an unclear answer; name a conflicting one beside the earlier answer and ask which holds. Never guess. When every topic is settled, show all of it, as a review.

## Map the code

1. Read the code's layout: its top-level folders, entry points, routes or handlers, and what the README says. Call `query` with `view: "tree"` for what the spec tree already holds.
2. Propose capability areas: what the product does, in the words its users would use ("Password reset", "Invoicing"), not one area per folder. Give each the paths it covers, its repository when the tree serves several, and one line on what it does. Make them a table, with a column for the area, its paths and what it does, in the order you recommend onboarding them, and say why in a sentence.
3. Ask: **Use this map** (the default), **Merge, split or rename areas**, or **Stop**, with the table and that sentence in your reply, so the user sees what is mapped to what before choosing. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Take in each change, and ask again with the whole table.
4. Once the user agrees, write the map with `manage`, `action: "map"`, `map: "set"` and the `areas`. Later changes to a written map use `map: "merge"`, `"split"` or `"rename"`. Then ask which area to onboard, as in "Choose an area", with the table `manage` returns, as it is, in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool.

## Choose an area

Offer each area that is not onboarded yet as its own choice, in the map's order, so the user picks among all of them, never between your pick and stopping alone. Mark the next one in the map's order as the default, and add **Stop**. When there are more areas than your host's choices allow, list the first ones and let the user type another area's name.

## Onboard an area

### 1. Find out what there is

- Call `query` with `view: "onboarding"`. When the area is partly done, call `query` with `view: "describes"` and its files: draft only what nothing describes yet.
- Read the code under the area's paths as it was at the baseline commit, which `buildkeel.yaml` names for each repository (`git show <baseline>:<path>`): version 0 describes the code before BuildKeel.
- Call `query` with `view: "process"` for the stages and the documents each requires, and `view: "tree"` for where the area fits, such as under an existing business idea or epic.
- Ask the user what they have about this area: a project or epic in their issue tracker, wiki pages, documents, or what they know. Read what they point to through their own tools; BuildKeel connects to no other tool. When you cannot reach it, ask them to paste it, and do not suggest setting up a connection. If they have nothing, draft from the code and from what they tell you.

### 2. Propose what the area needs

Show a table of the artifacts the area needs, top down, in the team's stage names, each existing or to draft:

| Level | Kind | Artifact | Version | From |
|---|---|---|---|---|
| Business idea | business idea | BI-01 "Self-service account recovery" | exists | |
| Epic | epic | "Password reset" | version 0 | the code, Confluence "Reset design" |
| Design document | | of that epic | version 1 | the code: no source has one |
| Story | user story | "Reset by email" | version 0 | the code, PAY-12 |
| Story | feature | "Reset by text" | version 0 | the code, PAY-20, labelled a feature |
| Test plan | | of each story | version 1 | one test case per criterion |
| Task | task | PAY-14 "Email template" | version 0 | finished in Jira |
| Left out | | PAY-31 "Reset by security question" | | open in Jira: drafted with /bk:new when someone takes it up |

When a stage holds more than one kind (`query` with `view: "process"` lists them), propose the kind of each artifact at that stage from where it came from, such as a ticket labelled a feature or a change to existing behavior, and say why in the table. The user confirms or changes each kind before anything is drafted; never pick one without their answer. Each is drafted with its kind as `type`, from that kind's template.

Once the area's drafts are approved, or all but those waiting on a question left open, record every ticket you read for it with `manage`, `action: "map"`, `map: "tickets"`, the area and its `tickets`: each with its `key`, `link` and `title`, and either `outcome: "carried"` with the `artifact` it became (its approved ID), or `outcome: "left-out"` with `why`: `open`, `in-progress`, or `choice` when the team chose not to carry it over. Nothing read is left off the list.

- Document every stage from the business idea down to the story, with the documents the process requires of each.
- Tasks and defects come in only when a source has them and they are finished: each as version 0, with its tracker key. Open or in-progress work is left out, and listed as such.
- A required document no source provides, such as a design document or a test plan, is drafted as version 1, under the normal rules, so that new work under the area can start as usual.
- When an artifact in BuildKeel already describes part of the area, see "Version 0 under an existing artifact" below.

Ask: **Draft them all** (the default), **Change the plan**, **Skip this area**, or **Stop**, with the table in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool.

### 3. Draft everything

Only once the user agrees. Draft top down, parents before children, so each child names its parent's draft ID. Call `get_template` once for each type you draft, and follow it.

**Each version 0**, with `save_draft` and `version: 0`:

- Fill the template's sections from the code and the sources, rewording what they say into the template's form, such as a ticket's description written as testable criteria. Add nothing they do not support. Supported means the code or a source says it; a plausible guess is not support. Who a story is for and why, a business idea's problem and goals, and a design's context are rarely in the code or a ticket: write a story's Story section only from a source or the user that says who wants it and why, and otherwise ask, as below.
- Name the paths it covers in its `scope`: an epic and a story always do.
- Keep each source as you read it: pass it in `sources`, with where it came from, its key and link, and its text exactly as your tool returned it (description, fields and comments). Never copy code into a source.
- Before drafting, go through every behavior each source states, such as each sentence of a ticket's description, and check it against the code. Each place they differ is a disagreement, however small: a ticket saying "rounded to the nearest cent" where the code rounds down is one. Ask about each, one at a time, before drafting that part; never take one side silently.
- When a source and the code disagree, or two sources do (a ticket says a reset link lasts 30 minutes, the code makes it 60), ask the user which is intended before drafting that part. Offer both answers as equals and recommend neither: **The code is right; the ticket is out of date** and **The ticket is right; the code has a defect**. When the ticket is out of date, version 0 follows the code. When the code is wrong, see "Known defects" below. Offer a third answer after those two, still with no recommendation: **Not sure: leave it open**. Then keep the question in the version 0 draft's front matter, under `openQuestions`, with an `id` (Q1, Q2, ...), what it is `about`, what the `code` does, what the `source` says and the `sources`' keys, and leave the part it concerns out of version 0: BuildKeel records who left it open, and version 0 waits for an answer before it can be approved. Someone who knows answers it later with /bk:onboard: add `answer: code` or `answer: source` to it, save the draft, and draft the part it concerns.
- For each required section nothing supports, ask the user, one question at a time, with your tool for asking a question with choices: **Leave it empty** (listed first) or **Type it in**, and put no answer of your own in the choices. A version 0 may leave a section empty: the approval records it, and it can be filled in later.

**Each finished task, and each defect fixed before BuildKeel**, is a version 0 too: `save_draft` with `type: "task"` or `"defect"`, `version: 0`, its `parent` the story or task it belongs to (a draft's ID is fine), and its tracker issue in `sources`. It is approved with the area, counts as done, and is linked to the commits before the baseline that name its key. Never record a defect that was already fixed as an open defect.

**Each version 1**, such as a design document or test plan no source has: draft it with `save_draft` and no `version`, from the code, as for any new artifact. It is held to its template, so it cannot leave a required section empty, and "Leave it empty" is never a choice for it. For each required section the code does not give, such as a design's context, ask the user, with what the code shows as a starting point they can accept or change: for code from before BuildKeel, "Built before BuildKeel; why is not recorded" is a fair answer when nobody knows.

A test plan has a test case for each acceptance criterion of its story. A finished task's test cases, if it has any, come from its sources.

### 4. Review and approve

Show what was drafted as a table: ID, title, version, the sources kept, and the sections left empty. Then offer to approve the area's drafts in one review: call `approve` with `ids` set to all of them and `onboard: true`, first without `apply`, and ask whether to approve them, with the table and the result as it is in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Call it again with `apply: true` only when the user confirms. Each version 0 is approved first, and a finished task's version 0 is linked to the commits before the baseline that name its key.

### 5. Existing tests

Once the area is approved:

1. Run the tests with a JUnit XML report and record it with `test_results`, as the agent instructions describe.
2. Call `query` with `view: "untested"` and the area's epic or story: it lists the test cases with no test, and the tests in the report that match no test case.
3. Propose which existing tests implement which test cases, as a table, naming each test exactly as the report does. Ask the user to confirm or correct it, with the table in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Then record each with `manage`, `action: "match"`, the test case's `id` and its `tests`. The code is never changed.
4. Call `query` with `view: "untested"` again and show the gap report: the behavior with no test, and the tests that test no stated behavior.

### 6. Next

Call `query` with `view: "onboarding"` and ask which area to onboard next, as in "Choose an area", with where onboarding stands in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. When the view lists anything left empty, also offer **Fill in what onboarding left empty**; when it lists questions left open, also offer **Answer a question left open**: ask the question, with both readings as equals, and record the answer as above.

## Known defects

When the user says a drafted behavior is a defect, not what was intended: revise version 0 to state the intended behavior, and once the area is approved, record the defect against that story: `save_draft` with `type: "defect"`, `parent` set to the story's ID, `testCase` set to the test case that covers that criterion when the story's test plan has one, its Expected naming the criterion (its ID and text), and its Actual saying what the code does instead. Fixing it is then work like any defect, and a test matched to that test case is tagged as the fix changes it.

## Version 0 under an existing artifact

An artifact made in BuildKeel can get its version 0 later: how its code worked at the baseline commit. Draft it with `save_draft`, the artifact's `id` and `version: 0`, from the code at the baseline (`git show <baseline>:<path>`), by the same rules. Its ID never changes.

When the version in force leaves out behavior that version 0 describes, also draft the next version with the complete picture: the version in force wherever the two overlap, version 0 only where the version in force says nothing, and both checked against today's code. Give it `completes: <the version in force>` in its frontmatter: it changes no code, so nothing built on the version in force becomes suspect, and the criteria it adds are coverage gaps until the test plan covers them. Approve version 0 and that version in one review, version 0 first (`<ID>@v0`, then `<ID>`). When the version in force already describes everything, draft only version 0.

## Fill in what onboarding left empty

The onboarding view lists the artifacts still as onboarding left them, with each section they leave empty. When it lists none, say that nothing was left empty, and stop: what the user says next is conversation, not a request for a new artifact. Otherwise ask which to fill in, the first listed as the default. For each empty section, ask the user, one question at a time, with **Leave it empty** as a choice. Save the whole artifact with the sections filled in, with `save_draft` and its `id`, and `completes: <the version in force>` in its frontmatter: that next version only completes it, so nothing built on it becomes suspect. Offer to approve it with /bk:approve.

Do not create or edit spec tree files yourself: `save_draft`, `approve` and `manage` do all writing.

## In a Spec-driven tree

Existing code is documented as capability specs, version 0, area by area. Map the code as "Map the code" says, each area to become one or more capabilities. For the area `query` with `view: "onboarding"` names next: read its code and what the user brings, then draft each capability spec (a purpose, requirements with scenarios, new IDs as `CODE-R{{new}}`, the code proposed from its name for the user to change) and show it whole. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Anything but agreement is feedback: discuss it, then list each point with how it was addressed, show the final version, and ask again. Only once the user confirms one, save it with `save_draft`, `type: "capability"`, `version: 0` and `area: <name>` in its frontmatter: it is written once, with who confirmed it. When sources disagree, ask as above, with **Not sure: leave it open** last; a question left open is recorded on the area with `manage`, `action: "map"`, `map: "question"`, and its requirement is left out of version 0. Answering one later (`map: "answer"`) is followed by a change that adds the requirement. Record the tickets read for the area with `map: "tickets"` as above, each carried one naming the capability spec it fed. Then offer the next area.

### Moving to Full SDLC is not onboarding

/bk:onboard only documents code. When the user asks to move the tree to Full SDLC, or for approvals, stages or gates, say that moving the tree is done with /bk:migrate, and convert nothing here. When `query` with `view: "onboarding"` shows a conversion in progress, say that /bk:migrate carries it on.
