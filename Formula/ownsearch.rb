class Ownsearch < Formula
  desc "MCP server for quality-ranked public SearXNG search"
  homepage "https://github.com/devops-infinity/ownsearch"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.1.2/ownsearch-aarch64-apple-darwin.tar.gz"
      sha256 "4fa56913abdfa9c89ab31ee226be047c46b3470b557813413853aa802666582c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.1.2/ownsearch-x86_64-apple-darwin.tar.gz"
      sha256 "f85361845d98f345b1b6b070c683094b69d22096b47a61ac8a331e23852bea3e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.1.2/ownsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "25d09a00b0a66cc09491a95b1b7e858bc268105fcb25cf536ed9111432c3ab40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.1.2/ownsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "78660d922cb589cae0624120d2838f1ee560656ac5a1aaa4b085ddf6c1ef3931"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ownsearch"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ownsearch"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ownsearch"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ownsearch"
    end

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match "ownsearch", shell_output("#{bin}/ownsearch --version")
  end
end
