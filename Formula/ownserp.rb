class Ownserp < Formula
  desc "MCP server for the Serper.dev search API with per-call credit accounting"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    url "https://github.com/devops-infinity/ownserp/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "4a719aaa08122e39723cd3c01e718fba4637bf516dede01eefeee0f69b3f2db3"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.0.0/ownserp-1.0.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eac610b728dbd26d71e1644d55e66d3716bc6ee5c6829657b0cf3b8aec05a32a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/devops-infinity/ownserp/releases/download/v1.0.0/ownserp-1.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "49e558d05df20d08cd2f9fcb0b3cd4779e732e471e66afd76ee8b5ce1c902471"
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
