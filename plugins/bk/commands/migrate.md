---
description: "BuildKeel: Move a Spec-driven tree to Full SDLC, area by area, or upgrade a spec tree in an older format, in one commit, without touching approved versions."
disable-model-invocation: true
---

Migrate the spec tree with the user: upgrade it to the format this version of BuildKeel uses when an update needs that, or move a Spec-driven tree to Full SDLC. Nothing is written without the user's confirmation.

## Upgrade the format first

Call the BuildKeel `manage` tool with `action: "migrate"`, without `apply`.

- If it says the plugin needs an update first, say so and stop.
- If it lists what changes (the working files and `buildkeel.yaml`, in one commit, with frozen versions and records left exactly as they are), show it as it is and ask, with your tool for asking a question with choices: **Migrate** (the default) or **Not now**. Only when the user confirms, call `manage` again with `action: "migrate"` and `apply: true`, and show the result as it is. Remind the user to push the spec repo, and that teammates need this version of BuildKeel, or a later one, to work in the tree. Then stop.
- If it says there is nothing to migrate, go on below.

## Move a Spec-driven tree to Full SDLC

If BuildKeel's session report, or `query` with `view: "process"`, says this spec tree follows Full SDLC, say that the tree is up to date and there is nothing to move, and stop.

In a Spec-driven tree, call `query` with `view: "onboarding"`. When it shows a conversion in progress, carry it on, as "Converting area by area" says. Otherwise, explain in a few lines what moving to Full SDLC means: work then goes through the team's stages, with approvals and gates, and the capability specs and archived changes are drafted into those stages, area by area, for the user to review and approve; the tree stays Spec-driven until every area is approved; and the move is one way. Then ask, with your tool for asking a question with choices: **Not now** (the default) or **Move this tree to Full SDLC**.

If the user chooses to move it, call `manage` with `action: "convert"` and `convert: "start"`, without `apply`. It refuses while any change is open, naming each with its title: show that, and stop. Otherwise it lists what starting the conversion does and the process the tree would follow, and the process is settled as for a new Full SDLC tree, before any area is drafted. Each call below is `manage` with `action: "convert"` and `convert: "start"`.

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

Once the process and its templates are settled and the user agrees to go ahead, call it again with the same `process`, `settled` and `templates`, and `apply: true`: the conversion starts, and the templates are written with it.

### Converting area by area

`query` with `view: "onboarding"` shows the conversion area by area.

1. **Map the areas.** Propose areas from the capability specs (`query`, `view: "capabilities"`), each holding one or more of them, as a table with what each covers. Ask the user to agree or change it, with the table in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Write the map with `manage`, `action: "map"`, `map: "set"` and each area's `capabilities`.
2. **For each area**, in the map's order, the next one as the default, with **Stop** as a choice:
   - **Its sources** are its capability specs and the archived changes that wrote them (`query`, `view: "changes"`), each change kept as a source with its ID as the key. Call `query` with `view: "process"` for the stages and the documents each requires, and `view: "tree"` for what exists.
   - **Propose** a table of the artifacts the area needs, top down, in the team's stage names: from the business idea down to the story, with the documents the process requires of each. Requirements become acceptance criteria and scenarios test cases, wherever they fit the stages; nothing maps one to one. Ask: **Draft them all** (the default), **Change the plan**, **Skip this area** or **Stop**, with the table in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool.
   - **Draft** top down, parents before children, each as version 0 with `save_draft` and `version: 0`, its sources in `sources`. Call `get_template` once for each type you draft. Add nothing the sources do not support; ask the user, one question at a time, about each required section nothing supports, with **Leave it empty** as a choice. A required document no source provides, such as a test plan, is drafted as version 1.
   - **Review and approve:** show what was drafted as a table: ID, title, version, the sources kept, and the sections left empty. Call `approve` with `ids` set to all of them and `onboard: true`, without `apply`, and ask whether to approve them, with the table and the result in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Call it again with `apply: true` only when the user confirms.
   - **Place the scenarios:** once the area is approved, show a table of each scenario and the criterion or test case it became, ask the user to agree it, and record it with `manage`, `action: "convert"`, `convert: "place"` and `place`. Leave a scenario out (`drop`) only when the user says so. A test tagged with a scenario counts for what that scenario became, so existing tests need no matching.
3. **Switch.** Once every area is converted, the view says so: call `manage` with `action: "convert"` and `convert: "finish"`, without `apply`, and ask the user to confirm the switch, with what it says in your reply. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Only when they confirm, call it again with `apply: true`, and show the result as it is.

The user can stop after any area: the next /bk:migrate carries on from there. While the conversion is in progress no change can be opened, and defects and ad-hoc units work as usual. Before any area is approved, the conversion can be cancelled with `manage`, `action: "convert"` and `convert: "cancel"`, after the user confirms.

Do not change spec tree files yourself; the BuildKeel tools do all of it.
