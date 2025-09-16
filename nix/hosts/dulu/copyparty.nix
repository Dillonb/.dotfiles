{ config, ... }:
{
  services.copyparty = {
    enable = true;

    user = "dillon";
    group = "users";

    accounts = {
      "dgb".passwordFile = config.age.secrets.copyparty-dgb.path;
      "iris".passwordFile = config.age.secrets.copyparty-iris.path;
      "snacks".passwordFile = config.age.secrets.copyparty-snacks.path;
      "epiccookie".passwordFile = config.age.secrets.copyparty-epiccookie.path;
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
      "/dwh" = {
        path = "/zpool/fileshares/dwh";
        access = {
          rwmd = [
            "dgb"
            "snacks"
            "epiccookie"
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
