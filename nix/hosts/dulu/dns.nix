{ config, ... }:
{
  services.ddclient = {
    enable = true;
    protocol = "namecheap";
    username = "dgb.sh";
    usev4 = "webv4, webv4=ipify-ipv4";
    passwordFile = config.age.secrets."dgb.sh-dynamic-dns-password".path;
    domains = [ "@" ];
  };
}
