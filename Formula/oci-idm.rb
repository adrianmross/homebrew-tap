class OciIdm < Formula
  desc "Plan OCI Identity Domains apps, grants, and token-helper handoffs"
  homepage "https://github.com/adrianmross/oci-idm"
  url "https://github.com/adrianmross/oci-idm/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "bda3a0094a835c67398b9a360a29cf900b8bee312ce238aa6924c874b6cd8d97"
  license "MIT"

  conflicts_with "oci-identity-apps", because: "both install the oci-identity-apps compatibility command"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/adrianmross/oci-idm/internal/cli.version=#{version}
      -X github.com/adrianmross/oci-idm/internal/cli.commit=homebrew
      -X github.com/adrianmross/oci-idm/internal/cli.date=homebrew
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
