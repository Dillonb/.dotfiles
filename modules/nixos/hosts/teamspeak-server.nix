{ modulesPath, lib, pkgs, ... }:

let
rclone-config = /home/dillon/.config/rclone/rclone.conf;
in
{
  imports = [ "${modulesPath}/virtualisation/azure-common.nix" ];

  services.openssh.settings.PasswordAuthentication = false;

  system.stateVersion = "24.05";

  virtualisation.docker.enable = true;

  services.nginx = {
    enable = true;
    virtualHosts = {
      "ts3.cyphe.red" = {
        serverAliases = [
          "currently.bingchill.ing"
          "youcantseeme.bingchill.ing"
          "ts3.bingchill.ing"
        ];
        addSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8080/";
        };
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # SSH
      80 443 # Web
    ];
  };

  users.users.teamspeak.extraGroups = [ "agenix" ]; # secrets access
  services.restic = {
    backups = {
      teamspeak-server = {
        initialize = true;
        rcloneConfigFile = rclone-config;
        passwordFile = "${(pkgs.writeText "restic-password" "password")}"; # pls no hack
        user = "teamspeak";
        paths = [
          "/var/log/teamspeak3-server"
          "/var/lib/teamspeak3-server"
        ];
        repository = "rclone:proton:restic-backups/teamspeak-server";
        pruneOpts = [
          "--keep-daily 7"
            "--keep-weekly 5"
            "--keep-monthly 12"
            "--keep-yearly 75"
        ];
      };
    };
  };
}
