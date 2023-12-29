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

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # List default system packages
  environment.systemPackages = with pkgs; [

  ];

  system.stateVersion = stateVer;
}
