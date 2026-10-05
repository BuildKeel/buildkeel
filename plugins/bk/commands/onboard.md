---
description: "BuildKeel: Document code that existed before BuildKeel, area by area: map the code, then draft each area for people to review and approve."
argument-hint: "[an area to onboard, or nothing to choose]"
---

Document the code that existed before BuildKeel with the user, one capability area at a time. People lead it: you propose and draft, the user corrects, completes and approves, and nothing is approved without them. They can stop after any area and carry on later; whatever they leave is documented as work touches it.

What describes code from before BuildKeel is version 0 of its artifact: the artifact as it would read had BuildKeel been used from the start, drafted from the code and from the material the user brings.

The user typed: $ARGUMENTS

## Choose what to do

Call the BuildKeel `query` tool with `view: "onboarding"`; it changes nothing. Then ask straight away, with your tool for asking a question with choices if you have one, the default listed first, showing what the view said. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence.

- When there is a map: **Continue with an area**, **Adjust the map**, **Fill in what onboarding left empty** (only when the view lists anything), **Stop**. When the user continues, ask which area, as in "Choose an area" below.
- When there is none: **Map the code** (the default), **Fill in what onboarding left empty** (only when the view lists anything), **Stop**.

If the user typed an area's name above, onboard that area. Ask one question at a time, each with your recommendation, and only for what you cannot work out. Two kinds of question carry no recommendation, because only the user knows the answer: which of two disagreeing sources is intended, and what a section nothing supports should say.

## Map the code

1. Read the code's layout: its top-level folders, entry points, routes or handlers, and what the README says. Call `query` with `view: "tree"` for what the spec tree already holds.
2. Propose capability areas: what the product does, in the words its users would use ("Password reset", "Invoicing"), not one area per folder. Give each the paths it covers, its repository when the tree serves several, and one line on what it does. Make them a table, with a column for the area, its paths and what it does, in the order you recommend onboarding them, and say why in a sentence.
3. Ask: **Use this map** (the default), **Merge, split or rename areas**, or **Stop**, showing the table and that sentence, so the user sees what is mapped to what before choosing. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. Take in each change, and ask again with the whole table.
4. Once the user agrees, write the map with `manage`, `action: "map"`, `map: "set"` and the `areas`. Later changes to a written map use `map: "merge"`, `"split"` or `"rename"`. Then ask which area to onboard, as in "Choose an area", showing the table `manage` returns, as it is. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence.

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

| Level | Artifact | Version | From |
|---|---|---|---|
| Business idea | BI-01 "Self-service account recovery" | exists | |
| Epic | "Password reset" | version 0 | the code, Confluence "Reset design" |
| Design document | of that epic | version 1 | the code: no source has one |
| Story | "Reset by email" | version 0 | the code, PAY-12 |
| Test plan | of that story | version 1 | one test case per criterion |
| Task | PAY-14 "Email template" | version 0 | finished in Jira |
| Left out | PAY-31 "Reset by text" | | open in Jira: drafted with /bk:new when someone takes it up |

- Document every stage from the business idea down to the story, with the documents the process requires of each.
- Tasks and bugs come in only when a source has them and they are finished: each as version 0, with its tracker key. Open or in-progress work is left out, and listed as such.
- A required document no source provides, such as a design document or a test plan, is drafted as version 1, under the normal rules, so that new work under the area can start as usual.
- When an artifact in BuildKeel already describes part of the area, see "Version 0 under an existing artifact" below.

Ask: **Draft them all** (the default), **Change the plan**, **Skip this area**, or **Stop**, showing the table. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence.

### 3. Draft everything

Only once the user agrees. Draft top down, parents before children, so each child names its parent's draft ID. Call `get_template` once for each type you draft, and follow it.

**Each version 0**, with `save_draft` and `version: 0`:

- Fill the template's sections from the code and the sources, rewording what they say into the template's form, such as a ticket's description written as testable criteria. Add nothing they do not support. Supported means the code or a source says it; a plausible guess is not support. Who a story is for and why, a business idea's problem and goals, and a design's context are rarely in the code or a ticket: write a story's Story section only from a source or the user that says who wants it and why, and otherwise ask, as below.
- Name the paths it covers in its `scope`: an epic and a story always do.
- Keep each source as you read it: pass it in `sources`, with where it came from, its key and link, and its text exactly as your tool returned it (description, fields and comments). Never copy code into a source.
- Before drafting, go through every behavior each source states, such as each sentence of a ticket's description, and check it against the code. Each place they differ is a disagreement, however small: a ticket saying "rounded to the nearest cent" where the code rounds down is one. Ask about each, one at a time, before drafting that part; never take one side silently.
- When a source and the code disagree, or two sources do (a ticket says a reset link lasts 30 minutes, the code makes it 60), ask the user which is intended before drafting that part. Offer both answers as equals and recommend neither: **The code is right; the ticket is out of date** and **The ticket is right; the code has a defect**. When the ticket is out of date, version 0 follows the code. When the code is wrong, see "Known defects" below.
- For each required section nothing supports, ask the user, one question at a time, with your tool for asking a question with choices: **Leave it empty** (listed first) or **Type it in**, and put no answer of your own in the choices. A version 0 may leave a section empty: the approval records it, and it can be filled in later.

