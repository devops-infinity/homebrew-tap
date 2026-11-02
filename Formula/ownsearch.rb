require "time"

class GitHubReleaseAssetDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    match = url.match(%r{^https://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/([^/]+)$})
    raise CurlDownloadStrategyError.new(url, "not a GitHub release asset url") unless match

    @owner, @repo, @tag, @filename = match.captures
  end

  private

  def asset
    @asset ||= begin
      release = GitHub::API.open_rest(
        "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}",
        scopes: ["repo"],
      )
      found = release.fetch("assets").find { |item| item.fetch("name") == @filename }
      raise CurlDownloadStrategyError.new(url, "no release asset named #{@filename}") unless found

      found
    end
  end

  def resolve_url_basename_time_file_size(_url, timeout: nil)
    [
      asset.fetch("url"),
      @filename,
      Time.parse(asset.fetch("updated_at")),
      asset.fetch("size"),
      asset.fetch("content_type"),
      false,
    ]
  end

  def _fetch(url:, resolved_url:, timeout:)
    token = [ENV["GH_TOKEN"], ENV["HOMEBREW_GITHUB_API_TOKEN"], GitHub::API.credentials]
            .find(&:present?)
            .to_s
    headers = ["Accept: application/octet-stream"]
    headers << "Authorization: Bearer #{token}" unless token.empty?
    curl_download(resolved_url, to: temporary_path, try_partial: @try_partial, timeout: timeout, header: headers)
  end
end

class Ownsearch < Formula
  desc "MCP server that queries search engines directly and merges the results"
  homepage "https://github.com/devops-infinity/ownsearch"
  version "2.1.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v2.1.0/ownsearch-aarch64-apple-darwin.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "29388a872356209b1db1007a85ccc999a1835b0c1f0fc7bfe48be261137ee07c"
    end

    on_intel do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v2.1.0/ownsearch-x86_64-apple-darwin.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "56a74e8bbf7af3d2f88f4a1dd8a914f38afdc3360e29f72ca207926481a55ec0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v2.1.0/ownsearch-aarch64-unknown-linux-gnu.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "261f0d3351d9fe0d9c8225d59986cf4f47a8b3e14f40cc9da9e79f5d55625a74"
    end

    on_intel do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v2.1.0/ownsearch-x86_64-unknown-linux-gnu.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "1e1c841890c9dda568a180f281ed751681bcf2fbb3b0b99d3f698956c61c2e69"
    end
  end

  def install
    bin.install "ownsearch"
  end

  test do
    assert_match "OwnSearch 2.1.0", shell_output("#{bin}/ownsearch --version")
  end
end
