{ pkgs, ... }:
let
  plex-version = import ./plex.nix;
  plex-package = pkgs.plex.override {
    plexRaw = pkgs.plexRaw.overrideAttrs (old: rec {
      version = plex-version.version;
      src = pkgs.fetchurl {
        url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
        sha256 = plex-version.sha256;
      };
    });
  };
in
{
  services.plex = {
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
    package = pkgs.unstable.sabnzbd;
  };

  services.transmission = {
    enable = true;
    package = pkgs.unstable.transmission_3;
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
    dataDir = "/var/lib/tautulli";
    configFile = "/var/lib/tautulli/config.ini";
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "dillon";
    package = pkgs.unstable.jellyfin;
  };

  nixpkgs.overlays = [ (final: prev: { ombi = pkgs.unstable.ombi; }) ];

  services.ombi = {
    enable = true;
    user = "dillon";
    package = pkgs.unstable.ombi;
  };

  services.bazarr = {
    enable = true;
    user = "dillon";
    openFirewall = true;
    package = pkgs.unstable.bazarr;
  };

  services.audiobookshelf = {
    enable = true;
    user = "dillon";
    group = "users";
    package = pkgs.unstable.audiobookshelf;
  };

  # Increase refresh token expiry to 10 years (default is 7 days) to avoid frequent login requirements
  systemd.services.audiobookshelf.environment.REFRESH_TOKEN_EXPIRY = "315360000";
}
