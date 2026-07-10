class SocktainerNext < Formula
  version "1.1.0-next.202607101936-a883fbb"
  desc "Docker-compatible REST API on top of Apple container"
  homepage "https://github.com/socktainer/socktainer"
  url "https://github.com/socktainer/prereleases/releases/download/v#{version}/socktainer.zip"
  sha256 "72e725da7b67e08621758daab21179ec839e64a8ac669d5692f8c8074c1bafca"
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
