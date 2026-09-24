class Ownpg < Formula
  desc "OwnPG serves PostgreSQL DBA tools to AI clients over the Model Context Protocol, one database and one schema per run"
  homepage "https://github.com/devops-infinity/ownpg-releases"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownpg-releases/releases/download/v0.1.1/ownpg-aarch64-apple-darwin.tar.gz"
      sha256 "da5b43e81942a0d379c33b500a047480069f8013f3c9b956b03c4c17d205d798"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownpg-releases/releases/download/v0.1.1/ownpg-x86_64-apple-darwin.tar.gz"
      sha256 "caa8b103492a888704e8ab191ac9a4c2d74a1e0cd49e3ff9f6df96fb80356c86"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownpg-releases/releases/download/v0.1.1/ownpg-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9cee464751768e429113351eee99345c7491b258442b662f489663d920b6dd3a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownpg-releases/releases/download/v0.1.1/ownpg-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5cb9c7b5bcb3ce569ad05812671d8b7eaf3c3f7b90c2f8933aebe57cab4cebac"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-pc-windows-gnu": {},
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
      bin.install "ownpg"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ownpg"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ownpg"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ownpg"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
