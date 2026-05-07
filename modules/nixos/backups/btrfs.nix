{
  config,
  lib,
  hostname,
  ...
}:
let
  cfg = config.backups.btrfs;
  backupCfg = config.backups;
  fsSet = if lib.isList config.boot.supportedFilesystems
          then builtins.listToAttrs
            (map (fs: { name = fs; value = true; }) config.boot.supportedFilesystems)
          else config.boot.supportedFilesystems;
  # Keep only attrs where value is true
  enabledFsSet = lib.filterAttrs (_: v: v == true) fsSet;
  enabledFsNames = builtins.attrNames enabledFsSet;
  hasBtrfs = lib.elem "btrfs" enabledFsNames;
  rootPartition = config.fileSystems."/".device;
in
{
  options.backups.btrfs = {
    enable = lib.mkOption {
#      default = backupCfg.enable && hasBtrfs; # auto enable if backups = enable AND the system has btrfs support
      default = false;
      type = lib.types.bool;
      description = "Whether to enable btrfs snapshots and backups.";
    };

    role = lib.mkOption {
      type = lib.types.enum [ "source" "target" "both" ];
      default = "source";
      description = "Whether the machine is a source of or target for btrfs snapshots";
    };

    partition = lib.mkOption {
      default = rootPartition;
      description = "Partition where btrfs filesystem exists";
      example = "/dev/nvme0n1p3";
    };

    subvolume = lib.mkOption {
      description = "Btrbk subvolumes declarations";
      default = { };
      example = {  home = { snapshot_create = "always"; };
                    nixos = {};  };
    };

    targetHost = lib.mkOption {
      type = lib.types.str;
      description = "hostname or IP of backup server";
      default = "";
    };

    targetPath = lib.mkOption {
      type = lib.types.str;
      description = "path to store snapshots on target host";
      default = "/tank/backups/${hostname}";
    };

    btrbkKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        List of public keys for backup clients to access the backup server.

        This is used to generate the `sshAccess` configuration for the `btrbk` service.
      '';
      default = [ ];
    };

  };

  config = lib.mkIf (cfg.enable && backupCfg.enable) (lib.mkMerge [

    {
      assertions = [
        {
          assertion = hasBtrfs;
          message = "backups.btrfs enabled but btrfs does not appear to be supported. `boot.supportedFilesystems` must include btrfs";
        }
      ];
    }

    # --- Source Role ---
    (lib.mkIf (cfg.role == "source" || cfg.role == "both") {

      assertions = [
        {
          assertion = cfg.subvolume != { };
          message = "backups.btrfs enabled as source but no subvolumes are declared";
        }
        {
          assertion = cfg.targetHost != "";
          message = "You must specify and target host when role is 'source'";
        }
      ];

      # mount the btrfs filesystem for snapshotting
      fileSystems = {
        "/btrfs_pool" = {
          device = cfg.partition;
          fsType = "btrfs";
          options = [ "subvolid=5" ];
        };
      };

      # btrbk doesn't create snapshot directory by default
      system.activationScripts = {
        script.text = ''
          install -d -m 755 /btrfs_pool/.snapshots -o root -g root
        '';
      };

      sops.secrets."btrbk_key" = {
        sopsFile = ../../../hosts/${hostname}/secrets.yaml;
      };

      services.btrbk = {
        instances."btrbk" = {
          onCalendar = "hourly";
          settings = {
            # generate a key with:
            # ssh-keygen -t ed25519 -f "/tmp/btrbk-key" -N "" -C "btrbk@$<config.networking.hostName>"
            # copy public key to backup server config
            ssh_identity = config.sops.secrets."btrbk_key".path;
            ssh_user = "btrbk";
            stream_compress = "lz4";
            snapshot_preserve_min = "1d";
            snapshot_preserve = "7d 3w 3m";
            target_preserve_min = "no";
            target_preserve = "7d 3w 11m";
            snapshot_dir = "/btrfs_pool/.snapshots";
            volume."/btrfs_pool" = {
              target = "ssh://${cfg.targetHost}/${cfg.targetPath}";
              inherit (cfg) subvolume;
            };
          };
        };
      }; 
    })

    # --- Target Role ---

    (lib.mkIf (cfg.role == "target" || cfg.role == "both") {

      assertions = [
        {
          assertion = cfg.btrbkKeys != [ ];
          message = "You must add a public key when Role is 'Target'";
        }
      ];

      services.btrbk = {
        sshAccess = lib.mkIf (cfg.btrbkKeys != [ ])
          (lib.map (key: {
            key = key;
            roles = [
              "info" # `btrfs subvolume find-new` and `btrfs filesystem usage`
              # "source" # `btrfs subvolume snapshot` and `btrfs send`
              "target" # `btrfs receive` and `mkdir`
              "delete" # `btrfs subvolume delete` FIXME: This is a bit dangerous
              # "snapshot" # `btrfs subvolume snapshot`
              # "send" # `btrfs send`
              "receive" # `btrfs receive`
            ];
          }) cfg.btrbkKeys);
      };   
    })
  ]);
}
