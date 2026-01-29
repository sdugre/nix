{ 
  lib, 
  pkgs, 
  config, 
  ... 
}:
let
  cfg = config.services.owntone;
  types = lib.types;

  configFile = pkgs.writeText "owntone.conf" ''
    general {
      uid = "${cfg.user}"

      websocket_port = ${builtins.toString cfg.websocketPort}

      db_path = "${cfg.cacheDir}/songs3.db"
      logfile = "/var/log/owntone.log"
      cache_dir = "${cfg.cacheDir}"
      loglevel = "${cfg.logLevel}"
    }

    library {
      port = ${builtins.toString cfg.listenPort}
      name = "${cfg.libraryName}"
      directories = { ${lib.concatStringsSep ", " (map (d: ''"${d}"'') cfg.musicDirectories)}, }
      filepath_ignore = { ${lib.concatStringsSep ", " cfg.filepathIgnore} }
    }

    ${cfg.extraConfig}
  '';
in
{
  options.services.owntone = {
    enable = lib.mkEnableOption "Owntone server";

    package = lib.mkOption {
      type = types.package;
      default = pkgs.owntone;
      description = lib.mdDoc ''
        The owntone package to use.
      '';
    };

    cacheDir = lib.mkOption {
      type = types.str;
      default = "/var/cache/owntone";
      description = lib.mdDoc ''
        Base directory for storing cache databases.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "owntone";
      description = ''
        User account under which owntone runs.
      '';
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "owntone";
      description = ''
        Group under which owntone runs.
      '';
    };

    websocketPort = lib.mkOption {
      type = types.port;
      default = 3688;
      description = ''
        Port for owntone websocket connection
      '';
    };
    listenPort = lib.mkOption {
      type = types.port;
      default = 3689;
      description = ''
        Port for owntone web interface
      '';
    };
    openFirewall = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open the firewall?
      '';
    };

    libraryName = lib.mkOption {
      type = types.str;
      default = "owntone";
      description = "Library name advertised via mDNS";
    };
    
    musicDirectories = lib.mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Music library directories";
    };
    
    filepathIgnore = lib.mkOption {
      type = types.listOf types.str;
      default = [ "^\\." "/\\." ];
      description = "Filepath patterns to ignore";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [ "fatal" "log" "warning" "info" "debug" "spam" ];
      default = "log";
      description = lib.mdDoc ''
        Available levels: fatal, log, warning, info, debug, spam";
      '';
    };

    extraConfig = lib.mkOption {
      type = types.str;
      default = "";
      description = lib.mdDoc ''
        Extra configuration to append to owntone.conf
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "f /var/log/owntone.log 0644 ${cfg.user} ${cfg.group} -"
      "d ${cfg.cacheDir} 0755 ${cfg.user} ${cfg.group} -"
    ];

    environment.systemPackages = [ cfg.package ];
    systemd.services.owntone = {
      description = "DAAP/DACP (iTunes), RSP and MPD server, supports AirPlay and Remote";
      documentation = [ "man:owntone(8)" ];

      requires = [ "network.target" "local-fs.target" "avahi-daemon.socket" ];
      after = [ "network.target" ];

      unitConfig = {
        StartLimitInterval = 600;
      };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/owntone -f -c ${configFile}";
        MemoryMax = "256M";
        MemorySwapMax = "32M";

        Restart = "on-failure";
        RestartSec = 5;
        StartLimitBurst = 10;

        User = cfg.user;
        Group = cfg.group;
      };

      wantedBy = [ "multi-user.target" ];
    };

    users = {
      users = lib.mkIf (cfg.user == "owntone") {
        owntone = {
          group = cfg.group;
          isSystemUser = true;
          extraGroups = [ "avahi" ];
        };
      };
      groups = lib.mkIf (cfg.group == "owntone") {
        owntone = { };
      };
    };

    services.avahi.enable = true;
    # necessary for owntone to advertise DAAP mDNS
    # this allows Soundbridge to see the owntone media server
    services.avahi.publish.enable = true;
    services.avahi.publish.userServices = true;

    networking.firewall.allowedTCPPorts =
      lib.mkIf cfg.openFirewall [ cfg.listenPort cfg.websocketPort ];
  };
}
