{ config, lib, ... }:
let
  users = [
    "dgb"
    "iris"
    "snacks"
    "epiccookie"
    "dehowell"
    "c"
    "siri"
  ];
in
{
  sops.secrets = lib.genAttrs (map (user: "copyparty-${user}") users) (name: {
    sopsFile = ../../secrets/copyparty.yaml;
    key = lib.removePrefix "copyparty-" name;
    owner = config.services.copyparty.user;
    restartUnits = [ "copyparty.service" ];
  });

  services.copyparty = {
    enable = true;

    user = "dillon";
    group = "users";

    accounts = lib.listToAttrs (
      map (user: {
        name = user;
        value = {
          passwordFile = config.sops.secrets."copyparty-${user}".path;
        };
      }) users
    );

    settings = {
      p = config.dgbCustom.ports.copyparty;
      rproxy = "1";
      xff-hdr = "X-Real-IP";
      xff-src = "lan";
    };

    volumes = {
      "/zpool" = {
        path = "/zpool";
        access = {
          rwmd = "dgb";
        };
      };
      "/syncthing" = {
        path = "/home/dillon/Syncthing";
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
            "siri"
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
      "/siri" = {
        path = "/zpool/fileshares/siri";
        access = {
          rwmd = "siri";
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
