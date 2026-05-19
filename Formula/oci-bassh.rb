class OciBassh < Formula
  desc "Unified operator CLI for SSH to OCI compute hosts through OCI Bastion"
  homepage "https://github.com/adrianmross/oci-bassh"
  url "https://github.com/adrianmross/oci-bassh/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "44f278f610e130d4cef72664e25aa5f6a81ad071880ffb0ab5ff5baf4bf9227f"
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

    system "go", "build", *std_go_args(output: bin/"oci-bassh", ldflags:), "./cmd/oci-bassh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oci-bassh version -o json")
    assert_match "install_script", shell_output("#{bin}/oci-bassh paths -o json")
  end
end
