---
description: "BuildKeel: Upgrade a spec tree in an older format to the one this BuildKeel uses, in one commit, without touching approved versions."
disable-model-invocation: true
---

Upgrade the spec tree to the format this version of BuildKeel uses. A tree in an older format can be read but not changed until it is migrated.

Call the BuildKeel `manage` tool with `action: "migrate"`, without `apply`, and show the result as it is.

- If it says there is nothing to migrate, or that the plugin needs an update first, say so and stop.
- Otherwise it lists what changes: the working files and `buildkeel.yaml`, in one commit, with frozen versions and records left exactly as they are. Ask the user to confirm, with your tool for asking a question with choices: **Migrate** (the default) or **Not now**.

Only when the user confirms, call `manage` again with `action: "migrate"` and `apply: true`, and show the result as it is. Remind the user to push the spec repo, and that teammates need this version of BuildKeel, or a later one, to work in the tree.

Do not change spec tree files yourself; the `manage` tool does all of it.
