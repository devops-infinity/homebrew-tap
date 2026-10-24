class Ownserp < Formula
  desc "OwnSERP, an MCP server for the Serper.dev search API, over stdio and Streamable HTTP"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v2.0.0/ownserp-aarch64-apple-darwin.tar.gz"
      sha256 "8437a71b1d31cf8bb2fea5374828bc8559b45f5464ca0c8a64dfc205a1e20644"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v2.0.0/ownserp-x86_64-apple-darwin.tar.gz"
      sha256 "fcd5dfd1f0553d960eb39cf046229297453f172e88f3b0a9d2f244638f985c8f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v2.0.0/ownserp-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c88a8da3bf31d845b847d2a0fd09d3bd6688b5e54da1a826987efe98e8ad0415"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v2.0.0/ownserp-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "404d88449c464799d076342f977f3e74b04552cc3eab0d0acad022869ae61b76"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

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

    install_binary_aliases!

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
