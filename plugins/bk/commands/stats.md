---
description: "BuildKeel: Show your own BuildKeel usage over a period: units finished, time to done, what the gates caught, suspects decided. Kept on this machine only."
argument-hint: "[days], e.g. 30; or off, on, delete or export to change the record"
---

Show the user their own use of BuildKeel in this spec tree, from the record kept on their machine. The record holds IDs, types, outcomes and times, never artifact text or code, and nothing is ever sent anywhere.

The user typed: $ARGUMENTS

## Choose the period

If the user typed a number of days, use it. If they typed off, on, delete or export, change the record as below.

If the user typed nothing, ask straight away, before calling any tool: "Which period?" Offer the choices with your tool for asking a question with choices, if you have one:

1. **The last 30 days** (the default, listed first).
2. **The last 7 days.**
3. **All of it.**
4. **Change the record:** turn recording off or on, delete it, or export it.

## Show it

Call the BuildKeel `query` tool with `view: "stats"` and `days` (leave `days` out for all of it). Show the result as it is: it opens with what the period comes to, then the details. In a Spec-driven tree it counts changes and what finishing them reported, in place of gate figures.

## Change the record

Only on the user's request, with the BuildKeel `manage` tool and `action: "usage"`:

- **Off:** `usage: "off"`. Nothing new is recorded; everything else works as before.
- **On:** `usage: "on"`.
- **Delete:** say that it deletes the record on this machine and cannot be undone, and ask for an explicit yes; then `usage: "delete"`.
- **Export:** ask where to write the file, suggesting `~/buildkeel-usage.jsonl`, then `usage: "export"` with that `path`.

Show the result as it is.
