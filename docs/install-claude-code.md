# Install BuildKeel in Claude Code

## What you need

- **Claude Code**
- **Node.js 20 or later.** Check with `node --version`. If it is missing or older, install it from [nodejs.org](https://nodejs.org) or with your version manager (for example `nvm install 20`). BuildKeel tells you if it cannot find a suitable Node.js.
- **git**

## Install

Run these two commands in Claude Code:

```
/plugin marketplace add BuildKeel/buildkeel
/plugin install bk@buildkeel
```

The first adds BuildKeel's marketplace, the public repository each version of BuildKeel is published to. The second installs BuildKeel from it. Claude Code asks where to install it:

- **For you**, in every project on this machine.
- **For everyone working in this repository**: Claude Code records it in the repository's `.claude/settings.json`, which you commit so the people working in the repository get it too.
- **For you, in this repository only.**

If Claude Code says to run `/reload-plugins`, run it, or start a new session.

## Update or remove it

Claude Code updates BuildKeel on its own only if you turn that on: run `/plugin`, open **Marketplaces**, select `buildkeel` and turn on auto-update. To update by hand, run these in a terminal, then start a new session:

```sh
claude plugin marketplace update buildkeel
claude plugin update bk@buildkeel
```

To remove BuildKeel, run `claude plugin uninstall bk@buildkeel`, adding `--scope project` or `--scope local` if you installed it for a repository. To remove its marketplace as well, run `claude plugin marketplace remove buildkeel`.

## Check that it works

In the Claude Code session:

- Run `/mcp`. The `buildkeel` server is listed as connected.
- Run `/bk:status`. In a project that is not set up yet, it tells you how to set one up. In a project that is, it shows your spec tree.

BuildKeel's commands are all named `/bk:<command>`. In the command menu they are listed by their short name, such as `status`, with descriptions starting with "BuildKeel:", so type `buildkeel` to see them all. Claude Code has its own `/status`; BuildKeel's is `/bk:status`.

In the command menu, press **Tab** to put a command in the prompt and type its input, such as `/bk:approve US-001`, then press Enter. Pressing **Enter** in the menu runs the command at once; a command that takes input then asks what you want.

## What BuildKeel adds to a session

- **Commands** starting with `/bk:`.
- **A local server**, started by Claude Code for the session and stopped with it. Claude reads and changes your spec tree through it. Nothing is sent anywhere.
- **Hooks** that run when a session starts and when Claude edits a file. They read a small file in `.buildkeel/` in your project and never use the network.

## If something goes wrong

- **"BuildKeel needs Node.js 20 or later"**: install Node.js as above and start a new session.
- **The `buildkeel` server is not connected in `/mcp`**: check that `node --version` works in the terminal you start Claude Code from, then start a new session.
