class OciHop < Formula
  desc "Prepare SSH access to OCI compute hosts through OCI Bastion"
  homepage "https://github.com/adrianmross/oci-hop"
  url "https://github.com/adrianmross/oci-hop/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "37ca5c0e3f4e0f0bed056a9b80950526622fa14287646b99b2e1ac47066bd148"
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
