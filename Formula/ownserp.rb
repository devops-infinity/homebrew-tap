class Ownserp < Formula
  desc "MCP server for the Serper.dev search API, over stdio and Streamable HTTP"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v2.2.0/ownserp-aarch64-apple-darwin.tar.gz"
      sha256 "ee65ce4bce682f5175a6798e04b3716c39daf094283184a432cb14c65b71dc15"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v2.2.0/ownserp-x86_64-apple-darwin.tar.gz"
      sha256 "96d509f578fb4eb72f141227c34be78f822de4e9e995aced66079756a7b1102e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v2.2.0/ownserp-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2f93f230e2c8438a738e59b2c475280cc8749e23b42ad865eae784408d6c6c4f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v2.2.0/ownserp-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "918fca148612ae0b747f869bed01d5e9100a5abb65e06ba089332df8a32cd13f"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

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
