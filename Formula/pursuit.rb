class Pursuit < Formula
  desc "Job-application tracker with a CLI, HTTP API, and embedded dashboard"
  homepage "https://github.com/adrianmross/pursuit"
  # v0.0.0 and zero checksums are placeholders: bump-formulae.yml rewrites
  # them from the real assets once pursuit publishes its first release.
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.2.1/pursuit_0.2.1_darwin_arm64.tar.gz"
      sha256 "414db3ff4b9c81e70a360efe2d96b511ea04a084c607b478869a80bc89bc5c1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.2.1/pursuit_0.2.1_darwin_amd64.tar.gz"
      sha256 "1840c98f33f950bb4c6e969527f9def047c99a7fcb6dbeceb3060c8af26c05e9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.2.1/pursuit_0.2.1_linux_arm64.tar.gz"
      sha256 "e546ee12366cf6b9a35c101b603718b78de02853875ce2eca1e01fb30b61515d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.2.1/pursuit_0.2.1_linux_amd64.tar.gz"
      sha256 "ae06f66315697022cfd69913beee861068b0da91bacbe89c469073370795be2a"
    end
  end
  license "MIT"

  def install
    bin.install "pursuit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pursuit version")
  end
end
