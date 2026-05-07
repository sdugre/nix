{
  config,
  pkgs,
  lib,
  hostname,
  username,
  ...
}: let
  cfg = config.backups.restic;
  btrfs = "${pkgs.btrfs-progs}/bin/btrfs";
in {

  options.backups.restic = {
  
    enable = lib.mkEnableOption "Restic Backups with btrfs snapshot capability";

    subvolumes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of Btrfs subvolumes to snapshot";
      example = [ "data" "home" ];
    };

    targetHost = lib.mkOption {
      type = lib.types.str;
      description = "hostname or IP of backup server";
      default = "";
    };

    targetPath = lib.mkOption {
      type = lib.types.str;
      description = "path to store backups on target host";
      default = "/tank/backups/${hostname}/restic";
    };
    
    paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of paths to backup";
      example = [ "/mnt/photos" "/var/lib" ];
    };

    exclude = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of paths to exclude from backup";
      example = [ "/mnt/videos" "/var/lib" ];
    };

    pruneOpts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "--keep-daily 3"
        "--keep-weekly 1"
        "--keep-monthly 1"
      ];
      description = "List of Restic prune options";
      example = [ "--keep-monthly 3" ];
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.targetHost != ""; 
        message = "Please specify a target host";
      }
      {
        assertion = cfg.subvolumes != [ ] || cfg.paths != [ ];
        message = "Please specify a subvolume or path to backup";
      }
    ];
    environment.systemPackages = [
      pkgs.restic
      pkgs.btrfs-progs
    ];

    sops.secrets.restic = {
      sopsFile = ../../../hosts/${hostname}/secrets.yaml;
      owner = "${username}";
      group = "users";
    };

    sops.secrets."ntfy/token" = {
      sopsFile = ../../../hosts/${hostname}/secrets.yaml;
      owner = "${username}";
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
      repository = "sftp:${username}@${cfg.targetHost}:${cfg.targetPath}";
      initialize = true;
      paths = (lib.optionals (cfg.subvolumes != [ ]) 
        [ "/btrfs_pool/.snapshots/restic-daily" ]) 
        ++ cfg.paths;
      exclude = cfg.exclude;
      timerConfig = {
        OnCalendar = "03:05";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
      pruneOpts = cfg.pruneOpts;
      backupPrepareCommand = ''
        set -Eeuxo pipefail
        
        SNAPSHOT_DIR="/btrfs_pool/.snapshots"
        SNAPSHOT_NAME="restic-daily"
        POOL_PATH="/btrfs_pool"
        
        # Ensure snapshot directory exists
        install -d -m 0755 "$SNAPSHOT_DIR"
        
        mkdir -p "$SNAPSHOT_DIR/$SNAPSHOT_NAME"
        
        for SUBVOL in ${lib.concatStringsSep " " cfg.subvolumes}; do
          SNAPSHOT_PATH="$SNAPSHOT_DIR/$SNAPSHOT_NAME/$SUBVOL"
          
          # Clean previous if exists
          if ${btrfs} subvolume show "$SNAPSHOT_PATH" >/dev/null 2>&1; then
            ${btrfs} subvolume delete "$SNAPSHOT_PATH"
          fi
          
          # Create readonly snapshot
          ${btrfs} subvolume snapshot -r "$POOL_PATH/$SUBVOL" "$SNAPSHOT_PATH"
        done
      '';

      backupCleanupCommand = ''
        BACKUP_EXIT=$EXIT_STATUS
        SNAPSHOT_DIR="/btrfs_pool/.snapshots"
        SNAPSHOT_NAME="restic-daily"
        
        for SUBVOL in ${lib.concatStringsSep " " cfg.subvolumes}; do
          SNAPSHOT_PATH="$SNAPSHOT_DIR/$SNAPSHOT_NAME/$SUBVOL"
          if ${btrfs} subvolume show "$SNAPSHOT_PATH" >/dev/null 2>&1; then
            ${btrfs} subvolume delete "$SNAPSHOT_PATH"
          fi
        done
        
        if ! ${pkgs.restic}/bin/restic -r "sftp:${username}@${cfg.targetHost}:${cfg.targetPath}" \
          --password-file "${config.sops.secrets.restic.path}" snapshots >/dev/null 2>&1; then
         
          ${pkgs.curl}/bin/curl \
            -u ":$(cat /run/secrets/ntfy/token)" \
            -H 'Title: Backup Repo Unreachable' \
            -H 'Tags: warning,backup,restic' \
            -d "Restic repo unreachable from ${hostname}! ${cfg.targetHost} offline?" https://ntfy.seandugre.com/backups
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
  };
}
