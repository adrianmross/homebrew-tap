class GitHubPrivateReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    token = ENV["HOMEBREW_GITHUB_API_TOKEN"] || ENV["GITHUB_TOKEN"] || ENV["GH_TOKEN"]
    raise CurlDownloadStrategyError, "Set HOMEBREW_GITHUB_API_TOKEN, GITHUB_TOKEN, or GH_TOKEN to install wiz." if token.to_s.empty?

    meta[:headers] ||= []
    meta[:headers] << "Authorization: Bearer #{token}"
    super
  end
end

class Wiz < Formula
  desc "Red Wiz platform CLI"
  homepage "https://github.com/red-wiz/wiz-platform-cli"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/red-wiz/wiz-platform-cli/releases/download/v0.1.0/wiz-platform-cli-aarch64-apple-darwin.tar.xz",
          using: GitHubPrivateReleaseDownloadStrategy
      sha256 "cc8aa5c1a1466900219fbe9591cf9c28f55fe24075111cfda26b50d81f16e9ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/red-wiz/wiz-platform-cli/releases/download/v0.1.0/wiz-platform-cli-x86_64-apple-darwin.tar.xz",
          using: GitHubPrivateReleaseDownloadStrategy
      sha256 "5968a250f83098568a4361a58f027984d5d458e12dfe4e8d60c69633fd9442fc"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/red-wiz/wiz-platform-cli/releases/download/v0.1.0/wiz-platform-cli-x86_64-unknown-linux-gnu.tar.xz",
          using: GitHubPrivateReleaseDownloadStrategy
      sha256 "07621902b328ca73d5ca4a29c9e87e78d3d5e95ec58d179c678bd283b1ef97d9"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
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

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wiz --version")
  end
end
