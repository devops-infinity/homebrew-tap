class Ownserp < Formula
  desc "MCP server for the Serper.dev search API with per-call credit accounting"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    url "https://github.com/devops-infinity/ownserp/archive/refs/tags/v0.1.3.tar.gz"
    sha256 "c2ef62c71cc9a5567d9bf6f3cd1acb1d6d3637193c1552d68375562dc44bfc78"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v0.1.3/ownserp-0.1.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a60926ce8836ceee8c64452e0cdd1af3b81b26f2526ee0480f8a6ee062544d26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v0.1.3/ownserp-0.1.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "228d2bf1b706fbb85bbd97d891213066aa4aaf38e694aa0d33b21f41d9f05a6b"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/devops-infinity/ownserp.git", branch: "main"

  on_macos do
    depends_on "rust" => :build
  end

  def install
    if OS.mac?
      system "cargo", "install", "--locked", *std_cargo_args(path: "crates/ownserp")
    else
      bin.install "ownserp"
    end
  end

  def caveats
    <<~EOS
      The Linux binary is not code signed. Each release publishes a SHA-256 file
      beside the archive at https://github.com/devops-infinity/ownserp/releases
      so you can check the download before running it. macOS builds from source,
      so Gatekeeper does not quarantine the result.
    EOS
  end

  test do
    assert_match "OwnSERP", shell_output("#{bin}/ownserp --version")
  end
end
