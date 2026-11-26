cask "katamaran" do
  version "0.10.0"
  sha256 "96d83fe49d09f7397201366e9f9ac76bdcdb227e99259fb433bbd081ba78bdf6"

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
