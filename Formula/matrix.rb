class Matrix < Formula
  desc "Compatibility matrix CLI for software zones, levels, facts, gates, and traces"
  homepage "https://github.com/adrianmross/matrix"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.23/matrix-0.3.23-aarch64-apple-darwin.tar.gz"
      sha256 "78cba56e7c97f6b9de72e46094f8f7f79bb4ed8c5a5ff6562ca955fedbfc9ba5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.23/matrix-0.3.23-x86_64-apple-darwin.tar.gz"
      sha256 "3c9bb2839db3f15aad0f2839d6b05d3e8f120ad0a0dff452c4124260395d0be5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/matrix/releases/download/v0.3.23/matrix-0.3.23-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "03284fa8b4c556e5d051bd1974bd7b6dad6f0f59af2c3cc31194e4d1172c19c8"
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
