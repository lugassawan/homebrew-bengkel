# Rendered at each release from the formula template kept with roster's sources
# (packaging/homebrew/roster.rb.in), with that release's version and sha256
# values. Edit the template; a change made directly in the tap is overwritten.
class Roster < Formula
  desc "Manage and launch coding-agent profiles"
  homepage "https://github.com/lugassawan/homebrew-bengkel"
  version "0.2.0"

  on_macos do
    on_arm do
      url "https://github.com/lugassawan/homebrew-bengkel/releases/download/roster/v0.2.0/roster_0.2.0_darwin_arm64.tar.gz"
      sha256 "fd25970e1244eedcd838755149c7991c9c59489ee3fbf5fdf7987f1d6dc82247"
    end
    on_intel do
      url "https://github.com/lugassawan/homebrew-bengkel/releases/download/roster/v0.2.0/roster_0.2.0_darwin_amd64.tar.gz"
      sha256 "2b2b58d6dbb5428593bae20abfa34a7a2a0dd2adcc78edc902fca80cd3dcdbfe"
    end
  end

  def install
    bin.install "roster"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/roster version")
  end
end
