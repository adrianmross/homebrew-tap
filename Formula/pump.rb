class Pump < Formula
  desc "Sparse config hydration for JSON/YAML manifests"
  homepage "https://github.com/adrianmross/pump"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pump/releases/download/v0.1.0/pump-aarch64-apple-darwin.tar.xz"
      sha256 "45886ea4aa1e838a76f15d5595cbc313301217df7fdb4abb7b075062b6a039c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pump/releases/download/v0.1.0/pump-x86_64-apple-darwin.tar.xz"
      sha256 "28b775a43ee4b8735ea3cd1b6d7ccb73fdca860f818fd612f7ae34f80f09d634"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/pump/releases/download/v0.1.0/pump-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "834dff7f2ffe6d0cfe645314d615fe3b915ab0a9043e2a22aed164fea107bbd5"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "pump" if OS.mac? && Hardware::CPU.arm?
    bin.install "pump" if OS.mac? && Hardware::CPU.intel?
    bin.install "pump" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pump --version")
  end
end
