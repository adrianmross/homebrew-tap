class Pursuit < Formula
  desc "Job-application tracker with a CLI, HTTP API, and embedded dashboard"
  homepage "https://github.com/adrianmross/pursuit"
  # v0.0.0 and zero checksums are placeholders: bump-formulae.yml rewrites
  # them from the real assets once pursuit publishes its first release.
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.11.0/pursuit_0.11.0_darwin_arm64.tar.gz"
      sha256 "f7b3dcaeb2000ce82eecda80e3a9e321111042faa7db3ae0e00ec82bc67a3b97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.11.0/pursuit_0.11.0_darwin_amd64.tar.gz"
      sha256 "19baca231378b43427ee42a258eebf69e359e4c3d494888187d958a60679bbf0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.11.0/pursuit_0.11.0_linux_arm64.tar.gz"
      sha256 "da855ee89dc752762556f037b8f227daf76f75ef345779c2e4217f6cefacce0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.11.0/pursuit_0.11.0_linux_amd64.tar.gz"
      sha256 "0fb14279ae9dd48672e10f6b8c7b700e83ef3721a2509279ae41e61987cad996"
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
