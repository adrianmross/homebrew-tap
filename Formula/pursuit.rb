class Pursuit < Formula
  desc "Job-application tracker with a CLI, HTTP API, and embedded dashboard"
  homepage "https://github.com/adrianmross/pursuit"
  # v0.0.0 and zero checksums are placeholders: bump-formulae.yml rewrites
  # them from the real assets once pursuit publishes its first release.
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.8.0/pursuit_0.8.0_darwin_arm64.tar.gz"
      sha256 "684cddaccdae4da667995c1b7bf84a47828516274778f3ffd12c93b82b1814b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.8.0/pursuit_0.8.0_darwin_amd64.tar.gz"
      sha256 "1e43c66b25718aa20972cfa6d5e542ad032293323176347c62ab93af2be42daf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.8.0/pursuit_0.8.0_linux_arm64.tar.gz"
      sha256 "d2d2015bb77e23d6439208f4bd78dafb44a144f5638adac4689111f2c35ce918"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.8.0/pursuit_0.8.0_linux_amd64.tar.gz"
      sha256 "d8f523cb97ab7fffe03eef2e18a230072b53617a0d650768b8251bc87534a10f"
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
