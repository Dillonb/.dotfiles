# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Support emulating arm64 binaries
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Disable SSD power management to stop / from vanishing
  # https://lore.kernel.org/linux-nvme/YnR%2FFiWbErNGXIx+@kbusch-mbp/T/
  boot.kernelParams = [ "nvme_core.default_ps_max_latency_us=0" ];

  # ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "zpool" ];
  services.zfs.autoScrub.enable = true;

  virtualisation.docker.enable = true;

  networking.hostId = "ad4d1b00";
  system.stateVersion = "24.05";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 9999 ];
  };

  environment.systemPackages = with pkgs; [
    weechat
  ];

  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;

    extraConfig = ''
      workgroup = DGB
      server string = smbnix
      netbios name = smbnix
      server role = standalone server
      map to guest = bad user
    '';

    shares = {
      zpool = {
        path = "/zpool";
        browseable = "yes";
        "guest ok" = "no";
        "read only" = "no";
        "create mask" = "755";
      };
    };
  };

  services.plex =
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


  services.nginx = {
    enable = true;
    virtualHosts = {
      "dgb.sh" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/html/dgb.sh";
      };

      "dgb.gay" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/html/dgb.gay";
      };

      "picrite.dgb.gay" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/html/picrite.dgb.gay";
      };

      "kanin.dgb.gay" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/html/dgb.gay/kanin";
      };

      "dulu.dgb.sh" = {
        forceSSL = true;
        enableACME = true;
        # http2 can more performant for streaming: https://blog.cloudflare.com/introducing-http2/
        http2 = true;
        # from https://nixos.wiki/wiki/Plex
        extraConfig = ''
          #Some players don't reopen a socket and playback stops totally instead of resuming after an extended pause
          send_timeout 100m;

          # Why this is important: https://blog.cloudflare.com/ocsp-stapling-how-cloudflare-just-made-ssl-30/
          ssl_stapling on;
          ssl_stapling_verify on;

          ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
          ssl_prefer_server_ciphers on;
          #Intentionally not hardened for security for player support and encryption video streams has a lot of overhead with something like AES-256-GCM-SHA384.
          ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';

          # Forward real ip and host to Plex
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Host $server_addr;
          proxy_set_header Referer $server_addr;
          # Wiki said to enable this, but this breaks CORS, so commented out
          # proxy_set_header Origin $server_addr;

          # Plex has A LOT of javascript, xml and html. This helps a lot, but if it causes playback issues with devices turn it off.
          gzip on;
          gzip_vary on;
          gzip_min_length 1000;
          gzip_proxied any;
          gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
          gzip_disable "MSIE [1-6]\.";

          # Nginx default client_max_body_size is 1MB, which breaks Camera Upload feature from the phones.
          # Increasing the limit fixes the issue. Anyhow, if 4K videos are expected to be uploaded, the size might need to be increased even more
          client_max_body_size 100M;

          # Plex headers
          proxy_set_header X-Plex-Client-Identifier $http_x_plex_client_identifier;
          proxy_set_header X-Plex-Device $http_x_plex_device;
          proxy_set_header X-Plex-Device-Name $http_x_plex_device_name;
          proxy_set_header X-Plex-Platform $http_x_plex_platform;
          proxy_set_header X-Plex-Platform-Version $http_x_plex_platform_version;
          proxy_set_header X-Plex-Product $http_x_plex_product;
          proxy_set_header X-Plex-Token $http_x_plex_token;
          proxy_set_header X-Plex-Version $http_x_plex_version;
          proxy_set_header X-Plex-Nocache $http_x_plex_nocache;
          proxy_set_header X-Plex-Provides $http_x_plex_provides;
          proxy_set_header X-Plex-Device-Vendor $http_x_plex_device_vendor;
          proxy_set_header X-Plex-Model $http_x_plex_model;

          # Websockets
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";

          # Buffering off send to the client as soon as the data is received from Plex.
          proxy_redirect off;
          proxy_buffering off;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:32400/";
        };
      };

      "plex-requests.dgb.sh" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3579/";
        };
      };

      "jellyfin.dgb.sh" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096/";
        };

        locations."/socket" = {
          proxyWebsockets = true;
        };
      };

      "jellyfin-dev.dgb.sh" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8097/";
        };

        locations."/socket" = {
          proxyWebsockets = true;
        };
      };

      "r.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:7878/";
        };
      };

      "s.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8989/";
        };
      };

      "nc.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "https://127.0.0.1:1010/";
          extraConfig = ''
            client_max_body_size 10G;
            client_body_buffer_size 400M;
          '';
        };
      };

      "sab.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8081/";
        };
      };

      "t.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:9091/";
        };
      };

      "sk.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8111/";
        };
      };

      "tt.cyphe.red" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8181/";
        };
      };

    };
  };

  services.restic = {
    backups = {
      dulu = {
        initialize = true;
        passwordFile = config.age.secrets.restic.path;
        rcloneConfigFile = "${config.services.syncthing.settings.folders."rclone-config".path}/rclone.conf";
        user = "root";

        paths = [
          "/home/dillon"
          "/zpool"
          "/etc"
          "/var/lib/syncthing-data"
          "/var/www"
        ];

        exclude = [
          "/zpool/Media"
          "/zpool/no-backup"
          "/home/dillon/Media"
          "/home/dillon/Dropbox"
          "/home/dillon/.dropbox"
          "/home/dillon/.cache"
          "/home/dillon/.cargo"
          "/home/dillon/.local"
          "/home/dillon/.rustup"
          "/home/dillon/.vscode-server"
          "/home/dillon/src/meta-pine64"
          "/zpool/docker_volumes/transmission_downloads/incomplete"
        ];

        repository = "rclone:b2-media:restic-dulu";

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--keep-yearly 75"
        ];

        timerConfig = {
          OnCalendar = "00:00";
          RandomizedDelaySec = "5h";
        };
      };
    };
  };

}

