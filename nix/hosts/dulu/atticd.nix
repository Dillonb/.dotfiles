{ config, ... }:
{
  services.atticd = {
    enable = true;
    environmentFile = config.age.secrets."atticd-env".path;
    settings = {
      listen = "127.0.0.1:8091";
      api-endpoint = "https://attic.dgb.sh/";
      allowed-hosts = [ "attic.dgb.sh" ];
    };
  };
}
