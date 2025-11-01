{
  pkgs,
  config,
  lib,
  ...
}:
{

  systemd.services.miniflux-dbsetup.serviceConfig = lib.mkForce {
    Type = "oneshot";
    User = config.services.postgresql.superUser;
    ExecStart = pkgs.writeScript "miniflux-pre-start" ''
      #!${pkgs.runtimeShell}
      echo "no-op"
    '';
  };

  services.miniflux = {
    enable = true;
    package = pkgs.unstable.miniflux;
    adminCredentialsFile = config.age.secrets."miniflux-admin-creds".path;
    config = {
      LISTEN_ADDR = "localhost:${toString config.dgbCustom.miniflux.port}";
    };
  };
}
