# Rendered at each release from the formula template kept with rembuk's sources
# (packaging/homebrew/rembuk.rb.in), with that release's version and sha256
# values. Edit the template; a change made directly in the tap is overwritten.
class Rembuk < Formula
  desc "Voice-and-whiteboard practice sessions with coding agents"
  homepage "https://github.com/lugassawan/homebrew-bengkel"
  version "0.2.0"

  depends_on "whisper.cpp"

  on_macos do
    on_arm do
      url "https://github.com/lugassawan/homebrew-bengkel/releases/download/rembuk/v0.2.0/rembuk_0.2.0_darwin_arm64.tar.gz"
      sha256 "5e2fe99f520c763b221b6589d6d5cba2cf5dd1f1651f0cfe7bac43626061da70"
    end
    on_intel do
      url "https://github.com/lugassawan/homebrew-bengkel/releases/download/rembuk/v0.2.0/rembuk_0.2.0_darwin_amd64.tar.gz"
      sha256 "9c0fdc91d91afa33e3105ddf2de9d1077ed751438a808df069d62cb5a948fa2f"
    end
  end

  resource "ggml-base.en.bin" do
    url "https://huggingface.co/ggerganov/whisper.cpp/resolve/5359861c739e955e79d9a303bcbc70fb988958b1/ggml-base.en.bin"
    sha256 "a03779c86df3323075f5e796cb2ce5029f00ec8869eee3fdfb897afe36c6d002"
  end

  def install
    bin.install "rembuk"
    resource("ggml-base.en.bin").stage { pkgshare.install "ggml-base.en.bin" }
  end

  def caveats
    <<~EOS
      To let a Claude Code, Codex or Pi that you start yourself join a session, register rembuk with them:

        rembuk init

      To check that everything rembuk needs is in place:

        rembuk doctor
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rembuk version")
    assert_path_exists pkgshare/"ggml-base.en.bin"
  end
end
