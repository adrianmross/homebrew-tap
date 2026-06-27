class Matrix < Formula
  desc "Compatibility matrix CLI for software zones, levels, facts, gates, and traces"
  homepage "https://github.com/adrianmross/matrix"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.20/matrix-0.3.20-aarch64-apple-darwin.tar.gz"
      sha256 "209915f7969bb3ff1b086111d82f38947deffd5cbc8e5fb1af17bf33b8028f85"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.20/matrix-0.3.20-x86_64-apple-darwin.tar.gz"
      sha256 "b856c189287afc2b1d9ddd71fca112792103904ce330f8f51b6f7139c6d21ad1"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/matrix/releases/download/v0.3.20/matrix-0.3.20-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "b0acb4fa6bc7c8e069fe2154f3286d01140506e1b51cef9d8a5e84afd6923d86"
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
