class BastionSession < Formula
  desc "Manage OCI Bastion managed SSH sessions and host aliases"
  homepage "https://github.com/adrianmross/bastion-session"
  url "https://github.com/adrianmross/bastion-session/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "984b95654587784738fd05110472492a246438596299381650c37e475746537c"
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
