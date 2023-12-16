{ lib, config, pkgs, hostname, stateVer, username, desktop, gpu, inputs, platform, theme, ... }: {
  imports = [
    # Modules
    ./common/global
      
    # Services

    # Software

    ./users/${username}
    ./${hostname}
  ] ++ lib.optional (builtins.isString desktop) ./common/desktops/${desktop};

  networking.hostname = ${hostname};

  # List default system packages
  environment.systemPackages = with pkgs; [

  ];

  system.stateVersion = stateVer;
}
