class BastionSession < Formula
  desc "Manage OCI Bastion managed SSH sessions and host aliases"
  homepage "https://github.com/adrianmross/bastion-session"
  url "https://github.com/adrianmross/bastion-session/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "41c49a2d104ea982cea1597ab3ead6bb013e189627ddbad11544094595b0c5c5"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/adrianmross/bastion-session/internal/cmd.version=#{version}
      -X github.com/adrianmross/bastion-session/internal/cmd.commit=homebrew
      -X github.com/adrianmross/bastion-session/internal/cmd.date=homebrew
    ]

    system "go", "build", *std_go_args(output: bin/"bastion-session", ldflags:), "./cmd/bastion-session"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bastion-session version -o json")
    assert_match "session_state_path", shell_output("#{bin}/bastion-session --no-context-scope paths -o json")
  end
end
