class Matrix < Formula
  desc "Compatibility matrix CLI for software zones, levels, facts, gates, and traces"
  homepage "https://github.com/adrianmross/matrix"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.25/matrix-0.3.25-aarch64-apple-darwin.tar.gz"
      sha256 "25d88c327b9bab6c90d239f591b358b7bdac8bc60e451ddfff8dab40e8b23316"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.25/matrix-0.3.25-x86_64-apple-darwin.tar.gz"
      sha256 "ee77bfb84e57c68793c6afcde74ed242cee46967945fed6ef3d1a6c69b65d493"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/matrix/releases/download/v0.3.25/matrix-0.3.25-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "d96a5d78cb8b79d3f937d4a241df65a0088d183938c9ebc65885604ec4b81966"
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
