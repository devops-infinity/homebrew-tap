class Ownserp < Formula
  desc "MCP server for the Serper.dev search API with per-call credit accounting"
  homepage "https://github.com/devops-infinity/ownserp"
  url "https://github.com/devops-infinity/ownserp/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "6b1fdc89224ff358b3f5adb49a287a26114e710c4fd2ef84ef0a7e22f41438be"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/devops-infinity/ownserp.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", *std_cargo_args(path: "crates/ownserp")
  end

  test do
    assert_match "OwnSERP", shell_output("#{bin}/ownserp --version")
  end
end
