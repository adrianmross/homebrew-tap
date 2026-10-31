class Pursuit < Formula
  desc "Job-application tracker with a CLI, HTTP API, and embedded dashboard"
  homepage "https://github.com/adrianmross/pursuit"
  # v0.0.0 and zero checksums are placeholders: bump-formulae.yml rewrites
  # them from the real assets once pursuit publishes its first release.
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.2.0/pursuit_0.2.0_darwin_arm64.tar.gz"
      sha256 "4a1a5d2cbe17ed8cd29bb1904bc9461860a5627ed1523f01afa56c0eced649f4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.2.0/pursuit_0.2.0_darwin_amd64.tar.gz"
      sha256 "6c4a7c8b59a00e0ff08992e80cfc2f21cf3c88aa53b51a1d0e60165f941d8b82"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.2.0/pursuit_0.2.0_linux_arm64.tar.gz"
      sha256 "bda76ba0e41de03cd1a228c3890d147016c67ebe7cd2ae9dac821a7801a75fa8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.2.0/pursuit_0.2.0_linux_amd64.tar.gz"
      sha256 "35e42c95d4807b960d3a55d1a0e18b8c0163d5ad284c44d2d486628807f3716e"
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
