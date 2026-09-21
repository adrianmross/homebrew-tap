class TradingBot < Formula
  desc "Momentum scanner + backtester CLI for personal trading tooling"
  homepage "https://github.com/adrianmross/trading-bot"
  # Private repo, personal-use only: build from source via git (uses the
  # installing user's own git/ssh auth) rather than a release pipeline --
  # no public release process needed for a single-machine private install.
  url "https://github.com/adrianmross/trading-bot.git", branch: "main", using: :git
  version "0.1.0"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust-cli")
  end

  test do
    assert_match "Usage", shell_output("#{bin}/trade --help")
  end
end
