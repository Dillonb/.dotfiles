{
  pkgs,
  config,
  lib,
  ...
}:
let
  dgbCustom = config.dgbCustom;
  isLinux = pkgs.stdenv.isLinux;
  stateVersion = "23.11";
in
{
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "home-manager-backup";
    users.${dgbCustom.username} =
      { pkgs, config, ... }:
      let
        inherit (pkgs) stdenv;
        inherit (lib) mkIf;
        linuxOnly = mkIf stdenv.isLinux;
      in
      (
        {
          home.stateVersion = stateVersion;
        }
        // lib.optionalAttrs isLinux {
          home.stateVersion = stateVersion;

          systemd = {
            user.services = {
              _1password = {
                Unit = {
                  Description = "1password gui";
                  Requires = "graphical-session.target";
                  After = "graphical-session.target";
                };

                Install = {
                  Alias = "1password.service";
                  WantedBy = [ "graphical-session.target" ];
                };

                Service = {
                  ExecStart = "${lib.getExe pkgs._1password-gui} --silent";
                  Type = "exec";
                  Restart = "always";
                };
              };
            };
          };
        }
      );
  };
}
