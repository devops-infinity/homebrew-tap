class Ownsearch < Formula
  desc ", an MCP server for quality-ranked public SearXNG search"
  homepage "https://github.com/devops-infinity/ownsearch"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.2.0/ownsearch-aarch64-apple-darwin.tar.gz"
      sha256 "60224f5c6c36eef529249626c3be2d220cf81d8ad4e8cad549e45bb343a7f561"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.2.0/ownsearch-x86_64-apple-darwin.tar.gz"
      sha256 "de82c3609fc6db7c9c4066d470a52a64d7f11d85467a56009e039cc1fa49cec4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.2.0/ownsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ce189180739f6cc5319c63ef8a3ad14a17a9219925c3b5439eb07191e97b2653"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.2.0/ownsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c376bf87812953629e7e0f4df54e39e9973e0412bfa82fa54af80c05cf09982b"
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
    assert_match "OwnSearch", shell_output("#{bin}/ownsearch --version")
  end
end
