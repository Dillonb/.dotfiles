{ config, ... }:
{
  services.restic = {
    backups = {
      dulu = {
        initialize = true;
        passwordFile = config.age.secrets.restic.path;
        rcloneConfigFile = "${config.services.syncthing.settings.folders."rclone-config".path}/rclone.conf";
        user = "root";

        paths = [
          "/home/dillon"
          "/zpool"
          "/etc"
          "/var/lib/syncthing-data"
          "/var/lib/plex"
          "/var/lib/sonarr"
          "/var/lib/private"
          "/var/lib/radarr"
          "/var/lib/sabnzbd"
          "/var/lib/transmission"
          "/var/lib/tautulli"
          "/var/www"
        ];

        exclude = [
          "/zpool/Media"
          "/zpool/no-backup"
          "/home/dillon/Media"
          "/home/dillon/Dropbox"
          "/home/dillon/.dropbox"
          "/home/dillon/.cache"
          "/home/dillon/.cargo"
          "/home/dillon/.local"
          "/home/dillon/.rustup"
          "/home/dillon/.vscode-server"
          "/home/dillon/src/meta-pine64"
          "/zpool/transmission/incomplete"
          "/zpool/sabnzbd/incomplete"
        ];

        repository = "rclone:b2-media:restic-dulu";

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
