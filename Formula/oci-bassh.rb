class OciBassh < Formula
  desc "Unified operator CLI for SSH to OCI compute hosts through OCI Bastion"
  homepage "https://github.com/adrianmross/oci-bassh"
  url "https://github.com/adrianmross/oci-bassh/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "226e2902749d42198b8298cd732c07e4da21a34f0f104e3f9d0d82c4fa5f5877"
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
