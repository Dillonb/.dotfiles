{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  ble-scale = inputs.ble-scale.packages."${pkgs.system}".default;
in
{
  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  hardware.raspberry-pi."4".bluetooth.enable = true;

  nix.settings.trusted-users = [ "dillon" ];

  system.stateVersion = "24.05";

  environment.systemPackages = [ ble-scale ];

  systemd.services.ble-scale = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "BLE smart scale recording";
    restartIfChanged = true;
    serviceConfig = {
      ExecStart = "${ble-scale}/bin/ble-scale -d /var/lib/syncthing-data/ble-scale-data/hook -s /var/lib/syncthing-data/ble-scale-data/sqlite.db";
      User = "dillon";
      Group = "users";
      Restart = "on-failure";
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  dgbCustom.minimal = true;
}
