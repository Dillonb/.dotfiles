{ config, lib, ... }:
{
  networking = {
    useDHCP = lib.mkDefault true;
    wireless = {
      enable = true;
      secretsFile = config.age.secrets."wireless.env".path;
      networks = {
        dgb.pskRaw = "ext:DGB_PSK";
      };
    };
  };

}
