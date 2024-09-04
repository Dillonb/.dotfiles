{ config, ... }:
{
  services.ddclient = {
    enable = true;
    protocol = "namecheap";
    username = "dgb.sh";
    use = "web,web=ifconfig.me/ip";
    passwordFile = config.age.secrets."dgb.sh-dynamic-dns-password".path;
    domains = [
      "home.dgb.sh"
      "@"
    ];
  };
}
