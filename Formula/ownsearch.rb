class Ownsearch < Formula
  desc "MCP server for quality-ranked public SearXNG search"
  homepage "https://github.com/devops-infinity/ownsearch"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.5.0/ownsearch-aarch64-apple-darwin.tar.gz"
      sha256 "1c10797b9eb53ed0b777a541a516b3bf582173a8520d0b8cb58884bae2894122"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.5.0/ownsearch-x86_64-apple-darwin.tar.gz"
      sha256 "6d7ff9933a6345b25932d8984f8f87b8460d105c5edc04cc2f734a0b3b03af9e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.5.0/ownsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "606b2ee9066bbcf8f2e55c8554995002eb955a1e28ec3a833f68d5266657f7ef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.5.0/ownsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "67990289b8582f159a9e8453b7ffb0fc146de09d5b6bcba7f90de72b25258c8f"
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

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
  test do
    assert_match version.to_s, shell_output("#{bin}/ownsearch --version")
  end
end
