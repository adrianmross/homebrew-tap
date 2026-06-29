class Matrix < Formula
  desc "Compatibility matrix CLI for software zones, levels, facts, gates, and traces"
  homepage "https://github.com/adrianmross/matrix"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.29/matrix-0.3.29-aarch64-apple-darwin.tar.gz"
      sha256 "a33fa84bb2419c8eaa61a97e43c2cbdd8bb01abbe9d75d3c1f4f5eda87bfa79b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/matrix/releases/download/v0.3.29/matrix-0.3.29-x86_64-apple-darwin.tar.gz"
      sha256 "d7e6088cab2cc49f040cd04c28cde9e269fbda972fe748746a9c5c117eab2fbf"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/matrix/releases/download/v0.3.29/matrix-0.3.29-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "234c16dc6f4007ee00b5527646ba87fa11a47256e65aa62abe41079455a7880e"
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
