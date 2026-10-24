class Ownserp < Formula
  desc "MCP server for the Serper.dev search API with per-call credit accounting"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    url "https://github.com/devops-infinity/ownserp/archive/refs/tags/v0.1.5.tar.gz"
    sha256 "281318060ec46c9a088ea29da7dee0b3e794a6544e43c67e590e7a460098c117"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v0.1.5/ownserp-0.1.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4147bbcc7a33f7d0630af6d13f4238beadc15eadb7f2f94326bd4769b4ac42d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v0.1.5/ownserp-0.1.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a49a2706f7debeb53469a7ba411e6f8aef9e11a52e38038df6bc8106e7f0d11e"
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
