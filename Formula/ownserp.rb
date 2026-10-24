class Ownserp < Formula
  desc "MCP server for the Serper.dev search API with per-call credit accounting"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    url "https://github.com/devops-infinity/ownserp/archive/refs/tags/v0.1.4.tar.gz"
    sha256 "6419cdc25f47931411bed59ec356bb24dba7ca98df864adfb875d3006eebdb70"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v0.1.4/ownserp-0.1.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d87463ed5c3f5acf621cc952714615bfd64400127b90c4f606199a2aa2196c6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v0.1.4/ownserp-0.1.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7da61611def9c718a167fd86a7ef955960c042a3fcc9dd1b67749577c55e7193"
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
