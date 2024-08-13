# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
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

