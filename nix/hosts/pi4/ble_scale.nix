{ pkgs, inputs, ... }:
let
  ble-scale = inputs.ble-scale.packages."${pkgs.stdenv.hostPlatform.system}".default;
in
{
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
}
