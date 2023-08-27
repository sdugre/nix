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
  };
}
