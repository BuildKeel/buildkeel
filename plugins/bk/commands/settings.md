---
description: "BuildKeel: Show how this repository is set up: the mode, where the spec tree lives, the process and its gates, or the numbering, and each template with where it comes from. Changes nothing."
---

Call the BuildKeel `query` tool with `view: "settings"`.

Show the user the result as it is, in your reply as normal text, with its table: do not summarize or reorder it.

If the result says this repository is not set up for BuildKeel, tell the user how to set it up with /bk:init, and stop.

Then offer, in plain text at the end of that reply, to show any one template in full, with an example from the list, such as the story or defect template. When the user names one, call `get_template` with its type and show it as it is.

The settings are read here, never changed: they live in `buildkeel.yaml` and `templates/` in the spec tree. If the user wants to change one, say which file holds it, and that the change is made there and committed with the spec tree.
