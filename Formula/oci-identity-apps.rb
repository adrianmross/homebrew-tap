class OciIdentityApps < Formula
  desc "Plan OCI Identity Domains OAuth applications for CLI and automation flows"
  homepage "https://github.com/adrianmross/oci-identity-apps"
  url "https://github.com/adrianmross/oci-identity-apps/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3377c72e1acfdecf4ac46693ab84ef669ba72a58fda9123141ee510c7b3bd2e0"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/adrianmross/oci-identity-apps/internal/cli.version=#{version}
      -X github.com/adrianmross/oci-identity-apps/internal/cli.commit=homebrew
      -X github.com/adrianmross/oci-identity-apps/internal/cli.date=homebrew
    ]

    system "go", "build", *std_go_args(output: bin/"oci-identity-apps", ldflags:), "./cmd/oci-identity-apps"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oci-identity-apps version")
    output = shell_output("#{bin}/oci-identity-apps plan " \
                          "--issuer https://idcs-example.identity.oraclecloud.com " \
                          "--scope https://service.example.com/.default " \
                          "--include user --format json")
    assert_match "oci-identity-apps.plan.v1", output
    assert_match "authorization_code", output
  end
end
