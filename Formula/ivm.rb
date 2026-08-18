class Ivm < Formula
  desc "Small Istio version and profile manager"
  homepage "https://github.com/adrianmross/ivm"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/adrianmross/ivm/releases/download/v0.1.0/ivm-aarch64-apple-darwin.tar.xz"
      sha256 "23620f23382a0d9790963c4a377006b337d13367c884dab6f83f1313e9623fdf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/adrianmross/ivm/releases/download/v0.1.0/ivm-x86_64-apple-darwin.tar.xz"
      sha256 "f1d6cf8d454b5b4251130ab30dc7a065ae3315fc2350b53929f8c980fdf5918d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/adrianmross/ivm/releases/download/v0.1.0/ivm-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "7288624dd8733238587a6ab8a61bd83b1c2a371b71c4dbe7202c212641ed5e17"
  end
  license "MIT"

  def install
    bin.install "ivm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ivm --version")
  end
end
