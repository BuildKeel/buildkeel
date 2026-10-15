---
description: "BuildKeel: Show the overview: the tree with each artifact's state, work in progress, claims, coverage gaps, unpushed approvals, commits with no unit, and what can be started next."
---

Call the BuildKeel `query` tool with `view: "status"`.

Show the user the result as it is, keeping its indentation, which shows the hierarchy. Do not summarize or reorder it. If it lists problems or files changed outside BuildKeel, show them with their fixes.

If it lists claims on this machine, end by saying that a claim can be released before its unit is finished. Release one only when the user asks for it: call the BuildKeel `manage` tool with `action: "release"` and the unit's `id`, and show the result.

If the result says this repository is not set up for BuildKeel, tell the user how to set it up with /bk:init.

In a Spec-driven tree, the result ends with an offer to review the active change. Ask, with your tool for asking a question with choices: **Review <ID> now** (the default) or **Not now**. To review, call `finish_work` without `apply`, review as its result says, and report your judgment; do not finish the change unless the user asks.