**Each finished task, and each bug fixed before BuildKeel**, is a version 0 too: `save_draft` with `type: "task"` or `"bug"`, `version: 0`, its `parent` the story or task it belongs to (a draft's ID is fine), and its tracker issue in `sources`. It is approved with the area, counts as done, and is linked to the commits before the baseline that name its key. Never record a bug that was already fixed as an open bug.

**Each version 1**, such as a design document or test plan no source has: draft it with `save_draft` and no `version`, from the code, as for any new artifact. It is held to its template, so it cannot leave a required section empty, and "Leave it empty" is never a choice for it. For each required section the code does not give, such as a design's context, ask the user, with what the code shows as a starting point they can accept or change: for code from before BuildKeel, "Built before BuildKeel; why is not recorded" is a fair answer when nobody knows.

A test plan has a test case for each acceptance criterion of its story. A finished task's test cases, if it has any, come from its sources.

### 4. Review and approve

Show what was drafted as a table: ID, title, version, the sources kept, and the sections left empty. Then offer to approve the area's drafts in one review: call `approve` with `ids` set to all of them and `onboard: true`, first without `apply`, and ask whether to approve them, showing the table and the result as it is. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. Call it again with `apply: true` only when the user confirms. Each version 0 is approved first, and a finished task's version 0 is linked to the commits before the baseline that name its key.

### 5. Existing tests

Once the area is approved:

1. Run the tests with a JUnit XML report and record it with `test_results`, as the agent instructions describe.
2. Call `query` with `view: "untested"` and the area's epic or story: it lists the test cases with no test, and the tests in the report that match no test case.
3. Propose which existing tests implement which test cases, as a table, naming each test exactly as the report does. Ask the user to confirm or correct it, showing the table. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. Then record each with `manage`, `action: "match"`, the test case's `id` and its `tests`. The code is never changed.
4. Call `query` with `view: "untested"` again and show the gap report: the behavior with no test, and the tests that test no stated behavior.

### 6. Next

Call `query` with `view: "onboarding"` and ask which area to onboard next, as in "Choose an area", showing where onboarding stands. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. When the view lists anything left empty, also offer **Fill in what onboarding left empty**.

## Known defects

When the user says a drafted behavior is a defect, not what was intended: revise version 0 to state the intended behavior, and once the area is approved, record the defect as a bug against that story: `save_draft` with `type: "bug"`, `parent` set to the story's ID, `testCase` set to the test case that covers that criterion when the story's test plan has one, its Expected naming the criterion (its ID and text), and its Actual saying what the code does instead. Fixing it is then work like any bug, and a test matched to that test case is tagged as the fix changes it.

## Version 0 under an existing artifact

An artifact made in BuildKeel can get its version 0 later: how its code worked at the baseline commit. Draft it with `save_draft`, the artifact's `id` and `version: 0`, from the code at the baseline (`git show <baseline>:<path>`), by the same rules. Its ID never changes.

When the version in force leaves out behavior that version 0 describes, also draft the next version with the complete picture: the version in force wherever the two overlap, version 0 only where the version in force says nothing, and both checked against today's code. Give it `completes: <the version in force>` in its frontmatter: it changes no code, so nothing built on the version in force becomes suspect, and the criteria it adds are coverage gaps until the test plan covers them. Approve version 0 and that version in one review, version 0 first (`<ID>@v0`, then `<ID>`). When the version in force already describes everything, draft only version 0.

## Fill in what onboarding left empty

The onboarding view lists the artifacts still as onboarding left them, with each section they leave empty. When it lists none, say that nothing was left empty, and stop: what the user says next is conversation, not a request for a new artifact. Otherwise ask which to fill in, the first listed as the default. For each empty section, ask the user, one question at a time, with **Leave it empty** as a choice. Save the whole artifact with the sections filled in, with `save_draft` and its `id`, and `completes: <the version in force>` in its frontmatter: that next version only completes it, so nothing built on it becomes suspect. Offer to approve it with /bk:approve.

Do not create or edit spec tree files yourself: `save_draft`, `approve` and `manage` do all writing.
