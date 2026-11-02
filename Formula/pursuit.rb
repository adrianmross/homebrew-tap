class Pursuit < Formula
  desc "Job-application tracker with a CLI, HTTP API, and embedded dashboard"
  homepage "https://github.com/adrianmross/pursuit"
  # v0.0.0 and zero checksums are placeholders: bump-formulae.yml rewrites
  # them from the real assets once pursuit publishes its first release.
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.3.0/pursuit_0.3.0_darwin_arm64.tar.gz"
      sha256 "f83b91fa9cc3d305882a8b94e98ee01420a9aa9a688d22757b2ba60fb60e5fef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.3.0/pursuit_0.3.0_darwin_amd64.tar.gz"
      sha256 "d3a47a36a3943e9d99c6429e0ecd93bec6205f6ce80d41d3e02dd934e46825b5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.3.0/pursuit_0.3.0_linux_arm64.tar.gz"
      sha256 "25d4f89113a3660dab283e60b93a68ee84c02833c12d9b775429aef70b9fbb85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.3.0/pursuit_0.3.0_linux_amd64.tar.gz"
      sha256 "7bd3afe7ae2dfd97d00df42b6fb1c9a1a5a7f4da72b002a2704e8bab6a1212a3"
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
