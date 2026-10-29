# How Spec-driven mode works

A Spec-driven spec tree holds two things: **capability specs**, which say how the system behaves now, and **changes**, each saying how one piece of work changes it. Nothing is approved. Work is planned as a change, built task by task, and finished, and finishing writes the capability's next version.

This page follows one change from the conversation to that next version, with what BuildKeel shows at each step. Along the way: a defect found while building, behavior questioned while building, and reported problems sorted into defects and changes in behavior. For setting a tree up, see [Setting up a Spec-driven tree](setting-up-spec-driven.md); for the file formats, see [Capability specs](capability-specs.md) and [Changes](changes.md).

The examples come from a small accounts service with two capabilities: AUTH (signing in and resetting a password) and NOTIF (email).

## How the system behaves now

Ask Claude what the system does, or run `/bk:status`, and Claude looks the capability specs up first:

```
Capability specs (2), each at its version in force:
- AUTH "Authentication" v1: 2 requirements, 3 scenarios
- NOTIF "Notifications" v1: 1 requirement, 1 scenario
```

Each requirement has an ID, such as `AUTH-R2`, and each scenario under it extends that ID, such as `AUTH-R2-S1`. The version in force is the highest one: AUTH v1 here. A capability spec is never edited by hand. It changes only when a change is finished.

## 1. From a conversation to a change

You talk the work through with Claude: reset links that never expire are a risk, so links should expire, and the email should say when. When the discussion has reached a point, `/bk:capture` turns it into a change, `CH-002 "Reset links expire"`, with four files:

- **The proposal**: why, and what changes in a few lines.
- **A spec change for AUTH**: requirement `AUTH-R3 Reset link expires` added, with its scenario `AUTH-R3-S1`, and `AUTH-R2` modified so the email says when the link expires.
- **A design**: each link carries its issue time, signed, and the endpoint refuses links that are too old.
- **Tasks**, each with how it is verified, such as `1.2 Refuse links older than 30 minutes. Verify: the "Expired link" scenario test (AUTH-R3-S1).`

Claude shows each file in full before saving it, and saves only what you agree to. See [Drafting with Claude](drafting.md).

## 2. Building it

`/bk:build CH-002` starts the change on its own branch and loads its context:

```
- Created its branch bk/CH-002-reset-links-expire from main.
- Claimed on this machine: other working trees cannot start CH-002 until it is finished or released.
```

Claude builds the tasks in order. Each commit ends with `BuildKeel-Unit: CH-002`, and a commit that does exactly one task adds `BuildKeel-Task: 1.2`. Each test carries the scenario it checks in its name, such as `it("refuses an expired link [AUTH-R3-S1]")`.

### A defect found while building

While building task 1.2, Claude opens an expired link and sees a stack trace where a message should be. That is a defect of the work under way: the code does not do what was agreed. Recorded with `/bk:new defect`, it is linked to the change and to the scenario whose test found it, and gets its number at once:

```
Created defect DEF-002 "Expired link page shows a stack trace" at defects/DEF-002/defect.md, attached to CH-002, where AUTH-R3-S1 found it.
```

It needs no approval. It is fixed like any unit, with a regression test that names it, such as `[DEF-002]`.

### Behavior questioned while building

The code repository has a security policy: a reset link must expire within 15 minutes. The change says 30. Claude does not build something else, and does not edit the spec on its own: it stops, names `AUTH-R3` and the policy, and asks whether to keep the behavior as agreed or change it.

