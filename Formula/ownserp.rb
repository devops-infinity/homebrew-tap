class Ownserp < Formula
  desc "MCP server for the Serper.dev search API with credit accounting"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.2.0/ownserp-aarch64-apple-darwin.tar.gz"
      sha256 "54ff6ee5a22ce9cd7150da6087b0dcf8fdc3fe9bff9c8428eaf2d9e3aaed1ca4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.2.0/ownserp-x86_64-apple-darwin.tar.gz"
      sha256 "abfacde3884537df9a6f008a5d99a23426fe40efa6350fef4b93d115b5465e8d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.2.0/ownserp-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d1cb4c966feed5aeb11f96dbd27082b74789c367d8e2712cc0cd6209967ec589"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.2.0/ownserp-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "55304a33a755350d9a2a163fe2c85ad6de45f4af6cf88a5fb04ab2111b259e69"
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
