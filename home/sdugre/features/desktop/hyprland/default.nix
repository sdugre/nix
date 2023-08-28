{ lib, config, pkgs, ... }: {
  imports = [
    ../common
    ../common/wayland-wm
    hyprland.homeManagerModules.default
  ];

  home.packages = with pkgs; [
  ];

  wayland.windowManager.hyprland = {
    xwayland.enable = true;
  };
}
