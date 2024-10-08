#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix nix-prefetch curl jq
CURRENT_PLEX_VER=`nix-instantiate --eval -E '(import ./plex.nix).version' | tr -d '"'`
if [ -z "${1}" ]; then
  PLEX_VER=`curl -s https://plex.tv/api/downloads/5.json | jq ".computer.Linux.version" -r`
else
  PLEX_VER=$1
fi
echo "Latest version is $PLEX_VER"
echo "Current version is $CURRENT_PLEX_VER"

if [ "$PLEX_VER" != "$CURRENT_PLEX_VER" ]; then
  echo "MISMATCH, trying to update..."
  NIX_HASH=`nix-prefetch -s --option extra-experimental-features flakes "{ pkgs }: pkgs.fetchurl {
    url = \"https://downloads.plex.tv/plex-media-server-new/${PLEX_VER}/debian/plexmediaserver_${PLEX_VER}_amd64.deb\";
  }"`

  cat <<EOF > plex.nix
{
  version = "$PLEX_VER";
  sha256 = "$NIX_HASH";
}
EOF
else
  echo "Already up to date."
fi
