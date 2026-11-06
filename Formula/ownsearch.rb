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
  version "6.0.1"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v6.0.1/ownsearch-aarch64-apple-darwin.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "b0baa13e023074357e345a8416bd47dd4c5a9437c2c87076288906737912b6bf"
    end

    on_intel do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v6.0.1/ownsearch-x86_64-apple-darwin.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "06781d0cb5465a5d76364ac0d1cb5ff25346a19d07aea33616a674113b72932c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v6.0.1/ownsearch-aarch64-unknown-linux-gnu.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "49ed67e454394ca4b3ac55871ac323812fe61239cdacfaa8697db0be7ef70cca"
    end

    on_intel do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v6.0.1/ownsearch-x86_64-unknown-linux-gnu.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "b62d9e99c84b8cd37d870cc22297e9d396be7cb5b2b4433786b36b786167970e"
    end
  end

  def install
    bin.install "ownsearch"
  end

  test do
    assert_match "OwnSearch 6.0.1", shell_output("#{bin}/ownsearch --version")
  end
end
