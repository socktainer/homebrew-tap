class SocktainerNext < Formula
  version "0.9.1-next.202603171208-cdf0ee1"
  desc "Docker-compatible REST API on top of Apple container"
  homepage "https://github.com/socktainer/socktainer"
  url "https://github.com/socktainer/prereleases/releases/download/v#{version}/socktainer.zip"
  sha256 "0d04ca73f6eefff73736eaa240c6f62d5ceb6d65455753643b5c15a86d9e624d"
  livecheck do
    url(:url)
    strategy(:github_latest)
  end

  license "Apache-2.0"

  depends_on :macos
  depends_on arch: :arm64
  depends_on macos: :tahoe

  conflicts_with "socktainer", because: "both install `socktainer` binaries"


  def install
      bin.install("socktainer")
  end

  service do
    run [opt_bin / "socktainer"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var / "log/socktainer.log"
    error_log_path var / "log/socktainer-error.log"
  end

  def caveats
    <<~EOS
      This is a pre-release version!

      Requires native Apple macOS container (https://github.com/apple/container)
      Currently, Apple container is not a dependency of this Formula.
    EOS
  end

  test do
    assert_match "socktainer", shell_output("#{bin}/socktainer --help")
  end
end
