# BuildKeel for Claude Code and Antigravity

BuildKeel keeps your specs, tests and code connected, and gives your coding agent that picture before it writes anything. It works in one of two modes, chosen for each spec tree:

- **Spec-driven**: capability specs say how your system behaves, and each piece of work is a change to them, with a proposal, spec changes, a design when needed, and tasks. Nothing waits for an approval.
- **Full SDLC**: your team's chain from business idea down, through epics, user stories and tasks, with approvals and gates.

Start Spec-driven and move to Full SDLC when your team needs approvals and gates; the move keeps your tests, linked code and history.

## Install

You need Node.js 20 or later, and git.

**Claude Code:** run these in Claude Code.

```
/plugin marketplace add BuildKeel/buildkeel
/plugin install bk@buildkeel
```

**Antigravity:** run this in a terminal, then quit Antigravity and open it again.

```sh
npx buildkeel install
```

For installing in one project only, updating and removing, see [Install in Claude Code](docs/install-claude-code.md) and [Install in Antigravity](docs/install-antigravity.md).

## What it does

- **Gives the agent the full "why".** Start a change, or a task, and the agent receives what it is for, the requirements and scenarios or acceptance criteria it must meet, the tests that apply, and the code already written for it.
- **Turns a conversation into a plan.** Talk ideas through as usual; when you are ready, the agent drafts a change (Spec-driven) or the epics, stories, test plans and tasks your process needs (Full SDLC), in your templates.
- **Builds what is ready.** After one confirmation, the agent works through the tasks, testing each, and stops when a test fails or a requirement is unclear.
- **Reviews before it finishes.** Finishing a change checks its code against its requirements, scenarios and design, reports what is missing, and gives each capability spec it touched its next version. In Full SDLC, work is not done until its tests pass.
- **Builds the audit trail for you.** Every commit is linked to its unit of work, and finishing records what was built, against which versions, verified by which tests.
- **Catches untested requirements.** Tests carry the IDs of the scenarios or test cases they check, so a requirement with no test is reported.
- **Shows what a change affects.** Change a requirement and see which tests, work and code are now in question.
- **Keeps work in order, when you want it.** In Full SDLC, the agent does not start on a story that is not approved, or one whose requirements changed after it was planned.
- **Leaves the conversation free.** BuildKeel steps in when you run one of its commands, ask for code to change, or ask to move work forward.
- **Works on code you already have.** Existing code is described as work touches it, or all at once when you choose, from the code and your existing tickets and pages, confirmed by people.

## How it works

Your specs live as structured files in git, next to your code. In a Spec-driven tree:

```
Capability specs ← Changes (proposal, spec changes, design, tasks) → Tests → Code
```

In a Full SDLC tree:

```
Business Idea → Epic → User Story → Task → Test cases → Code
```

One spec tree can serve many code repositories, or sit in a folder of a single repository.

The plugin needs no server and no account. It works with git and your coding agent, Claude Code or Antigravity, and nothing leaves your repositories.

## Commands

Commands are shown in Claude Code's form. In Antigravity, use a hyphen instead of a colon: `/bk-init`, `/bk-start` and so on.

| Command | What it does |
|---|---|
| `/bk:init` | Set up a spec tree, Spec-driven or Full SDLC, or point this repository at an existing one |
| `/bk:capture` | Turn what you discussed into a change, or the artifacts your process needs, drafted once you agree |
| `/bk:new` | Draft a change or an artifact, break a parent down, or record a bug |
| `/bk:onboard` | Document code from before BuildKeel, area by area, or move a Spec-driven tree to Full SDLC |
| `/bk:approve` | Full SDLC: validate and approve an artifact, or a whole plan in one review |
| `/bk:start` | Load the context for a change or a unit of work and begin |
| `/bk:build` | Build a change task by task, or every ready unit in turn |
| `/bk:adhoc` | Record a small change as an ad-hoc unit and start it |
| `/bk:done` | Review and archive a change, or check the tests and record what was built; close a bug that is not a defect |
| `/bk:status` | Show the tree, work in progress, coverage gaps, what is not pushed and what to do next |
| `/bk:impact` | Show what a change affects and resolve it |
| `/bk:stats` | Show your own usage, kept on your machine |
| `/bk:migrate` | Upgrade a spec tree to a newer format |

## Documentation

Start with [Getting started](docs/getting-started.md), and see [Spec-driven and Full SDLC](docs/modes.md) for the two modes. On a codebase that already exists, see [Documenting existing code](docs/onboarding.md). Every guide is listed in the [documentation index](docs/README.md). The website is [buildkeel.ai](https://buildkeel.ai).

## License

BuildKeel is free to use, in any organization and for any project. See [LICENSE](LICENSE). The open source components it includes are listed, with their licenses, in each package's `THIRD-PARTY-NOTICES`.
