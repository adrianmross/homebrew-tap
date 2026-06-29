class OciIdm < Formula
  desc "Plan OCI Identity Domains apps, grants, and token-helper handoffs"
  homepage "https://github.com/adrianmross/oci-identity-apps"
  url "https://github.com/adrianmross/oci-identity-apps/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "069d70b9223ce4691b9bc896aff2f29d25ee23a47b1f7d37aa88f176baba7c53"
  license "MIT"

  conflicts_with "oci-identity-apps", because: "both install the oci-identity-apps compatibility command"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/adrianmross/oci-identity-apps/internal/cli.version=#{version}
      -X github.com/adrianmross/oci-identity-apps/internal/cli.commit=homebrew
      -X github.com/adrianmross/oci-identity-apps/internal/cli.date=homebrew
    ]

    system "go", "build", *std_go_args(output: bin/"oci-idm", ldflags:), "./cmd/oci-idm"
    system "go", "build", *std_go_args(output: bin/"oci-identity-apps", ldflags:), "./cmd/oci-identity-apps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oci-idm version")
    assert_match version.to_s, shell_output("#{bin}/oci-identity-apps version")
    output = shell_output("#{bin}/oci-idm plan apps " \
                          "--issuer https://idcs-example.identity.oraclecloud.com " \
                          "--scope https://service.example.com/.default " \
                          "--include user -o json")
    assert_match "oci-idm.plan.v1", output
    assert_match "authorization_code", output
  end
end
