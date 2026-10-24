class Ownserp < Formula
  desc "MCP server for the Serper.dev search API with credit accounting"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.2.1/ownserp-aarch64-apple-darwin.tar.gz"
      sha256 "0b0dd2691c45f6f4c5c486110af4c93247b1183f818c477b1c7304de4fba6f6f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.2.1/ownserp-x86_64-apple-darwin.tar.gz"
      sha256 "27afc82ce296122e985f0b55978abd73096edcd5205de8da1943ba71f7de7321"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.2.1/ownserp-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e707f350fbae15522a07eb68df33b6348fd529035a0ec03c2fa5b2fc65f03da1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.2.1/ownserp-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5e16fca3d38a250b9de01d91dfbd340b662fd98c7d9e3b7a0a9b5e4e09515a4e"
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
