class OciContext < Formula
  desc "Manage OCI CLI contexts, auth, and local OCI metadata"
  homepage "https://github.com/adrianmross/oci-context"
  url "https://github.com/adrianmross/oci-context/archive/refs/tags/v0.22.3.tar.gz"
  sha256 "c48d133e171f7ba883abce93c554c7149ae16131853340829fd5e3e20eb060b1"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/adrianmross/oci-context/internal/cmd.version=#{version}
      -X github.com/adrianmross/oci-context/internal/cmd.commit=homebrew
      -X github.com/adrianmross/oci-context/internal/cmd.date=homebrew
    ]

    system "go", "build", *std_go_args(output: bin/"oci-context", ldflags:), "./cmd/oci-context"
    system "go", "build", *std_go_args(output: bin/"oci-contextd", ldflags:), "./cmd/oci-contextd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oci-context version -o json")
    assert_match "config_path", shell_output("#{bin}/oci-context paths -o json")
  end
end
