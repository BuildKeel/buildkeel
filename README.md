# BuildKeel for Claude Code and Antigravity

BuildKeel keeps your requirements, tests and code connected, from the business idea down to the commit, and gives your coding agent that full picture before it writes anything.

> **Early access.** Commands and behavior may change between 0.x releases. Your spec trees keep working across them: a change of format comes with `/bk:migrate`.

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

- **Gives the agent the full "why".** Start a task and the agent receives the task, its story and acceptance criteria, the epic, the business idea, the tests that apply, and the code already written for it.
- **Keeps work in order.** The agent will not start on a story that has not been approved, or one whose requirements changed after it was planned. Work is not done until its tests pass.
- **Builds the audit trail for you.** Every commit is linked to its unit of work automatically. Finishing a unit records what was built, against which requirements, verified by which tests.
- **Catches untested requirements.** Every test case declares what it covers, so an acceptance criterion with no test is flagged before the code is written.
- **Shows what a change affects.** Change a requirement and see which tests, tasks and code are now in question.
- **Leaves the conversation free.** Talk through ideas, options and architecture as usual. BuildKeel steps in when you run one of its commands, ask for code to change, or ask to move work forward.
- **Turns a conversation into a plan.** The agent sums up what you discussed and drafts the epics, design documents, stories, acceptance criteria, test cases and tasks your process needs, in your templates, for you to approve in one review.
- **Builds what is ready.** After one confirmation, the agent starts, builds, tests and finishes each ready unit in turn, stopping when a check fails or a requirement is unclear.
- **Works on code you already have.** Code from before BuildKeel is described as work touches it, or all at once when you choose: drafted from the code and your existing tickets and pages, read and approved by people, with its old commits and tests linked.

## How it works

Your plan lives as structured files in git, next to your code:

```
Business Idea → Epic → User Story → Task → Test cases → Code
```

One spec tree can serve many code repositories, or sit in a folder of a single repository.

The plugin needs no server and no account. It works with git and your coding agent, Claude Code or Antigravity, and nothing leaves your repositories.

## Commands

Commands are shown in Claude Code's form. In Antigravity, use a hyphen instead of a colon: `/bk-init`, `/bk-start` and so on.

| Command | What it does |
|---|---|
| `/bk:init` | Set up a spec tree and its process, or point this repository at an existing one |
| `/bk:capture` | Turn what you discussed into the artifacts your process needs, drafted once you agree |
| `/bk:new` | Draft an artifact, break a parent down into drafts, or record a bug |
| `/bk:onboard` | Document code from before BuildKeel, area by area, for people to review and approve |
| `/bk:approve` | Validate and approve an artifact, or a whole plan in one review |
| `/bk:start` | Load the context for a unit of work and begin |
| `/bk:build` | Start, build, test and finish every ready unit in turn |
| `/bk:adhoc` | Record a small change as an ad-hoc unit and start it |
| `/bk:done` | Check the tests and record what was built, for a unit or a whole story or epic |
| `/bk:status` | Show the tree, work in progress, coverage gaps, what is not pushed and what to do next |
| `/bk:impact` | Show what a change affects and resolve it |
| `/bk:stats` | Show your own usage, kept on your machine |
| `/bk:migrate` | Upgrade a spec tree to a newer format |

## Documentation

Start with [Getting started](docs/getting-started.md). On a codebase that already exists, see [Documenting existing code](docs/onboarding.md). Every guide is listed in the [documentation index](docs/README.md). The website is [buildkeel.ai](https://buildkeel.ai).

## License

BuildKeel is free to use, in any organization and for any project. See [LICENSE](LICENSE). The open source components it includes are listed, with their licenses, in each package's `THIRD-PARTY-NOTICES`.
