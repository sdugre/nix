{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.tailscaleAutoconnect;
in {
  options.services.tailscaleAutoconnect = {
    enable = mkEnableOption "tailscaleAutoconnect";
    authkeyFile = mkOption {
      type = types.str;
      description = "The authkey to use for authentication with Tailscale";
    };

    loginServer = mkOption {
      type = types.str;
      default = "";
      description = "The login server to use for authentication with Tailscale";
    };

    advertiseExitNode = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to advertise this node as an exit node";
    };

    exitNode = mkOption {
      type = types.str;
      default = "";
      description = "The exit node to use for this node";
    };

    exitNodeAllowLanAccess = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to allow LAN access to this node";
    };

    enableSSH = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Tailscale SSH";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.authkeyFile != "";
        message = "authkeyFile must be set";
      }
      {
        assertion = cfg.exitNodeAllowLanAccess -> cfg.exitNode != "";
        message = "exitNodeAllowLanAccess must be false if exitNode is not set";
      }
      {
        assertion = cfg.advertiseExitNode -> cfg.exitNode == "";
        message = "advertiseExitNode must be false if exitNode is set";
      }
    ];

    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      # make sure tailscale is running before trying to connect to tailscale
      after = ["network-pre.target" "tailscale.service"];
      wants = ["network-pre.target" "tailscale.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig.Type = "oneshot";

      script = with pkgs; ''
        # wait for tailscaled to settle
        sleep 2

        # check if we are already authenticated to tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        # if status is not null, then we are already authenticated
        echo "tailscale status: $status"
        if [ "$status" = "Running" ]; then
            exit 0
        fi

        # otherwise authenticate with tailscale
        # timeout after 10 seconds to avoid hanging the boot process
        ${coreutils}/bin/timeout 10 ${tailscale}/bin/tailscale up \
          --reset \
          ${lib.optionalString (cfg.loginServer != "") "--login-server=${cfg.loginServer}"} \
          ${lib.optionalString (cfg.advertiseExitNode) "--advertise-exit-node"} \
          ${lib.optionalString (cfg.authkeyFile != "") "--auth-key=file:${cfg.authkeyFile}"} \
          ${lib.optionalString (cfg.exitNode != "") "--exit-node=${cfg.exitNode}"} \
          ${lib.optionalString (cfg.enableSSH) "--ssh"} \
          ${lib.optionalString (cfg.exitNodeAllowLanAccess) "--exit-node-allow-lan-access"}
      '';
    };

    networking.firewall = {
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [config.services.tailscale.port];
    };

    services.tailscale = {
      enable = true;
      useRoutingFeatures =
        if cfg.advertiseExitNode
        then "server"
        else "client";
      #      authKeyFile = cfg.authkeyFile;
      #      extraUpFlags = [
      #        "--reset"
      #      ]
      #        ++ (lib.optional (cfg.enableSSH) "--ssh")
      #        ++ (lib.optional (cfg.loginServer != "") "--login-server=${cfg.loginServer}");
    };

    environment.persistence = lib.mkIf config.services.persistence.enable {
      "/persist".directories = ["/var/lib/tailscale"];
    };
  };
}
