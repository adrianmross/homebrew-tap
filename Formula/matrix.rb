class Matrix < Formula
  desc "Compatibility matrix CLI for software zones, levels, facts, gates, and traces"
  homepage "https://github.com/adrianmross/matrix"
  url "https://github.com/adrianmross/matrix/archive/refs/tags/v0.3.16.tar.gz"
  sha256 "210dcc22da8d4adf052c9b87fb4c13facbbc7dde36f6a529efe3cdae666c29a3"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "crates/matrix-enter")
    system "cargo", "install", *std_cargo_args(path: "crates/matrix-construct")
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
