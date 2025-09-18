{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.rofi = {
    enable = true;
#    package = pkgs.rofi-wayland;
    font = lib.mkForce "${config.fontProfiles.monospace.family} 16";
    extraConfig = {
      modi = "run,drun,window";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = false;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };
  };
}
