class Ownserp < Formula
  desc "MCP server for the Serper.dev search API with per-call credit accounting"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    url "https://github.com/devops-infinity/ownserp/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "253727c5769d1bf5fc98d1b453e9b6b572adfcc871d864bf4fb99a1c4ba35252"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.1.0/ownserp-1.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3363652580987a94578a5f4b782ba7aa40a00822340589356b3eba1881d24fe1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.1.0/ownserp-1.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bc7c9ec3914e059a3ac97e6e4a58e5f8575b258e6e1293c0c85ae4ac6fb8816d"
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
