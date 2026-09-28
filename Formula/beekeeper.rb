class Beekeeper < Formula
  desc "Capability-based authorization and identity continuity for AI agents"
  homepage "https://github.com/adrianmross/beekeeper"
  version "0.1.0"
  license "Apache-2.0"

  # Release assets are per-target tarballs from .github/workflows/release.yml,
  # each containing beekeeper-<tag>-<target>/ with the binary plus the stack
  # files. Homebrew strips that single root directory on unpack.
  #
  # REPLACE_ME: needs the first post-rename release. The v0.1.0 assets are still
  # named tinman-*; cut a beekeeper tag, then `scripts/bump-formulae.py` fills
  # the urls and sha256s in one pass.
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/beekeeper/releases/download/v0.1.0/beekeeper-v0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "0" * 64  # REPLACE_ME: fill from the first beekeeper release
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/beekeeper/releases/download/v0.1.0/beekeeper-v0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "0" * 64  # REPLACE_ME: fill from the first beekeeper release
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/beekeeper/releases/download/v0.1.0/beekeeper-v0.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0" * 64  # REPLACE_ME: fill from the first beekeeper release
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/beekeeper/releases/download/v0.1.0/beekeeper-v0.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0" * 64  # REPLACE_ME: fill from the first beekeeper release
    end
  end

  depends_on "docker" => :optional

  def install
    bin.install "beekeeper"
    # The binary is not self-contained: it drives `compose.yaml` and `deploy/`
    # in a working directory (`--dir`, default CWD). Installing only the binary
    # would put a `beekeeper` on PATH that cannot start anything.
    pkgshare.install "compose.yaml", "relay", "deploy", "docs", "README.md"
  end

  def caveats
    <<~EOS
      beekeeper runs against a working directory holding compose.yaml and .env.
      Seed one from the copy this formula installed:

        mkdir -p ~/beekeeper && cp -R #{pkgshare}/. ~/beekeeper
        cd ~/beekeeper && beekeeper init && beekeeper up

      `beekeeper init` clones the bap repository with your own git credentials.
      That repository is private, so this currently works only for accounts with
      access to it.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/beekeeper --version")
    # The stack files must ship, or `beekeeper up` has nothing to drive.
    assert_path_exists pkgshare/"compose.yaml"
  end
end
