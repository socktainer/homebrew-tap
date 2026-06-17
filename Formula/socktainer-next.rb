class SocktainerNext < Formula
  version "1.0.0-next.202606170722-b68888e"
  desc "Docker-compatible REST API on top of Apple container"
  homepage "https://github.com/socktainer/socktainer"
  url "https://github.com/socktainer/prereleases/releases/download/v#{version}/socktainer.zip"
  sha256 "a71da06f8cbf8384ad05d105f3f7849847d265729c33974502b02b5ae4e3a12c"
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
