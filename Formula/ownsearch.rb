class Ownsearch < Formula
  desc "MCP server that queries search engines directly and merges the results"
  homepage "https://github.com/devops-infinity/ownsearch"
  url "https://github.com/devops-infinity/ownsearch.git",
      tag:      "v1.0.0",
      revision: "db8ecdb0978618d6ab7f36caf51776a44c1db25f",
      using:    :git
  version "1.0.0"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/devops-infinity/ownsearch.git", branch: "main", using: :git

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/ownsearch")
  end

  test do
    assert_match "OwnSearch 1.0.0", shell_output("#{bin}/ownsearch --version")
  end
end
