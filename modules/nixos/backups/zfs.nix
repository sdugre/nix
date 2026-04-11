{
  config,
  lib,
  ...
}:
let
  cfg = config.backups.zfs;
  backupCfg = config.backups;
  fsSet = if lib.isList config.boot.supportedFilesystems
          then builtins.listToAttrs
            (map (fs: { name = fs; value = true; }) config.boot.supportedFilesystems)
          else config.boot.supportedFilesystems;
  # Keep only attrs where value is true
  enabledFsSet = lib.filterAttrs (_: v: v == true) fsSet;
  enabledFsNames = builtins.attrNames enabledFsSet;
  hasZfs = lib.elem "zfs" enabledFsNames;
in
{
  options.backups.zfs = {
    enable = lib.mkOption {
      default = backupCfg.enable && hasZfs; # auto enable if backups = enable AND the system has zfs support
      type = lib.types.bool;
      description = "Whether to enable ZFS‑specific sanoid/syncoid backups.";
    };

    datasets = lib.mkOption {
      default = { };
      description = "services.sanoid.datasets to snapshot or prune";
    };

    templates = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrs);
      default = { };
      description = "Optional per‑host template overrides.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.length (builtins.attrNames cfg.datasets) > 0;
        message = "backups.zfs enabled but no datasets are defined";
      }
    ];

    # Enable sanoid snapshoting with rules for creating snapshots.
    services.sanoid = {
      enable = true;
      interval = "*-*-* *:00,15,30,45:00";

      inherit (cfg) datasets;

      # Home snapshotting rules
      templates.home = {
        autosnap = true;
        autoprune = true;
        frequently = 3;
        hourly = 23;
        daily = 6;
        weekly = 3;
        monthly = 11;
        yearly = 1;
      };

      # Data snapshotting rules
      templates.data = {
        autosnap = true;
        autoprune = true;
        frequently = 3;
        hourly = 12;
        daily = 6;
        weekly = 3;
        monthly = 11;
        yearly = 0;
      };

      # Bulk storage snapshotting rules
      templates.storage = {
        autosnap = true;
        autoprune = true;
        frequently = 0;
        hourly = 0;
        daily = 6;
        weekly = 3;
        monthly = 3;
        yearly = 0;
      };

      # Storage snapshotting rules for backup servers
      templates.backup = {
        autosnap = false;
        autoprune = true;
        frequently = 0;
        hourly = 0;
        daily = 6;
        weekly = 3;
        monthly = 3;
        yearly = 0;
      };
    } // cfg.templates;
  };
}
