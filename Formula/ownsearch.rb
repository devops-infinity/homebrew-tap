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
  version "2.4.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v2.4.0/ownsearch-aarch64-apple-darwin.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "5a1897eb552ba48ed60a456e84954cb40f6d2e71ff2dbc9fc8d54a3011bd82fa"
    end

    on_intel do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v2.4.0/ownsearch-x86_64-apple-darwin.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "3bf22f05a5e9afbc4e98c68547f0d69507fe4335b1102cba450736a5a5095244"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v2.4.0/ownsearch-aarch64-unknown-linux-gnu.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "bfd7a6421d4f766ba2c1cbf628296fe75b31be59e8b89a5248c923f78372153d"
    end

    on_intel do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v2.4.0/ownsearch-x86_64-unknown-linux-gnu.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "79a3b771835973a702c1139e4626e751638eb4399f6776985952fc6f8969d1f1"
    end
  end

  def install
    bin.install "ownsearch"
  end

  test do
    assert_match "OwnSearch 2.4.0", shell_output("#{bin}/ownsearch --version")
  end
end
