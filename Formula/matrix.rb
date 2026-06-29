class Matrix < Formula
  desc "Compatibility matrix CLI for software zones, levels, facts, gates, and traces"
  homepage "https://github.com/adrianmross/matrix"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.28/matrix-0.3.28-aarch64-apple-darwin.tar.gz"
      sha256 "fa609a928583368e8fbcfb0d6cde325bed9bcc25e773e1ba1ac00b7eaed289f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.28/matrix-0.3.28-x86_64-apple-darwin.tar.gz"
      sha256 "d2ce1c64ffd74ed93ac4a79e5938f0272506387c3432fd1e71c83c5cef81c955"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/matrix/releases/download/v0.3.28/matrix-0.3.28-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "7915566e9fcb983027b03f7eadb04bdff467fce35d1c062d931681e636fcbe87"
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
