class SocktainerNext < Formula
  version "1.6.1-next.202611120925-fb8f893"
  desc "Docker-compatible REST API on top of Apple container"
  homepage "https://github.com/socktainer/socktainer"
  url "https://github.com/socktainer/prereleases/releases/download/v#{version}/socktainer.zip"
  sha256 "0a83a0bfc00aadf053bec1c7297fcb95fef2539fc437aeb5fbd13555da487278"
  livecheck do
    url(:url)
    strategy(:github_latest)
  end

  license "Apache-2.0"

  depends_on arch: :arm64

  on_macos do
    depends_on macos: :tahoe
  end

  conflicts_with "socktainer", because: "both install `socktainer` binaries"

  def install
    bin.install("socktainer")
  end

  service do
    args = [opt_bin / "socktainer"]
    args << "--no-check-compatibility" if ENV["SOCKTAINER_NO_CHECK_COMPATIBILITY"] == "1"
    run args
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

      To disable the Apple container version compatibility check for the service:
        SOCKTAINER_NO_CHECK_COMPATIBILITY=1 brew services restart socktainer-next
    EOS
  end

  test do
    assert_match "socktainer", shell_output("#{bin}/socktainer --help")
  end
end
