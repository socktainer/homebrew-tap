class SocktainerNext < Formula
  version "1.0.0-next.202607061925-1a63acc"
  desc "Docker-compatible REST API on top of Apple container"
  homepage "https://github.com/socktainer/socktainer"
  url "https://github.com/socktainer/prereleases/releases/download/v#{version}/socktainer.zip"
  sha256 "a079f382002019dff187815424963d67fa56675489797641ea70eb8b65f01eb2"
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
