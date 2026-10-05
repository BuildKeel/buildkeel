# Organization templates

When several teams use BuildKeel, a platform or process team can keep one set of templates and one process for all of them, in a repository of its own. Each team's spec tree points at it and pins a version, so a team's templates change only when the team decides to move to a new version.

Templates resolve in this order, the first match winning:

1. the spec tree's own `templates/` folder;
2. the organization's templates, at the version the spec tree pins;
3. BuildKeel's built-in templates.

The process resolves the same way: each setting in the spec tree's `buildkeel.yaml` wins over the organization's, and anything neither sets keeps its default.

## Set up the template repository

The repository holds a `templates/` folder with a template per type, in the same format as a spec tree's own (see [Process and templates](process-and-templates.md)), and optionally a `process.yaml` holding a process. Either can be left out, and `templates/` needs only the types the organization wants to standardize:

```text
buildkeel-templates/
  templates/
    story.md
    test-plan.md
    capability.md
  process.yaml
```

`process.yaml` has the same settings as the `process` section of `buildkeel.yaml`, at the top level:

```yaml
chain:
  - type: idea
  - type: epic
  - type: capability
    prefix: CAP
    width: 2
    dir: capabilities
  - type: story
  - type: task
gates:
  start: block
  done: block
```

Each release is a git tag. Commit the templates, then tag and push the release:

```sh
git add templates process.yaml
git commit -m "BuildKeel templates v1.0.0"
git tag v1.0.0
git push origin main v1.0.0
```

## Point a spec tree at it

In the spec tree's `buildkeel.yaml`, name the repository and the tag:

```yaml
format: 1
templates:
  org:
    source: git@github.com:acme/buildkeel-templates.git
    version: v1.0.0
```

`source` is any git remote the team can fetch, or a path, which is taken from the spec tree's root. Commit the change, so that the whole team moves to the organization's templates together.

The first time BuildKeel works in the project on a machine, it fetches that tag once and keeps a copy under `~/.buildkeel/org-templates/`. After that, nothing is fetched again for that version, and everything works offline. If the tag cannot be fetched (no connection, no access, a mistyped source), validation and `/bk:status` say why, and the types the spec tree does not override have no template until it is fetched: BuildKeel never quietly falls back to its built-in templates, since that would change what artifacts are checked against.

To see where each template comes from, ask the agent for a type's template (the `get_template` tool names its source), or run validation: it lists the templates and process settings the spec tree overrides.

## Pinned versions

The version is always a tag. Validation refuses an organization source without a version, a version such as `latest` or `main` that follows whatever is newest, and a version that is a branch rather than a tag.

When the organization publishes a new version, nothing changes for a team until it changes `version` in its `buildkeel.yaml`. A copy already fetched is kept, even if the organization moves the tag later.

## Override locally

A team can still differ where it needs to:

- a template in the spec tree's `templates/` folder replaces the organization's for that type;
- a setting in the `process` section of `buildkeel.yaml` replaces the organization's: the chain, `bug`, `adhoc`, or one gate's mode.

Validation lists each local override, so the difference from the organization stays visible:

```text
Templates and process come from the organization's templates git@github.com:acme/buildkeel-templates.git@v1.0.0. Overridden locally:
- the story template: templates/story.md overrides the organization's
- the start gate: warn in buildkeel.yaml overrides the organization's block
```

## Move to a new version

Change `version` in `buildkeel.yaml` and commit it. Moving to a new version never changes what is already approved: each approval records the template and the organization version it was checked against, and stays valid. Validation then lists the approved artifacts that do not follow the new templates under "Approved under earlier rules", with what each lacks, and `/bk:status` counts them. Each is checked against the new templates when its next version is approved.
