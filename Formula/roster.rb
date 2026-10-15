# Rendered at each release from the formula template kept with roster's sources
# (packaging/homebrew/roster.rb.in), with that release's version and sha256
# values. Edit the template; a change made directly in the tap is overwritten.
class Roster < Formula
  desc "Manage and launch coding-agent profiles"
  homepage "https://github.com/lugassawan/homebrew-bengkel"
  version "0.1.1"

  on_macos do
    on_arm do
      url "https://github.com/lugassawan/homebrew-bengkel/releases/download/roster/v0.1.1/roster_0.1.1_darwin_arm64.tar.gz"
      sha256 "c79e6f566576407322af9cb142fc2b08fc67956e57e4435f171bf3266f69f0d5"
    end
    on_intel do
      url "https://github.com/lugassawan/homebrew-bengkel/releases/download/roster/v0.1.1/roster_0.1.1_darwin_amd64.tar.gz"
      sha256 "d41ea2ae8c66c282374c39bb076771a8f437289079e4c922349f0190cf6fad0e"
    end
  end

  def install
    bin.install "roster"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/roster version")
  end
end
