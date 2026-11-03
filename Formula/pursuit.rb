class Pursuit < Formula
  desc "Job-application tracker with a CLI, HTTP API, and embedded dashboard"
  homepage "https://github.com/adrianmross/pursuit"
  # v0.0.0 and zero checksums are placeholders: bump-formulae.yml rewrites
  # them from the real assets once pursuit publishes its first release.
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.3.1/pursuit_0.3.1_darwin_arm64.tar.gz"
      sha256 "4a6b4658ffecae92100ef3d5ea315b606b938eb6a2900047de0ca9d87f03cc28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.3.1/pursuit_0.3.1_darwin_amd64.tar.gz"
      sha256 "f097d197a1820fe9a297797dbb1f3c194e127a1961384adeb8de06c03b8d35b0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.3.1/pursuit_0.3.1_linux_arm64.tar.gz"
      sha256 "6a660f3001b69da61fc6b1011972589ebf888e89807178458b312670bf437c30"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.3.1/pursuit_0.3.1_linux_amd64.tar.gz"
      sha256 "34195d20480c24299f922cbe86d14bde6a27337458b963fd02fb5764fa2f9e00"
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
