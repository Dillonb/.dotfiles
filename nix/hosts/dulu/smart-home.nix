{ config, pkgs, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [
    # home assistant
    8123
    config.services.zigbee2mqtt.settings.frontend.port
  ];
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  # TODO: remove this next line when I upgrade to 25.04
  # See: https://github.com/NixOS/nixpkgs/commit/99eabc0ab3dab1634eadc0092fb2efad8321d9c3#diff-ae914e83933020486ee71b87a797531d86925ecb8d2d4544b028b23e2fc2c8b7
  systemd.services.zigbee2mqtt.serviceConfig.SystemCallFilter = [ "@chown" ];

  services.zigbee2mqtt = {
    enable = true;
    package = pkgs.unstable.zigbee2mqtt_2;
    settings = {
      homeassistant = true;
      permit_join = false;
      serial = {
        # TODO: can't get mDNS working inside the systemd unit.
        # port = "tcp://slzb-06m.local:6638";
        # port = "mdns://slzb-06";

        # $ avahi-resolve --name slzb-06m.local
        port = "tcp://192.168.0.43:6638";
        # port = "tcp://192.168.0.25:6638";

        baudrate = 115200;
        adapter = "ember";
        disable_led = false;
      };
      advanced.transmit_power = 20;
      mqtt = {
        server = "mqtt://localhost:1883";
      };
      frontend = {
        port = 8099;
      };
    };
  };

  systemd.services.zigbee2mqtt.serviceConfig = {
    Restart = lib.mkForce "always";
    RestartSec = "10";
  };
}
