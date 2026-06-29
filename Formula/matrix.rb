class Matrix < Formula
  desc "Compatibility matrix CLI for software zones, levels, facts, gates, and traces"
  homepage "https://github.com/adrianmross/matrix"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.27/matrix-0.3.27-aarch64-apple-darwin.tar.gz"
      sha256 "8069fec22d0f5bd6b9050ed3705a5eddaf54a2f5916bd74fe542950e1b763337"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.27/matrix-0.3.27-x86_64-apple-darwin.tar.gz"
      sha256 "634b6de5136bc285d4c4a586d2166a3c2a2d9114b32f034da4de48e589d27747"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/matrix/releases/download/v0.3.27/matrix-0.3.27-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "4285e0fc0ebba915f14d2cdad16f8d7011806ff3798c5595f3d0b38e30a99f0e"
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
