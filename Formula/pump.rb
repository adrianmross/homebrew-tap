class Pump < Formula
  desc "Sparse config hydration for JSON/YAML manifests"
  homepage "https://github.com/adrianmross/pump"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/pump/releases/download/v0.1.1/pump-aarch64-apple-darwin.tar.xz"
      sha256 "ee71dc4930cf7ae9c2d2caa75350a3be5faa455f1149a534d09a6305398c7fb5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/pump/releases/download/v0.1.1/pump-x86_64-apple-darwin.tar.xz"
      sha256 "acdbb523f314756b66d751ea48460c5f7d732def7c7079d5f36c3e1dbf7d7740"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/pump/releases/download/v0.1.1/pump-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7f4f01aa28872b4965fcbbcf1d38681e70d196edaeaa1e8224412d32ee8eaa03"
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
