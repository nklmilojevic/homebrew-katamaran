cask "katamaran" do
  version "0.9.1"
  sha256 "aafde47cd942991817a9d6b42530c2444114ed1c8b47dffbf0c0cfe72c6447d5"

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
