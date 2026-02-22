{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.ftp = {
    isSystemUser = true;
    group = "ftp";
    description = "user for scanner, which only support ftp";
    home = "/var/ftp";
    createHome = true;
    homeMode = "777";
    hashedPassword = "$y$j9T$vgeqh4IHJBM2yC6gRCUCz0$92qd1QmheljYQbjgkXT3dD.c4Qiy3D18j/lATXlfm80";
  };

  users.groups.ftp = {};

  services.vsftpd = {
    enable = true;
    localRoot = "/var/ftp";
    localUsers = true;
    userlistEnable = true;
    userlist = [ 
      "ftp"
    ];
    writeEnable = true;
    extraConfig = ''
      pasv_enable=Yes
      pasv_min_port=51000
      pasv_max_port=51999
      file_open_mode=0644   # max perms for files
      local_umask=002       # 644/775 style
    '';
  };

  system.activationScripts.createFtpDirectory = ''
    mkdir -p "/var/ftp"
    chown ftp:ftp "/var/ftp"
    chmod 755 "/var/ftp"
  '';

  networking.firewall.allowedTCPPorts = [ 21 ];  
  networking.firewall.allowedTCPPortRanges = [ { from = 51000; to = 51999; } ];
}
