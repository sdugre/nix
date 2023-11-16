{ lib, inputs, config, pkgs, ... }: {
  imports = [
    ../common
    ../common/wayland-wm
    inputs.hyprland.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./config.nix {
      inherit (config) home wallpaper;
      inherit pkgs;
    };
  };
}
