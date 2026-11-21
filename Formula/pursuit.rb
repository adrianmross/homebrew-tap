class Pursuit < Formula
  desc "Job-application tracker with a CLI, HTTP API, and embedded dashboard"
  homepage "https://github.com/adrianmross/pursuit"
  # v0.0.0 and zero checksums are placeholders: bump-formulae.yml rewrites
  # them from the real assets once pursuit publishes its first release.
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.10.0/pursuit_0.10.0_darwin_arm64.tar.gz"
      sha256 "3cc4cd739a6de7ed0c4cf2f6bafffba0813acf4cab48f925893b479ca6f2cfff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.10.0/pursuit_0.10.0_darwin_amd64.tar.gz"
      sha256 "6564c8371478fdd01a3d8529721008e1f9dd5d9788cd0614cebb2265978ecbf5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.10.0/pursuit_0.10.0_linux_arm64.tar.gz"
      sha256 "1343aa37f982daaa793e9377436f452ae78fad5aae37ed0400aab8458a0b8a0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.10.0/pursuit_0.10.0_linux_amd64.tar.gz"
      sha256 "76621583743526c31e9438aa845b8b686bf2023630d4e043737c652fca7d2818"
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
