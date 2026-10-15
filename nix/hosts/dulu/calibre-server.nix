{ config, ... }:
{
  # sudo -u calibre-server calibre-server --manage-users
  services.calibre-server = {
    enable = true;
    host = "127.0.0.1";
    port = config.dgbCustom.ports.calibreServer;
    auth = {
      enable = true;
      mode = "basic";
    };
  };
}
