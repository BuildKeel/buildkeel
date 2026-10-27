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

If the user chooses to move it, call `manage` with `action: "convert"` and `convert: "start"`, without `apply`, and follow what it says: it refuses while any change is open, naming each with its title, and otherwise shows the process the tree will follow. Show it in your reply and ask the user to confirm, or to adjust the stages first. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Only once they confirm, call it again with `apply: true`.

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

The user can stop after any area: the next /bk:migrate carries on from there. While the conversion is in progress no change can be opened, and bugs and ad-hoc units work as usual. Before any area is approved, the conversion can be cancelled with `manage`, `action: "convert"` and `convert: "cancel"`, after the user confirms.

Do not change spec tree files yourself; the BuildKeel tools do all of it.
