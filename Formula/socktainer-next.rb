class SocktainerNext < Formula
  version "0.7.1-next.202601292000-4dfe907"
  desc "Docker-compatible REST API on top of Apple container"
  homepage "https://github.com/socktainer/socktainer"
  url "https://github.com/socktainer/prereleases/releases/download/v#{version}/socktainer.zip"
  sha256 "235870b8a3234846cd57c910fc4b8438b36fc39386c359ea442c8bd110dcccc7"
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
