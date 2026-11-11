# Install

This page installs BuildKeel in Claude Code or in Antigravity, checks that it works, and shows how to update or remove it. Install it one way, then set up your repository with [Your first change](getting-started.md).

## Before you start

You need three things on your machine.

- **Claude Code or Antigravity.**
- **Node.js 20 or later.** It comes with `npx`, which the Antigravity install uses. Check with `node --version`. If it is missing or older, install it from [nodejs.org](https://nodejs.org) or with your version manager (for example `nvm install 20`). BuildKeel tells you if it cannot find a suitable Node.js.
- **git.**

## 1. Install in Claude Code

You install BuildKeel from its marketplace, the public repository each version of BuildKeel is published to.

1. Open Claude Code.
2. Add BuildKeel's marketplace:

   ```
   /plugin marketplace add BuildKeel/buildkeel
   ```

3. Install BuildKeel from it:

   ```
   /plugin install bk@buildkeel
   ```

4. Choose where to install it when Claude Code asks:
   - **For you**, in every project on this machine.
   - **For everyone working in this repository.** Claude Code records it in the repository's `.claude/settings.json`. Commit that file so the people working in the repository get BuildKeel too.
   - **For you, in this repository only.**
5. If Claude Code says to run `/reload-plugins`, run it, or start a new session.

## 2. Install in Antigravity

This installs BuildKeel for every project you open in Antigravity.

1. In a terminal, run:

   ```sh
   npx buildkeel install
   ```

   This puts BuildKeel in `~/.gemini/config/plugins/buildkeel/`.
2. Quit Antigravity if it is running.
3. Open Antigravity again with your project.
4. Start a new conversation.

Antigravity starts BuildKeel's server once and keeps it running until you quit, for all its windows. Reloading a window is not enough.

> **Install it one way, not both.** An install for every project and an install for one project both bring a server named `buildkeel`, and Antigravity runs only one of them.

## 3. Install for one project only

In Claude Code, choose **For everyone working in this repository** or **For you, in this repository only** in [step 4 of the Claude Code install](#1-install-in-claude-code). In Antigravity, you install into the project's folder.

1. In a terminal, run:

   ```sh
   npx buildkeel install --workspace /path/to/your/project
   ```

   This puts BuildKeel in `.agents/plugins/buildkeel/` inside that project. It also adds that folder to the repository's local ignore file (`.git/info/exclude`), so the folder is never committed and never shows as a change.
2. Quit Antigravity if it is running, open it again with your project, and start a new conversation.

## 4. Install without npm

Each release on [BuildKeel's releases page](https://github.com/BuildKeel/buildkeel/releases) carries the Antigravity package as an archive, `buildkeel-antigravity-<version>.zip`.

1. Download the archive.
2. Unzip it.
3. In the folder it makes, run this to install for every project:

   ```sh
   node install.mjs
   ```

   Or run `node install.mjs --workspace /path/to/your/project` to install for one project.
4. Quit and reopen Antigravity, then start a new conversation.

To update, do the same with a newer release's archive. To remove it, run `node install.mjs --remove`, with `--workspace /path/to/your/project` for a project install.

## 5. Check that it works

Run two checks in a new session or conversation.

### In Claude Code

1. Run `/mcp`. The `buildkeel` server is listed as connected.
2. Run `/bk:status`. In a project that is not set up yet, it tells you how to set one up. In a project that is, it shows your spec tree.

BuildKeel's commands are all named `/bk:<command>`. In the command menu they are listed by their short name, such as `status`, with descriptions starting with "BuildKeel:", so type `buildkeel` to see them all. Claude Code has its own `/status`; BuildKeel's is `/bk:status`.

In the command menu, press **Tab** to put a command in the prompt and type its input, such as `/bk:approve US-001`, then press Enter. Pressing **Enter** in the menu runs the command at once; a command that takes input then asks what you want.

### In Antigravity

1. Open a new conversation in the agent panel.
2. Run `/bk-status`. In a project that is not set up yet, it tells you how to set one up. In a project that is, it shows your spec tree.
3. Ask "Which BuildKeel tools do you have?". The agent lists twelve, from `get_context` to `resolve_suspect`.

BuildKeel's server comes with the plugin, so it is not shown under **Additional options (…) > MCP Servers**, which lists the servers you added yourself.

BuildKeel's commands are all named `/bk-<command>`, such as `/bk-init` and `/bk-build`. Type `/bk` in the agent panel to see them all. A command that takes input, such as `/bk-approve`, asks what you want when you run it on its own. You can also type the input after it, such as `/bk-approve US-001`.

## 6. Update or remove it

Update BuildKeel the way you installed it.

### In Claude Code

Claude Code updates BuildKeel on its own only if you turn that on.

1. To turn on updates, run `/plugin`, open **Marketplaces**, select `buildkeel` and turn on auto-update.
2. To update by hand, run these in a terminal, then start a new session:

   ```sh
   claude plugin marketplace update buildkeel
   claude plugin update bk@buildkeel
   ```

3. To remove BuildKeel, run `claude plugin uninstall bk@buildkeel`. Add `--scope project` or `--scope local` if you installed it for a repository.
4. To remove its marketplace as well, run `claude plugin marketplace remove buildkeel`.

### In Antigravity

1. To update BuildKeel to the newest version, run this, then quit and reopen Antigravity:

   ```sh
   npx buildkeel@latest update
   ```

   `@latest` makes npx fetch the newest version rather than run one it has kept from before. For a project install, add `--workspace /path/to/your/project`.
2. To remove BuildKeel, run `npx buildkeel remove`, with `--workspace /path/to/your/project` for a project install.

> **After an update.** If BuildKeel says your spec tree uses an older format, run `/bk:migrate`. It upgrades the tree in one commit, and work in progress carries on. See [Move to Full SDLC, or upgrade a tree](migration.md).

## Details

What BuildKeel adds to your sessions, and what to do when something goes wrong.

### What it adds to a Claude Code session

- **Commands** starting with `/bk:`.
- **A local server**, started by Claude Code for the session and stopped with it. Claude reads and changes your spec tree through it. Nothing is sent anywhere.
- **Hooks** that run when a session starts and when Claude edits a file. They read a small file in `.buildkeel/` in your project and never use the network.

### What it adds to an Antigravity conversation

- **Commands** starting with `/bk-`.
- **A rule** that is always on. It tells the agent how to work in a project set up with BuildKeel: change the spec tree only through BuildKeel, add a `BuildKeel-Unit` line to every commit, and put test case IDs in test names.
- **A local server**, started by Antigravity and stopped with it. The agent reads and changes your spec tree through it. Nothing is sent anywhere.
- **Hooks** that run before each step of the agent and when it edits a file. They read small files in `.buildkeel/` in your project and never use the network. Antigravity has every hook that checks an edit approve or refuse it. So BuildKeel refuses edits to approved records, approves other edits inside the folders open in Antigravity and the agent's own working files, and leaves edits anywhere else for Antigravity to ask you about.

### If something goes wrong in Claude Code

- **"BuildKeel needs Node.js 20 or later"**: install Node.js as in [Before you start](#before-you-start), and start a new session.
- **The `buildkeel` server is not connected in `/mcp`**: check that `node --version` works in the terminal you start Claude Code from, then start a new session.

### If something goes wrong in Antigravity

- **"BuildKeel needs Node.js 20 or later"**: install Node.js as in [Before you start](#before-you-start), run the install command again, and quit and reopen Antigravity.
- **The first conversation after opening Antigravity says BuildKeel's tools are not available**: Antigravity starts BuildKeel's server when that conversation starts, and the conversation can begin before the server is ready. Start a new conversation. BuildKeel's tools are there from then on.
- **`/bk-status` is not listed, or the agent has no BuildKeel tools in a new conversation either**: check that `node --version` works in a terminal, run the install command again, and quit and reopen Antigravity.
- **BuildKeel works in the wrong project**: the agent passes the project's folder to every BuildKeel tool. If it did not, ask it to call the tool again with `workspace` set to your project's folder.
- **"… exists and is not a BuildKeel plugin; nothing was installed"**: another plugin already uses the folder `buildkeel` there. BuildKeel leaves it alone.

**More:** [Your first change](getting-started.md), [Troubleshooting](troubleshooting.md).

Commands are shown in Claude Code's form. In Antigravity, use a hyphen: `/bk-status`.
