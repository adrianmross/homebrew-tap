class OciHop < Formula
  desc "Prepare SSH access to OCI compute hosts through OCI Bastion"
  homepage "https://github.com/adrianmross/oci-hop"
  url "https://github.com/adrianmross/oci-hop/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "79fa58c17099bea8f1418e4e6d76e4834c14600cc6d0f4ccd59b22f42afe8d24"
  license "MIT"

  depends_on "go" => :build
  depends_on "bastion-session"
  depends_on "oci-context"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=homebrew
      -X main.date=homebrew
    ]

    system "go", "build", *std_go_args(output: bin/"oci-hop", ldflags:), "./cmd/oci-hop"
    bin.install_symlink "oci-hop" => "hop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oci-hop version -o json")
    assert_match version.to_s, shell_output("#{bin}/hop version -o json")
    assert_match "install_script", shell_output("#{bin}/hop paths -o json")
  end
end
