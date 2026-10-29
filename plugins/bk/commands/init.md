---
description: "BuildKeel: Set up BuildKeel in this repository, with a new spec tree or an existing one."
argument-hint: "[path of an existing spec tree]"
disable-model-invocation: true
---

Set up BuildKeel in this repository using the BuildKeel `manage` tool with `action: "init"`. Ask the user one question at a time, each with your recommendation, and wait for the answer before asking the next.

The user typed: $ARGUMENTS

Ask each question with your tool for asking a question with choices, if you have one, with your recommendation as the first choice, so the user can pick it with Enter, except where a step says to ask in prose or in plain text.

## 1. Check the folder

Before any question, call `manage` with `action: "init"` and nothing else. It only reads.

- When it says the folder is not a git repository, ask before anything else, with your tool for asking a question with choices, so the user can pick an answer: **Run git init for me** (the default) or **Stop**. Only when the user agrees, call `manage` with `action: "init"`, `apply: true` and nothing else: it runs `git init`, so never run it yourself. Then say in one line that `git init` ran, before the next question. Ask nothing else until this is settled.
- When it says the repository is already set up, show that, and stop.

## 2. Where the spec tree lives

If the user gave a path above, use it as an existing spec tree and skip this question; if `manage` then reports there is no spec tree there, ask whether to create a new spec repository at that path instead. Otherwise ask:

- **In this repository**, in a `specs/` folder. Recommend this when this is the team's only repository, or when trying BuildKeel out.
- **An existing spec tree**, usually its own repository shared by several code repositories. Ask for its local path. If it is not cloned yet, tell the user to clone it first.
- **A new spec repository**, a repository of its own that several code repositories will share. Ask for its folder, outside this repository, such as `../specs`: a folder that does not exist yet, an empty folder, or an empty repository the user has cloned. Use `location: "new-repo"` with that `path`.

## 3. The mode

For a new spec tree only: an existing tree keeps its own, and `manage` says which. Ask, with a line on each:

- **Spec-driven** (the default, listed first): capability specs say how the system behaves, and each piece of work is a change to them, with no approvals or gates.
- **Full SDLC**: work goes through the team's stages, from business idea down, with approvals and gates.

Pass the choice as `mode` (`spec-driven` or `full-sdlc`) in every call to `manage` below.

## 4. Stamping their own commits

Explain: while a unit of work is active, BuildKeel adds a line `BuildKeel-Unit: <id>` to commits the agent makes. If they agree, a git hook adds the same line to commits they make themselves, for example in a terminal. It changes nothing when no unit is active. Recommend yes. If the repository already manages its git hooks with another tool, nothing is installed and BuildKeel shows the lines to add.

Then call `manage` with `action: "init"`, the `location` (`this-repo`, `existing` or `new-repo`), the `path` if there is one, `stampCommits` and, for a new tree, `mode`, without `apply`. Show the list it returns, as it is, in your reply as normal text.

## 5. The process, for a new Full SDLC spec tree

Topics for this step, in this order:

- **stages**: what each stage is called, and any stage added between the business idea and the user story, with where it sits.
- **kinds**: whether a stage holds more than one kind of work, such as features and enhancements beside user stories. Each kind is numbered in its own sequence, has its own template and documents, and behaves as its stage does.
- **prefixes**: the ID prefix and digits of each stage and kind, such as `US-001`, `FEAT-0001` or `PROJ-12`.
- **documents**: what each stage and kind needs approved before work under it starts: a test plan, a design document, or a document of the team's own, such as a security review.
- **test-plans**: whether a task's own test plan is recorded as it is saved (the default) or approved like any other plan.
- **gates**: each gate's mode: block stops the action, warn lets it go ahead with a warning, off skips the check. The approve gate checks an artifact before it is approved: it follows its template, and its parent is approved. The start gate checks before work starts: everything above the unit is approved and not suspect, and its required documents are approved. The done gate checks before a unit is finished: its test cases pass. The lock gate checks before the agent edits approved versions and records.

Work from the topics listed for this step. The user may answer in their own words, several topics at once or part of one. After each answer, say which topics it settled, with what you understood for each, and which are left; then ask the next one left, one topic per message. Where a topic has a default, list keeping it first, naming its actual value, and give examples where they help. Anything you work out that the user did not say is a proposal: ask it as that topic's question, with it as the default, and never use it without the user's answer. Ask about an unclear answer; name a conflicting one beside the earlier answer and ask which holds. Never guess. When every topic is settled, show all of it, as a review.

