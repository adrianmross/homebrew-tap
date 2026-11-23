class Pursuit < Formula
  desc "Job-application tracker with a CLI, HTTP API, and embedded dashboard"
  homepage "https://github.com/adrianmross/pursuit"
  # v0.0.0 and zero checksums are placeholders: bump-formulae.yml rewrites
  # them from the real assets once pursuit publishes its first release.
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.10.1/pursuit_0.10.1_darwin_arm64.tar.gz"
      sha256 "1c38c45a6fcb9b33aa23fd2c672a8cb04ceca4dd1ed584c54570064b37eace62"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.10.1/pursuit_0.10.1_darwin_amd64.tar.gz"
      sha256 "57c1b7d8a30a436bde8a2df86d1f7e21f1eafb0b39846c313f7fc3e3c05d9743"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.10.1/pursuit_0.10.1_linux_arm64.tar.gz"
      sha256 "caba9e92cd7d8826cddcf8a4a2d51d45c5a3700ccc8645326571b6fa4de39a40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.10.1/pursuit_0.10.1_linux_amd64.tar.gz"
      sha256 "9caadb186093545cbd5652835331904f2b9d480ba9edddb65059eea1b243c69f"
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
