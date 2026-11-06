# Exploring and capturing

Most work starts as a conversation. BuildKeel stays out of it until you want structure: then `/bk:capture` turns what you discussed into a plan, and `/bk:pause` keeps an exploration you are not ready to plan.

## Exploring

While you explore, Claude is a thinking partner: it checks facts in the code and docs before asking, lays out two or three options with their trade-offs for a design choice, and keeps what you said apart from what it proposes. It holds the conversation to precise words, against the team's [glossary](glossary-practices-adrs.md#the-glossary) and the code. It mentions no BuildKeel structure until you signal the discussion has reached a point. When you ask for structure, such as "let's work through this properly", Claude plays back its understanding, keeping your words apart, and gives two or three approaches with a recommendation.

This structure is **Structured exploring**, on by default. With `planning.exploring: off`, Claude still checks facts in the code and docs before asking, and talks as it would without BuildKeel. See [Settings](settings.md#planning).

**Keeping an exploration.** When you stop before planning, `/bk:pause` keeps the conversation as a thread, shown in full before it is saved. This is **Threads**: `continuity.threads` is `ask` by default; `auto` saves the thread without asking, and `off` saves nothing. See [Settings](settings.md#continuity).

```text
A new thread "Reset by text message" would keep, in one commit in the spec repo, held by Ana on laptop:

## Intent
Let people reset their password by a code sent by text message, for those who cannot reach their email.

## Approaches
- A code by text message (leaning this way).
- A magic link by text message.

## Decisions and constraints
- Codes, not links.

## Dead ends and open questions
- Which provider sends the texts?

## Next
Compare two text message providers on cost.

## The user's words
- "codes must work on another device, so no magic links"

## Code read
- src/reset/endpoint.ts

Working notes:
- Decision: a code, not a magic link [the user said "codes must work on another device, so no magic links"]
```

See [Pausing and resuming](pausing-and-resuming.md) for threads, resuming them, and a teammate picking one up. Threads are in the spec tree, so the team can see them once it is pushed.

**When you forget.** The next session in this repository offers once to recover an exploration left unsaved, from its transcript, which stays on your machine:

```text
- The previous conversation in this repository on this machine (started 2026-11-02, 3 messages from the user) ended with no unit, and was not paused or captured. Offer once, in one line, to recover it as a thread with /bk:pause, built from its whole transcript at /home/you/other.jsonl, which stays on this machine. If the user declines or says nothing of it, do not offer again.
```

## Spikes

A spike is throwaway work to find something out, such as whether a provider's client does what you need. Claude starts one, with no unit active, on a branch of its own:

```text
Started the spike "SMS provider" on a new branch spike/sms-provider, from main: untracked, throwaway work. BuildKeel holds no edits here meanwhile, and its commits carry no BuildKeel-Unit line.
```

Ask for one in words, with a name and the question it should answer, such as "spike the SMS provider: can it send a code in under five seconds?". A spike needs no tests and no review; its commits carry no unit line, so on main they show as commits with no unit. Its code is never kept as it is: what it showed is built again in a unit, test first.

Ending it switches back, and offers what it showed as working notes, each with its source, for the thread or the conversation it came from. BuildKeel never merges a spike's branch:

```text
Ended the spike spike/sms-provider, and switched back to main. Its branch is left as it is: BuildKeel never merges it; keep it, delete it or take from it as the user decides.
```

`/bk:status` lists the spike branches still around, for you to keep, delete or take from. Spikes are on by default. With `planning.spikes: off`, starting one is refused, and spike branches from before are left as they are. See [Settings](settings.md#planning).

## Capturing

`/bk:capture` turns the conversation into a plan, with you agreeing at each step. The steps are in [Drafting with Claude](drafting.md); what follows is what it adds.

**The summary** says what you set out to do, the idea, the approaches weighed and the one chosen and why, the design choices, and the pitfalls raised, each settled or open. Each point is marked as what you said or what Claude proposed. When the session resumed a thread, the summary draws on the thread and the conversation since.

**Approaches are recorded.** The design document (Full SDLC) or the proposal (Spec-driven) gets an Approaches section from the conversation: the approaches considered, the one chosen and why, the non-goals and things to avoid. Nothing the conversation did not raise is added; when no other approach was weighed, it says so. A set with no such document keeps its approaches as working notes on its top new artifact.

**Edge-case suggestions.** When a story's test plan is drafted, or a change's scenarios, a fresh agent looks for the cases nobody has written, without asking by default (`planning.edge-cases: auto`; `ask` offers it in one line first, `off` leaves it out): boundaries, empty and invalid input, errors, permissions, concurrency, and state left from earlier runs. It proposes at most five, ranked by risk, each with the criterion it belongs to and a one-line reason, in the same review as the plan. You answer once, such as "add 1 and 3"; more found at lower risk are counted, to show if you ask. A case one of the team's practices already covers is not proposed.

**Design options.** Before the tasks are drafted, when three or more tasks would use one interface, or it crosses from one code repository to another, Claude offers once, in one line, design options for it (`planning.design-options: ask`, the default; `auto` runs them without asking, `off` leaves them out). When they run, fresh agents, 2 by default, each propose a design from a different angle; Claude compares how much each hides behind a small interface, where changes and defects would collect, and where the seams go, and recommends one. The chosen design and those set aside are recorded as approaches. You can ask for design options for any interface at any time.

**The readiness check.** Before capture closes, for larger work, a fresh agent reads the agreed set as the person who will build it, and lists its questions. By default Claude offers it in one line, saying why:

```text
Offer the readiness check in one line, as this is larger work: it has a design document.
```

Larger work is a set with a design document, more than one story (or capability changed), more than three tasks, an interface one task delivers and another uses, a library the project does not depend on yet, or files in more than one code repository. Small work is skipped, with a line saying you can ask: "run the readiness check". The team can set it to run without asking (`auto`), or turn it off, with `planning.readiness`, and add readers: `{ mode: ask, readers: 2 }` adds a tester, and 3 adds an operator. Its questions come in one round: those the set or the conversation already answers are shown as edits; minor ones Claude settles, labeled "my call"; yours are listed together, the most important first, then asked one at a time.

**When agents can't be started,** edge-case suggestions, design options and the readiness check follow the same rule as every agent: Claude says why once. With `ask`, its offer says the check would run here, without a fresh reader; with `auto`, it runs here and says so. What it finds is labeled as Claude's own reading, not an independent one. See [When agents can't be started](building-with-agents.md#when-agents-cant-be-started).

**The close.** After the readiness check come the gaps (pitfalls no artifact covers), then, when the capture started from a thread, the thread is closed with a link to what was saved. A Spec-driven change captured from a thread names it. In Full SDLC, capture then offers to approve the set; in a Spec-driven tree it names the change and offers to build it.
