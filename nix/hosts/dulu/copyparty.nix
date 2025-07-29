{ config, ... }:
{
  services.copyparty = {
    enable = true;

    accounts = {
      "dgb".passwordFile = config.age.secrets.copyparty-dgb.path;
    };

    volumes = {
      "/zpool" = {
        path = "/zpool";
        access = {
          rwmd = "dgb";
        };
      };
    };
  };

  users.users."${config.services.copyparty.user}".extraGroups = [
    "agenix" # secrets access
  ];
}
