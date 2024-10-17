{
  networking.firewall.allowedTCPPorts = [
    # home assistant
    8123
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

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = true;
      permit_join = false;
      serial = {
        # port = "tcp://slzb-06m.local:6638";
        port = "tcp://192.168.0.25:6638";
        baudrate = 115200;
        adapter = "ember";
        disable_led = false;
      };
      advanced.transmit_power = 20;
      mqtt = {
        server = "mqtt://localhost:1883";
      };
    };
  };
}
