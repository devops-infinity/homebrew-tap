class Ownserp < Formula
  desc "MCP server for the Serper.dev search API with credit accounting"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.3.1/ownserp-aarch64-apple-darwin.tar.gz"
      sha256 "7eb574b0dddc57623949a1ecbb1866184a7d06be722992c48aa967fd316db67f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.3.1/ownserp-x86_64-apple-darwin.tar.gz"
      sha256 "7fdd4838df244e7be577a6332c14ff1a77eaa65e23cf820eb0f9810850ef917f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.3.1/ownserp-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4ad98cdb23d40241b8ae70d8da9f99a419ed3e6928079a71226a8d056eddbc6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.3.1/ownserp-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "29524c25d31894a8397b6a1d0eb07b515064f89d5657fd9d41e8538fa8b8de80"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ownserp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ownserp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ownserp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ownserp"
    end

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match "OwnSERP", shell_output("#{bin}/ownserp --version")
  end
end
