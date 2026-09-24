class Ownpg < Formula
  desc "OwnPG serves PostgreSQL DBA tools to AI clients over the Model Context Protocol, one database and one schema per run"
  homepage "https://github.com/devops-infinity/ownpg-releases"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownpg-releases/releases/download/v0.1.0/ownpg-aarch64-apple-darwin.tar.gz"
      sha256 "8d024fab2c515dedcf2f9658270fb3bfbf42f2b8012519bf5dacdad44b9b97ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownpg-releases/releases/download/v0.1.0/ownpg-x86_64-apple-darwin.tar.gz"
      sha256 "2534ca0fefde79b5343e14bed86ce1eeb0f9e466f6cdbd33d80a48094e8e7ef7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownpg-releases/releases/download/v0.1.0/ownpg-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5da18b872941594a5a67140fc3c7b3ae1d031259b1221cbfc6539fa65e94a8ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownpg-releases/releases/download/v0.1.0/ownpg-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0e4f48ff3c0f16e9b41cfce6466511174af277980b898d2bd275acf54842083f"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-apple-darwin": {},
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
