class OciBassh < Formula
  desc "Unified operator CLI for SSH to OCI compute hosts through OCI Bastion"
  homepage "https://github.com/adrianmross/oci-bassh"
  url "https://github.com/adrianmross/oci-bassh/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "b454fd8f8e4f6f6fdf6228d8df1344d118c98113ef471d89e92742e4243a26c7"
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
