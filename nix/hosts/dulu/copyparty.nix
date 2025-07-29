{ config, ... }:
{
  services.copyparty = {
    enable = true;

    accounts = {
      "dgb".passwordFile = config.age.secrets.copyparty-dgb.path;
      "iris".passwordFile = config.age.secrets.copyparty-iris.path;
    };

    volumes = {
      "/zpool" = {
        path = "/zpool";
        access = {
          rwmd = "dgb";
        };
      };
      "/panda" = {
        path = "/zpool/panda";
        access = {
          rwmd = [
            "dgb"
            "iris"
          ];
        };
      };
    };
  };

  users.users."${config.services.copyparty.user}".extraGroups = [
    "agenix" # secrets access
    "users"
  ];
}
