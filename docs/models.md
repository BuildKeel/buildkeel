# Models and effort per role

Each agent BuildKeel starts plays one of ten roles, and every role uses your session's model and effort until you give it a tier. This page shows how to set a model and effort for a role, how tiers work, and what Antigravity does with them.

## Before you start

You need a repository where `/bk:init` has been run. Roles and tiers are settings in the `process` section of the spec tree's `buildkeel.yaml`, in either mode, committed with the tree so the whole team uses them. See [Change your configuration](configuration.md#4-turn-a-feature-switch-on-or-off).

## 1. See how each role runs now

1. Run `/bk:settings`.
2. Read the "Agents" part. It shows each role as it runs on your host, and how Claude starts each agent. In Claude Code:

   ```text title="/bk:settings"
   Agents, as they run in Claude Code:
   - The implementer: the principal tier: opus at high effort.
   - The spec reviewer, after each task: the standard tier: sonnet at medium effort.
   - The quality reviewer, after each task: the standard tier: sonnet at medium effort.
   - The final spec reviewer, at finish: inherits the session's model and effort.
   - The final quality reviewer, at finish: inherits the session's model and effort.
   - Break-it: inherits the session's model and effort.
   - The readiness readers: inherits the session's model and effort.
   - Edge-case suggestions: inherits the session's model and effort.
   - The designers: inherits the session's model and effort.
   - The note checker: inherits the session's model and effort.
   - Principal handoff's round: the principal tier: opus at high effort.
   ```

   An example, with three roles given a tier. Yours shows your own.

## 2. Give a role a tier

Spend more model where judgment matters, such as on the reviewers, by naming a tier for a role.

1. Open `buildkeel.yaml` at the root of the spec tree.
2. Under `process`, add `agents.roles`, naming a tier for each role you want to change:

   ```yaml
   process:
     agents:
       roles: { implementer: principal, spec-reviewer: standard, quality-reviewer: standard }
       handoff: { tier: principal, after: 2 }
   ```

3. Run `/bk:settings` again to check each role. A role that names a tier that does not exist is reported by validation, and runs on the session's model and effort.
4. Commit the change with the spec tree.

## 3. Change a tier or add your own

Two tiers are ready to use:

- **standard**: Sonnet at medium effort in Claude Code, `flash` in Antigravity;
- **principal**: Opus at high effort in Claude Code, the conversation's model in Antigravity.

1. Under `process`, add `agents.tiers`, with a model and an effort for each host. Either can be `inherit`:

   ```yaml
   process:
     agents:
       tiers:
         careful: { claude-code: { model: opus, effort: max }, antigravity: { model: pro } }
       roles: { implementer: principal, final-spec-reviewer: careful }
       handoff: { tier: careful, after: 2 }
   ```

2. Name the tier for a role, or for Principal handoff.
3. Run `/bk:settings` to check, and commit the change.

A tier name is lower-case letters, digits and hyphens. In Claude Code, an effort is `inherit` or one of `low`, `medium`, `high`, `xhigh` and `max`; validation reports any other. Giving a built-in tier's name changes that tier: what you leave out keeps its built-in value.

## 4. Set Principal handoff

Principal handoff is the tier for one more round of fixes when the fix rounds do not clear a review's finding (see [Reviews and the fix loop](reviews.md)).

1. Set `agents.handoff` under `process`: `tier` is the tier, and `after` the number of failed fix rounds before it, 1 or more.
2. To turn it off, set `tier: none`: the run then stops and asks you after the fix rounds.

By default it is the principal tier after 2 rounds.

## The ten roles

| Role | Setting key | What it does, and when | Default |
|---|---|---|---|
| The implementer | `implementer` | builds each task | `inherit` |
| The spec reviewer | `spec-reviewer` | after each task | `inherit` |
| The quality reviewer | `quality-reviewer` | after each task | `inherit` |
| The final spec reviewer | `final-spec-reviewer` | at finish | `inherit` |
| The final quality reviewer | `final-quality-reviewer` | at finish | `inherit` |
| Break-it | `break-it` | writes tests that try to break the code, in `/bk:build`, `/bk:done` and `/bk:review` | `inherit` |
| The readiness readers | `readiness-readers` | the readiness check | `inherit` |
| Edge-case suggestions | `edge-cases` | when a test plan or scenarios are drafted | `inherit` |
| The designers | `designers` | design options, in `/bk:capture` | `inherit` |
| The note checker | `note-checker` | checks each drafted working note against its source, at checkpoints and pauses | `inherit` |

`inherit` is your session's model and effort.

## In Antigravity

Antigravity sets an agent's model only in the agent's own definition, and has no effort setting for agents. So BuildKeel ships two of each agent there, one on the conversation's model and one on `flash`, and Claude starts the one the role's tier names. An effort is ignored there, and a tier that names a model other than `flash` runs on the conversation's model. `/bk:settings` says so:

```text title="/bk-settings"
Agents, as they run in Antigravity:
- The implementer: the principal tier: the conversation's model.
- The spec reviewer, after each task: the standard tier: flash.
```

When agents cannot be started at all, Claude does the work here, says so, and labels the result: see [Build](working-on-a-unit.md).

**More:** [Feature switches](settings.md), [Reviews and the fix loop](reviews.md), [Build](working-on-a-unit.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-settings`.
