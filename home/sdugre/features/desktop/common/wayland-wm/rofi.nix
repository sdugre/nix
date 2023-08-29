{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      modi = "drun,run";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = false;
    };
  };
}
