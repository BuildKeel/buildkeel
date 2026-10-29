# The two modes

BuildKeel works in one of two modes. Each spec tree follows one of them, chosen when the tree is created. To help you choose, see [Choosing a mode](comparing-modes.md).

- **Spec-driven.** Living specs of how the system behaves. Each piece of work is a change to them, with no approvals or gates.
  Change → Code and tests → Next spec versions
- **Full SDLC.** Your team's own stages, from business idea down, with approvals and gates.
  Business Idea → Epic → User Story → Task → Test cases → Code

| | Spec-driven | Full SDLC |
|---|---|---|
| What you plan with | Capability specs, and changes to them | Your process's stages: by default business ideas, epics, user stories and tasks, with test plans and design documents |
| Approvals | None: everything stays editable until a change is finished | Each artifact is approved, and its approved version is locked |
| Gates | Only the lock gate, which protects finished records | Approve, start, done and lock, each set to block, warn or off |
| Set by your team | Templates, rules for each artifact, ID prefixes | Stages, kinds within a stage, documents, which kinds a reported defect can belong to, templates, rules, ID prefixes and gates |
| Traceability | Versions, code links, tests, change impact, defects and ad-hoc work, reported and never blocking | The same, with gates that can stop work |

## Spec-driven

**Capability specs** describe how the system behaves now. Each has a purpose, then requirements, and each requirement has scenarios written as WHEN and THEN. Every capability has a short code, such as `AUTH`, and its requirements and scenarios have IDs from the moment they are written: `AUTH-R3`, `AUTH-R3-S1`.

`AUTH` capability › `AUTH-R3` requirement › `AUTH-R3-S1` scenario, WHEN … THEN …

A **change** holds one piece of work: a proposal saying why and what, spec changes adding, modifying or removing requirements, a design when the work needs one, and a list of tasks. While a change is open, every part of it can be edited, and Claude keeps the parts consistent with each other.

Finishing a change archives it. Its files are frozen as the record of what was done, its spec changes are merged, and each capability spec it touched gets its next version. If another change reached the same capability first, the overlap is shown to you rather than merged silently.

### The change is the unit of work

1. **Build:** `/bk:build CH-012` switches to the change's branch, loads its context, and Claude builds the change task by task.
2. **Finish:** `/bk:done CH-012` reviews the code against the change's requirements, scenarios and design, then archives it once you choose to finish.

Code links, test tracking, change impact, defects and ad-hoc units work as they do in Full SDLC, but they report and never block.

## Full SDLC

Full SDLC follows your team's chain of stages, from business idea down, with approvals and gates. Stages, documents, templates and gates are all yours to set. See [Process and templates](process-and-templates.md) and [Approving artifacts](approval.md).

## Setting the mode

`/bk:init` asks for the mode when it creates a new spec tree, with Spec-driven first. Press Enter to take it. When you point a repository at an existing spec tree, nothing is asked: the closing summary names the tree's mode. Each mode has a setup guide that explains every question setup asks next: [Setting up a Spec-driven tree](setting-up-spec-driven.md) and [Setting up a Full SDLC tree](setting-up-full-sdlc.md).

The mode is written to `buildkeel.yaml`:

```yaml title="buildkeel.yaml"
format: 3
mode: spec-driven
name: Accounts
repos:
  - name: accounts-api
```

> **Teammates on older versions.** A new tree of either mode uses format 3. A version of BuildKeel from before 0.5.0 opens it read-only and asks for an update, so everyone who works in the tree needs 0.5.0 or later.

A spec tree created before modes existed names no mode. It follows Full SDLC, exactly as before, with nothing to migrate.

## One mode per spec tree

Every code repository that points at a spec tree follows that tree's mode. The commands are the same in both modes and adapt to the tree: in a Spec-driven tree, `/bk:new` drafts a change, and `/bk:approve` explains that there is nothing to approve. See [Commands](commands.md).

A tree never holds the artifacts of both modes. Validation reports one that does not belong, such as a story in a Spec-driven tree:

```text title="Validation"
stories/US-001 is a user story, which does not belong in this spec tree: it is Spec-driven, so work is planned as changes to capability specs.
To fix: Plan the work as a change, then remove the directory. A spec tree follows one mode.
```

## Moving to Full SDLC

A Spec-driven tree can move to Full SDLC when your team needs approvals and gates. The move goes one way: a Full SDLC tree cannot become Spec-driven.

Run `/bk:migrate` once no change is open, and choose **Move this tree to Full SDLC**. Your process is set up first, with the same questions `/bk:init` asks for a new Full SDLC tree, and a template is settled for each stage, kind or document you add. Then your stages are drafted from the capability specs and archived changes, area by area, for you to review and approve, the same way onboarding documents existing code. Scenarios become test cases or acceptance criteria, as fits your stages, and each one's new place is recorded. While the move is under way:

- the tree is still Spec-driven: defects, ad-hoc units and looking up capability specs work as usual, but no new change can be opened;
- you can stop after any area, and the next `/bk:migrate` carries on;
- you can cancel the move until the first area is approved.

Once every area is converted, `/bk:migrate` switches the tree, in a commit of its own. Tests tagged with scenario IDs count for the test cases those scenarios became, code linked to changes stays linked, and each open defect keeps its ID under the artifact it affects. The capability specs and archived changes stay in the tree, read-only, as the history of how the system came to be. See [Moving a Spec-driven tree to Full SDLC](onboarding.md#moving-a-spec-driven-tree-to-full-sdlc).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-init`, `/bk-build`, `/bk-done`, `/bk-new`, `/bk-approve`, `/bk-migrate`.
