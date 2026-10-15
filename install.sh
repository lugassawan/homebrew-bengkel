#!/bin/sh
# shellcheck shell=sh
# Install a bengkel tool from its public release mirror.
#
# Usage: install.sh <tool> [X.Y.Z]
#
#   curl -fsSL https://raw.githubusercontent.com/lugassawan/homebrew-bengkel/main/install.sh |
#     sh -s -- roster
#
# With no version, installs the latest stable release. A version installs that
# exact release, prereleases included. The tarball is checked against the
# release's checksums.txt before anything is written to BINDIR. The checksum is
# fetched from the same place as the tarball, so it catches a corrupt or
# truncated download, not a compromised mirror.
#
# Environment:
#   BINDIR        destination (default: $HOME/.local/bin)
#   BENGKEL_API   releases API base (tests point this at file:// fixtures)
#   BENGKEL_DL    release download base (same)
#
# This file is published as install.sh on the mirror's main branch by
# scripts/publish.sh. The body is one function, called last, so a truncated
# download defines a function and runs nothing.
set -eu

MIRROR=lugassawan/homebrew-bengkel
API=${BENGKEL_API:-https://api.github.com/repos/$MIRROR}
DL=${BENGKEL_DL:-https://github.com/$MIRROR/releases/download}

# https only, unless a test has pointed the base URLs at file:// fixtures.
PROTO='=https'
if [ -n "${BENGKEL_API:-}${BENGKEL_DL:-}" ]; then
  PROTO='=https,file'
fi

die() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

# fetch <url> [outfile]: stdout, or a file. Gives up on a connect that hangs or a
# transfer under 1 KB/s for 30s, so a `curl | sh` cannot stall silently.
fetch() {
  if [ $# -gt 1 ]; then
    curl -fsSL --proto "$PROTO" --retry 3 --connect-timeout 10 --speed-limit 1000 --speed-time 30 \
      -o "$2" "$1"
  else
    curl -fsSL --proto "$PROTO" --retry 3 --connect-timeout 10 --speed-limit 1000 --speed-time 30 "$1"
  fi
}

# latest_version <tool>: the highest stable X.Y.Z released for the tool. The
# pattern has no prerelease suffix, so rc builds never match, and the tool
# prefix keeps other tools sharing the mirror out. It reads the newest 100
# releases across every tool; a tool whose last stable release is older than
# that has to be pinned.
latest_version() {
  list=$(fetch "$API/releases?per_page=100") ||
    die "could not list releases at $API (rate limited? pass a version: install.sh $1 X.Y.Z)"
  found=$(printf '%s\n' "$list" | tr '{' ',' | tr ',' '\n' |
    sed -n "s|.*\"tag_name\": *\"$1/v\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\)\".*|\1|p" |
    sort -t. -k1,1n -k2,2n -k3,3n | tail -1)
  [ -n "$found" ] ||
    die "no stable release of $1 found (rate limited? pass a version: install.sh $1 X.Y.Z)"
  printf '%s\n' "$found"
}

# valid_tool <name>, valid_version <X.Y.Z[-pre]>: whole-string checks. grep
# alone matches per line, so a value with a good first line would pass.
valid_tool() {
  case $1 in
    '' | [!a-z]* | *[!a-z0-9]*) return 1 ;;
  esac
}

valid_version() {
  # The character set excludes a newline, so grep then sees a single line.
  case $1 in
    '' | *[!0-9A-Za-z.-]*) return 1 ;;
  esac
  printf '%s\n' "$1" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$'
}

main() {
  if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    printf 'usage: install.sh <tool> [X.Y.Z]\n' >&2
    exit 2
  fi
  tool=$1
  want=${2:-}
  want=${want#v}

  valid_tool "$tool" || {
    printf 'error: invalid tool name\n' >&2
    exit 2
  }
  if [ -n "$want" ]; then
    valid_version "$want" || {
      printf 'error: invalid version: expected X.Y.Z\n' >&2
      exit 2
    }
  fi

  [ "$(uname -s)" = Darwin ] || die "bengkel tools are macOS only"
  arch=$(uname -m)
  case "$arch" in
    arm64) ;;
    x86_64)
      # An x86_64 shell on Apple Silicon (Rosetta) still wants the native build.
      # sysctl lives in /usr/sbin, which a minimal PATH can lack; appended, so a
      # PATH that has it keeps its own.
      if [ "$(PATH="$PATH:/usr/sbin:/sbin" sysctl -n sysctl.proc_translated 2> /dev/null || echo 0)" = 1 ]; then
        arch=arm64
      else
        arch=amd64
      fi
      ;;
    *) die "unsupported architecture $arch" ;;
  esac

  for cmd in curl tar shasum install cmp; do
    command -v "$cmd" > /dev/null 2>&1 || die "$cmd is required"
  done

  dest=${BINDIR:-$HOME/.local/bin}
  { mkdir -p "$dest" && [ -w "$dest" ]; } 2> /dev/null ||
    die "$dest is not writable; set BINDIR to a directory you own"
  # Absolute, without a trailing slash, so the PATH and shadow checks below
  # compare spellings that can match.
  dest=$(cd "$dest" && pwd)
  tap=${MIRROR%%/*}/${MIRROR#*/homebrew-}

  # Homebrew's own link in BINDIR: replacing it would leave `brew upgrade` and
  # this installer fighting over one name.
  if [ -L "$dest/$tool" ]; then
    case "$(readlink "$dest/$tool" 2> /dev/null || true)" in
      */Cellar/"$tool"/*)
        die "$dest/$tool is Homebrew's link; update it with: brew update && brew upgrade $tap/$tool"
        ;;
    esac
  fi

  tmp=$(mktemp -d)
  staged=
  trap 'rm -rf "$tmp"; if [ -n "$staged" ]; then rm -f "$staged"; fi' EXIT

  if [ -z "$want" ]; then
    want=$(latest_version "$tool")
  fi

  asset=${tool}_${want}_darwin_${arch}.tar.gz
  base=$DL/$tool/v$want
  printf 'installing %s %s (darwin/%s)\n' "$tool" "$want" "$arch"

  fetch "$base/$asset" "$tmp/$asset" ||
    die "could not download $base/$asset (is $tool $want released?)"
  fetch "$base/checksums.txt" "$tmp/checksums.txt" ||
    die "could not download $base/checksums.txt"

  expected=$(awk -v f="$asset" '$2 == f { print $1; exit }' "$tmp/checksums.txt")
  [ -n "$expected" ] || die "checksums.txt has no entry for $asset"
  actual=$(shasum -a 256 "$tmp/$asset" | awk '{ print $1 }')
  [ "$expected" = "$actual" ] || die "checksum mismatch for $asset; nothing was installed"

  mkdir "$tmp/x"
  tar -xzf "$tmp/$asset" -C "$tmp/x" "$tool" || die "$asset does not contain $tool"
  { [ -f "$tmp/x/$tool" ] && [ ! -L "$tmp/x/$tool" ]; } ||
    die "$asset does not contain a regular file named $tool"

  # Same directory, then rename: an interrupted install never leaves a
  # half-written binary under the real name. The trap removes the temp name.
  staged=$dest/.$tool.new.$$
  install -m 0755 "$tmp/x/$tool" "$staged" || die "could not write to $dest"
  mv -f "$staged" "$dest/$tool" || die "could not replace $dest/$tool"
  staged=
  printf 'installed %s/%s\n' "$dest" "$tool"

  case ":$PATH:" in
    *":$dest:"*) ;;
    *) printf 'note: %s is not on your PATH\n' "$dest" ;;
  esac
  other=$(command -v "$tool" 2> /dev/null || true)
  if [ -n "$other" ] && [ "$other" != "$dest/$tool" ] && ! cmp -s "$other" "$dest/$tool"; then
    # Homebrew's bin/ entry is a link into this tool's keg in its Cellar, so
    # the link target says it.
    case "$other $(readlink "$other" 2> /dev/null || true)" in
      */Cellar/"$tool"/*)
        printf 'warning: %s is a Homebrew install and comes first on your PATH.\n' "$other" >&2
        printf '  Run "brew update && brew upgrade %s/%s" to update it, or "brew uninstall %s" to use this copy.\n' \
          "$tap" "$tool" "$tool" >&2
        ;;
      *)
        printf 'warning: %s comes first on your PATH and shadows the new install\n' "$other" >&2
        ;;
    esac
  fi

  # The install is done; a tool without a working `version` is not a failure.
  "$dest/$tool" version ||
    printf 'warning: installed %s, but "%s version" failed\n' "$dest/$tool" "$tool" >&2
}

main "$@"
