{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };

            # Btrfs root partition
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "btrfs";
                extraArgs = [ "-L" "nixos" "-f" ]; # -f to override existing partition

                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "subvol=root" "compress=zstd" "noatime" ];
                  };

                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "subvol=home" "compress=zstd" "noatime" ];
                  };

                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "subvol=nix" "compress=zstd" "noatime" ];
                  };

                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = [ "subvol=persist" "compress=zstd" "noatime" ];
                  };

                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "subvol=log" "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  
    # First 6 TB HDD
    hdd1 = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank";
            };
          };
        };
      };
    };

    # Second 6 TB HDD (mirror)
    hdd2 = {
      type = "disk";
      device = "/dev/sdb";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank";
            };
          };
        };
      };
    };

    # ZFS pool definition (mirror)
    zpool = {
      tank = {
        type = "zpool";
        mode = "mirror";
        options = {          # corresponds to -o pool property options
          cachefile = "none";
          ashift = "12";
        };
        rootFsOptions = {    # corresponds to -O file system property options
          compression = "on";
          atime = "off";
          recordsize = "1M"; # general purpose file sharing per Jim Salter
          xattr = "sa";
          acltype = "posixacl";
        };
        mountpoint = "none";  # datasets handle mounts
      };
    };
  };

  # Very basic placeholder mount for the pool itself (optional)
  # not needed for `disko‑zfs` datasets, but sometimes convenient
  # fileSystems."/tank" = {
  #   device = "tank";
  #   fsType = "zfs";
  #   options = [ "xattr" "atime" ];
  #   neededForBoot = false;
  # };  


  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}

