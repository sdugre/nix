{ lib, inputs, config, pkgs, ... }: {
  imports = [
    ../common
    ../common/wayland-wm
    inputs.hyprland.homeManagerModules.default
  ];

  home.packages = with pkgs; [
#    hyprland
    inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./config.nix {
      inherit (config) home;
    };
  };
}
