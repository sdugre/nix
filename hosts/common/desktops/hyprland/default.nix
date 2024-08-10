{ inputs, pkgs, ...}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;	
  };
  environment.systemPackages = with pkgs; [
    nautilus
    networkmanagerapplet
  ];

  services.udisks2.enable = true; # needed for auto mounting USB drives;  See also Home Manager hyprland config.

  # Hyprlock should have access to passwords, etc.
  security.pam.services.hyprlock = {};

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red' \
            --cmd hyprland
        '';  
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
