# Install BuildKeel in Antigravity

## What you need

- **Antigravity**
- **Node.js 20 or later**, which comes with `npx`. Check with `node --version`. If it is missing or older, install it from [nodejs.org](https://nodejs.org) or with your version manager (for example `nvm install 20`). BuildKeel tells you if it cannot find a suitable Node.js.
- **git**

## Install

In a terminal, install BuildKeel for every project you open in Antigravity:

```sh
npx buildkeel install
```

This puts BuildKeel in `~/.gemini/config/plugins/buildkeel/`.

Or for one project only:

```sh
npx buildkeel install --workspace /path/to/your/project
```

This puts BuildKeel in `.agents/plugins/buildkeel/` inside that project, and adds that folder to the repository's local ignore file (`.git/info/exclude`), so it is never committed and never shows as a change.

Then quit Antigravity if it is running, open it again with your project, and start a new conversation. Antigravity starts BuildKeel's server once and keeps it running until you quit, for all its windows, so reloading a window is not enough.

Install BuildKeel one way or the other, not both: both installs bring a server named `buildkeel`, and Antigravity runs only one of them.

## Update or remove it

To update BuildKeel to the newest version, run this, then quit and reopen Antigravity:

```sh
npx buildkeel@latest update
```

`@latest` makes npx fetch the newest version rather than run one it has kept from before. For a project install, add `--workspace /path/to/your/project`.

To remove BuildKeel, run `npx buildkeel remove`, with `--workspace /path/to/your/project` for a project install.

## Install without npm

Each release on [BuildKeel's releases page](https://github.com/BuildKeel/buildkeel/releases) carries the Antigravity package as an archive, `buildkeel-antigravity-<version>.zip`. Download it, unzip it, and in the folder it makes run:

```sh
node install.mjs
```

for every project, or `node install.mjs --workspace /path/to/your/project` for one. To remove it, run `node install.mjs --remove`, with `--workspace /path/to/your/project` for a project install. To update, do the same with a newer release's archive.

## Check that it works

In a new conversation in the agent panel:

- Run `/bk-status`. In a project that is not set up yet, it tells you how to set one up. In a project that is, it shows your spec tree.
- Ask "Which BuildKeel tools do you have?". The agent lists ten, from `get_context` to `manage`. BuildKeel's server comes with the plugin, so it is not shown under **Additional options (…) > MCP Servers**, which lists the servers you added yourself.

BuildKeel's commands are all named `/bk-<command>`, such as `/bk-init` and `/bk-start`. Type `/bk` in the agent panel to see them all. A command that takes input, such as `/bk-approve`, asks what you want when you run it on its own; you can also type the input after it, such as `/bk-approve US-001`.

## What BuildKeel adds to a conversation

- **Commands** starting with `/bk-`.
- **A rule** that is always on, telling the agent how to work in a project set up with BuildKeel: change the spec tree only through BuildKeel, add a `BuildKeel-Unit` line to every commit, and put test case IDs in test names.
- **A local server**, started by Antigravity and stopped with it. The agent reads and changes your spec tree through it. Nothing is sent anywhere.
- **Hooks** that run before each step of the agent and when it edits a file. They read small files in `.buildkeel/` in your project and never use the network. Antigravity has every hook that checks an edit approve or refuse it, so BuildKeel refuses edits to approved records, approves other edits inside the folders open in Antigravity and the agent's own working files, and leaves edits anywhere else for Antigravity to ask you about.

## If something goes wrong

- **"BuildKeel needs Node.js 20 or later"**: install Node.js as above, run the install command again, and quit and reopen Antigravity.
- **The first conversation after opening Antigravity says BuildKeel's tools are not available**: Antigravity starts BuildKeel's server when that conversation starts, and the conversation can begin before the server is ready. Start a new conversation; BuildKeel's tools are there from then on.
- **`/bk-status` is not listed, or the agent has no BuildKeel tools in a new conversation either**: check that `node --version` works in a terminal, run the install command again, and quit and reopen Antigravity.
- **BuildKeel works in the wrong project**: the agent passes the project's folder to every BuildKeel tool. If it did not, ask it to call the tool again with `workspace` set to your project's folder.
- **"… exists and is not a BuildKeel plugin; nothing was installed"**: another plugin already uses the folder `buildkeel` there. BuildKeel leaves it alone.
