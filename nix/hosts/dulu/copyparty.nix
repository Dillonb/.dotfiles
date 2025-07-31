{ config, ... }:
{
  services.copyparty = {
    enable = true;

    user = "dillon";
    group = "users";

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
        path = "/zpool/fileshares/panda";
        access = {
          rwmd = [
            "dgb"
            "iris"
          ];
        };
      };
      "/public" = {
        path = "/zpool/fileshares/public";
        access = {
          g = "*";
          rwmd = [ "dgb" ];
        };
      };
    };
  };
}
