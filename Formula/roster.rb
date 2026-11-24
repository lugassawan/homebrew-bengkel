# Rendered at each release from the formula template kept with roster's sources
# (packaging/homebrew/roster.rb.in), with that release's version and sha256
# values. Edit the template; a change made directly in the tap is overwritten.
class Roster < Formula
  desc "Manage and launch coding-agent profiles"
  homepage "https://github.com/lugassawan/homebrew-bengkel"
  version "0.3.0"

  on_macos do
    on_arm do
      url "https://github.com/lugassawan/homebrew-bengkel/releases/download/roster/v0.3.0/roster_0.3.0_darwin_arm64.tar.gz"
      sha256 "3de0930d9f24930be8ebfdbd99d8151e13a4b179bc1c5e710e205fa80196ae95"
    end
    on_intel do
      url "https://github.com/lugassawan/homebrew-bengkel/releases/download/roster/v0.3.0/roster_0.3.0_darwin_amd64.tar.gz"
      sha256 "f21bd8ae291ed62e9a5603e622fda108c03b9d935d9581cafb09c72478a6c0b0"
    end
  end

  def install
    bin.install "roster"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/roster version")
  end
end
