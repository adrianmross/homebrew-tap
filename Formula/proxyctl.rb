class Proxyctl < Formula
  desc "CLI tool for managing proxy configurations"
  homepage "https://github.com/adrianmross/proxyctl-rs"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/proxyctl-rs/releases/download/v1.2.0/proxyctl-rs-aarch64-apple-darwin.tar.xz"
      sha256 "c894609a1205cb6bc661006133c3c00b4b7f1f0b09586d987b3418babfa0a0c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/proxyctl-rs/releases/download/v1.2.0/proxyctl-rs-x86_64-apple-darwin.tar.xz"
      sha256 "a01f0847aeba3a2a81c27ecf65cd3a9bb6c27f3b3bae6823596c06013a18e086"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/proxyctl-rs/releases/download/v1.2.0/proxyctl-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "328b7b72d02896c6f1a6eb25a2bb3a8d0a8e82107fc48cb1b85c1c50db3f00b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/proxyctl-rs/releases/download/v1.2.0/proxyctl-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2da506dfe16c41ee45e8158b26871b90f2b30fd172c602923cf2320461b60f82"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "proxyctl-rs"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "proxyctl-rs"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "proxyctl-rs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "proxyctl-rs"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
