class Ownsearch < Formula
  desc "MCP server for quality-ranked public SearXNG search"
  homepage "https://github.com/devops-infinity/ownsearch"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.4.0/ownsearch-aarch64-apple-darwin.tar.gz"
      sha256 "1f5d4b78cf98cf872b9ec5987460a882542b99d978f99de358037eec29c5a3d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.4.0/ownsearch-x86_64-apple-darwin.tar.gz"
      sha256 "00abf31303f02e0821753a05fc445f6369d1b9a6a135d5687bd1c3e3321f7211"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.4.0/ownsearch-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f2d079f2cc572e37db0115e035a3f2d68f04e385ff1bff94b7226853120ab695"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownsearch/releases/download/v0.4.0/ownsearch-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1fd5f4e4d5447335bf7b3a375bae10d0dc2bc0a3a6a34b7a3f26af86d002abe0"
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
