---
description: "BuildKeel: Set up BuildKeel in this repository, with a new spec tree or an existing one."
argument-hint: "[path of an existing spec tree]"
---

Set up BuildKeel in this repository using the BuildKeel `manage` tool with `action: "init"`. Ask the user one question at a time, each with your recommendation, and wait for the answer before asking the next.

The user typed: $ARGUMENTS

Ask each question with your tool for asking a question with choices, if you have one, with your recommendation as the first choice, so the user can pick it with Enter. If the user typed nothing above, ask the first question straight away, before calling any tool.

1. **Where the spec tree lives.** If the user gave a path above, use it as an existing spec tree and skip this question; if `manage` then reports there is no spec tree there, ask whether to create a new spec repository at that path instead. Otherwise ask:
   - **In this repository**, in a `specs/` folder. Recommend this when this is the team's only repository, or when trying BuildKeel out.
   - **An existing spec tree**, usually its own repository shared by several code repositories. Ask for its local path. If it is not cloned yet, tell the user to clone it first.
   - **A new spec repository**, a repository of its own that several code repositories will share. Ask for its folder, outside this repository, such as `../specs`: a folder that does not exist yet, an empty folder, or an empty repository the user has cloned. Use `location: "new-repo"` with that `path`.

2. **The mode**, for a new spec tree only (an existing tree keeps its own, and `manage` says which). Ask, with a line on each:
   - **Spec-driven** (the default, listed first): capability specs say how the system behaves, and each piece of work is a change to them, with no approvals or gates.
   - **Full SDLC**: work goes through the team's stages, from business idea down, with approvals and gates.

   Pass the choice as `mode` (`spec-driven` or `full-sdlc`) in every call to `manage` below.

3. **Stamping their own commits.** Explain: while a unit of work is active, BuildKeel adds a line `BuildKeel-Unit: <id>` to commits the agent makes. If they agree, a git hook adds the same line to commits they make themselves, for example in a terminal. It changes nothing when no unit is active. Recommend yes. If the repository already manages its git hooks with another tool, nothing is installed and BuildKeel shows the lines to add.

4. Call `manage` with `action: "init"`, the `location` (`this-repo`, `existing` or `new-repo`), the `path` if there is one, `stampCommits` and, for a new tree, `mode`, without `apply`. Show the user the list it returns, as it is.

5. **The process**, for a new Full SDLC spec tree. The list ends with the process as a table: each stage, and the documents it requires before work under it starts (by default a design document for an epic and a test plan for a story). Never ask about a table the user has not seen: ask, showing the table as it is. Put what you show in your call to the question tool, since what you write before it may not be shown: a table as the preview of each choice, where its columns are lined up, keeping each row to about 80 characters; anything else in the question itself, after a question of one sentence. The choices:
   - **Set up with this process** (the default, listed first).
   - **Adjust the process.** Ask what to change, one question at a time, with your recommendation: rename a stage (such as stories called "features"), add a stage between the business idea and the user story, change the documents a stage requires, or add a document of the team's own (it needs a template of its own later). Put the changes in a `process` object, as in buildkeel.yaml's process section, call `manage` again without `apply` with it, and show the new table. Repeat until the user agrees.
   - **Stop, and set up nothing.**

   A Spec-driven tree has no stages, and an existing spec tree keeps its own process: skip this question and ask the user to confirm the list.

6. Only when the user confirms, call `manage` again with the same values (and the same `process`, if they adjusted it) and `apply: true`. Show the result as it is, including any lines the user must add to their hook manager, and, for a new spec repository, that it needs a remote and a push before others can use it.

7. **The guide**, for a Spec-driven tree, new or existing: the result asks it. Ask **Guide me through my first change** (the default) or **Jump right in**, and record the answer with `manage`, `action: "guide"`, `guide: "on"` or `"off"`.

Do not create or edit any BuildKeel files yourself; the `manage` tool does all of it. If `manage` reports a problem, show it with its fix and ask how to continue.
