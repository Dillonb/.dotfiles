{
  config,
  inputs,
  pkgs,
  ...
}:
let
  dataDir = "/var/lib/ts3status";
  configFile = config.age.secrets."ts3status.toml".path;
  ts3status = inputs.ts3status.packages."${pkgs.stdenv.hostPlatform.system}".default;
in
{
  systemd.services.ts3status = {
    description = "ts3status TeamSpeak 3 Status Page";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${ts3status}/bin/ts3status-rs";
      WorkingDirectory = dataDir;
      User = "teamspeak";
      Group = "teamspeak";
      Restart = "on-failure";
      StateDirectory = "ts3status";
      StateDirectoryMode = "0700";
      Environment = [ "TS3STATUS_CONFIG_PATH=${configFile}" ];
    };
  };
}
