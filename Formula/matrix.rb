class Matrix < Formula
  desc "Compatibility matrix CLI for software zones, levels, facts, gates, and traces"
  homepage "https://github.com/adrianmross/matrix"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.30/matrix-0.3.30-aarch64-apple-darwin.tar.gz"
      sha256 "f94331a7312b3ce41b7fdfa3e0eaf2ebc91f4fe1cb782a4044f47c72cc0ff3aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.30/matrix-0.3.30-x86_64-apple-darwin.tar.gz"
      sha256 "00c4da4bcd24a1610351c33e5dd845991de3cf1c0cd0860455001f965fa62536"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/matrix/releases/download/v0.3.30/matrix-0.3.30-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "90573e2fc2f28e7462e213a245b4b8b806213b7d1ae739c269d083e80d0e6c3d"
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
