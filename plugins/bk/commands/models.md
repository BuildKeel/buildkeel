---
description: "BuildKeel: Choose the model and effort for each of BuildKeel's agents on this host, from the models you can use: your own choice, kept on this machine. Roles your team set stay as the team set them."
disable-model-invocation: true
---

Call the BuildKeel `query` tool with `view: "models"`. If the result says this repository is not set up for BuildKeel, tell the user how to set it up with /bk:init, and stop. Otherwise show its "Now" list to the user as it is, in your reply as normal text, with the models to choose from.

Then ask about each group as the result says, one group per question, with your tool for asking a question with choices: the group's current choice first, then "Same as the previous group" (from the second group on), then each model the result lists, and "Each one separately", which asks that group's agents one by one. Skip a group whose agents the team set, and say in a line that the team set them. Then ask the effort for each group the same way, the current one first; on Antigravity there is none to ask.

When every group is answered, call `manage` with `action: "models"` and `models`, one entry for each agent whose choice changed (its `role`, or "handoff" for the Principal handoff round, its `model` and its `effort`), without `apply`. Show the table it returns. Show it in full in your reply, as normal text: the document, table or list itself. End the message with your question in plain text, and take the user's next message as the answer. Never put what you show inside your question tool. Only when the user agrees, call it again with `apply: true`, and show the result.

These are the user's own choices, in their own `~/.buildkeel/settings.yaml`, never committed. To set models for the whole team, the team changes `agents` in the spec tree's `buildkeel.yaml` instead: say so if the user asks.
