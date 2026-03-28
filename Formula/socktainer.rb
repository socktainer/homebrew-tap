class Socktainer < Formula
  version "0.9.1"
  desc "Docker-compatible REST API on top of Apple container"
  homepage "https://github.com/socktainer/socktainer"
  url "https://github.com/socktainer/socktainer/releases/download/v#{version}/socktainer.zip"
  sha256 "27298733dc662a28c8597ee92251d0023adbfd09877a6d685349ae2a6a5c9874"
  livecheck do
    url(:url)
    strategy(:github_latest)
  end

  conflicts_with "socktainer-next", because: "both install `socktainer` binaries"

  license "Apache-2.0"
  head "https://github.com/socktainer/socktainer.git", branch: "main"

  depends_on :macos
  depends_on xcode: ["26.0", :build] if build.head?
  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    if build.head?
      ENV["GIT_COMMIT"] = Utils.git_head
      system("swift", "build", "--disable-sandbox", "--configuration", "release")
      release_dir = buildpath / ".build/release"
      bin.install(release_dir / "socktainer")
    else
      bin.install("socktainer")
    end
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
      Requires native Apple macOS container (https://github.com/apple/container)
      Currently, Apple container is not a dependency of this Formula.
    EOS
  end

  test do
    assert_match "socktainer", shell_output("#{bin}/socktainer --help")
  end
end
