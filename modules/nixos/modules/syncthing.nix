{ config, ... }:
let
  allDevices = builtins.attrNames config.services.syncthing.settings.devices;
in
{
  services.syncthing = {
    enable = true;
    overrideDevices = true;
    overrideFolders = true;
    key = config.age.secrets."${config.networking.hostName}-syncthing.key.pem".path;
    cert = config.age.secrets."${config.networking.hostName}-syncthing.cert.pem".path;
    settings = {
      devices = {
        "desktop-windows" = { id = "GUZCQLR-VIACQQX-V2JEFTC-IO72U6Z-6PF4MLQ-4DTH4FM-NWXFXAO-MP5HAAX"; };
        "teamspeak-server" = { id = "FA2QTLW-XOXLFNT-KG6WGGY-CXFQBKU-A4XKJMX-SCGOWSE-2M4NO4E-N3WCQAI"; };
        "mini" = { id = "TMPP7GZ-25UWINW-RL4LTP5-FDCDVGU-7GPR6CW-QZWLHZS-RX5VKY5-XL43DAM"; };
      };
      folders = {
        "rclone-config" = {
          path = "/var/lib/syncthing/rclone-config";
          devices = allDevices;
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
  users.groups.syncthing = {};
}
