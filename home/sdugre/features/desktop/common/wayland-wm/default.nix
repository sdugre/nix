{ pkgs, ... }:
{
  imports = [
    ./kitty.nix
    ./mako.nix
#    ./qutebrowser.nix
    ./waybar.nix
    ./rofi.nix
    ./gtk.nix
    ./swayidle.nix
    ./swaylock.nix
  ];

  home.packages = with pkgs; [
    swaybg # wallpaper utility
    galculator
    backlight
    rofi-logout
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };
}
