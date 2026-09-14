class OciHop < Formula
  desc "Prepare SSH access to OCI compute hosts through OCI Bastion"
  homepage "https://github.com/adrianmross/oci-hop"
  url "https://github.com/adrianmross/oci-hop/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "fb1b2303e93e65073c7fb26aac358f040715df6d7e728de7ed2ce25e52f265f9"
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
