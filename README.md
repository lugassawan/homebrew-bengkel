# Bengkel: releases and Homebrew tap

Release binaries, an installer and a Homebrew tap for the bengkel tools.

Their source is not public; this repository only distributes the releases.
`README.md`, `install.sh` and `Formula/` are written by the release workflow, so
edit none of them here, and issues are disabled.

## Tools

| Tool | What it does | Homebrew |
|---|---|---|
| `roster` | Manage and launch coding-agent profiles | `brew install lugassawan/bengkel/roster` |
| `tradercuan` | Read brokers through macOS Accessibility and run the profile-scoped Trading Lab | `brew install lugassawan/bengkel/tradercuan` |

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/lugassawan/homebrew-bengkel/main/install.sh | sh -s -- <tool>
```

This installs the latest stable release of `<tool>` into `~/.local/bin` after
checking its sha256 against the release's `checksums.txt`. Pass a version to pin
one (`... | sh -s -- <tool> 0.2.0`), and set `BINDIR` to install elsewhere. It
works for any tool with a release, even one that is not on the tap yet.

## Homebrew

```sh
brew install lugassawan/bengkel/<tool>
brew update && brew upgrade lugassawan/bengkel/<tool>
```

Only a stable release reaches the tap. After an upgrade, run
`brew info lugassawan/bengkel/<tool>` to see any steps the tool asks for.

## Update

Re-run the installer to move to the latest release. `roster` can also update
itself:

```sh
roster update
```

For an install made by Homebrew, use `brew upgrade` as above; `roster update`
says so too.
