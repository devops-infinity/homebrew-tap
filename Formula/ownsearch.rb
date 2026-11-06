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
  version "5.0.3"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v5.0.3/ownsearch-aarch64-apple-darwin.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "59e463bfb05a76e51cd10ad73c61c9938249bc93eaad11fffc6b310d0964ac9c"
    end

    on_intel do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v5.0.3/ownsearch-x86_64-apple-darwin.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "24bd5daf846bc803fd1afc87a480cb012f1b971d43ae744cc1efecc1ac66482a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v5.0.3/ownsearch-aarch64-unknown-linux-gnu.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "40f122acd73437974074b9427e921962aeba240dba968427a9f7ae2a15cce186"
    end

    on_intel do
      url "https://github.com/devops-infinity/ownsearch/releases/download/v5.0.3/ownsearch-x86_64-unknown-linux-gnu.tar.gz",
          using: GitHubReleaseAssetDownloadStrategy
      sha256 "36cd42082b678308d4fffe788f3acf17b93d0abf6223db400be2a3dafa837493"
    end
  end

  def install
    bin.install "ownsearch"
  end

  test do
    assert_match "OwnSearch 5.0.3", shell_output("#{bin}/ownsearch --version")
  end
end
