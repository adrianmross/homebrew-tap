class Matrix < Formula
  desc "Compatibility matrix CLI for software zones, levels, facts, gates, and traces"
  homepage "https://github.com/adrianmross/matrix"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.19/matrix-0.3.19-aarch64-apple-darwin.tar.gz"
      sha256 "a149ab82da196956c1526ea6419680dc5e1b6897ef829dbbf0140801495be627"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.19/matrix-0.3.19-x86_64-apple-darwin.tar.gz"
      sha256 "2330ca0b147a6257d7d137fdbead88559cbbd7b08a473d0b72cb567d6379f8cf"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/matrix/releases/download/v0.3.19/matrix-0.3.19-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "89d591dd13e11e9b817cbc8e0fd36d4bcd71e073d8f7bf3f058e07d92aaf6881"
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
