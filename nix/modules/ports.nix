{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  mkPort =
    default: description:
    mkOption {
      type = types.port;
      inherit default description;
    };
in
{
  options.dgbCustom.ports = {
    plex = mkPort 32400 "Plex Media Server";
    jellyfin = mkPort 8096 "Jellyfin media server";
    jellyfinDev = mkPort 8097 "Jellyfin (dev instance)";
    radarr = mkPort 7878 "Radarr";
    sonarr = mkPort 8989 "Sonarr";
    sabnzbd = mkPort 8081 "SABnzbd";
    transmission = mkPort 9091 "Transmission RPC/web UI";
    tautulli = mkPort 8181 "Tautulli";
    sk = mkPort 8111 "Shoko";
    nextcloud = mkPort 1010 "Nextcloud";
    copyparty = mkPort 3923 "copyparty";
    ombi = mkPort 5000 "Ombi";
    audiobookshelf = mkPort 13378 "Audiobookshelf";

    miniflux = mkPort 8080 "Miniflux";
    nixServe = mkPort 5001 "nix-serve";
    atticd = mkPort 8091 "atticd";
    ankiSync = mkPort 27701 "Anki sync server";

    homeAssistant = mkPort 8123 "Home Assistant";
    zigbee2mqttFrontend = mkPort 8099 "zigbee2mqtt web frontend";
    mqtt = mkPort 1883 "Mosquitto MQTT broker";
    matter = mkPort 5540 "Matter server (UDP)";

    teamspeakWeb = mkPort 8000 "ts3 status page";
  };

  # Fail the build if two services are configured to share a port.
  config.assertions =
    let
      ports = config.dgbCustom.ports;
      byPort = lib.foldl' (
        acc: name:
        let
          p = toString ports.${name};
        in
        acc // { ${p} = (acc.${p} or [ ]) ++ [ name ]; }
      ) { } (lib.attrNames ports);
      collisions = lib.filterAttrs (_: users: lib.length users > 1) byPort;
    in
    [
      {
        assertion = collisions == { };
        message =
          "dgbCustom.ports has duplicate port assignments: "
          + lib.concatStringsSep "; " (
            lib.mapAttrsToList (
              port: users: "port ${port} used by ${lib.concatStringsSep ", " users}"
            ) collisions
          );
      }
    ];
}
