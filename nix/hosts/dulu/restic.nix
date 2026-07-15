{
  config,
  lib,
  pkgs,
  ...
}:

let
  sqlite_backup_dir = "/var/backup/sqlite";
  sqlite_dbs = [
    "/var/lib/sonarr/.config/NzbDrone/sonarr.db"
    "/var/lib/radarr/.config/Radarr/radarr.db"
    "/var/lib/private/prowlarr/prowlarr.db"
    "/var/lib/bazarr/db/bazarr.db"
    "/var/lib/sabnzbd/admin/history1.db"
    "/var/lib/tautulli/tautulli.db"
    "/var/lib/audiobookshelf/config/absdatabase.sqlite"
    "/var/lib/ombi/Ombi.db"
    "/var/lib/ombi/OmbiExternal.db"
    "/var/lib/ombi/OmbiSettings.db"
    "/var/lib/jellyfin/data/jellyfin.db"
    "/var/lib/plex/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db"
    "/var/lib/plex/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.blobs.db"
  ];
  sqlite_backup = pkgs.writeShellApplication {
    name = "backup-sqlite-databases";
    runtimeInputs = [ pkgs.sqlite ];
    text = ''
      ${lib.concatMapStringsSep "\n" (
        db:
        let
          db_name = baseNameOf db;
          output = "${sqlite_backup_dir}/${db_name}";
        in
        ''
          sqlite3 ${lib.escapeShellArg db} ${lib.escapeShellArg ".backup '${output}'"}
          echo "Backed up ${db} to ${output}"
        ''
      ) sqlite_dbs}
    '';
  };
in
{
  systemd.tmpfiles.rules = [ "d ${sqlite_backup_dir} 0700 root root -" ];

  services.restic = {
    backups = {
      dulu = {
        initialize = true;
        passwordFile = config.age.secrets.restic.path;
        rcloneConfigFile = "${config.services.syncthing.settings.folders."rclone-config".path}/rclone.conf";
        user = "root";
        backupPrepareCommand = lib.getExe sqlite_backup;

        paths = [
          "/home/dillon"
          "/zpool"
          "/etc"
          "/var/lib/syncthing-data"
          "/var/lib/plex"
          "/var/lib/jellyfin"
          "/var/lib/sonarr"
          "/var/lib/private"
          "/var/lib/radarr"
          "/var/lib/sabnzbd"
          "/var/lib/transmission"
          "/var/lib/tautulli"
          "/var/lib/plexpy"
          "/var/lib/ombi"
          "/var/lib/mosquitto"
          "/var/lib/pihole"
          "/var/lib/zigbee2mqtt"
          "/var/backup/postgresql"
          "/var/lib/anki-sync-server"
          "/var/lib/bazarr"
          "/var/lib/audiobookshelf"
          "/var/www"
        ];

        exclude = [
          "/zpool/Media"
          "/zpool/no-backup"
          "/zpool/timemachine"
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