You say 15 minutes. `AUTH-R3` is a requirement this change adds, so it is edited in place, and Claude names the follow-on edits (the scenario's 31 minutes, task 1.2, the proposal and the design) and takes each through the review:

```
Replaced AUTH-R3 in the AUTH spec change of CH-002 "Reset links expire"; nothing else in it changed.
```

Had the behavior been a requirement of the version in force, one an earlier change wrote, the change would gain a spec change modifying it (the default), or you would open a separate change. Either way, the spec changes first and the code follows it. In code that nothing describes yet, the code is documented first, as version 0 of a capability spec, and changed on top of that.

### Ticking tasks

Once a task's verification passes, Claude ticks it and says so in a line, without asking:

```
Ticked 1.2, 2.1 in CH-002 "Reset links expire": 3 of 3 tasks done.
Every task of CH-002 "Reset links expire" is done: tell the user they can run /bk:done to finish it.
```

## 3. Finishing: the capability's next version

`/bk:done` shows what finishing will write: the requirements and scenarios after the merge, the code linked to the change, which scenarios pass, and anything to look at. Claude reviews the code against the requirements and the design, and you choose to finish or to fix something first. See [Finishing a unit](finishing-a-unit.md).

Finishing writes AUTH v2 and freezes the change as the record of the work:

```
Archived CH-002 "Reset links expire".
- Wrote AUTH v2 (capabilities/AUTH/versions/v2.md), naming CH-002.
```

AUTH v2 is now in force. It holds `AUTH-R3` as the change left it ("15 minutes after it is sent") and `AUTH-R2` as modified. AUTH v1 stays as it was, and every later change starts from v2.

## A defect, or a change in behavior?

The rule is the same in both modes:

- **A defect**: the code does not do what the spec says. The code is fixed and the spec keeps its version. For example, `AUTH-R3` says 15 minutes, and links expire after 3.
- **A change in behavior**: the code does what the spec says, and the spec is wrong, no longer wanted, or silent. The spec changes and gets a new version, through a change. For example, links expire after 15 minutes, as `AUTH-R3` says, and support now wants an hour.

When someone reports a problem, Claude checks it against the spec in force and the code linked to it before recording anything, and proposes one reading: a defect, a change in behavior, a gap (the spec says nothing about it), or code nothing describes yet. It labels the reading as its own, says what it rests on, and records nothing until you confirm or pick another.

### A reported defect that is really a change in behavior

A customer writes that reset links "expire too fast". Claude reads `AUTH-R3` (15 minutes) and the code (15 minutes): the code does what the spec says. Its reading is a change in behavior, and it proposes drafting a change that modifies `AUTH-R3`, not a defect. If you agree, `/bk:capture` drafts it. If a defect had been recorded and later turned out this way, it is closed without a fix as a change in behavior, naming the change that takes it over, such as `CH-003`.

### A reported defect

A customer on one mail provider gets no reset email. `AUTH-R2` says the system sends one to a registered address, and the code fails for that provider: a defect. A reported defect names the requirement it affects, pinned to the version in force:

```
Created defect DEF-004 "Reset email never arrives for some domains" at defects/DEF-004/defect.md, affecting AUTH-R2@v2.
```

Its context shows `AUTH-R2` as v2 states it, with its scenarios and the tests tagged with them. If a later change modifies `AUTH-R2` while the defect is open, the defect becomes suspect: Claude asks whether it still applies, and saves its file against the new version, or closes it. Finishing it leaves AUTH at its version: the code is fixed, the spec is not.

### A defect in code nothing describes

A customer reports that invoice totals round down. Claude asks BuildKeel what describes the billing code:

```
Nothing describes src/billing/invoice.ts in accounts-api yet: no artifact's scope covers it, and no unit's commits changed it.
```

Claude says so, and asks whether to **record it standalone** (the default) or **document this code first**, as version 0 of a capability spec, and link the defect to its requirement. Recorded standalone:

```
Created defect DEF-003 "Invoice totals round down" at defects/DEF-003/defect.md, standalone.
```

When a standalone defect is finished, BuildKeel looks at the files its fix changed, finds the requirements that archived changes built in them, and offers to link the defect to one.

## Where it all shows

`/bk:status` lists the capability specs, open and closed changes, and the defects, each with what it is linked to:

```
Defects: 4 open, 0 done.
- DEF-001 "Reset email lands in spam": standalone, reported
- DEF-002 "Expired link page shows a stack trace": in CH-002, found while building
- DEF-003 "Invoice totals round down": standalone, reported
- DEF-004 "Reset email never arrives for some domains": affects AUTH-R2@v2, reported
```

See [The status overview](status.md) and [Defects and ad-hoc units](defects-and-adhoc.md).
