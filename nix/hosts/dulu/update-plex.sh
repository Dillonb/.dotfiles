#!/usr/bin/env bash
CURRENT_PLEX_VER=`nix-instantiate --eval -E '(import ./plex.nix).version' | tr -d '"'`
if [ -z "${1}" ]; then
  TOKEN=$(cat /run/agenix/plex-token)
  URL=$(curl -Ls -o /dev/null -w %{url_effective} https://plex.tv/downloads/latest/5\?channel\=8\&build\=linux-x86_64\&distro\=debian\&X-Plex-Token\=$TOKEN)
  PLEX_VER=$(echo $URL | cut -d/ -f5)
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
