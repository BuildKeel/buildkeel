---
template: thread
version: 1
description: A paused exploration with no unit or change yet, saved so it can be resumed. It has no stages and no approval; it ends when it is captured or dropped.
fields:
  title: { required: true }
sections:
  Intent: { required: true }
  Approaches: { required: true }
  Decisions and constraints: { required: true }
  Dead ends and open questions: { required: true }
  Next: { required: true }
  The user's words: { required: true }
  Code read: { offered: "Pointers to the code that was read, one per line: the file, with the lines or names that mattered." }
  Spikes: { offered: "Each spike: its branch, or the files it left, and what it showed." }
  Notes: { offered: "Background, links, and anything that fits no other section." }
---

## Intent

<!-- What the user wants to achieve, and the idea as it stands. -->

## Approaches

<!-- The approaches discussed, and which way the discussion is leaning. "None weighed yet" when there were none. -->

## Decisions and constraints

<!-- What was settled, and the limits the work must respect. "None yet" when there are none. -->

## Dead ends and open questions

<!-- What was tried or ruled out, with why, and the questions still open. -->

## Next

<!-- The next thing to discuss when the thread is resumed. -->

## The user's words

<!-- The user's own statements that matter, quoted, kept apart from the agent's proposals. -->
