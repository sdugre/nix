{ lib, inputs, config, pkgs, ... }: {
  imports = [
    inputs.hyprland.homeManagerModules.default
   
    # wayland stuff necessary for hyprland
    ../../software/gui/gtk.nix
    ../../software/gui/kitty.nix
    ../../software/gui/mako.nix
    ../../software/gui/swayidle.nix
    ../../software/gui/swaylock.nix
    ../../software/gui/waybar.nix

  ];

#  xdg.portal.config.common.default = "*";   

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
