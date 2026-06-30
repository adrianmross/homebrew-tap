class Wiz < Formula
  desc "Red Wiz platform CLI"
  homepage "https://github.com/red-wiz/wiz-platform-cli"
  version "0.2.39"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://api.github.com/repos/red-wiz/wiz-platform-cli/releases/assets/462012421",
          headers: ["Accept: application/octet-stream",
                    "Authorization: Bearer #{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", "")}"]
      sha256 "8ed59ebabd22b68cef061ddac09fab6288f06eb1ff73d5d47a87af24e306b0eb"
    end
    if Hardware::CPU.intel?
      url "https://api.github.com/repos/red-wiz/wiz-platform-cli/releases/assets/462012443",
          headers: ["Accept: application/octet-stream",
                    "Authorization: Bearer #{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", "")}"]
      sha256 "f96bc07908100058e8bf89cb9cb5ec1e71bd1024e356a11e9832b45e7e6d7aa8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://api.github.com/repos/red-wiz/wiz-platform-cli/releases/assets/462012449",
        headers: ["Accept: application/octet-stream",
                  "Authorization: Bearer #{ENV.fetch("HOMEBREW_GITHUB_API_TOKEN", "")}"]
    sha256 "d629975bab784a30c6550cc16a4003a4b43c8835a22670d66769bb15e7f0b00d"
  end
  license "MIT"

  def install
    bin.install "wiz"

    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wiz --version")
  end
end
