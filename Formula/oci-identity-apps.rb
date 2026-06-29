class OciIdentityApps < Formula
  desc "Plan OCI Identity Domains OAuth applications for CLI and automation flows"
  homepage "https://github.com/adrianmross/oci-idm"
  url "https://github.com/adrianmross/oci-idm/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "302df8ebcb4a71ceeed1ea5ca29f6a2d7c38becbbe97acc0789bce26b3cd8bcf"
  license "MIT"

  conflicts_with "oci-idm", because: "both install the oci-identity-apps command"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/adrianmross/oci-idm/internal/cli.version=#{version}
      -X github.com/adrianmross/oci-idm/internal/cli.commit=homebrew
      -X github.com/adrianmross/oci-idm/internal/cli.date=homebrew
    ]

    system "go", "build", *std_go_args(output: bin/"oci-identity-apps", ldflags:), "./cmd/oci-identity-apps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oci-identity-apps version")
    output = shell_output("#{bin}/oci-identity-apps plan apps " \
                          "--issuer https://idcs-example.identity.oraclecloud.com " \
                          "--scope https://service.example.com/.default " \
                          "--include user -o json")
    assert_match "oci-idm.plan.v1", output
    assert_match "authorization_code", output
    clone_output = shell_output("#{bin}/oci-identity-apps clone app " \
                                "--name hebe-obp-user " \
                                "--issuer https://idcs-example.identity.oraclecloud.com " \
                                "--scope https://service.example.com/.default " \
                                "-o json")
    assert_match "oci-idm.handoff.oci-context.v1", clone_output
    assert_match "hebe-obp-user", clone_output
  end
end
