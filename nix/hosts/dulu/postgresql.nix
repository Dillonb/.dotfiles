{ ... }: {
  services.postgresqlBackup = {
    enable = true;
    # pg_dumpall of every database -> /var/backup/postgresql/all.sql.zstd
    backupAll = true;
    compression = "zstd";
    compressionLevel = 19;
    # Disable the standalone timer; the dump is instead triggered as a
    # dependency of the restic backup so every archive contains a fresh,
    # internally-consistent dump (see restic.nix).
    startAt = [ ];
  };

  # Ensure a fresh dump is produced immediately before restic runs, and that
  # restic waits for it to finish before archiving.
  systemd.services.restic-backups-dulu = {
    wants = [ "postgresqlBackup.service" ];
    after = [ "postgresqlBackup.service" ];
  };
}
