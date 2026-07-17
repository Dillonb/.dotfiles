{ config, pkgs, ... }: {
  services.postgresql = {
    ensureDatabases = [ "atticd" ];
    ensureUsers = [
      {
        name = "atticd";
        ensureDBOwnership = true;
      }
    ];
  };

  services.atticd = {
    enable = true;
    environmentFile = config.age.secrets."atticd-env".path;
    package = pkgs.unstable.attic-server;
    settings = {
      listen = "127.0.0.1:${toString config.dgbCustom.ports.atticd}";
      api-endpoint = "https://attic.dgb.sh/";
      allowed-hosts = [ "attic.dgb.sh" ];
      database.url = "postgresql:///atticd?host=/run/postgresql&user=atticd";
    };
  };
}
