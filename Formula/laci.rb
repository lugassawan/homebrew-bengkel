# Rendered at each release from the formula template kept with laci's sources
# (packaging/homebrew/laci.rb.in), with that release's version and sha256
# values. Edit the template; a change made directly in the tap is overwritten.
class Laci < Formula
  desc "Search and edit Google Drive, Docs, Sheets and Slides across several accounts"
  homepage "https://github.com/lugassawan/homebrew-bengkel"
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/lugassawan/homebrew-bengkel/releases/download/laci/v0.1.0/laci_0.1.0_darwin_arm64.tar.gz"
      sha256 "6cc998670b91effa0c45625d6ef7665c69e2665afaf7b512f2c1cdc2764856ec"
    end
    on_intel do
      url "https://github.com/lugassawan/homebrew-bengkel/releases/download/laci/v0.1.0/laci_0.1.0_darwin_amd64.tar.gz"
      sha256 "eb249954ea9dbe203ddea03cc384648fb7f8a77960c265a81ff781f281c23d0c"
    end
  end

  def install
    bin.install "laci"
  end

  def caveats
    <<~EOS
      laci init needs the Google Cloud CLI: brew install --cask gcloud-cli
      Then run: laci init
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/laci version")
  end
end
