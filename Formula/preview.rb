class Preview < Formula
  desc "Run a repo's dev server detached, one per git worktree"
  homepage "https://github.com/adrianmross/preview"
  url "https://github.com/adrianmross/preview/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "55a73aeaffe26eb7e0940b477a639f675c4bea4933b289445834f9445f9d93cb"
  license "MIT"

  def install
    bin.install "preview"
  end

  test do
    assert_match "not inside a git repository", shell_output("#{bin}/preview up 2>&1", 1)
  end
end
