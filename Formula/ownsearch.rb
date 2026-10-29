class Ownsearch < Formula
  desc "MCP server for quality-ranked public SearXNG search"
  homepage "https://github.com/devops-infinity/ownsearch"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.3.0/ownsearch-aarch64-apple-darwin.tar.gz"
      sha256 "89552456b86bf172e43aab7947823a03ac5b38e1fa23cc0f3e45d51fdc1df838"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.3.0/ownsearch-x86_64-apple-darwin.tar.gz"
      sha256 "48f1196d33606026d394cbcaabdcdcb4641d5821e364b93df928f7ae37f0fc72"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.3.0/ownsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c6b8af269567dfa43f530704cc3e6f10d8b7713709dee30e58af068d36d279c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.3.0/ownsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7b8ca518e90608f02f8d7a103aecab15882fbf1ec9fb834dd67cb2ecfa10669a"
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
