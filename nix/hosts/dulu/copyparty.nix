{ config, lib, ... }:
{
  services.copyparty = {
    enable = true;

    user = "dillon";
    group = "users";

    accounts =
      let
        users = [
          "dgb"
          "iris"
          "snacks"
          "epiccookie"
          "dehowell"
          "c"
        ];
      in
      lib.listToAttrs (
        map (user: {
          name = user;
          value = {
            passwordFile = config.age.secrets."copyparty-${user}".path;
          };
        }) users
      );

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
            "c"
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
      "/books" = {
        path = "/zpool/fileshares/books";
        access = {
          rwmd = [
            "dgb"
            "snacks"
            "epiccookie"
            "dehowell"
            "c"
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
