{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.miniflux = {
    enable = true;
    package = pkgs.unstable.miniflux;
    adminCredentialsFile = config.age.secrets."miniflux-admin-creds".path;
    config = {
      LISTEN_ADDR = "localhost:${toString config.dgbCustom.miniflux.port}";
    };
  };
}
