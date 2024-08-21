{ modulesPath, config, ... }:
{
  imports = [ "${modulesPath}/virtualisation/azure-common.nix" ];

  services.openssh.settings.PasswordAuthentication = false;

  system.stateVersion = "24.05";

  virtualisation.docker.enable = true;

  services.teamspeak3 = {
    enable = true;
    openFirewall = true;
    openFirewallServerQuery = true;
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "ts3.cyphe.red" = {
        serverAliases = [
          "currently.bingchill.ing"
          "youcantseeme.bingchill.ing"
          "ts3.bingchill.ing"
        ];
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8080/";
        };
      };
      "bingchill.ing" = {
        forceSSL = true;
        enableACME = true;
        root = "/var/www/html/bingchill.ing";
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

  users.users.teamspeak.extraGroups = [
    "agenix" # secrets access
    "syncthing" # access to syncthing data
  ];

  services.restic = {
    backups = {
      teamspeak-server = {
        initialize = true;
        passwordFile = config.age.secrets.restic.path;
        rcloneConfigFile = "${config.services.syncthing.settings.folders."rclone-config".path}/rclone.conf";
        user = "teamspeak";
        paths = [
          "/var/log/teamspeak3-server"
          "/var/lib/teamspeak3-server"
          "/var/lib/ts3status"
          "/var/www"
        ];
        repository = "rclone:proton:restic-backups/teamspeak-server";
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--keep-yearly 75"
        ];
        timerConfig = {
          OnCalendar = "00:00";
          RandomizedDelaySec = "5h";
        };
      };
    };
  };
}
