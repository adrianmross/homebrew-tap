class Secretspec < Formula
  desc "Declarative secrets management with pluggable providers"
  homepage "https://github.com/adrianmross/secretspec"
  version "0.12.2-adrian.1"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/secretspec/releases/download/v0.12.2-adrian.1/secretspec-aarch64-apple-darwin.tar.xz"
      sha256 "939009ea826da6f721a54abb72baf3730fd834fe13124ae3652b989625923095"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/secretspec/releases/download/v0.12.2-adrian.1/secretspec-x86_64-apple-darwin.tar.xz"
      sha256 "a7150795e8034536b61744dec29077f2996541e16eb10714b62640e1980f5488"
    end
  end

  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/secretspec/releases/download/v0.12.2-adrian.1/secretspec-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5e28eb7f19bad2af3d39d4463d311f6857a3493902178e75425ea290946e54e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/secretspec/releases/download/v0.12.2-adrian.1/secretspec-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "317858fb0e9cf768ec8e24aec353a4d1c4d6bc082d16c85b949bfe5a686cc11e"
    end
  end

  license "Apache-2.0"

  def install
    archive_dir = Dir["secretspec-*"].find { |path| File.directory?(path) }
    source = archive_dir || "."
    bin.install "#{source}/secretspec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
  end
end
