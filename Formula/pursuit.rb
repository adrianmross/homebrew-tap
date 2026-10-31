class Pursuit < Formula
  desc "Job-application tracker with a CLI, HTTP API, and embedded dashboard"
  homepage "https://github.com/adrianmross/pursuit"
  # v0.0.0 and zero checksums are placeholders: bump-formulae.yml rewrites
  # them from the real assets once pursuit publishes its first release.
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.1.0/pursuit_0.1.0_darwin_arm64.tar.gz"
      sha256 "65b52649af63b19975288661a77db7a3f13b27c49f94caf4aea6f40ef59caaf4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.1.0/pursuit_0.1.0_darwin_amd64.tar.gz"
      sha256 "85ba42d58c7979e044f90146e46ca7aaa6f8c896dd51d81846ef066289d288d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.1.0/pursuit_0.1.0_linux_arm64.tar.gz"
      sha256 "cc2607c381087d3c64941dd98a4f5e22a627c4c5ad429dfed9c27e94c5019fb5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.1.0/pursuit_0.1.0_linux_amd64.tar.gz"
      sha256 "975efb8d2ac67e7bdcadf3fa7173106f7e866a5bdaed107bf37d4362b1e48d35"
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
