class Pump < Formula
  desc "Sparse config hydration for JSON/YAML manifests"
  homepage "https://github.com/adrianmross/pump"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pump/releases/download/v0.2.0/pump-aarch64-apple-darwin.tar.xz"
      sha256 "ce5df2bc85025e0f668777800a330fdb95af2818cc345fcf30f697faaef99d36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pump/releases/download/v0.2.0/pump-x86_64-apple-darwin.tar.xz"
      sha256 "10599cc244d0e938f3aeb6f2b39da83eec0e6524382f4cd385fc63401639380f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/pump/releases/download/v0.2.0/pump-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "954523b1d4a0c2cfe9d5bc659bf34ae17ccb2edf3cf68459d3fc536be29e8f72"
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
