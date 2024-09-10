{ config, ... }:
{
  users.users.netdata.extraGroups = [
    "agenix" # secrets access
  ];
  services.netdata = {
    enable = true;
    configDir = {
      "health_alarm_notify.conf" = config.age.secrets."netdata-discord.conf".path;
    };
  };
}
