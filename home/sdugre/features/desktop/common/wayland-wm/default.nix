{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./mako.nix
#    ./qutebrowser.nix
    ./waybar.nix
    ./rofi.nix
    ./gtk.nix
    ./rdp.nix
  ];

  home.packages = with pkgs; [
    swaybg # wallpaper utility
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };
}
