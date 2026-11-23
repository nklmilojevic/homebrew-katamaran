cask "katamaran" do
  version "0.8.0"
  sha256 "56a89c20d43c78b98f134ffe5cd3eb99f336b8359653bcbf25a54f27b1367051"

  url "https://github.com/nklmilojevic/katamaran/releases/download/v#{version}/Katamaran-#{version}.dmg"
  name "Katamaran"
  desc "Fast Docker containers and Linux machines for Apple silicon Macs"
  homepage "https://github.com/nklmilojevic/katamaran"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :sequoia
  depends_on arch: :arm64

  app "Katamaran.app"
  binary "#{appdir}/Katamaran.app/Contents/MacOS/katamaran"
  binary "#{appdir}/Katamaran.app/Contents/MacOS/katamaran", target: "kat"

  uninstall quit:      "dev.katamaran.app",
            launchctl: "dev.katamaran.daemon"

  zap trash: [
    "~/.katamaran",
    "~/Library/Preferences/dev.katamaran.app.plist",
  ]
end
