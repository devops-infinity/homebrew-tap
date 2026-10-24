class Ownserp < Formula
  desc "MCP server for the Serper.dev search API with credit accounting"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.3.0/ownserp-aarch64-apple-darwin.tar.gz"
      sha256 "bd4a04fbe054f2629ddeab4030796f85b0c032e5960add8d531729db133d7b97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.3.0/ownserp-x86_64-apple-darwin.tar.gz"
      sha256 "6791f61cc2957e063c84d28679b67b977003377e3fced5858042028f9a4991fa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.3.0/ownserp-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c0edc40be62d7391f81e9b0be475f4f8d16d6c9141f98291619e0a508d349d2b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.3.0/ownserp-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d70d738d9104f7c021ad865c95fd162a3c6e2a233d29a6775008d761bebaa57c"
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
