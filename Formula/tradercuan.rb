# Rendered at each release from the formula template kept with tradercuan's sources
# (packaging/homebrew/tradercuan.rb.in), with that release's version and sha256
# values. Edit the template; a change made directly in the tap is overwritten.
class Tradercuan < Formula
  desc "Read brokers through macOS Accessibility and run the profile-scoped Trading Lab"
  homepage "https://github.com/lugassawan/homebrew-bengkel"
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/lugassawan/homebrew-bengkel/releases/download/tradercuan/v0.1.0/tradercuan_0.1.0_darwin_arm64.tar.gz"
      sha256 "cb27411d2997dcb7c2029b7853d7bc6522f1c0f96755eb975af7b6a19e35d6dd"
    end
    on_intel do
      url "https://github.com/lugassawan/homebrew-bengkel/releases/download/tradercuan/v0.1.0/tradercuan_0.1.0_darwin_amd64.tar.gz"
      sha256 "4e19a245f3ba5d73a666a16e7fc0abc7381e98bc9ea23e5c6c272a818fbcdf01"
    end
  end

  def install
    bin.install "tradercuan"
  end

  def caveats
    <<~EOS
      After brew upgrade tradercuan, restart the daemon and grant Accessibility again:

        tradercuan stop
        tradercuan start

      The daemon's launchd job records the versioned Cellar path, and macOS ties the
      Accessibility grant to the binary's signature, so each new version needs the
      grant in System Settings > Privacy & Security > Accessibility.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tradercuan version")
  end
end
