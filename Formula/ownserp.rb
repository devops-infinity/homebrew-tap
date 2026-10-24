class Ownserp < Formula
  desc "MCP server for the Serper.dev search API with per-call credit accounting"
  homepage "https://github.com/devops-infinity/ownserp"
  url "https://github.com/devops-infinity/ownserp/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "b6ca59e72f872d166924c3adf598ab00adafbb99da4d3371f0afe5dde5d31960"
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
