class OciScm < Formula
  desc "OCI DevOps SCM CLI with pull requests, comments, and review integration"
  homepage "https://github.com/adrianmross/oci-scm"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/adrianmross/oci-scm/releases/download/v0.1.0/oci-scm_0.1.0_darwin_arm64.tar.gz"
      sha256 "f3015134bde89c0d4d63936939e5a20fde16c0b8c739a79aa28988ca1a47b70e"
    end
    on_intel do
      url "https://github.com/adrianmross/oci-scm/releases/download/v0.1.0/oci-scm_0.1.0_darwin_amd64.tar.gz"
      sha256 "d8bbabbc77a5dd300ec62c8161642393362df09682042373b79fcd26bfe8e978"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/adrianmross/oci-scm/releases/download/v0.1.0/oci-scm_0.1.0_linux_arm64.tar.gz"
      sha256 "66861705c1ab17600d90ccc3ccbc2d7324a6651225b1024dd2485c3a1cd3d02d"
    end
    on_intel do
      url "https://github.com/adrianmross/oci-scm/releases/download/v0.1.0/oci-scm_0.1.0_linux_amd64.tar.gz"
      sha256 "b3b32a108c955e08dfbaee3d2f989eca82007262cf64ea5c3da3303d2d7d32f8"
    end
  end

  def install
    bin.install "oscm", "oci-scm"
    (share/"oci-scm").install "integrations", "docs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oscm version --json all")
    assert_match "pull request", shell_output("#{bin}/oci-scm pr --help")
  end
end
