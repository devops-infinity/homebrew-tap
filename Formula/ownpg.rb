class Ownpg < Formula
  desc "OwnPG serves PostgreSQL DBA tools to AI clients over the Model Context Protocol, one database and one schema per run"
  homepage "https://github.com/devops-infinity/ownpg-releases"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownpg-releases/releases/download/v0.1.2/ownpg-aarch64-apple-darwin.tar.gz"
      sha256 "b56b6e6d8aa2e3f567a5b71dbf7c08e3c738aea950b5c1712e60ced9d9d1d249"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownpg-releases/releases/download/v0.1.2/ownpg-x86_64-apple-darwin.tar.gz"
      sha256 "b5fa2c814bde9a4d201617175658f9fe7c4cbbe303a772f5ef6f077d13052834"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownpg-releases/releases/download/v0.1.2/ownpg-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "831243ef6f060063d7dbc2bee8506de6513696698bb6e75c237b49ddcc40d173"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownpg-releases/releases/download/v0.1.2/ownpg-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "993d914adad7cb22eb14863391393c15d65064cf710b17acb706f95ac96fbc45"
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
