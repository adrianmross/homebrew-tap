class TradingBot < Formula
  desc "tape (market analysis CLI), traded (daemon), trade (client for traded)"
  homepage "https://github.com/adrianmross/trading-bot"
  # Private repo, personal-use only: build from source via git (uses the
  # installing user's own git/ssh auth) rather than a release pipeline --
  # no public release process needed for a single-machine private install.
  url "git@github.com:adrianmross/trading-bot.git", branch: "main", using: :git
  version "0.1.0"
  license "MIT"

  depends_on "rust" => :build

  def install
    # rust-cli is a Cargo workspace (trade-core lib, plus the tape/traded/trade
    # bins) -- cargo install operates on one package at a time, so install each bin
    # explicitly rather than the workspace root.
    %w[tape traded trade].each do |crate|
      system "cargo", "install", *std_cargo_args(path: "rust-cli/#{crate}")
    end
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tape --help")
    assert_match "Usage", shell_output("#{bin}/trade --help")
  end
end