The list shows the process as a table: BuildKeel's default, or the organization's when the tree takes its templates from one. Show it as it is, in your reply as normal text. Then ask in prose, not with your tool for asking a question with choices, whether the team uses this process as it is, or works differently and how: they can describe it in their own words, all at once or in part. If they only say it works differently, ask in one line how their team works.

- **Used as it is**: every topic is settled. Pass `settled: ["all"]`, and go on to the review below.
- **Works differently**: settle the topics their description covers, and ask each topic left, in the order above, with the default's actual value from the table as the first answer. Build `process` as in buildkeel.yaml's process section from what the user said or confirmed, nothing else. An added stage or kind needs a prefix: propose one, such as `FEAT` for feature, and say it is a suggestion they can change. When the user names a stage the default process does not have, ask whether it is a stage of its own, between two stages, or a kind of work beside one, such as features beside user stories, before you settle stages: a list of stage names in order does not say which. Name anything the process cannot express, such as a stage after the code is built, with the closest setting it has, such as the done gate's checks; never drop it silently, and never invent a setting. After each answer, call `manage` again without `apply`, with the same values as before, the `process` so far and every topic settled in `settled`: it lists the topics left.

When no topic is left, call `manage` again without `apply` and show the whole table it returns, as it is, with its line on what each stage or kind the team added means, and ask whether to go ahead with it. Never ask about a table the user has not seen. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. The answers: go ahead with this process (the default); change something, which you take in, then call `manage` again and show the whole table again, in the same layout; or stop, and write nothing.

**Templates.** Once the user agrees the table, settle a template for each one the list says the process needs, one at a time, in the order listed. For each, ask: **Claude drafts it** (the default) or **I'll provide a file**. Nothing is left for later: if the user asks to leave one, say that the tree needs it to check what is drafted from it, and ask again with the same two answers.

- **Claude drafts it**: call `get_template` for the closest built-in type: `story` for a kind at the user story stage, `epic` for a stage between the epic and the user story or a kind at one, `idea` for a kind at the business idea stage, `task` for a kind at the task stage, `design` for a document of the team's own. Change its `template:` line to the new type, and its description and sections to what the user said about it. Show it in full, and ask whether to use it or change something. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool.
- **I'll provide a file**: read the file the user names with your own tools, and pass its text. When `manage` says it fails the template check, show what is wrong, and ask: **Claude fixes it** (the default) or **Use another file**. Show a fixed template in full, and ask whether to use it. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool.

Pass each agreed template in `templates`, by type, and call `manage` again without `apply`: it checks each one. Nothing is written until every template the list names is given and passes.

## 6. Numbering, for a new Spec-driven spec tree

Topics for this step: **numbering**, how the tree's IDs read.

Work from the topics listed for this step. The user may answer in their own words, several topics at once or part of one. After each answer, say which topics it settled, with what you understood for each, and which are left; then ask the next one left, one topic per message. Where a topic has a default, list keeping it first, naming its actual value, and give examples where they help. Anything you work out that the user did not say is a proposal: ask it as that topic's question, with it as the default, and never use it without the user's answer. Ask about an unclear answer; name a conflicting one beside the earlier answer and ask which holds. Never guess. When every topic is settled, show all of it, as a review.

The list shows the tree's IDs, each with an example: changes, capability codes, requirements, scenarios, defects and ad-hoc units. Show them as they are, then ask in plain text whether to keep them (the default) or change them, with examples of other numbering, such as `RFC-0012` or `PROJ-12` for changes, or `AUTH-REQ1` for requirements. A change of change, defect or ad-hoc prefix or digits goes in `process`, such as `{ change: { prefix: RFC, width: 4 } }`; a change of the letters in requirement or scenario IDs goes in `markers`. Call `manage` again without `apply` with them, show the IDs it returns, and ask the user to confirm them. Pass `settled: ["numbering"]` once they keep or confirm the numbering.

## 7. Confirm and set up

Show the last list `manage` returned in full and ask whether to set up with it, change something or stop. An existing spec tree keeps its own process and numbering: just ask the user to confirm the list. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool.

Only when the user confirms, call `manage` again with the same values (the same `process`, `settled`, `templates` and `markers`, when there are any) and `apply: true`. Show the result as it is, including any lines the user must add to their hook manager, and, for a new spec repository, that it needs a remote and a push before others can use it.

## 8. The guide

For a Spec-driven tree, new or existing, the result asks it. Ask **Guide me through my first change** (the default) or **Jump right in**, and record the answer with `manage`, `action: "guide"`, `guide: "on"` or `"off"`.

Do not create or edit any BuildKeel files yourself; the `manage` tool does all of it. If `manage` reports a problem, show it with its fix and ask how to continue.
