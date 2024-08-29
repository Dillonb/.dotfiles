{ pkgs, ... }:
let
  plex-version = "1.41.0.8911-1bd569c5f";
  plex-package = pkgs.plex.override {
    plexRaw = pkgs.plexRaw.overrideAttrs (old: rec {
      version = plex-version;
      src = pkgs.fetchurl {
        url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
        sha256 = "sha256-2emtJM5XBgwkZ/D04AEn4RxKQW7Nhexr4r+AJq6Q/ds=";
      };
    });
  };
in
{
  services.plex =
    {
      enable = true;
      user = "dillon";
      package = plex-package;
      extraPlugins = [
        (builtins.path {
          name = "Hama.bundle";
          path = pkgs.fetchFromGitHub {
            owner = "ZeroQI";
            repo = "Hama.bundle";
            "rev" = "daa43001bc1ced67aa2f90de8c61e5a1d109e862";
            sha256 = "tUzjbE4rNgocZFg9lCXBP9sAe/cPGInYj2P/RXvpbmM=";
          };
        })
      ];
      extraScanners = [
        (pkgs.fetchFromGitHub {
          owner = "ZeroQI";
          repo = "Absolute-Series-Scanner";
          rev = "048e8001a525ba1c04afda2aa2005feb74709eb8";
          sha256 = "+j4BiGjB3vAmMYjALI+4SNyj1zlriKE0qaCNQOlmpuY=";
        })
      ];
    };

    services.sonarr = {
      enable = true;
      package = pkgs.unstable.sonarr;
      user = "dillon";
    };

    services.radarr = {
      enable = true;
      package = pkgs.unstable.radarr;
      user = "dillon";
    };

    services.sabnzbd = {
      enable = true;
      user = "dillon";
    };

    services.transmission = {
      enable = true;
      package = pkgs.unstable.transmission;
      user = "dillon";
      settings = {
        incomplete-dir = "/zpool/transmission/incomplete";
        incomplete-dir-enabled = true;
        download-dir = "/zpool/transmission/complete";

        bind-address-ipv4 = "0.0.0.0";
        cache-size-mb = 4;
        dht-enabled = true;
        encryption = 1;
        message-level = 2;
        rpc-bind-address = "127.0.0.1";
        rpc-enabled = true;
        rpc-host-whitelist = "127.0.0.1";
        rpc-host-whitelist-enabled = true;
        rpc-authentication-required = false;
        rpc-port = 9091;
        rpc-url = "/transmission/";
      };
    };

    services.prowlarr = {
      enable = true;
      package = pkgs.unstable.prowlarr;
    };

    services.tautulli = {
      enable = true;
      package = pkgs.unstable.tautulli;
      user = "dillon";
    };
}
