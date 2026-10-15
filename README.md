# homebrew-bengkel

Release binaries, an installer and a Homebrew tap for the bengkel tools.

Their source is not public; this repository only distributes the releases.
Everything in it is written by the release workflow, so pull requests are not
accepted and issues are disabled.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/lugassawan/homebrew-bengkel/main/install.sh | sh -s -- roster
```

This installs the latest stable release of `roster` into `~/.local/bin` after
checking its sha256 against the release's `checksums.txt`. Pass a version to pin
one (`... | sh -s -- roster 0.2.0`), and set `BINDIR` to install elsewhere.

## Homebrew

```sh
brew install lugassawan/bengkel/roster
brew update && brew upgrade lugassawan/bengkel/roster
```

The formula appears with the first stable release published after this
repository was set up.

## Update

```sh
roster update
```

For an install made by Homebrew, `roster update` says which `brew` command to
run instead.
