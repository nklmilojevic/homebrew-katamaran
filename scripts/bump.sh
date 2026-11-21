#!/usr/bin/env bash
# Regenerates Casks/katamaran.rb for the given release tag (for example v0.1.0)
# from the release's Katamaran-<version>.dmg.sha256 asset.
set -euo pipefail

tag="${1:?usage: bump.sh vX.Y.Z}"
if ! [[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Invalid release tag: $tag" >&2
  exit 1
fi
version="${tag#v}"
repo="nklmilojevic/katamaran"
dmg="Katamaran-${version}.dmg"

sum_line="$(gh release download "$tag" --repo "$repo" --pattern "${dmg}.sha256" --output -)"
dmg_sha="$(awk '{ print $1; exit }' <<<"$sum_line")"
if ! [[ "$dmg_sha" =~ ^[0-9a-f]{64}$ ]]; then
  echo "No valid SHA-256 checksum in ${dmg}.sha256 of $tag" >&2
  exit 1
fi

cat > Casks/katamaran.rb <<RB
cask "katamaran" do
  version "${version}"
  sha256 "${dmg_sha}"

  url "https://github.com/${repo}/releases/download/v#{version}/Katamaran-#{version}.dmg"
  name "Katamaran"
  desc "Fast Docker containers and Linux machines for Apple silicon Macs"
  homepage "https://github.com/${repo}"

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
RB
