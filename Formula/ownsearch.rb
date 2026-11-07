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
  version "7.0.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v7.0.0/ownsearch-aarch64-apple-darwin.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "fbba57ee0fb6b7d0b810d52e145a74f5731dddb0a11481ca2749741c3f05b0f4"
    end

    on_intel do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v7.0.0/ownsearch-x86_64-apple-darwin.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "8e1395e31be7314463d931d0e24338857d3eaf7e71843abf5c6af782d1037f5b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v7.0.0/ownsearch-aarch64-unknown-linux-gnu.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "b080b6d5674731949c967886ae3d6941840cdfb9f3f205484937b225eeb64597"
    end

    on_intel do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v7.0.0/ownsearch-x86_64-unknown-linux-gnu.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "12ab12955e918d982088b6504152e2e64703c3dba98dba78dfba88b4935655be"
    end
  end

  def install
    bin.install "ownsearch"
  end

  test do
    assert_match "OwnSearch 7.0.0", shell_output("#{bin}/ownsearch --version")
  end
end
