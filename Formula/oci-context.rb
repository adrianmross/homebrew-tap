class OciContext < Formula
  desc "Manage OCI CLI contexts, auth, and local OCI metadata"
  homepage "https://github.com/adrianmross/oci-context"
  url "https://github.com/adrianmross/oci-context/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "82c74d6ab6c5ecab9344ccf9ca470a5d9cc4f36b7edf6adc371526898ffab163"
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
