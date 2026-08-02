{ config, ... }: {
  sops.secrets."dgb.sh-dynamic-dns-password" = {
    sopsFile = ../../secrets/dulu.yaml;
    restartUnits = [ "ddclient.service" ];
  };

  services.ddclient = {
    enable = true;
    protocol = "namecheap";
    username = "dgb.sh";
    usev4 = "webv4, webv4=ipify-ipv4";
    passwordFile = config.sops.secrets."dgb.sh-dynamic-dns-password".path;
    domains = [ "@" ];
  };
}
