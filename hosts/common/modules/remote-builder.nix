{
  users.users.remotebuild = {
    isNormalUser = true;
    createHome = false;
    group = "remotebuild";

    openssh.authorizedKeys.keyFiles = [ 
      ./remotebuild.pub 
      ./remotebuild-thinkpad.pub
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

