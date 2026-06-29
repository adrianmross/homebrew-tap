class Matrix < Formula
  desc "Compatibility matrix CLI for software zones, levels, facts, gates, and traces"
  homepage "https://github.com/adrianmross/matrix"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.26/matrix-0.3.26-aarch64-apple-darwin.tar.gz"
      sha256 "71aa808e43c2b731658a63ea9e04d85e3c8c4306eea9cb0ef075b623520c5077"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.26/matrix-0.3.26-x86_64-apple-darwin.tar.gz"
      sha256 "cd2c83a20101a6ecfefac4c884f787ba9ca3517cf74e739284ee21cb72c99c1d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/matrix/releases/download/v0.3.26/matrix-0.3.26-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "d707b6644fb9904631db2ef13036cb7b714e7f7e72e33bfb8f25a53e6c8abedc"
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
