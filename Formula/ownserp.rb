class Ownserp < Formula
  desc "MCP server for the Serper.dev search API with per-call credit accounting"
  homepage "https://github.com/devops-infinity/ownserp"
  if OS.mac?
    url "https://github.com/devops-infinity/ownserp/archive/refs/tags/v0.1.2.tar.gz"
    sha256 "6b1fdc89224ff358b3f5adb49a287a26114e710c4fd2ef84ef0a7e22f41438be"
  end
  if OS.linux?
    url "https://github.com/devops-infinity/ownserp/releases/download/v0.1.2/ownserp-0.1.2-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "a5e46163d007a350315d80b1e184dfe3b1191aff30fb69f024baebe53a9d7ac6"
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

  test do
    assert_match "OwnSERP", shell_output("#{bin}/ownserp --version")
  end
end
