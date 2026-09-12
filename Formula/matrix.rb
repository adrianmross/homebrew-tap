class Matrix < Formula
  desc "Compatibility matrix CLI for software zones, levels, facts, gates, and traces"
  homepage "https://github.com/adrianmross/matrix"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.33/matrix-0.3.33-aarch64-apple-darwin.tar.gz"
      sha256 "8148aea3f689b719e540459f52af494779a0094a8e6e2a6c2192f3f9b733fd42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.33/matrix-0.3.33-x86_64-apple-darwin.tar.gz"
      sha256 "5816461f7c8111bab95f9d05038da17615da4df8d97154c326cc37f7e223245d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/matrix/releases/download/v0.3.33/matrix-0.3.33-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "ac76015082ef29c212a8c8f0f2cf5edea5b6360f9fd6e5b997a6ef94dbd843b6"
  end
  license "Apache-2.0"

  def install
    archive_dir = Dir["matrix-*"].find { |path| File.directory?(path) }
    source = archive_dir || "."
    bin.install "#{source}/matrix"
    bin.install "#{source}/matrix-enter"
    bin.install "#{source}/matrix-construct"
    generate_completions_from_executable(bin/"matrix", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/matrix --version")
    assert_match version.to_s, shell_output("#{bin}/matrix-enter --version")
    assert_match version.to_s, shell_output("#{bin}/matrix-construct --version")
    assert_match "\"construct\"", shell_output("#{bin}/matrix --construct http://127.0.0.1:1 --json doctor")
    assert_match "_matrix", shell_output("#{bin}/matrix completion zsh")
  end
end
