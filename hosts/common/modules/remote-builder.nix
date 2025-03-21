{
  users.users.remotebuild = {
    isNormalUser = true;
    createHome = false;
    group = "remotebuild";

    openssh.authorizedKeys.keys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6AXd0wc3K1UWj4AmZ+Qo6c4F/uaszWylnydGtclTss root@optiplex"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMIo7vG9UOsUWyk/sT+0CEOhKhHx/nlgHKvJQ6Wekzso root@thinkpad"
    ];
  };

  users.groups.remotebuild = {};

  nix = {
    nrBuildUsers = 64;
    settings = {
      trusted-users = [ "remotebuild" ];
      min-free = 10 * 1024 * 1024 * 1024;
      max-jobs = "auto";
      cores = 0;
    };
  };

  systemd.services.nix-daemon.serviceConfig = {
    MemoryAccounting = true;
    MemoryMax = "80%";
    OOMScoreAdjust = 500;
  };
}

