# This file defines the "non-hardware dependent" part of opt-in persistence
# It imports impermanence and defines the basic persisted dirs.
{ lib, inputs, config, ... }: 

with lib; let
  cfg = config.services.persistence;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.services.persistence = {
    enable = mkEnableOption "persistence";
    partition = mkOption {
      type = types.str;
      description = "The name of the partition containing the btrfs subvolumes";
    }; 
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.partition != "";
        message = "partition must be set";
      }
    ];

    # default.  more in optional modules
    environment.persistence = {
      "/persist" = {
        directories = [
          "/var/lib/systemd"
          "/var/lib/nixos"
        ];
        files = [
          "/etc/machine-id"
          "/etc/ssh/ssh_host_*"
        ];
      };
    };

    boot.initrd = {
      enable = true;
      supportedFilesystems = [ "btrfs" ];

      systemd.services.restore-root = {
        description = "Rollback btrfs rootfs";
        wantedBy = [ "initrd.target" ];
        requires = [
          "dev-${cfg.partition}.device"
        ];
        after = [
          "dev-${cfg.partition}.device"
          # for luks
          #"systemd-cryptsetup@${config.networking.hostName}.service"
        ];
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /mnt

          mount -o subvol=/ /dev/${cfg.partition} /mnt

          btrfs subvolume list -o /mnt/root |
          cut -f9 -d' ' |
          while read subvolume; do
            echo "deleting /$subvolume subvolume..."
            btrfs subvolume delete "/mnt/$subvolume"
          done &&
          echo "deleting /root subvolume..." &&
          btrfs subvolume delete /mnt/root

          echo "restoring blank /root subvolume..."
          btrfs subvolume snapshot /mnt/root-blank /mnt/root

          umount /mnt
        '';
      };
    };
  };
}
