class Pursuit < Formula
  desc "Job-application tracker with a CLI, HTTP API, and embedded dashboard"
  homepage "https://github.com/adrianmross/pursuit"
  # v0.0.0 and zero checksums are placeholders: bump-formulae.yml rewrites
  # them from the real assets once pursuit publishes its first release.
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.9.0/pursuit_0.9.0_darwin_arm64.tar.gz"
      sha256 "11b8dff4a54a1226aee25d566c4053bf1a2c78002e5c7fac0cb7fd2488cc3509"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.9.0/pursuit_0.9.0_darwin_amd64.tar.gz"
      sha256 "f2c590a18e66b53ed4eb9c2313a7dc19aa250291294b23c32530716d99c02af1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.9.0/pursuit_0.9.0_linux_arm64.tar.gz"
      sha256 "a3c88e1c8ec491580e92029a2a120a7286ca68a37ab370269035e145084e1073"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.9.0/pursuit_0.9.0_linux_amd64.tar.gz"
      sha256 "6be4803d8e7188691061bb1f44cbcf02b51ff15b2e32670a934e78fed9f03dd4"
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
