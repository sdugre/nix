{ 
  config, 
  lib, 
  ... 
}:
{
  imports = [
    ./zfs.nix
    ./btrfs.nix
    ./restic.nix
  ];

  options.backups = {
    enable = lib.mkEnableOption "Enable generic backups infrastructure";
    # Anything that is shared across all backends (zfs, btrfs, restic, etc.)
  };
}

