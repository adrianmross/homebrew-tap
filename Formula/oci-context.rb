class OciContext < Formula
  desc "Manage OCI CLI contexts, auth, and local OCI metadata"
  homepage "https://github.com/adrianmross/oci-context"
  url "https://github.com/adrianmross/oci-context/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "a6a09e24ca156813ae2587a47884baa43f4aa2d3374130142315285d2aabb962"
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
