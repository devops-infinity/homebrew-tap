class Ownserp < Formula
  desc "MCP server for the Serper.dev search API, over stdio and Streamable HTTP"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v2.1.0/ownserp-aarch64-apple-darwin.tar.gz"
      sha256 "83a11e3623c01730f93002637d5726edf61d4a4549daaffee54ab9a4e70678c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v2.1.0/ownserp-x86_64-apple-darwin.tar.gz"
      sha256 "d56de6232cba92b5b39b3ad052f7a21c9d549dd4fa6fc7c53e7a1df1a32f0912"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v2.1.0/ownserp-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c24fe622350b805b14b8e9070824ca1f8eddff576a2dff551a318b5e159c696e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v2.1.0/ownserp-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "01899668b5c9ab81eb7d81868954bfa3bf5b667cfec2b5caf741c96ff792635e"
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
