{ config, lib, ... }: {
  sops.secrets."wireless.env" = {
    sopsFile = ../secrets/misc.yaml;
    owner = "wpa_supplicant";
    restartUnits = [ "wpa_supplicant.service" ];
  };

  networking = {
    useDHCP = lib.mkDefault true;
    wireless = {
      enable = true;
      secretsFile = config.sops.secrets."wireless.env".path;
      networks = {
        dgb.pskRaw = "ext:DGB_PSK";
      };
    };
  };

}
