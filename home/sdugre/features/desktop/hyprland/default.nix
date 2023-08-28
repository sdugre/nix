{ lib, config, pkgs, ... }: {
  imports = [
    ../common
    ../common/wayland-wm
  ];

  home.packages = with pkgs; [
  ];

  wayland.windowManager.hyprland = {
    xwayland.enable = true;
  };
}
