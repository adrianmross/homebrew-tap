class Matrix < Formula
  desc "Compatibility matrix CLI for software zones, levels, facts, gates, and traces"
  homepage "https://github.com/adrianmross/matrix"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.24/matrix-0.3.24-aarch64-apple-darwin.tar.gz"
      sha256 "789033a2c9aff8ce4151d8543cbcc3425f83c26fcf56de0a056c2bbb6bf119e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.24/matrix-0.3.24-x86_64-apple-darwin.tar.gz"
      sha256 "7379313547ee6e803508138eef648a553a7cc0964fd4f0dc34c47f2fc6ceffdc"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/matrix/releases/download/v0.3.24/matrix-0.3.24-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "ffb6754a8e2f6ee93724bb757cdbea5e8921929f4fb0aedbc5dc27141c676b2e"
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
