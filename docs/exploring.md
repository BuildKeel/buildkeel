# Talk it through and explore

Most work starts as a conversation. This page shows how to think an idea through with Claude, ask for structure when you want it, and know when to stop and capture it.

## 1. Talk it through first

BuildKeel stays out of the conversation until you want structure.

1. Open Claude Code or Antigravity in your repository.
2. Talk the idea through as you would without BuildKeel: what it is for, the options, the design, the code it touches.
   Claude brings up no stages, IDs or commands. It mentions no BuildKeel structure until you signal the discussion has reached a point.
3. Let Claude check facts as you go.
   Claude is a thinking partner. It checks facts in the code and docs before asking you. For a design choice, it lays out two or three options with their trade-offs before it asks you to choose.
4. Keep to precise words.
   Claude holds the conversation to precise words, against the team's [glossary](glossary-practices-adrs.md) and the code.

## 2. Ask for structured exploring

When you want to weigh options properly, ask for it in words.

1. Say so, such as "let's work through this properly", or ask Claude to explore the idea.
2. Read what Claude plays back.
   It gives its understanding of the idea, with your words kept apart from what it proposes. Then it gives two or three approaches, each with its trade-offs, and a recommendation.
3. Correct anything it got wrong, or choose an approach and go on talking.

This structure is **Structured exploring**, a switch that is on by default. With `planning.exploring: off`, Claude still checks facts in the code and docs before asking, and otherwise talks as it would without BuildKeel. See [Feature switches](settings.md).

## 3. Decide what comes next

When you say you are done, Claude asks once whether to explore more or capture it.

1. To keep talking, say so.
2. To turn the conversation into a plan, run `/bk:capture`.
   Capture starts only when you run it. See [Capture a plan](capture.md).
3. To stop before planning, run `/bk:pause`.
   The conversation is kept as a thread, shown in full before it is saved. See [Working notes and threads](working-notes.md).

> **If you forget.** The next session in this repository offers once to recover an exploration left unsaved, from its transcript, which stays on your machine. See [Working notes and threads](working-notes.md).

## When to try it instead

Some questions are cheaper to answer by trying than by discussing, such as whether a provider's client is fast enough. Ask for a spike: throwaway work on a branch of its own, whose code is never kept as it is. See [Small fixes, defects and spikes](defects-and-adhoc.md).

**More:** [Capture a plan](capture.md), [Working notes and threads](working-notes.md), [Feature switches](settings.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-capture`.
