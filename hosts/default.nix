{ lib, config, pkgs, hostname, stateVer, username, desktop, gpu, inputs, platform, theme, ... }: {
  imports = [
    # Modules
    ./common/global
    ./common/modules/printing.nix      
    # Services

    # Software

    ./users/${username}
    ./${hostname}
  ] ++ lib.optional (builtins.isString desktop) ./common/desktops/${desktop};

#  sops.secrets.defaultSopsFile = ./${hostname}/secrets.yaml;
#  sops.secrets.defaultSopsFormat = "yaml";

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # List default system packages
  environment.systemPackages = with pkgs; [
    jq
    lsof
    sops
    usbutils
  ];

  system.stateVersion = stateVer;
}
