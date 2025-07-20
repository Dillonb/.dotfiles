{ config, lib, ... }:
let
  allDevices = builtins.attrNames config.services.syncthing.settings.devices;
  nixos-devices = [
    "mini"
    "battlestation"
    "dulu"
    "teamspeak-server"
    "pi4"
  ];
  syncthing-data = "/var/lib/syncthing-data";
in
{
  systemd.tmpfiles.rules = [
    "d ${syncthing-data} 770 dillon syncthing"
  ]
  ++ map (
    folder: "d ${config.services.syncthing.settings.folders.${folder}.path} 770 dillon syncthing"
  ) (builtins.attrNames config.services.syncthing.settings.folders);

  services.syncthing = {
    enable = true;
    user = "dillon";
    group = "syncthing";
    overrideDevices = true;
    overrideFolders = true;
    key = config.age.secrets."${config.networking.hostName}-syncthing.key.pem".path;
    cert = config.age.secrets."${config.networking.hostName}-syncthing.cert.pem".path;
    settings = {
      devices = {
        "desktop-windows" = {
          id = "GUZCQLR-VIACQQX-V2JEFTC-IO72U6Z-6PF4MLQ-4DTH4FM-NWXFXAO-MP5HAAX";
        };
        "teamspeak-server" = {
          id = "FA2QTLW-XOXLFNT-KG6WGGY-CXFQBKU-A4XKJMX-SCGOWSE-2M4NO4E-N3WCQAI";
        };
        "mini" = {
          id = "TMPP7GZ-25UWINW-RL4LTP5-FDCDVGU-7GPR6CW-QZWLHZS-RX5VKY5-XL43DAM";
        };
        "battlestation" = {
          id = "GVFGK6Z-NLFR24N-NJJ7GMR-RH2W2SO-D5I5DUD-ZAJHUKR-LU2JJMU-VSMOIQI";
        };
        "dulu" = {
          id = "3HS7WI5-AAIUDOL-XFPAECF-JB5QSMU-2HIBG44-MBDQSXI-T53BGPG-ADKSRQP";
        };
        "pi4" = {
          id = "QZOWDVT-6SYXCXP-5IEM3EM-VZO3ZKQ-N7X6GGS-YG4U7WD-QOFVEMF-3ALABAU";
        };
        "dgbmbp" = {
          id = "4UEJ4VX-OZLXBTQ-GHSJN7N-SIPL5ZF-JJ6NX2W-TY3KAYT-L5IE2FI-DBZOJAE";
        };
      };
      # Just folders that have this device in `devices`
      folders = lib.attrsets.filterAttrs (n: v: builtins.elem config.networking.hostName v.devices) {
        "rclone-config" = {
          path = "${syncthing-data}/rclone-config";
          devices = nixos-devices;
        };

        "ble-scale-data" = {
          path = "${syncthing-data}/ble-scale-data";
          devices = nixos-devices;
        };

        "binary-ninja" = {
          path = "${syncthing-data}/binary-ninja";
          devices = [
            "mini"
            "battlestation"
            "dulu"
          ];
        };

        "syncthing" = {
          path = "/home/dillon/Syncthing";
          devices = [
            "mini"
            "battlestation"
            "dulu"
            "dgbmbp"
          ];
        };
      };
    };
  };

  users.users.syncthing = {
    isNormalUser = false;
    isSystemUser = true;
    group = "syncthing";
    extraGroups = [ "agenix" ]; # secrets access
  };
  users.groups.syncthing = { };
}
