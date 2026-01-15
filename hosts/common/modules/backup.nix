{
  config,
  pkgs,
  hostname,
  ...
}: let
  nasIP = "192.168.1.16";
  backupDir = "backup-${hostname}";
in {

  environment.systemPackages = [
    pkgs.restic
  ];

  sops.secrets.restic = {
    sopsFile = ../../${hostname}/secrets.yaml;
    owner = "sdugre";
    group = "users";
  };

  sops.secrets."ntfy/token" = {
    sopsFile = ../../${hostname}/secrets.yaml;
    owner = "sdugre";
    group = "users";
  };


  # backup any postgres DBs
  services.postgresqlBackup = {
    enable = config.services.postgresql.enable;
    startAt = "*-*-* 01:15:00";
  };

  # note: this runs as root.  Need to make ssh key and copy to nas
  services.restic.backups.daily = {
    passwordFile = config.sops.secrets.restic.path;
    repository = "sftp:sdugre@${nasIP}:${backupDir}";
    initialize = true;
    paths = [ 
      "/var/lib"
      "/var/backup"
      "/home/sdugre"
      "/mnt/photos"
      "/mnt/data/media"
    ];
    exclude = [
      "/mnt/data/media/movies"
      "/mnt/data/media/videos*"
      "/mnt/data/media/tv*"
    ];
    timerConfig = {
      OnCalendar = "03:05";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
    pruneOpts = [
      "--keep-daily 3"
      "--keep-weekly 3"
      "--keep-monthly 3"
    ];

    backupCleanupCommand = ''
      BACKUP_EXIT=$EXIT_STATUS
      
      if ! ${pkgs.restic}/bin/restic -r "sftp:sdugre@${nasIP}:${backupDir}" \
        --password-file "${config.sops.secrets.restic.path}" snapshots >/dev/null 2>&1; then
       
        ${pkgs.curl}/bin/curl \
          -u ":$(cat /run/secrets/ntfy/token)" \
          -H 'Title: Backup Repo Unreachable' \
          -H 'Tags: warning,backup,restic' \
          -d "Restic repo unreachable from ${hostname}! NAS offline?" https://ntfy.seandugre.com/backups
        exit 1
      fi

      if [ $BACKUP_EXIT -ne 0 ]; then
        ${pkgs.curl}/bin/curl \
          -u ":$(cat /run/secrets/ntfy/token)" \
          -H 'Title: Backup failed' \
          -H 'Tags: warning,backup,restic' \
          -d "Restic backup error on ${hostname}!" https://ntfy.seandugre.com/backups
      else
        ${pkgs.curl}/bin/curl \
          -u ":$(cat /run/secrets/ntfy/token)" \
          -H 'Title: Backup successful' \
          -H 'Tags: heavy_check_mark,backup,restic' \
          -d "Restic backup success on ${hostname}" https://ntfy.seandugre.com/backups
      fi
    '';
  };
}
