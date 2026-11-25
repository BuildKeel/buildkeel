# Models and effort per role

Each agent BuildKeel starts plays one of ten roles. By default the implementer uses your session's model and effort, the two final reviewers and Principal handoff's round run on the principal tier, and every other role, each a check, runs on the standard tier. The defaults leave out each host's costliest and cheapest models. You can choose your own model for each role with `/bk:models`; a role your team sets in the spec tree is fixed for everyone. This page shows both, how tiers work, and what Antigravity and Pi do with them.

## Before you start

You need a repository where `/bk:init` has been run. There are two places a role's model can be set:

- **By you,** with `/bk:models`, in your own `~/.buildkeel/settings.yaml`, for each host you use. It is never committed.
- **By the team,** in the `process` section of the spec tree's `buildkeel.yaml`, in either mode, committed with the tree. A role the team sets is fixed for everyone: your own choice for it is ignored. See [Change your configuration](configuration.md#4-turn-a-feature-switch-on-or-off).

Where neither is set, the defaults apply.

## 1. Choose your own models

1. Run `/bk:models`. It lists the models you can use on this host: Fable, Opus, Sonnet and Haiku in Claude Code; the conversation's model, `pro` or `flash` in Antigravity; in Pi, the models your keys and subscriptions give you.
2. Answer for each group: the implementer, the reviewers after each task, the final reviewers, the planning agents, the note checker, and Principal handoff's round. The current choice comes first, then "Same as the previous group", so pressing Enter keeps going; "Each one separately" asks a group's agents one by one. Roles your team set are shown, not asked.
3. Answer the effort for each group the same way (Antigravity takes none).
4. Agree to the table it shows. It is saved to your own `~/.buildkeel/settings.yaml`:

   ```yaml
   agents:
     pi:
       spec-reviewer: { model: anthropic/claude-haiku-5-5, effort: low }
       quality-reviewer: { model: anthropic/claude-haiku-5-5, effort: low }
   ```

`/bk:init` offers the same step at its end, with keeping the defaults first; in Pi, choosing comes first, since no default model is right for everyone there. Choosing a different vendor for the reviewers than for the implementer gives you an independent check from a different model.

## 2. See how each role runs now

1. Run `/bk:settings`.
2. Read the "Agents" part. It shows each role as it runs on your host, and how Claude starts each agent. In Claude Code:

   ```text title="/bk:settings"
   Agents, as they run in Claude Code:
   - The implementer: the principal tier: opus at high effort, set by the team.
   - The spec reviewer, after each task: the standard tier: sonnet at medium effort.
   - The quality reviewer, after each task: the standard tier: sonnet at medium effort.
   - The final spec reviewer, at finish: inherits the session's model and effort, set by the team.
   - The final quality reviewer, at finish: inherits the session's model and effort, set by the team.
   - Break-it: the standard tier: sonnet at medium effort.
   - The readiness readers: the standard tier: sonnet at medium effort.
   - Edge-case suggestions: the standard tier: sonnet at medium effort.
   - The designers: the standard tier: sonnet at medium effort.
   - The note checker: the standard tier: sonnet at medium effort.
   - Principal handoff's round: the principal tier: opus at high effort, set by the team.
   ```

   An example of a team that gave the implementer the principal tier and its final reviewers the session's model. Yours shows your own.

## 3. Give a role a tier, for the team

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

## 4. Change a tier or add your own

Two tiers are ready to use:

- **standard**: Sonnet at medium effort in Claude Code, `flash` in Antigravity, the session's model at thinking `medium` in Pi;
- **principal**: Opus at high effort in Claude Code, the conversation's model in Antigravity, the session's model at thinking `high` in Pi.

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

## 5. Set Principal handoff

Principal handoff is the tier for one more round of fixes when the fix rounds do not clear a review's finding (see [Reviews and the fix loop](reviews.md)).

1. Set `agents.handoff` under `process`: `tier` is the tier, and `after` the number of failed fix rounds before it, 1 or more.
2. To turn it off, set `tier: none`: the run then stops and asks you after the fix rounds.

By default it is the principal tier after 2 rounds.

## The ten roles

| Role | Setting key | What it does, and when | Default |
|---|---|---|---|
| The implementer | `implementer` | builds each task | `inherit` |
| The spec reviewer | `spec-reviewer` | after each task | `standard` |
| The quality reviewer | `quality-reviewer` | after each task | `standard` |
| The final spec reviewer | `final-spec-reviewer` | at finish | `principal` |
| The final quality reviewer | `final-quality-reviewer` | at finish | `principal` |
| Break-it | `break-it` | writes tests that try to break the code, in `/bk:build`, `/bk:done` and `/bk:review` | `standard` |
| The readiness readers | `readiness-readers` | the readiness check | `standard` |
| Edge-case suggestions | `edge-cases` | when a test plan or scenarios are drafted | `standard` |
| The designers | `designers` | design options, in `/bk:capture` | `standard` |
| The note checker | `note-checker` | checks each drafted working note against its source, at checkpoints and pauses | `standard` |

`inherit` is your session's model and effort; `standard` is sonnet at medium effort in Claude Code, `flash` in Antigravity, and the session's model at thinking `medium` in Pi; `principal` is opus at high effort, the conversation's model, and the session's model at thinking `high`.

## In Antigravity

Antigravity sets an agent's model only in the agent's own definition, and that definition takes only the conversation's model, `pro` or `flash`: a Gemini model's name, such as `gemini-4-neon-high`, is refused. `pro` runs on Hydrogen at extra-high effort, and `flash` on Hydrogen at high effort. So BuildKeel ships three of each agent there, and the agent starts the one the role's tier names. Antigravity has no effort setting for agents, so an effort is ignored there, and a tier that names any other model runs on the conversation's model. `/bk:settings` says so:

```text title="/bk-settings"
Agents, as they run in Antigravity:
- The implementer: the principal tier: the conversation's model, set by the team.
- The spec reviewer, after each task: the standard tier: flash (Hydrogen at high effort).
```

## In Pi

Pi has no agents of its own, so BuildKeel brings a tool, `bk_agent`, that starts each of its agents as a separate Pi run, with only its role's tools. A tier's Pi entry names a model as `provider/model`, or `inherit`, and an effort as Pi's thinking level: `off`, `minimal`, `low`, `medium`, `high`, `xhigh` or `max`. Both tiers keep the session's model by default, since the models you have depend on your keys and subscriptions:

```yaml
process:
  agents:
    tiers:
      principal: { pi: { model: anthropic/claude-opus-5-5, effort: high } }
```

A model Pi does not have for you makes the agent's start fail with Pi's reason, and the step goes on as when agents cannot be started. `/bk-models` lists only the models Pi says you can use, and names any role your team fixed on a model you cannot.

When agents cannot be started at all, Claude does the work here, says so, and labels the result: see [Build](working-on-a-unit.md).

**More:** [Feature switches](settings.md), [Reviews and the fix loop](reviews.md), [Build](working-on-a-unit.md).

Commands are shown in Claude Code's form. In Antigravity and Pi, use a hyphen: `/bk-settings`.
