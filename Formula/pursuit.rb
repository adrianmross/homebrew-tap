class Pursuit < Formula
  desc "Job-application tracker with a CLI, HTTP API, and embedded dashboard"
  homepage "https://github.com/adrianmross/pursuit"
  # v0.0.0 and zero checksums are placeholders: bump-formulae.yml rewrites
  # them from the real assets once pursuit publishes its first release.
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.7.0/pursuit_0.7.0_darwin_arm64.tar.gz"
      sha256 "cd35a0bbba55bbf95209d0dd30572be55654364c259ada722a808ad84cbc8e0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.7.0/pursuit_0.7.0_darwin_amd64.tar.gz"
      sha256 "cda2676e9c4982d4ca1958bcbd42900fa8c52fccf6d533660350d2b8df314ab8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.7.0/pursuit_0.7.0_linux_arm64.tar.gz"
      sha256 "74276027ccce7ad1447303bc05c67b701e218efac928768d539b69fc65eb8eb6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pursuit/releases/download/v0.7.0/pursuit_0.7.0_linux_amd64.tar.gz"
      sha256 "3423d06fc17928b034af7e6e48aef88082cd4ced9905cb94beb2e0914517a9f7"
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
