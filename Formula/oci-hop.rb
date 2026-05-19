class OciHop < Formula
  desc "Prepare SSH access to OCI compute hosts through OCI Bastion"
  homepage "https://github.com/adrianmross/oci-bassh"
  url "https://github.com/adrianmross/oci-bassh/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "f5617618a6f9e1ed39fe62d36b81125b785e224cad2aacec1edadebfa1c02541"
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
    system "go", "build", *std_go_args(output: bin/"oci-bassh", ldflags:), "./cmd/oci-hop"
    bin.install_symlink "oci-hop" => "hop"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oci-hop version -o json")
    assert_match version.to_s, shell_output("#{bin}/hop version -o json")
    assert_match version.to_s, shell_output("#{bin}/oci-bassh version -o json")
    assert_match "install_script", shell_output("#{bin}/hop paths -o json")
  end
end
