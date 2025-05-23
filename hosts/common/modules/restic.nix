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
  
  services.restic.backups.daily = {
    user = "sdugre";
    passwordFile = config.sops.secrets.restic.path;
    repository = "sftp:sdugre@${nasIP}:${backupDir}";
    initialize = true;
    paths = [ 
      "/var/lib"
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
  };
}
