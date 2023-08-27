{ lib, config, pkgs, ... }: {
  imports = [
    ../common
    ../common/wayland-wm
  ];

  home.packages = with pkgs; [
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      general = {
        gaps_in = 15;
        gaps_out = 20;
        border_size = 2.7;
        cursor_inactive_timeout = 4;
      };
    };
  };
}
