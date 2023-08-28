{ lib, config, pkgs, ... }: {
  imports = [
    ../common
    ../common/wayland-wm
  ];

  home.packages = with pkgs; [
  ];

  hyprland.homeManagerModules.default
  {wayland.windowManager.hyprland.enable = true;}
#  wayland.windowManager.hyprland = {
#    xwayland.enable = true;
#  };
}
