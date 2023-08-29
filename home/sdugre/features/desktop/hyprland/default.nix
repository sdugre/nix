{ lib, inputs, config, pkgs, ... }: {
  imports = [
    ../common
    ../common/wayland-wm
    inputs.hyprland.homeManagerModules.default
  ];

  home.packages = with pkgs; [
  ];

  wayland.windowManager.hyprland = {
    xwayland.enable = true;
    extraConfig = import ./config.nix {

    };
  };
}
