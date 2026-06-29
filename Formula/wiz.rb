class Wiz < Formula
  desc "Red Wiz platform CLI"
  homepage "https://github.com/red-wiz/wiz-platform-cli"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/red-wiz/wiz-platform-cli/releases/download/v0.2.33/wiz-platform-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6fd306af284d01b5cdcdb41b5eb11840e0c4cf3646fb417020ab5c3115af22b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/red-wiz/wiz-platform-cli/releases/download/v0.2.33/wiz-platform-cli-x86_64-apple-darwin.tar.xz"
      sha256 "fb2f0ec653a715b9ded21d37148576cfa50176895bfabdc7f40b6f1d65c99c15"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/red-wiz/wiz-platform-cli/releases/download/v0.2.33/wiz-platform-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ad42cbf7da433ee2123b4a8e8ae682de669239d69b4653b88b8bf091063ef7cf"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {},
  }

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
      bin.install "wiz"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "wiz"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "wiz"
    end

    install_binary_aliases!

    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
