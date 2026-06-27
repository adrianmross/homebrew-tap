class OciIdm < Formula
  desc "Plan OCI Identity Domains apps, grants, and token-helper handoffs"
  homepage "https://github.com/adrianmross/oci-identity-apps"
  url "https://github.com/adrianmross/oci-identity-apps/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "4eb3d64730902c4b0d9dfe2e544e154b4c2d63cdf6420a7bb0975ded0eed9559"
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
    output = shell_output("#{bin}/oci-idm plan " \
                          "--issuer https://idcs-example.identity.oraclecloud.com " \
                          "--scope https://service.example.com/.default " \
                          "--include user --format json")
    assert_match "oci-idm.plan.v1", output
    assert_match "authorization_code", output
  end
end
